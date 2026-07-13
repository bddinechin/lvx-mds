#!/usr/bin/perl -w
# Machine Description System (MDS)
#
# Copyright (C) 2018 Kalray
#
# Benoît Dupont de Dinechin (benoit.dinechin@kalray.eu).
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.


my $debug = $ENV{DEBUG} || 0;
my $family = lc($ENV{FAMILY});
my $FAMILY = uc($family);

use Carp;
use strict;
use Data::Dumper;

use MDS;
&MDS::parse(*ARGV);
use integer;

# Emit GCC source file boilerplate.
print << "EOT";
/*
 * Definitions of target machine for GNU compiler, for Kalray $family.
 * Copyright (C) 2009-2019 Kalray S.A.
 *
 * This file is part of GCC.
 *
 * GCC is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3, or (at your option)
 * any later version.
 *
 * GCC is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with GCC; see the file COPYING3.  If not see
 * <http://www.gnu.org/licenses/>.
 */\n
EOT

# List of Conventions(s) in canonical GCC order.
my %Convention;
my @ConventionNames;
foreach my $convention (@Convention::table) {
    my $name = $convention->name();
    $Convention{$name} = { CONVENTION=>$convention, NAME=>$name };
    push @ConventionNames, $name;
}

# The virtual frame pointer is defined as the last unused (ie., reserved)
# system function register.
my $virtualFramePointerNo = -1;

# List of Register(s) in canonical GCC order (DWARF order).
my %Register;
my %RegisterRegno;
foreach my $register (@Register::table) {
    my $dwarfId = $register->attribute("dwarfId");
    my $what = $register->attribute("what");
    my $address = $register->attribute("addresses");
    next unless defined $dwarfId;
    my ($regFile) = $register->access("regFile");
    my $name = $register->name();
#print $register->attribute("ID") . " => name: $name, , dwarf: $dwarfId, regfile: " . $regFile->name() . ", core(s): ";
#map { print $_->core() . " " } $register->access("processors");
#print "\n";
    if (defined $RegisterRegno{$dwarfId}) {
        if ($name ne $RegisterRegno{$dwarfId}->name()) {
            print STDERR "Error: " . $register->attribute("ID") . " has same dwarfId($dwarfId) than " .
              $RegisterRegno{$dwarfId}->attribute("ID") . "\n";
            die;
        }
    } else {
        $RegisterRegno{$dwarfId} = $register;
    }
    if (defined $Register{$name}) {
        if (($Register{$name}{REGNO} != $dwarfId) ||
            ($Register{$name}{REGFILE}->regFileName() ne $regFile->regFileName())) {
            print STDERR "Error: " . $register->attribute("ID") . " differs from " .
              $Register{$name}{REGISTER}->attribute("ID") . "\n";
            die;
        }
    }
    $Register{$name} = { REGNO=>$dwarfId, REGISTER=> $register, NAME=>$name, REGFILE=>$regFile};
    next unless defined $what and $name =~ /^RES/ and $virtualFramePointerNo == -1;
    $virtualFramePointerNo = $address;
}


if ($virtualFramePointerNo eq -1) {
    die "Error: No more room for the virtual stack pointer.\n";
}

my @RegisterNames = map { $Register{$_}{NAME} }
  sort { $Register{$a}{REGNO} <=> $Register{$b}{REGNO} }
  keys %Register;

# Build the list of RegClass(es) in canonical GCC order (DWARF).
# First, only pick from RegClass(es) which are full RegFile(s).
my %RegClass;
foreach my $regFile (&MDS::regFiles()) {
    my $name = $regFile->regFileName();
    next if $name =~ /^RV_/; # Skip RISV-V register files.
    my $regClass = $regFile;
    my @registers = grep {
        $Register{$_->name()}
      } $regClass->access("registers");
    my $order = 1<<30;
    foreach my $register (@registers) {
        my $dwarfId = $register->attribute("dwarfId");
        if (defined $dwarfId) {
            $order = $dwarfId*1024 if $order > $dwarfId;
        }
    }
    my ($width) = $regFile->attribute("width");
    if ($order < 1<<30 && $width <= 64) {
        # The RegFile defines the register dwarf IDs, use the RefFile@registers.
        @registers = grep {
            $Register{$_->name()}
          } $regFile->access("registers");
        $RegClass{$name} = { ORDER=>$order, REGCLASS=>$regClass, NAME=>$name, REGISTERS=>\@registers };
    } elsif ($regFile->access("multi")) {
        # Multi RegFile, assume all the multi RegClass(es) are the same.
        my @multi = $regFile->access("multi");
        my ($multiRegClass) = $regFile->access("multi");
        my ($multiRegFile) = $multiRegClass->access("regFile");
        # Recurse into to multi of multi if any.
        my $multi = scalar @multi;
        while ($multiRegFile->access("multi")) {
            $multi *= scalar $multiRegFile->access("multi");
            ($multiRegClass) = $multiRegFile->access("multi");
            ($multiRegFile) = $multiRegClass->access("regFile");
        }
        my $multiName = $multiRegFile->regFileName();
        if ($RegClass{$multiName} && !$RegClass{$name}) {
            $order = $RegClass{$multiName}{ORDER} + $width;
            #my ($step, $count) = (scalar @multi, 0);
            my @registers = grep {
                #!($count++ % $step) && $Register{$_->name()}
                $Register{$_->name()}
              } $multiRegClass->access("registers");
            $RegClass{$name} = { ORDER=>$order, REGCLASS=>$regClass, NAME=>$name, REGISTERS=>\@registers, MULTI=> $multi };
        }
    }
}

# Then, only include a few extra RegClass(es):
#  - SAB (insn alone in bundle);
#  - EGR (even general register).
foreach my $regClass (@RegClass::table) {
    my $name = undef;
    my $className = $regClass->name();
    if ($className =~ /^alone/) {
        $name = 'SAB';
    } elsif ($className =~ /^worddRegE/) {
        $name = 'EGR';
    }
    if (defined $name && !$RegClass{$name}) {
        my ($regFile) = $regClass->access("regFile");
        my $regFileName = $regFile->regFileName();
        my $order = $RegClass{$regFileName}{ORDER} + 1;
        my @registers = grep {
            $Register{$_->name()}
          } $regClass->access("registers");
        # Add EXTRA to flag this is not a full RegFile.
        $RegClass{$name} = { ORDER=>$order, REGCLASS=>$regClass, NAME=>$name, REGISTERS=>\@registers, EXTRA=>1 };
        #print STDERR "RegClass $name: order=$order regFile= $regFileName\n";
    }
}

# Order RegClass(es) into RegClassNames
my @RegClassNames = map { $RegClass{$_}{NAME} }
  sort { $RegClass{$a}{ORDER} <=> $RegClass{$b}{ORDER} }
  keys %RegClass;

# Emit reg_class.
print << "EOT";
enum reg_class {
  NO_REGS,
EOT
foreach my $entry (map {$RegClass{$_}} @RegClassNames) {
    next if defined $$entry{MULTI};
    my $NAME = uc($$entry{NAME});
    print << "EOT";
  ${NAME}_REGS,
EOT
}
print << "EOT";
  ALL_REGS,
  LIM_REG_CLASSES
};\n
EOT

# Emit REG_CLASS_NAMES.
print << "EOT";
#define REG_CLASS_NAMES { \\
  "NO_REGS", \\
EOT
foreach my $entry (map {$RegClass{$_}} @RegClassNames) {
    next if defined $$entry{MULTI};
    my $NAME = uc($$entry{NAME});
    print << "EOT";
  "${NAME}_REGS", \\
EOT
}
print << "EOT";
  "ALL_REGS", \\
  "LIM_REG_CLASSES" \\
}\n
EOT

# Table of fake registers.
my %fakeRegSlice = (
    'SFR'=> [ 'GPR', 16 ],
  );
my $RegCount = 0;
my %plusRegno = ();
my %minusRegno = ();
# Emit first and last REGNO for each REG_CLASS.
foreach my $entry (map {$RegClass{$_}} @RegClassNames) {
    next if defined $$entry{MULTI};
    next if defined $$entry{EXTRA};
    my $NAME = uc($$entry{NAME});
    my $firstRegister = $$entry{REGISTERS}[0];
    my $lastRegister = $$entry{REGISTERS}[-1];
    my $firstRegno = $Register{$firstRegister->name()}{REGNO};
    my $lastRegno = $Register{$lastRegister->name()}{REGNO};
    my $slice = $fakeRegSlice{$NAME};
    # Fill %plusRegno and %minusRegno.
    if (defined $slice) {
        my $CLASS = $$slice[0];
        my $count = $$slice[1];
        for my $index (1..$count) {
            my $regno = sprintf("%d", $lastRegno - $count + $index);
            push @{$plusRegno{$CLASS}}, $regno;
            $minusRegno{$NAME}{$regno} = 1;
        }
    }
    print << "EOT";
#define ${FAMILY}_${NAME}_FIRST_REGNO $firstRegno
#define ${FAMILY}_${NAME}_LAST_REGNO $lastRegno
EOT
    $RegCount = $lastRegno + 1 if $RegCount < $lastRegno + 1;
}
print << "EOT";

#define ${FAMILY}_MDS_REGISTERS $RegCount
#define FIRST_PSEUDO_REGISTER (${FAMILY}_MDS_REGISTERS)
#define ${FAMILY}_FRAME_POINTER_VIRT_REGNO (${FAMILY}_SFR_FIRST_REGNO + $virtualFramePointerNo)

EOT

# Insert the fake GPRs at the end of SFRs.
foreach my $entry (map {$RegClass{$_}} @RegClassNames) {
    my $NAME = uc($$entry{NAME});
    my $slice = $fakeRegSlice{$NAME};
    if (defined $slice) {
        my $CLASS = $$slice[0];
        my $count = $$slice[1];
        print<<"EOT";
#define ${FAMILY}_${NAME}_FAKE_${CLASS}_COUNT $count
#define ${FAMILY}_${NAME}_FAKE_${CLASS}_MASK (${FAMILY}_${NAME}_FAKE_${CLASS}_COUNT - 1)
#define ${FAMILY}_${NAME}_FAKE_${CLASS}_FIRST (${FAMILY}_${NAME}_LAST_REGNO - (${FAMILY}_${NAME}_FAKE_${CLASS}_MASK))

EOT
    }
}

# Helper for REG_CLASS_CONTENTS
sub masks32 {
    my @result;
    my @regnos = sort { $a <=> $b } @_;
    my @regBitset = map {0} (0 .. $RegCount-1);
    foreach my $regno (@regnos) {
        die "Invalid regno $regno" unless $regno >=0 && $regno < $RegCount;
        $regBitset[$regno] = 1;
    }
    my $maskCount = $RegCount/32;
    for (my $i = 0; $i < $maskCount; $i++) {
        my $mask = 0;
        for (my $j = 0; $j < 32; $j++) {
            my $value = $regBitset[$i*32 + $j];
            $mask |= $value << $j;
        }
        my $value = sprintf("0x%08x", $mask);
        push @result, $value;
    }
    return @result;
}

# Emit the REG_CLASS_CONTENTS
print << "EOT";
#define REG_CLASS_CONTENTS { \\
EOT
print "  { ";
map { print $_, ", "; } &masks32();
print "}, /* NO_REGS */ \\\n";
foreach my $entry (map {$RegClass{$_}} @RegClassNames) {
    next if defined $$entry{MULTI};
    my $NAME = uc($$entry{NAME});
    my @entries =  map { $Register{$_->name()} } @{$$entry{REGISTERS}};
    my @regnos = grep { !defined $minusRegno{$NAME}{$_} }
      map { $$_{REGNO} } @entries;
    print "  { ";
    map { print $_, ", "; } &masks32(@regnos, @{$plusRegno{$NAME}});
    print "}, /* ${NAME}_REGS */ \\\n";
}
print "  { ";
map { print $_, ", "; } &masks32(0 .. $RegCount-1);
print "}, /* ALL_REGS */ \\\n";
print << "EOT";
}\n
EOT

# Emit REGNO_REG_CLASS
print << "EOT";
#define REGNO_REG_CLASS(REGNO) ( \\
EOT
my $indent;
my $level = 0;
foreach my $entry (map {$RegClass{$_}} @RegClassNames) {
    next if defined $$entry{MULTI};
    next if defined $$entry{EXTRA};
    my $NAME = uc($$entry{NAME});
    my $firstRegister = $$entry{REGISTERS}[0];
    my $lastRegister = $$entry{REGISTERS}[-1];
    my $firstRegno = $Register{$firstRegister->name()}{REGNO};
    my $lastRegno = $Register{$lastRegister->name()}{REGNO};
    $indent = "  " x $level;
    my $slice = $fakeRegSlice{$NAME};
    if (defined $slice) {
        my $CLASS = $$slice[0];
        my $count = $$slice[1];
        my $COUNT = "${FAMILY}_${NAME}_FAKE_${CLASS}_COUNT";
        print << "EOT";
  $indent(((REGNO) <= ${FAMILY}_${NAME}_LAST_REGNO-$COUNT)? ${NAME}_REGS: \\
    $indent(((REGNO) <= ${FAMILY}_${NAME}_LAST_REGNO)? ${CLASS}_REGS: \\
EOT
        $level += 2;
    } else {
        print << "EOT";
  $indent(((REGNO) <= ${FAMILY}_${NAME}_LAST_REGNO)? ${NAME}_REGS: \\
EOT
        $level++;
    }
}
$indent = "  " x $level;
my $close = ')' x $level;
print << "EOT";
  ${indent}NO_REGS$close)\n
EOT

# Emit REGISTER_NAMES
print << "EOT";
#define ${FAMILY}_REGISTER_NAMES \\
EOT
my $count = 0;
foreach my $entry (map {$Register{$_}} @RegisterNames) {
    last if $count >= $RegCount;
    print " \\\n" if $count;
    my $register = $$entry{REGISTER};
    my ($firstName) = split ' ', $register->attribute("names");
    $firstName =~ s/^\$//;
    if($firstName =~ /^res[0-9]+/) {
        $firstName = lc($$entry{NAME});
    }
    print "\t\"$firstName\",";
    $count++;
}
print "\n\n";

# Emit XXX_REGISTER_NAMES in case of multi
foreach my $entry (map {$RegClass{$_}} @RegClassNames) {
    next unless $$entry{MULTI};
    my $NAME = uc($$entry{NAME});
    print << "EOT";
#define ${FAMILY}_${NAME}_REGISTER_NAMES \\
EOT
    my $count = 0;
    my $regClass = $$entry{REGCLASS};
    my @registers = $regClass->access("registers");
    foreach my $register (@registers) {
        print " \\\n" if $count && $count%8 == 0;
        my ($firstName) = split ' ', $register->attribute("names");
        $firstName =~ s/^\$//;
        print "\t\"$firstName\",";
        $count ++;
    }
    print "\n\n";
}

# Emit ABI information
my $abiNumber = 0;
foreach my $entry (map {$Convention{$_}} @ConventionNames) {
    my $NAME = uc($$entry{NAME});
    my $convention = $$entry{CONVENTION};
    my @reserved = map {$_->name()} $convention->access("reserved");
    my @argument = map {$_->name()} $convention->access("argument");
    my @result = map {$_->name()} $convention->access("result");
    my @struct = map {$_->name()} $convention->access("struct");
    my @caller = map {$_->name()} $convention->access("caller");
    my @callee = map {$_->name()} $convention->access("callee");
    my @program = map {$_->name()} $convention->access("program");
    my @handler = map {$_->name()} $convention->access("handler");
    my @veneer = map {$_->name()} $convention->access("veneer");
    my @return = map {$_->name()} $convention->access("return");
    my @stack = map {$_->name()} $convention->access("stack");
    my @static = map {$_->name()} $convention->access("static");
    my @frame = map {$_->name()} $convention->access("frame");
    my @global = map {$_->name()} $convention->access("global");
    my @local = map {$_->name()} $convention->access("local");
    my @wired = map {$_->name()} $convention->access("wired");
    my @zero = map {$_->name()} $convention->access("zero");
    my @one = map {$_->name()} $convention->access("one");
    my ($programEntry) = map { $Register{$_} } @program;
    my ($stackEntry) = map { $Register{$_} } @stack;
    my ($frameEntry) = map { $Register{$_} } @frame;
    my ($localEntry) = map { $Register{$_} } @local;
    my ($structEntry) = map { $Register{$_} } @struct;
    my ($returnEntry) = map { $Register{$_} } @return;
    my ($argumentEntry) = map { $Register{$_} } @argument;
    my $arg_reg_slots = scalar map { $Register{$_} } @argument;
    print << "EOT";
#define ${FAMILY}_ABI_${NAME} $abiNumber
#define ${FAMILY}_PROGRAM_POINTER_REGNO $$programEntry{REGNO}
#define ${FAMILY}_STACK_POINTER_REGNO $$stackEntry{REGNO}
#define ${FAMILY}_FRAME_POINTER_REGNO $$frameEntry{REGNO}
#define ${FAMILY}_LOCAL_POINTER_REGNO $$localEntry{REGNO}
#define ${FAMILY}_STRUCT_POINTER_REGNO $$structEntry{REGNO}
#define ${FAMILY}_RETURN_POINTER_REGNO $$returnEntry{REGNO}
#define ${FAMILY}_ARGUMENT_POINTER_REGNO $$argumentEntry{REGNO}
#define ${FAMILY}_ARG_REG_SLOTS $arg_reg_slots
EOT
    $abiNumber++;
    last;
}
print "\n\n";

# Emit XXX_FIXED_REGISTERS
foreach my $entry (map {$Convention{$_}} @ConventionNames) {
    my $NAME = uc($$entry{NAME});
    my $convention = $$entry{CONVENTION};
    my @reserved = map {$_->name()} $convention->access("reserved");
    my @reservedEntries = map { $Register{$_} } @reserved;
    my %reservedName = map { $$_{NAME}, 1 } @reservedEntries;
    print << "EOT";
#define ${FAMILY}_ABI_${NAME}_FIXED_REGISTERS \\
EOT
    &printValues(\%reservedName);
    last;
}
print "\n\n";

# Emit XXX_CALL_USED_REGISTERS
foreach my $entry (map {$Convention{$_}} @ConventionNames) {
    my $NAME = uc($$entry{NAME});
    my $convention = $$entry{CONVENTION};
    my @reserved = map {$_->name()} $convention->access("reserved");
    my @reservedEntries = map { $Register{$_} } @reserved;
    my %reservedName = map { $$_{NAME}, 1 } @reservedEntries;
    my @caller = map {$_->name()} $convention->access("caller");
    my @callerEntries = map { $Register{$_} } @caller;
    my %callerName = map { $$_{NAME}, 1 } @callerEntries;
    print << "EOT";
#define ${FAMILY}_ABI_${NAME}_CALL_USED_REGISTERS \\
EOT
    &printValues(\%callerName, \%reservedName);
    last;
}
print "\n\n";

# Emit XXX_CALL_REALLY_USED_REGISTERS
foreach my $entry (map {$Convention{$_}} @ConventionNames) {
    my $NAME = uc($$entry{NAME});
    my $convention = $$entry{CONVENTION};
    my @reserved = map {$_->name()} $convention->access("reserved");
    my @reservedEntries = map { $Register{$_} } @reserved;
    my %reservedName = map { $$_{NAME}, 1 } @reservedEntries;
    my @caller = map {$_->name()} $convention->access("caller");
    my @callerEntries = map { $Register{$_} } @caller;
    my %callerName = map { $$_{NAME}, 1 } @callerEntries;
    my @return = map {$_->name()} $convention->access("return");
    my ($returnEntry) = map { $Register{$_} } @return;
    print << "EOT";
#define ${FAMILY}_ABI_${NAME}_CALL_REALLY_USED_REGISTERS \\
EOT
    &printValues(\%callerName, \%reservedName, { $$returnEntry{NAME}=>0 });
    last;
}
print "\n\n";

# Helper function.
sub printValues {
    my $count = 0;
    my %nameSet = map {%{$_}} @_;
    foreach my $entry (map {$Register{$_}} @RegisterNames) {
        last if $count >= $RegCount;
        my $name = $$entry{NAME};
        my $regFileName = $$entry{REGFILE}->regFileName();
        print " \\\n" if $count && $count%8 == 0;
        my $value = $nameSet{$name};
        $value = ($regFileName eq 'SFR') unless defined $value;
        $value = 0 unless $value;
        print "\t$value,";
        $count++;
    }
}

# vim: set ts=4 sw=4 et:
