##!/usr/bin/perl -w
# Machine Description System (MDS)
#
# Copyright (C) 2005 STMicroelectronics
#
# Benoit Dupont de Dinechin (Benoit.Dupont-de-Dinechin@st.com).
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
my $FAMILY = $ENV{FAMILY};

my $MDS_SPLIT_MODE = 0;
if ($ARGV[0] eq "--split") {
    $MDS_SPLIT_MODE = 1;
    shift @ARGV;
}

use Carp;

use strict;

use MDS;
use Behavior;

# Unbox the generated C: give each Integer a native type where the width analysis
# proves one fits, instead of a 32-byte Int256_ union.  DOC/Behavior.md section 6.
# Off by default -- the generator is then byte-for-byte what it always was.
$Behavior::Unbox = 1 if $ENV{BEHAVIOR_UNBOX};

&MDS::parse(*ARGV);

my $copyrights = &MDS::get_copyrights(" *  ","");

print<<"EOT";
/*
 * $FAMILY/Behavior.tuple
 * Automatically generated from the Machine Description System (MDS).
${copyrights}
 */

EOT

exit if $FAMILY eq 'arm';

#
# The operator helpers' signatures (DOC/MDD.dtd's Helper).  Without one a helper takes and
# returns Int256_, exactly as all of them did, so a description that declares nothing gets
# the generator it always got.
#
foreach my $helper (@Helper::table) {
    my $name = $helper->name();
    my $result = $helper->attribute("result");
    my $arguments = $helper->attribute("arguments");
    $Behavior::Signature{$name}{result} = $result if defined $result;
    $Behavior::Signature{$name}{arguments} = [ split ' ', $arguments ]
      if defined $arguments;
}

my %isMemory;
my %isControl;
foreach my $storage (@Storage::table) {
    my $name = $storage->name();
    my $kind = $storage->attribute("kind");
    my $width = $storage->attribute("width");
    if ($kind eq 'Constant') {
        my $contents = $storage->contents();
        &Behavior::Constant($name, $contents);
    } else {
        &Behavior::Storage($name, { KIND=>$kind, WIDTH=>$width });
        $isMemory{$name}++ if $kind eq 'Memory';
        $isControl{$name}++ if $kind eq 'Control';
    }
}

foreach my $regFile (&MDS::regFiles()) {
    my $name = $regFile->regFileName();
    my $width = $regFile->attribute("width");

    # Used in Behavior.pm: CodeGen to get storage/regfile width
    &Behavior::Storage($regFile->regFileName(), { WIDTH=>$width });
}

my %helpers;
my %enums;

my %operator;
foreach my $operator (@Operator::table) {
    my @origins = $operator->access("origins");
    my @opcodes = grep {$_->type() =~ /^(Opcode|Simulated)/} @origins;
    my @opcodeNames = map {$_->fullName('_')} @opcodes;
    foreach my $opcodeName (@opcodeNames) {
        $operator{$opcodeName} = $operator;
    }
}

my %fetch_body;
my %execute_body;
my %commit_body;
my %opcode_fetch;
my %opcode_execute;
my %opcode_commit;

my $undefined_operator = 0;
foreach my $opcode (@Opcode::table) {
    my $ID = $opcode->fullName('_');
    my $operator = $operator{$ID};
    if (not defined $operator) {
        $undefined_operator = 1;
        last;
    }
}

if ($undefined_operator) {
    $opcode_fetch{undefined} = "fetch_undefined";
    $opcode_execute{undefined} = "execute_undefined";
    $opcode_commit{undefined} = "commit_undefined";

    print << "EOT";
#ifdef Behavior_FETCH
  void fetch_undefined(__attribute__((unused)) void *this, __attribute__((unused)) OperandDecoded *decoded, __attribute__((unused)) Processor processor);
  void fetch_undefined(__attribute__((unused)) void *this, __attribute__((unused)) OperandDecoded *decoded, __attribute__((unused)) Processor processor) {
  }
#endif /* Behavior_FETCH */
#ifdef Behavior_EXECUTE
  void execute_undefined(__attribute__((unused)) void *this, __attribute__((unused)) OperandDecoded *decoded, __attribute__((unused)) Processor processor);
  void execute_undefined(__attribute__((unused)) void *this, __attribute__((unused)) OperandDecoded *decoded, __attribute__((unused)) Processor processor) {
  }
#endif /* Behavior_EXECUTE */
#ifdef Behavior_COMMIT
  void commit_undefined(__attribute__((unused)) void *this, __attribute__((unused)) OperandDecoded *decoded, __attribute__((unused)) Processor processor);
  void commit_undefined(__attribute__((unused)) void *this, __attribute__((unused)) OperandDecoded *decoded, __attribute__((unused)) Processor processor) {
  }
#endif /* Behavior_COMMIT */
EOT
}

my %statics;
my %emitted;
my $maxrank = 0;

foreach my $opcode (@Opcode::table) {
    my $ID = $opcode->fullName('_');
    my $operator = $operator{$ID};
    my ($instruction) = $opcode->access("instruction");
    my ($synthetic) = $instruction->access("synthetic");
    my $unused = $synthetic? "__attribute__((unused))" : "";
    my @processors = $instruction->access("processors");

    my %proxies;
    my $rank = 1;
    foreach my $operand ($opcode->access("operands")) {
        my ($proxy, $index) = ("%$rank", $rank - 1);
        $proxies{$proxy}{RANK} = $rank;
        $proxies{$proxy}{INDEX} = $index;
        $operand->attribute("method") =~ /^([A-Za-z]+)/;
        $proxies{$proxy}{METHOD} = $1;
        if ($proxies{$proxy}{METHOD} eq "RegClass") {
            # Register base register of the associated register file
            my ($method) = $operand->access("method");
            my ($regFile) = $method->access("regFile");
            my ($baseRegister) = $regFile->access("registers");
            $proxies{$proxy}{VALUE} = "decoded[$index] - Register_". $baseRegister->fullName('_');
            my @multi = $method->access("multi");
            if (@multi) {
                my ($count, $shift) = (scalar @multi, 0);
                ++$shift while ($count >>= 1);
                push @{$proxies{$proxy}{SHIFT}}, $shift;
            }
        }
        $rank++;
    }

    my $extra_rank = $rank;
    my ($behavior) = $opcode->children('Behavior');
    my $proxies = $behavior->attribute("proxies") || '';
    foreach my $proxy (split ' ', $proxies) {
        $proxy =~ /%([0-9]+)(:(\d+))?/;
        my ($rank, $match_bias, $bias) = ($1, $2, $3);
        $proxies{$proxy}{RANK} = $rank;
        $proxies{$proxy}{METHOD} = $proxies{"%$rank"}{METHOD};
        if ($match_bias) {
            $proxies{$proxy}{BIAS} = $bias;
            $proxies{$proxy}{INDEX} = $extra_rank++ - 1;
            my @shifts = @{$proxies{"%$rank"}{SHIFT}};
            my $where = $proxies{"%$rank"}{VALUE};
            my $bias_str = " + $bias";
            foreach my $shift (@shifts) {
                $where = "(($where) << $shift)$bias_str";
                $bias_str = "";
            }
            $proxies{$proxy}{WHERE} = $where;
        } else {
            $proxies{$proxy}{WHERE} = $proxies{"%$rank"}{VALUE};
        }
        #elsif (defined $proxies{"%$rank"}{SHIFT}) {
        #    my $where = $proxies{"%$rank"}{VALUE};
        #    my @shifts = @{$proxies{"%$rank"}{SHIFT}};
        #    foreach my $shift (@shifts) {
        #        $where = "($where) << $shift";
        #    }
        #    $proxies{$proxy}{WHERE} = $where;
        #}
    }
    $maxrank = $extra_rank if $maxrank < $extra_rank;

    my %operands;
    my @result;
    my $pretty = "";

    my $fetch_body = "";
    my $execute_body = "";
    my $commit_body = "";

    my ($behavior) = $opcode->children('Behavior');
    if (defined $behavior) {
        $behavior = $behavior->contents();

        &Behavior::yyin(@{$behavior});
        if (&Behavior::yyparse) {
            #print STDERR $operator->name(), @{$behavior}, "\n";
            die "syntax error:\t", &Behavior::yylval, "\n";
        }
        &Behavior::yyflush;
        # my $tree = &Parallel(&Behavior::yytree);
        my $tree = &Simplify(&Behavior::yytree);
        @result = &CodeGen($tree, $opcode, \%helpers, \%proxies, \%operands, \%statics, "  ");
        $pretty = join('', &Pretty($tree, "  "));
    }

    #my $name = $opcode->name();
    #my $length = length $opcode->attribute("mnemonic");
    #(my $signature = $name) =~ s/^.{$length}//;

    foreach my $Int256_undef (sort keys %{$operands{UNDEF}}) {
        $execute_body .= "  static const Int256_ $Int256_undef;\n";
    }
    foreach my $Int256 (sort keys %{$operands{INT256}}) {
        # CodeGen decided each variable's C type (DOC/Behavior.md section 6); with
        # $Behavior::Unbox off it is Int256_ for every one of them, as it always was.
        my $type = $operands{INT256}{$Int256};
        my $zero = $type eq 'Int256_' ? 'Int256_zero' : '0';
        $execute_body .= "  $type $Int256 ${unused}= $zero;\n";
    }
    foreach my $Mask (sort keys %{$operands{MASK}}) {
        $execute_body .= "  Int256_ $Mask = Int256_zero;\n";
    }
    $execute_body .= join("\n", @result);

    my %constant_operands;
    foreach my $proxy (sort keys %proxies) {
        my $rank = $proxies{$proxy}{RANK};
        if ($proxies{$proxy}{METHOD} eq "Immediate") {
            $constant_operands{$proxy} = "Int256_fromInt64((ImmediateValue)decoded[$rank-1])";
        } elsif ($proxies{$proxy}{METHOD} eq "Modifier") {
            $constant_operands{$proxy} = "Int256_fromUInt64(ModifierMember_value(decoded[$rank-1]))";
        }
    }

    $execute_body =~ s|&&&&|\n|g;
    $execute_body .= "\n\n";
    $execute_body =~ s/([\)\w])\s+([;,])/$1$2/g;

    my $EXECUTE_ROUTINE = "#ifdef Behavior_EXECUTE\n";
    $EXECUTE_ROUTINE .= "static void\nexecute_$ID(void *this, OperandDecoded *decoded, Processor processor)\n{\n";

    $EXECUTE_ROUTINE .= "/*$pretty*/\n$execute_body}\n#endif /* Behavior_EXECUTE */";

    my $read_operands = $operands{READ};
    my $decoded_used = 0;
    foreach my $proxy (sort keys %$read_operands) {
        my $rank = $proxies{$proxy}{RANK};
        my $index = $proxies{$proxy}{INDEX};
        my $regFile = $$read_operands{$proxy}{REGFILE};
        my $stage   = $$read_operands{$proxy}{STAGE};
        my $where = $proxies{$proxy}{WHERE};
        $decoded_used = 1;
        $fetch_body .= "  HELPER(operandFromRegFile_$regFile)(this, $stage, $rank, $index, $where);\n";
    }
    foreach my $proxy (sort keys %constant_operands) {
        my $rank = $proxies{$proxy}{RANK};
        my $index = $proxies{$proxy}{INDEX};
        $decoded_used = 1;
        $fetch_body .= "  HELPER(operandFromValue)(this, $rank, $index, 0, $constant_operands{$proxy});\n";
    }

    my $FETCH_ROUTINE = "#ifdef Behavior_FETCH\n";
    if ($decoded_used eq 1) {
        $FETCH_ROUTINE .= "static void\nfetch_$ID(void *this, OperandDecoded *decoded, __attribute__((unused)) Processor processor)\n{\n";
    } else {
        $FETCH_ROUTINE .= "static void\nfetch_$ID(__attribute__((unused)) void *this,__attribute__((unused)) OperandDecoded *decoded, __attribute__((unused)) Processor processor)\n{\n";
    }

    $FETCH_ROUTINE .= "${fetch_body}}\n#endif /* Behavior_FETCH */";

    my $write_operands = $operands{WRITE};
    my $decoded_used = 0;
    foreach my $proxy (sort keys %$write_operands) {
        my $rank = $proxies{$proxy}{RANK};
        my $index = $proxies{$proxy}{INDEX};
        my $where = $proxies{$proxy}{WHERE};
        my $regFile = $$write_operands{$proxy}{REGFILE};
        my $stage = $$write_operands{$proxy}{STAGE};
        $decoded_used = 1;
        $commit_body .= "  HELPER(operandToRegFile_$regFile)(this, $stage, $rank, $index, $where);\n";
    }

    if(defined $operands{COMMITS}) {
        my @locations_list;
        my $locations = $operands{COMMITS};
        foreach my $loc (sort keys %{$locations}) {
            push @locations_list, $loc;
        }
        $commit_body .= "  /* Commits of: " . join(", ", @locations_list) . " */\n";
        $commit_body .= "  HELPER(commitRegFiles)(this);\n";

        $decoded_used = 2;
    }

    my $COMMIT_ROUTINE = "#ifdef Behavior_COMMIT\n";

    if ($decoded_used eq 1) {
        $COMMIT_ROUTINE .= "static void\ncommit_$ID(void *this, OperandDecoded *decoded, __attribute__((unused)) Processor processor)\n{\n";
    } elsif ($decoded_used eq 2) {
        $COMMIT_ROUTINE .= "static void\ncommit_$ID(void *this, __attribute__((unused)) OperandDecoded *decoded, __attribute__((unused)) Processor processor)\n{\n";
    } else {
        $COMMIT_ROUTINE .= "static void\ncommit_$ID(__attribute__((unused)) void *this, __attribute__((unused)) OperandDecoded *decoded, __attribute__((unused)) Processor processor)\n{\n";
    }

    $COMMIT_ROUTINE .= "$commit_body}\n#endif /* Behavior_COMMIT */";

    my $enums =$operands{ENUM};
    map { my $values = $$enums{$_};
        foreach my $value (sort keys %$values) {
            $enums{$_}{$value}++;
        }
      } sort keys %$enums;

    my @statics;
    foreach my $static_name (sort keys %statics) {
        unless ($emitted{$static_name}) {
            my $static_value = join ', ', @{$statics{$static_name}};
            push @statics, "static Int256_ $static_name = { .dwords = { $static_value } };\n";
            $emitted{$static_name} = 1;
        }
    }
    if (@statics) {
        print "#ifdef Behavior_STATIC\n";
        print @statics;
        print "#endif /* Behavior_STATIC */\n";
    }

    if (not defined $fetch_body{$fetch_body}) {
        $fetch_body{$fetch_body} = "fetch_$ID";
        print "$FETCH_ROUTINE\n";
    }
    $opcode_fetch{$ID} = $fetch_body{$fetch_body};

    if (not defined $execute_body{$execute_body}) {
        $execute_body{$execute_body} = "execute_$ID";
        print "$EXECUTE_ROUTINE\n";
    }
    $opcode_execute{$ID} = $execute_body{$execute_body};

    if (not defined $commit_body{$commit_body}) {
        $commit_body{$commit_body} = "commit_$ID";
        print "$COMMIT_ROUTINE\n";
    }
    $opcode_commit{$ID} = $commit_body{$commit_body};
}

print <<"EOT";
#ifndef Behavior
#define Behavior(OPCODE,FETCH,EXECUTE,COMMIT)
#else
EOT

foreach my $opcode (@Opcode::table) {
    my $ID = $opcode->fullName('_');
    my $BNAME = $ID;
    my $operator = $operator{$ID};
    if (not defined $operator) {
        $BNAME = "undefined";
    }
    croak "Opcode fetch undefined $ID" unless defined $opcode_fetch{$BNAME};
    croak "Opcode execute undefined $ID" unless defined $opcode_execute{$BNAME};
    croak "Opcode commit undefined $ID" unless defined $opcode_commit{$BNAME};
    print "Behavior($ID,FETCH($opcode_fetch{$BNAME}),",
      "EXECUTE($opcode_execute{$BNAME}),",
      "COMMIT($opcode_commit{$BNAME}))\n";
}

print <<"EOT";
#endif
#undef Behavior

EOT

print <<"EOT";
#ifndef BehaviorDeclare
#define BehaviorDeclare(ID, DECLARE)
#else
EOT

foreach  my $helper (sort keys %helpers) {
    my $declare = $helpers{$helper};
    #print STDERR "DECLARE($declare)\n";
    $declare =~ s|([^\s*]+)\(|HELPER(${1})(|g;
    print "#ifdef BehaviorDeclareAlt_$helper\n";
    print "BehaviorDeclare($helper,DECLARE_ALT($declare))\n";
    print "#else\n";
    print "BehaviorDeclare($helper,DECLARE($declare))\n";
    print "#endif\n";
}

print <<"EOT";
#endif
#undef BehaviorDeclare

EOT

print <<"EOT";
#ifndef Behavior_MAXRANK
#define Behavior_MAXRANK $maxrank
#endif/*Behavior_MAXRANK*/

EOT

# vim: set ts=4 sw=4 et:
