#!/usr/bin/perl -w
# Machine Description System (MDS)
#
# Copyright (C) 2005 STMicroelectronics.
#
# Stephen Clarke (Stephen.Clarke@st.com).
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

# Create opcodes/$target-opc.c file for binutils.

use strict;
use warnings "FATAL" => "all";

use MDS;
use BitString;
use AsmTestLib;
use GBUTarget;
use GBU;
use Carp;
use GBUFamilyRegFiles;

my $Family = $ENV{FAMILY};
my $FAMILY = uc $Family;
my $wordWidth = &GBUTarget::wordWidth();


sub getRegisterNames {
    my ($register, $core) = @_;

    my %registers;
    foreach my $register (@Register::table) {
        my @processors = $register->access("processors");
        foreach my $processor (@processors) {
            $registers{$register->name()}{$processor->core()} = $register;
        }
    }

    my $reg = $register;
    if(not defined $reg) {
        $reg = $registers{$register->name()}{$core};
        if(not defined $reg) {
            croak "Unable to get register " . $register->name() . " for core $core";
        }
    }
    return split(' ',$reg->attribute("names"));
}

sub printHeader {
    my $file = shift;

    #  my $copyrights = &MDS::get_copyrights("*** ","\n");

    print $file <<"EOT";
/* lvx-opc.c -- LVX opcode support.
   Copyright (C) 2009-2024 Free Software Foundation, Inc.
   Contributed by Kalray SA.

   This file is part of the GNU opcodes library.

   This library is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 3, or (at your option)
   any later version.

   It is distributed in the hope that it will be useful, but WITHOUT
   ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
   or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
   License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; see the file COPYING3. If not,
   see <http://www.gnu.org/licenses/>.  */

#include "sysdep.h"
#include <stddef.h>
#include <stdio.h>
#include "bfd.h"
#include "libbfd.h"
EOT

    print $file "#include <elf/$Family.h>\n";
    print $file "#include <opcode/$Family.h>\n\n";
}

sub printRegisters {
    my $file = shift;
    my $core = shift;
    my $core_uc = uc($core);

    my %regfiles;
    foreach my  $regfile (&MDS::regFiles()) {
        push @{$regfiles{$regfile->regFileName()}}, $regfile;
    }
    my @sorted_regfiles = get_sorted_regfilenames($FAMILY, [ &MDS::regFiles() ]);

    #    foreach my $processor (@Processor::table) {
    # Regfiles
    my $reg_offset = 0;
    my $last_reg_offset;
    my $dec_reg_offset = 0;
    my $last_dec_reg_offset;
    my $last_rf_name;

    print $file "int ${core}_regfiles[] = {\n";
    foreach my $rf_name (@sorted_regfiles) {
        my @regfiles = @{$regfiles{$rf_name}};
        my $found_rf_for_this_core = 0;
        foreach my $regfile (@regfiles) {
            #my @processors = $regfile->access("processors");
            #my @tmp_cores = map { $_->core(); } @processors;
            #if(grep {/\b$core\b/} @tmp_cores) {
            $found_rf_for_this_core = 1;
            if(defined $last_reg_offset) {
                print $file "  $last_reg_offset, \t/* ${core_uc}_REGFILE_FIRST_".uc($last_rf_name)." */\n";
                print $file "  ".eval($reg_offset-1).", \t/* ${core_uc}_REGFILE_LAST_".uc($last_rf_name)." */\n";
                print $file "  $last_dec_reg_offset, \t/* ${core_uc}_REGFILE_DEC_".uc($last_rf_name)." */\n";
            }
            my @registers = $regfile->access("registers");
            $last_dec_reg_offset = $dec_reg_offset;
            $dec_reg_offset += scalar @registers;
            $last_reg_offset = $reg_offset;

            map { my @names =  getRegisterNames($_, $core); $reg_offset += scalar @names; } @registers;

            $last_rf_name = $rf_name;
            #}
        }
        if(not $found_rf_for_this_core) {
            print $file "  -1,\n";
            print $file "  -1,\n";
            print $file "  -1,\n";
        }
    }

    print $file "  $last_reg_offset, \t/* ${core_uc}_REGFILE_FIRST_".uc($last_rf_name)." */\n";
    print $file "  ".eval($reg_offset-1).", \t/* ${core_uc}_REGFILE_LAST_".uc($last_rf_name)." */\n";
    print $file "  $last_dec_reg_offset, \t/* ${core_uc}_REGFILE_DEC_".uc($last_rf_name)." */\n";
    print $file "  $reg_offset, \t/* ${core_uc}_REGFILE_REGISTERS*/\n";
    print $file "  $dec_reg_offset, \t/* ${core_uc}_REGFILE_DEC_REGISTERS*/\n";
    print $file "};\n\n";
    print $file "struct ${Family}_register ${core}_registers[] = {\n";

    my %decReg;
    my $tableId = 0;
    my $regId = 0;
    foreach my $rf_name (@sorted_regfiles) {
        my @regfiles = @{$regfiles{$rf_name}};
        foreach my $regfile (@regfiles) {
            #my @processors = $regfile->access("processors");
            #if(grep {/\b$core\b/} map { $_->core(); } @processors) {
            my @registers = $regfile->access("registers");
            my $id = 0;
            foreach my $register (@registers) {
                my @names = getRegisterNames($register, $core);
                $decReg{$regId}{ID} = $tableId;
                $decReg{$regId}{NAME} = $names[0];
                foreach my $name (@names) {
                    print $file "  { $id, \"$name\"}, /* $tableId */\n";
                    $tableId++;
                }
                $id++;
                $regId++;
            }
            #}
        }
    }

    print $file "};\n\n";

    print $file "int ${core}_dec_registers[] = {\n";
    for( my $i = 0; $i < $regId; $i++) {
        if(defined $decReg{$i}) {
            print $file "  $decReg{$i}{ID}, /* $i $decReg{$i}{NAME} */\n";
        } else {
            print $file "  -1, /* $i */\n";
        }
    }
    print $file "};\n\n";
    #    }
}

sub printModifiers {
    my $file = shift;
    my $core = shift;

    foreach my $modifier (@Modifier::table) {
        next unless defined $modifier->name();
        my $name = $modifier->attribute("ID");
        $name =~ s/\W/_/g;
        $name =~ s/Modifier/mod/;
        print $file "const char *${name}[] = {\n";
        my @names = map {s/^_//;$_} split ' ', (lc $modifier->attribute("members"));
        for(my $i=0; $i<@names; $i++) {
            print $file "  \"$names[$i]\",\n";
        }
        print $file "  NULL,\n";
        print $file "};\n\n";
    }

    my @mod_names;
    print $file "const char **${core}_modifiers[] = {\n";
    foreach my $modifier (@Modifier::table) {
        next unless defined $modifier->name();
        my $name = $modifier->attribute("ID");
        $name =~ s/\W/_/g;
        $name =~ s/Modifier/mod/;
        $name = "  " . $name;
        push @mod_names, $name;
    }
    print $file (join(",\n", (sort @mod_names)));
    print $file "\n};\n\n";
}

sub printRelocations {
    my $file = shift;

    foreach my  $reloc (@Relocation::table) {
        my $reloc_name = $reloc->core()."_".$reloc->name()."_reloc";
        my @howtos = split(' ',$reloc->attribute("linker"));
        my $reloc_nb = scalar(@howtos);
        my @bfields = $reloc->access("fields");
        my $bitsize = 0;
        foreach my $bfield (@bfields) {
            $bitsize += $bfield->attribute("width");
        }
        my $relative = $reloc->attribute("relative") || "ABS";
        $relative = "${FAMILY}_REL_" . $relative;
        my $howtos_str = join(", ", @howtos);

        print $file <<"EOT";
struct ${Family}_reloc $reloc_name __attribute__((unused)) = {
  .bitsize = $bitsize,
  .relative = $relative,
  .reloc_nb = $reloc_nb,
  .relocs = { $howtos_str }
};
EOT
    }
    print $file "\n";
}

sub gcd {
    my ($u, $v) = @_;
    return $u unless $v;
    return $v unless $u;
    my $g = 1;
    while (!($u & 0x1) && !($v & 0x1)) {
        $u >>= 1;
        $v >>= 1;
        $g <<= 1;
    }
    while ($u > 0) {
        if (!($u & 0x1)) { $u >>= 1; }
        elsif (!($v & 0x1)) { $v >>= 1; }
        else {
            if ($u < $v) {
                $v = ($v - $u) >> 1;
            } else {
                $u = ($u - $v) >> 1;
            }
        }
    }
    return $g*$v;
}

sub isSynthetic {
    my $opcode = shift;
    my $instructionID = $opcode->attribute("instruction");
    my $instruction = &MDS::fetch($instructionID);
    return defined $instruction->attribute("synthetic");
}

sub methodIsSigned {
    my $methodID = shift;
    my $method = &MDS::fetch($methodID);

    if (ref($method) =~ /Immediate/) {
        my $extend = $method->attribute("extend");
        return $extend =~ /\bSigned\b/;
    }

    return 0;
}

sub methodIsWrapped {
    my $methodID = shift;
    my $method = &MDS::fetch($methodID);

    if (ref($method) =~ /Immediate/) {
        my $extend = $method->attribute("extend");
        return $extend =~ /\bWrap\b/;
    }

    return 0;
}

sub methodShift {
    my ($methodID) = shift;
    my $method = &MDS::fetch($methodID);

    if (ref($method) =~ /Immediate/) {
        my $shift = $method->attribute("shift");
        if(defined $shift) {
            return $shift;
        }
    }
    if (ref($method) =~ /RegClass/) {
        my $shift = $method->attribute("shift");
        if(defined $shift) {
            return $shift;
        }
    }

    return 0;
}

sub methodBias {
    my ($methodID) = shift;
    my $method = &MDS::fetch($methodID);

    if (ref($method) =~ /Immediate/) {
        my $bias = $method->attribute("bias");
        if(defined $bias) {
            return $bias;
        }
    }
    if (ref($method) =~ /RegClass/) {
        my $bias = $method->attribute("bias");
        if(defined $bias) {
            return $bias;
        }
    }

    return 0;
}

sub printOpndType {
    my ($file, $name, $mname, $width, $shift, $bias, $flags, $bitfields,$regs,$relocs) = @_;
    my $bitfield_nb = scalar(keys %$bitfields);

    my $reg_nb = scalar(@$regs);
    if($reg_nb) {
        print $file "static int ${name}_regs[] = {";
        my $reg_idx = 0;
        foreach my $reg (@$regs) {
            if($reg_idx %16 == 0) {
                print $file "\n      ";
                $reg_idx = 0;
            }
            print $file "$reg, ";
            $reg_idx++;
        }
        print $file "};\n";
    }

    my $reloc_nb = scalar(@$relocs);
    print $file "static struct ${Family}_reloc *${name}_relocs[] __attribute__((unused)) = {\n";
    my @reloc_names;
    foreach my $reloc (@$relocs) {
        my $reloc_name = "  &".$reloc->core()."_".$reloc->name()."_reloc";
        push @reloc_names, $reloc_name;
    }
    push @reloc_names, "  0\n";
    print $file join(",\n",@reloc_names);
    print $file "};\n";

    my $regs_str = $reg_nb ? "${name}_regs" : "0";

    my $bitfields_str = "";
    foreach my $bitfield (sort keys %$bitfields) {
        $bitfields_str .= "{ $$bitfields{$bitfield}{SIZE}, "
          . "$$bitfields{$bitfield}{FROM_OFFSET}, "
          . "$$bitfields{$bitfield}{TO_OFFSET} }, ";
    }

    print $file <<"EOT";
static struct ${Family}_operand $name  __attribute__((unused)) = {
  .tname = "$name",
  .type = $mname,
  .width = $width,
  .shift = $shift,
  .bias = $bias,
  .flags = $flags,
  .reg_nb = $reg_nb,
  .regs = $regs_str,
  .reloc_nb = $reloc_nb,
  .relocs = ${name}_relocs,
  .bitfields = $bitfield_nb,
  .bfield = { $bitfields_str }
EOT
    print $file "};\n\n";
}

sub getRegs {
    my ($method,$regs) = @_;
    if(ref $method eq "RegClass") {
        my ($regfile) = $method->access("regFile");
        my @regfile_regs = map { $_->name(); } $regfile->access("registers");
        my @regclass_regs = $method->access("registers");
        my %regclass_regs;
        map { $regclass_regs{$_->name()} = 1; } @regclass_regs;
        foreach my $reg (@regfile_regs) {
            if(defined $regclass_regs{$reg}) { push @$regs, "1"; }
            else { push @$regs, "0"; }
        }
    }
}

sub getOpndName {
    my ($opndID) = @_;
    my $opd_core;
    my $opd_name;
    if(&MDS::exists($opndID)) {
        my $opnd = &MDS::fetch($opndID);
        $opd_core = $opnd->core();
        $opd_name = $opnd->name();
    }
    else {
        # Hack for ST200 link register...
        if($opndID =~ /^Operand-([a-zA-Z0-9]+)-([a-zA-Z0-9]+)/) {
            $opd_core = $1;
            $opd_name = $2;
        }
        else {
            croak "Unrecognized operand ID: $opndID";
        }
    }

    croak "Undefined operand core" if(not defined $opd_core);
    croak "Undefined operand name" if(not defined $opd_name);

    (my $opndName = $opd_core."_".$opd_name."_opnd") =~ s/\W/_/g;
    return lc($opndName);
}

sub printOpndTypes {
    my $file = shift;

    my %hasImmediateExtension;
    foreach my $immediate (@Immediate::table) {
        if(defined $immediate->attribute("canExtend")) {
            my @extendedImms = $immediate->access("canExtend");
            map { $hasImmediateExtension{$_->attribute("ID")} = 1; } @extendedImms;
        }
    }

    foreach my $opd (sort { $a->name() cmp $b->name(); } @Operand::table) {
        my $name = &getOpndName($opd->attribute("ID"));
        my $methodID = $opd->attribute("method");
        my $method = &MDS::fetch($methodID);
        my @relocations = $opd->access("relocations");

        my $mname = $methodID;
        $mname =~ s/\W/_/g;
        next if ($mname =~ /_\d+$/); # Skip multi-RegClass

        my $method_shift = methodShift($methodID);
        my $method_bias = methodBias($methodID);
        # flags: SIGNED = 1, CANEXTEND = 2, BITMASK = 4.
        my @flags;
        push @flags, "${FAMILY}_OPERAND_SIGNED" if (methodIsSigned($methodID));
        push @flags, "${FAMILY}_OPERAND_WRAPPED" if (methodIsWrapped($methodID));
        push @flags, "${FAMILY}_OPERAND_CANEXTEND" if ($hasImmediateExtension{$methodID} or &GBUTarget::methodCanExtend($methodID));
        push @flags, "${FAMILY}_OPERAND_BITMASK" if ($methodID =~ /^Immediate/ and defined $method->attribute("bitmask"));
        push @flags, "0" if (@flags == 0);

        my @bfield = $opd->access("fields")
          if(defined $opd->attribute("fields"));
        my %bitfields;
        my $bf_idx = 'A';
        my $method_width = 0;
        foreach my $bfield (@bfield) {
            $method_width += $bfield->attribute("width");
        }
        my $bf_from_offset = $method_width;
        foreach my $bfield (@bfield) {
            my $bf_name = $bf_idx."_".$bfield->attribute("ID");
            my $width = $bfield->attribute("width");
            my $offset = $bfield->attribute("offset");
#print STDERR "\nBF NAME $bf_name\twidth=$width\toffset=$offset\tmethod=$methodID\tmethod_width=$method_width\n";
            $bf_from_offset -= $width;
            $bf_from_offset = 0 if($bf_from_offset < 0);
            $bitfields{$bf_name}{SIZE} = $width;
            $bitfields{$bf_name}{FROM_OFFSET} = $bf_from_offset;
            $bitfields{$bf_name}{TO_OFFSET} = $offset;
            $bf_idx++;
        }
        my @regs;
        getRegs($method,\@regs);
        printOpndType $file, $name, $mname, $method_width, $method_shift, $method_bias, (join " | ", @flags), \%bitfields, \@regs, \@relocations;
    }
    # ... and we have one completely synthesized operand type
    my $opdtypes = &GBUTarget::getAdditionalOpndType();
    foreach my $name (sort keys %$opdtypes) {
        my %bitfields;
        my @relocations;
        $bitfields{BF}{SIZE}=$$opdtypes{$name}{WIDTH};
        $bitfields{BF}{FROM_OFFSET}=0;
        $bitfields{BF}{TO_OFFSET}=$$opdtypes{$name}{SHIFT};
        my $method = &MDS::fetch($$opdtypes{$name}{MNAME});
        my $mname = $$opdtypes{$name}{MNAME};
        my @regs;
        getRegs($method,\@regs);
        $mname =~ s|\-|_|g;
        printOpndType $file, $name, $mname, $$opdtypes{$name}{WIDTH}, $$opdtypes{$name}{SHIFT}, $$opdtypes{$name}{BIAS}, $$opdtypes{$name}{FLAGS}, \%bitfields, \@regs, \@relocations;
    }

    print $file "\n";

}

sub factorBundleTypes {
    my @bundle_types = @_;

    my @recordNames;
    my %recordTable;
    my %recordNameAlignments;
    foreach my $bundle_type (@bundle_types) {
        my ($length, $bias, $base, $entries) = split ':', $bundle_type;
        my @alignment = ($bias, $base);
        my $alignment = join ' ', @alignment;
        if (! exists $recordNameAlignments{$entries}{$alignment}) {
            my $record = {
                ALIGNMENT=>  [ @alignment ],
              };
            push @recordNames, $entries unless $recordTable{$entries};
            push @{$recordTable{$entries}}, $record;
            $recordNameAlignments{$entries}{$alignment} = 1;
        }
    }

    foreach my $recordName (@recordNames) {
        my @records = sort {
            $$a{ALIGNMENT}[1] <=> $$b{ALIGNMENT}[1];
          } @{$recordTable{$recordName}};
        if (@records > 1) {
            my $gcd = 0;
            #            print STDERR "$recordName\n";
            # Compute the GCD of alignments.
            foreach my $record (@records) {
                my ($bias, $base) = @{$$record{ALIGNMENT}};
                $gcd = &gcd($gcd, $bias);
                $gcd = &gcd($gcd, $base);
            }
            # Collect and collapse the generators.
            my %generator;
            foreach my $record (@records) {
                my ($bias, $base) = @{$$record{ALIGNMENT}};
                my $remainder = $bias/$gcd;
                my $factor = $base/$gcd;
                $generator{$factor}{$remainder}++;
                my @remainders = keys %{$generator{$factor}};
                if ($factor > 1 && @remainders == $factor) {
 #print STDERR "$recordName COLLAPSE($factor, ", (join ' ', @remainders), ")\n";
                    delete $generator{$factor};
                    $generator{1}{0}++;
                }
            }
            # Rewrite the @records;
            my $record = $records[0];
            @records = ();
            foreach my $factor (sort {$a <=> $b} keys %generator) {
                my $base = $factor*$gcd;
                my @remainders = keys %{$generator{$factor}};
                foreach my $remainder (sort {$a <=> $b} @remainders) {
                    my $bias = $remainder*$gcd;
                    push @records, { %{$record}, ALIGNMENT=> [ $bias, $base ] };
                }
            }
            @{$recordTable{$recordName}} = @records;
        }
    }

    # Recreate the bundle types.
    @bundle_types = ();
    foreach my $recordName (@recordNames) {
        my @s = split ',', $recordName;
        my $length = scalar @s;
        foreach my $record (@{$recordTable{$recordName}}) {
            my ($bias, $base) = @{$$record{ALIGNMENT}};
            push @bundle_types, "$length:$bias:$base:$recordName";
        }
    }
    return sort @bundle_types;
}

sub printBundleTypes {
    my $file = shift;

    # Build and print bundle_types table
    print $file "BundleType bundle_types[] = {\n";
    my $val = 0;
    foreach my $bundle (@Bundle::table) {
        my ($template) = $bundle->access("template");
        my @nops;
        if (defined $template->attribute("nopified")) {
            my ($original_template) = $template->access("original");
            my $original_dispersals = $original_template->attribute("dispersals");
            my $pos = 0;
            my %dispersal_map = map { $_ => $pos++ } split ' ', $original_dispersals;
            @nops = sort { $a <=> $b } map { $dispersal_map{$_} } split ' ', $template->attribute("nopified");
        }
        push @nops, -1;
        my $name = "Bundle_".$bundle->fullName('_');
        my @contents = $bundle->access("contents");
        next if scalar @contents == 0;
        my $length = scalar @contents;
        my $bias = $bundle->attribute("alignBias");
        my $base = $bundle->attribute("alignBase");
        my $contents = join ', ', map { "Bundling_".$_->fullName('_') } @contents;
        my $nops = join ', ', @nops;
        my $nnops = scalar @nops - 1;
        print $file "#define $name $val\n";
        print $file "  { $length, $bias, $base, $nnops, { $contents }, { $nops } }, \n";
        $val++;
    }

    print $file "  { -1, 0, 0, 0, {}, {} }};\n\n";

    # Build bundlematch table
    my %canonical;
    my %bundlematch;
    my $nBundlings = scalar @Bundling::table;
    my $maxhash = -1;
    foreach my $bundle (@Bundle::table) {
        my ($template) = $bundle->access("template");
        my $mappingKey = $bundle->attribute("canonic") || '';
        my $mappingHash = 0;
        foreach my $bundlingID (split ' ', $mappingKey) {
            $mappingHash = ($mappingHash * $nBundlings) + $GBU::order{$bundlingID};
        }
        next if $mappingHash == 0;
        $maxhash = $mappingHash if ($mappingHash > $maxhash);
        push @{$bundlematch{$mappingHash}}, $bundle;
    }
    die "maxhash ($maxhash) too large for int\n", $maxhash if ($maxhash > ((1 << 31) - 1));

    # Print bundlematch table
    print $file "int bundlematch_table_size = $maxhash;\n";
    print $file "int bundlematch_table[$maxhash + 1] = { \n /*     0 */ ";
    my $canonical_count = 0;
    my $canonical;
    foreach my $i (0..$maxhash) {
        my $val = -1;
        if ($bundlematch{$i}) {
            my @bundles = @{$bundlematch{$i}};
            my $count = scalar @bundles;
            my $bundles = @bundles ? (join ', ', map { "Bundle_".$_->fullName('_') } @bundles) : "0";
            $canonical.= "  { $count, { $bundles } },\n";
            $val = $canonical_count++;
        }
        printf $file " %4d,", $val;
        printf $file "\n /* %5d */ ", $i+1 if (($i+1) % 10) == 0;
    }
    print $file "};\n\n";
    print $file "BundleMatchType canonical_table[$canonical_count] = {\n$canonical};\n\n";
}

sub printResources {
    my $file = shift;
    my $core = shift;

    my @resource_strings;

    my %avail;

    foreach my $resource (@Resource::table) {
        my $resourceID = $resource->attribute("ID");
        my $resource_name = $resourceID;
        my $resource_string = $resource_name;
        $resource_string =~ s/(.*)\-(.*)\-(.*)/$3/;
        push @resource_strings, "\"$resource_string\"";
        my @availability = split ' ', $resource->attribute("availability");
        $avail{$resourceID} = shift @availability;
    }

    print $file "\nconst char *${core}_resource_names[${core}_RESOURCE_COUNT] = {\n  ";
    print $file (join ",\n  ", @resource_strings), "\n};\n\n";

    foreach my $processor (@Processor::table) {
        my @resources = map { $avail{$_->attribute("ID")} || "0"; } (@Resource::table);
        print $file "const int ${core}_resources[${core}_RESOURCE_COUNT] = { ", (join ',', @resources), "};\n";
    }
    print $file "\n";

    my %reservation_table;
    my $max_table_line = 0;
    foreach my $reservation (@Reservation::table) {
        my $reservationID = $reservation->attribute("ID");
        my @requirements = split ' ', $reservation->attribute("requirements");
        my @resources = split ' ', $reservation->attribute("resources");
        my $reservation_table_line = 0;
        my $table_line = 0;
        foreach my $requirement (@requirements) {
            if (! @resources) {
                $table_line++;
                $max_table_line = $table_line if ($table_line > $max_table_line);
                @resources = split ' ', $reservation->attribute("resources");
            }
            my $resource = shift @resources;
            $reservation_table{$reservationID}{$table_line}{$resource} = $requirement;
        }
    }
    print $file "\n\n#define ${core}_RESERVATION_TABLE_CYCLES ", $max_table_line + 1, "\n";
    print $file "const int ${core}_reservation_table_cycles = ${core}_RESERVATION_TABLE_CYCLES;\n\n";

    foreach my $reservation (sort keys %reservation_table) {
        my $reservation_name = $reservation;
        $reservation_name =~ s/\W/_/g;
        my @lines;
        foreach my $table_line (0 .. $max_table_line) {
            push @lines, join ",\n  ", ( map {
                    my $resourceID = $_->attribute("ID");
                    ($reservation_table{$reservation}{$table_line}{$resourceID} || "0")." /* cyc.$table_line $resourceID */";
                  } (@Resource::table));
        }
        print $file "static const int ${reservation_name}_table[${core}_RESERVATION_TABLE_CYCLES * ${core}_RESOURCE_COUNT] = {\n  ", (join ",\n  ", @lines), "\n};\n\n";
    }

    print $file "const int *${core}_reservation_tables[] ={\n  ";
    print $file join ",\n  ", (map {
            my $reservation_name = $_->attribute("ID");
            $reservation_name =~ s/\W/_/g;
            "${reservation_name}_table";
          } @Reservation::table);
    print $file "\n};\n\n";
}

sub printInst {
    my ($file, $opcode, $opcode_key, $coding_size, $modifier_proxies, $modifier_names, $modifier_bitstring) = @_;

    my $instructionID = $opcode->attribute("ID");
    my $mnemonic = $opcode->attribute("mnemonic");
    my ($scheduling) = $opcode->access("scheduling");
    my $bundling = $scheduling->attribute("bundling");
    my $reservation = $scheduling->attribute("reservation");
    my $format = &MDS::fetch($opcode->attribute("format"));
    my $encoding = &MDS::fetch($format->attribute("encoding"));
    my $operands = $opcode->attribute("operands") || "";
    my @operands_ = $opcode->access("operands");
    my @operands = (split ' ', $operands);

    $bundling =~ s/\W/_/g;
    $reservation =~ s/\W/_/g;

    my $syntax = $opcode->attribute("syntax");

    my $encoded = $opcode->attribute("encoded");
    my $coding_words = $coding_size % 32 != 0 ? int($coding_size / 32) + 1 : int($coding_size / 32);
    my $bitstring = BitString->new(0, $encoded);
#print STDERR "$instructionID proxies:\t$modifier_proxies\n" if defined $modifier_proxies;

    # Replace all Modifier proxies by a member name.
    if(defined $modifier_proxies) {
        my @modifier_proxies = split ' ', $modifier_proxies;
        my @modifier_names = split ' ', $modifier_names;
        croak "Not same number of proxies/names ($modifier_proxies/$modifier_names)"
          if(scalar(@modifier_proxies) != scalar(@modifier_names));
        for(my $i=0; $i<@modifier_proxies; $i++) {
            $syntax =~ s|$modifier_proxies[$i]|$modifier_names[$i]|g;
        }
        # Assume empty modifiers are '.', and remove them from $syntax
        undef while $syntax =~ s/\.\./\./g;
        $syntax =~ s/\.(\s)/$1/;
        $syntax =~ s/\.$//;
        #
        $bitstring = $bitstring->merge($bitstring,$modifier_bitstring);
    }

    my @fullmasks = $bitstring->hex_mask(32);
    my @fullcodes = $bitstring->hex_value(32);

    foreach my $synthesized_mnemonic (&GBUTarget::synthesizeMnemonics($mnemonic, $syntax)) {
        $synthesized_mnemonic =~ s/%.*//d;

        print $file <<"EOT";
  { /* $opcode_key */
    .as_op = "$synthesized_mnemonic",
    .codewords = {
EOT

        for(my $i=0; $i < $coding_words; $i++) {
            my $flags = &GBUTarget::getOpcodeFlags($opcode,$synthesized_mnemonic,$fullcodes[$i],$i)  || "${FAMILY}_OPCODE_FLAG_UNDEF";
            print $file <<"EOT";
      {
        .opcode = $fullcodes[$i],
        .mask = $fullmasks[$i],
        .flags = $flags
      },
EOT
        }

        print $file <<"EOT";
    },
    .wordcount = $coding_words,
    .bundling = (int)$bundling,
    .reservation = (int)$reservation,
    .format = {
EOT
    #    foreach my $operand (@operands_) {
    #      if ($operand->attribute("method") =~ /^Modifier/) {
    #        print $file (lc "      &" . $operand->attribute("method") . ",\n");
    #      }
    #    }
        my @opds = &GBUTarget::synthesizeOperands ($synthesized_mnemonic, $syntax, \@operands);
        if (@opds) {
            my @opndstr;
            map { push @opndstr, "      &".&getOpndName($_); } @opds;
            my $opstring = join(",\n",@opndstr);
            print $file (lc $opstring), ",\n";
        }
        my $syntax = &GBUTarget::fixSyntax($synthesized_mnemonic, $syntax);
        print $file <<"EOT";
      NULL
    },
    .fmtstring = "$syntax",
  },
EOT
    }
}

sub printOpcode {
    my ($file, $opcode, $opcode_key) = @_;

    my @operands = $opcode->access("operands");
    my $format = &MDS::fetch($opcode->attribute("format"));
    my $encoding = &MDS::fetch($format->attribute("encoding"));
    my ($coding_size) = $encoding->attribute("wordCount")*$encoding->attribute("wordWidth");
    my $modifiers = &GBU::getModifiers($coding_size,@operands);

    my $instr_nb = 0;

    # if(keys %$modifiers) {
    #     foreach my $modifier (sort keys %$modifiers) {
    #         printInst($file,$opcode, $opcode_key, $coding_size,
    #         $$modifiers{$modifier}{proxies}, $$modifiers{$modifier}{names},
    #         $$modifiers{$modifier}{coding});
    #     }
    # } else {
    $instr_nb++;
    my $modifier_proxies;
    my $modifier_names;
    printInst($file, $opcode, $opcode_key, $coding_size, $modifier_proxies, $modifier_names);
    # }

    return $instr_nb;
}

sub get_opcode_key {
    my ($opcode) = @_;

    my $opcode_key = $opcode->attribute("ID");
    my @operands = $opcode->access("operands");

    foreach my $operand (@operands) {
        my $operand_name = $operand->name();
        my ($method) = $operand->access("method");

        if($method->type() eq "Immediate") {
            my $width = $method->attribute("width");
            my $extend = $method->attribute("extend");

            croak "Unrecognized extend: $extend"
              if($extend ne "Signed" and
                $extend ne "Unsigned" and
                $extend ne "Wrap");

            $extend =~ s/Signed/s/;
            $extend =~ s/Unsigned/u/;
            $extend =~ s/Wrap/w/;

            my $method_id = sprintf("%s%03d",$extend,scalar($width));
            $opcode_key =~ s/$operand_name/$method_id/g;
        }
    }
    $opcode_key;
}

sub printInstTab {
    my $file = shift;
    my $core = shift;

    my $nb_inst = 0;

    my %opcodes;

    # Build a map from decodingID to encodingID.
    my %encodingID = ();
    my %decodingID = ();
    foreach my $decoding (@Decoding::table) {
        my $encodingID = $decoding->attribute("encoding");
        my $decodingID = $decoding->attribute("ID");
        my $decoding_core = $decoding->core();
        $decodingID{$encodingID."_".$decoding_core} = $decodingID;
    }

    foreach my $opcode (@Opcode::table) {
        if ($opcode->core() eq $core && !&GBUTarget::isExtended($opcode)) {
            my $encodingID = $opcode->attribute("encoding");
            $encodingID{$decodingID{$encodingID."_".$core}} = 1;
        }
    }

    my @opcodes = &sort_decoding ($core, sort keys %encodingID);

    foreach my $opcode (@opcodes) {
        my ($instruction) = $opcode->access("instruction");
        my $opcode_key = get_opcode_key($opcode);
        if(defined $instruction->attribute("synthetic")) {
            my ($synthetic) = $instruction->access("synthetic");
            my $forced = $synthetic->attribute("forced");
            if(defined $forced) {
# Check if forced operand is a modifier. In this case, it is managed as asm alias
                my @formats = $synthetic->access("formats");
                my @forced = split(' ', $forced);
                my @operands = $formats[0]->access("operands");
                my $all_opnd_modifiers = 1;
                foreach my $f (@forced) {
                    $f =~ /%([0-9]+)/;
                    my $opnd_idx = $1 - 1;
                    my $operand = $operands[$opnd_idx];
                    if(defined $operand && $operand->attribute("method") !~ /^Modifier/) {
                        $all_opnd_modifiers = 0;
                    }
                }
                if($all_opnd_modifiers) {
# Put pure alias synthetic at the end to get not synthetic version during disassembly...
                    $opcodes{"~_".$opcode_key} = $opcode;
                }
                else {
                 # Put synthetic before others to get them during disassembly...
                    $opcodes{"A_".$opcode_key} = $opcode;
                }
            }
            else {
# Put pure alias synthetic at the end to get not synthetic version during disassembly...
                $opcodes{"~_".$opcode_key} = $opcode;
            }
        }
        else {
            $opcodes{$opcode_key} = $opcode;
        }
    }

    print $file "struct ${Family}_opc ${core}", "_optab[] = {\n";
    foreach my $opcode_key (sort keys %opcodes) {
        my $opcode = $opcodes{$opcode_key};

        # Mnemonic with _ at the end are illegal.
        next if($opcode->attribute("mnemonic") =~ /_$/);
        $nb_inst += printOpcode ($file, $opcode, $opcode_key);
    }

    print $file "/* Number of instructions: ", $nb_inst, " */\n";
    print $file "  {\"\", { }, 0, 0, 0, { }, \"\"}\n};\n\n";
}

sub printCoreInfo {
    my $file = shift;
    my $core = shift;
    my $optab = "${core}_optab";
    my $resources = "${core}_resources";
    my $core_names = &GBUTarget::CoreNames($core);
    my $core_elfs = &GBUTarget::elfCoreInfo($core);

    print STDERR "Core names: $core_names, core elfs: $core_elfs\n";

    print $file "const struct ",${Family},"_core_info ${core}_core_info = { $optab, \"$core_names\", $resources, $core_elfs, ${core}_pseudo_func, 26, (int **) ${core}_reservation_tables, ${core}_RESERVATION_TABLE_CYCLES, ${core}_RESOURCE_COUNT, (char **) ${core}_resource_names };\n\n";
}

sub printCoreInfoTable {
    my $file = shift;
    my @cores = @_;

    @cores = map { "& ${_}_core_info" } @cores;
    print $file "const struct ",${Family},"_core_info *${Family}_core_info_table[] =\n{\n  ";
    print $file (join ",\n  ", @cores), "\n};\n\n";
}

sub printCoreRegisterTable {
    my $file = shift;
    my @cores = @_;

    @cores = map { "${_}_registers" } @cores;
    print $file "const struct ",${Family},"_register *${Family}_registers_table[] =\n{\n  ";
    print $file (join ",\n  ", @cores), "\n};\n\n";
}

sub printCoreModifierTable {
    my $file = shift;
    my @cores = @_;

    @cores = map { "${_}_modifiers" } @cores;
    print $file "const char ***${Family}_modifiers_table[] =\n{\n  ";
    print $file (join ",\n  ", @cores), "\n};\n\n";
}

sub printCoreRegFileTable {
    my $file = shift;
    my @cores = @_;

    my @cores_regfiles = map { "${_}_regfiles" } @cores;
    print $file "const ","int *${Family}_regfiles_table[] =\n{\n  ";
    print $file (join ",\n  ", @cores_regfiles), "\n};\n\n";

    my @cores_regfiles_size = map { uc($_) . "_REGFILE_REGISTERS" } @cores;
    print $file "const ","int ${Family}_regfiles_size_table[] =\n{\n  ";
    print $file (join ",\n  ", @cores_regfiles_size), "\n};\n\n";
}

sub printPseudoFuncs {
    my $file = shift;
    my $core = shift;

    print $file <<"EOT";
struct pseudo_func ${core}_pseudo_func[] = {
  // reloc pseudo functions:
  {
    .name = "signed32",
    .pseudo_relocs = {
      .avail_modes = PSEUDO_ALL,
      .bitsize = 32,
      .reloc_type = S32_LO5_UP27,
      .reloc_lo5 = BFD_RELOC_LVX_S32_LO5,
      .reloc_up27 = BFD_RELOC_LVX_S32_UP27,
      .single = BFD_RELOC_UNUSED,
      .kreloc = & ${core}_signed32_reloc,
    }
  },
  {
    .name = "gotoff",
    .pseudo_relocs = {
      .avail_modes = PSEUDO_ALL,
      .bitsize = 37,
      .reloc_type = S37_LO10_UP27,
      .reloc_lo10 = BFD_RELOC_LVX_S37_GOTOFF_LO10,
      .reloc_up27 = BFD_RELOC_LVX_S37_GOTOFF_UP27,
      .single = BFD_RELOC_UNUSED,
      .kreloc = & ${core}_gotoff_signed37_reloc,
    }
  },
  {
    .name = "gotoff",
    .pseudo_relocs = {
      .avail_modes = PSEUDO_32_ONLY,
      .bitsize = 32,
      .reloc_type = S32,
      .single = BFD_RELOC_LVX_32_GOTOFF,
      .kreloc = & ${core}_gotoff_32_reloc,
    }
  },
  {
    .name = "got",
    .pseudo_relocs = {
      .avail_modes = PSEUDO_ALL,
      .bitsize = 37,
      .reloc_type = S37_LO10_UP27,
      .reloc_lo10 = BFD_RELOC_LVX_S37_GOT_LO10,
      .reloc_up27 = BFD_RELOC_LVX_S37_GOT_UP27,
      .single = BFD_RELOC_UNUSED,
      .kreloc = & ${core}_got_signed37_reloc,
    }
  },
  {
    .name = "got",
    .pseudo_relocs = {
      .avail_modes = PSEUDO_32_ONLY,
      .bitsize = 32,
      .reloc_type = S32,
      .single = BFD_RELOC_LVX_32_GOT,
      .kreloc = & ${core}_got_32_reloc,
    }
  },
  {
    .name = "tlsgd",
    .pseudo_relocs = {
      .avail_modes = PSEUDO_ALL,
      .bitsize = 37,
      .reloc_type = S37_LO10_UP27,
      .reloc_lo10 = BFD_RELOC_LVX_S37_TLS_GD_LO10,
      .reloc_up27 = BFD_RELOC_LVX_S37_TLS_GD_UP27,
      .single = BFD_RELOC_UNUSED,
      .kreloc = & ${core}_tlsgd_signed37_reloc,
    }
  },
  {
    .name = "tlsgd",
    .pseudo_relocs = {
      .avail_modes = PSEUDO_ALL,
      .bitsize = 43,
      .reloc_type = S43_LO10_UP27_EX6,
      .reloc_lo10 = BFD_RELOC_LVX_S43_TLS_GD_LO10,
      .reloc_up27 = BFD_RELOC_LVX_S43_TLS_GD_UP27,
      .reloc_ex = BFD_RELOC_LVX_S43_TLS_GD_EX6,
      .single = BFD_RELOC_UNUSED,
      .kreloc = & ${core}_tlsgd_signed43_reloc,
    }
  },
  {
    .name = "tlsle",
    .pseudo_relocs = {
      .avail_modes = PSEUDO_ALL,
      .bitsize = 37,
      .reloc_type = S37_LO10_UP27,
      .reloc_lo10 = BFD_RELOC_LVX_S37_TLS_LE_LO10,
      .reloc_up27 = BFD_RELOC_LVX_S37_TLS_LE_UP27,
      .single = BFD_RELOC_UNUSED,
      .kreloc = & ${core}_tlsle_signed37_reloc,
    }
  },
  {
    .name = "tlsle",
    .pseudo_relocs = {
      .avail_modes = PSEUDO_ALL,
      .bitsize = 43,
      .reloc_type = S43_LO10_UP27_EX6,
      .reloc_lo10 = BFD_RELOC_LVX_S43_TLS_LE_LO10,
      .reloc_up27 = BFD_RELOC_LVX_S43_TLS_LE_UP27,
      .reloc_ex = BFD_RELOC_LVX_S43_TLS_LE_EX6,
      .single = BFD_RELOC_UNUSED,
      .kreloc = & ${core}_tlsle_signed43_reloc,
    }
  },
  {
    .name = "tlsld",
    .pseudo_relocs = {
      .avail_modes = PSEUDO_ALL,
      .bitsize = 37,
      .reloc_type = S37_LO10_UP27,
      .reloc_lo10 = BFD_RELOC_LVX_S37_TLS_LD_LO10,
      .reloc_up27 = BFD_RELOC_LVX_S37_TLS_LD_UP27,
      .single = BFD_RELOC_UNUSED,
      .kreloc = & ${core}_tlsld_signed37_reloc,
    }
  },
  {
    .name = "tlsld",
    .pseudo_relocs = {
      .avail_modes = PSEUDO_ALL,
      .bitsize = 43,
      .reloc_type = S43_LO10_UP27_EX6,
      .reloc_lo10 = BFD_RELOC_LVX_S43_TLS_LD_LO10,
      .reloc_up27 = BFD_RELOC_LVX_S43_TLS_LD_UP27,
      .reloc_ex = BFD_RELOC_LVX_S43_TLS_LD_EX6,
      .single = BFD_RELOC_UNUSED,
      .kreloc = & ${core}_tlsld_signed43_reloc,
    }
  },
  {
    .name = "dtpoff",
    .pseudo_relocs = {
      .avail_modes = PSEUDO_ALL,
      .bitsize = 37,
      .reloc_type = S37_LO10_UP27,
      .reloc_lo10 = BFD_RELOC_LVX_S37_TLS_DTPOFF_LO10,
      .reloc_up27 = BFD_RELOC_LVX_S37_TLS_DTPOFF_UP27,
      .single = BFD_RELOC_UNUSED,
      .kreloc = & ${core}_dtpoff_signed37_reloc,
    }
  },
  {
    .name = "dtpoff",
    .pseudo_relocs = {
      .avail_modes = PSEUDO_ALL,
      .bitsize = 43,
      .reloc_type = S43_LO10_UP27_EX6,
      .reloc_lo10 = BFD_RELOC_LVX_S43_TLS_DTPOFF_LO10,
      .reloc_up27 = BFD_RELOC_LVX_S43_TLS_DTPOFF_UP27,
      .reloc_ex = BFD_RELOC_LVX_S43_TLS_DTPOFF_EX6,
      .single = BFD_RELOC_UNUSED,
      .kreloc = & ${core}_dtpoff_signed43_reloc,
    }
  },
  {
    .name = "tlsie",
    .pseudo_relocs = {
      .avail_modes = PSEUDO_ALL,
      .bitsize = 37,
      .reloc_type = S37_LO10_UP27,
      .reloc_lo10 = BFD_RELOC_LVX_S37_TLS_IE_LO10,
      .reloc_up27 = BFD_RELOC_LVX_S37_TLS_IE_UP27,
      .single = BFD_RELOC_UNUSED,
      .kreloc = & ${core}_tlsie_signed37_reloc,
    }
  },
  {
    .name = "tlsie",
    .pseudo_relocs = {
      .avail_modes = PSEUDO_ALL,
      .bitsize = 43,
      .reloc_type = S43_LO10_UP27_EX6,
      .reloc_lo10 = BFD_RELOC_LVX_S43_TLS_IE_LO10,
      .reloc_up27 = BFD_RELOC_LVX_S43_TLS_IE_UP27,
      .reloc_ex = BFD_RELOC_LVX_S43_TLS_IE_EX6,
      .single = BFD_RELOC_UNUSED,
      .kreloc = & ${core}_tlsie_signed43_reloc,
    }
  },
  {
    .name = "gotoff",
    .pseudo_relocs = {
      .avail_modes = PSEUDO_ALL,
      .bitsize = 43,
      .reloc_type = S43_LO10_UP27_EX6,
      .reloc_lo10 = BFD_RELOC_LVX_S43_GOTOFF_LO10,
      .reloc_up27 = BFD_RELOC_LVX_S43_GOTOFF_UP27,
      .reloc_ex = BFD_RELOC_LVX_S43_GOTOFF_EX6,
      .single = BFD_RELOC_UNUSED,
      .kreloc = & ${core}_gotoff_signed43_reloc,
    }
  },
  {
    .name = "gotoff",
    .pseudo_relocs = {
      .avail_modes = PSEUDO_64_ONLY,
      .bitsize = 64,
      .reloc_type = S64,
      .single = BFD_RELOC_LVX_64_GOTOFF,
      .kreloc = & ${core}_gotoff_64_reloc,
    }
  },
  {
    .name = "got",
    .pseudo_relocs = {
      .avail_modes = PSEUDO_ALL,
      .bitsize = 43,
      .reloc_type = S43_LO10_UP27_EX6,
      .reloc_lo10 = BFD_RELOC_LVX_S43_GOT_LO10,
      .reloc_up27 = BFD_RELOC_LVX_S43_GOT_UP27,
      .reloc_ex = BFD_RELOC_LVX_S43_GOT_EX6,
      .single = BFD_RELOC_UNUSED,
      .kreloc = & ${core}_got_signed43_reloc,
    }
  },
  {
    .name = "got",
    .pseudo_relocs = {
      .avail_modes = PSEUDO_64_ONLY,
      .bitsize = 64,
      .reloc_type = S64,
      .single = BFD_RELOC_LVX_64_GOT,
      .kreloc = & ${core}_got_64_reloc,
    }
  },
  {
    .name = "gotaddr",
    .pseudo_relocs = {
      .avail_modes = PSEUDO_32_ONLY,
      .bitsize = 37,
      .has_no_arg = 1,
      .reloc_type = S37_LO10_UP27,
      .reloc_lo10 = BFD_RELOC_LVX_S37_GOTADDR_LO10,
      .reloc_up27 = BFD_RELOC_LVX_S37_GOTADDR_UP27,
      .single = BFD_RELOC_UNUSED,
      .kreloc = & ${core}_gotaddr_signed37_reloc,
    }
  },
  {
    .name = "gotaddr",
    .pseudo_relocs = {
      .avail_modes = PSEUDO_32_ONLY,
      .bitsize = 43,
      .has_no_arg = 1,
      .reloc_type = S43_LO10_UP27_EX6,
      .reloc_lo10 = BFD_RELOC_LVX_S43_GOTADDR_LO10,
      .reloc_up27 = BFD_RELOC_LVX_S43_GOTADDR_UP27,
      .reloc_ex = BFD_RELOC_LVX_S43_GOTADDR_EX6,
      .single = BFD_RELOC_UNUSED,
      .kreloc = & ${core}_gotaddr_signed43_reloc,
    }
  },
  {
    .name = "gotaddr",
    .pseudo_relocs = {
      .avail_modes = PSEUDO_64_ONLY,
      .bitsize = 64,
      .has_no_arg = 1,
      .reloc_type = S64_LO10_UP27_EX27,
      .reloc_lo10 = BFD_RELOC_LVX_S64_GOTADDR_LO10,
      .reloc_up27 = BFD_RELOC_LVX_S64_GOTADDR_UP27,
      .reloc_ex = BFD_RELOC_LVX_S64_GOTADDR_EX27,
      .single = BFD_RELOC_UNUSED,
      .kreloc = & ${core}_gotaddr_signed64_reloc,
    }
  },
  // pcrel()
  {
    // use pcrel16 to force the use of 16bits. This would normally not
    // be selected as symbol would not fit.
    .name = "pcrel16",
    .pseudo_relocs = {
      .avail_modes = PSEUDO_ALL,
      .bitsize = 16,
      .single = BFD_RELOC_LVX_S16_PCREL,
      .reloc_type = S16,
      .kreloc = & ${core}_pcrel_signed16_reloc,
    }
  },
  {
    .name = "pcrel",
    .pseudo_relocs = {
      .avail_modes = PSEUDO_32_ONLY,
      .bitsize = 37,
      .reloc_type = S37_LO10_UP27,
      .reloc_lo10 = BFD_RELOC_LVX_S37_PCREL_LO10,
      .reloc_up27 = BFD_RELOC_LVX_S37_PCREL_UP27,
      .single = BFD_RELOC_UNUSED,
      .kreloc = & ${core}_pcrel_signed37_reloc,
    }
  },
  {
    .name = "pcrel",
    .pseudo_relocs = {
      .avail_modes = PSEUDO_32_ONLY,
      .bitsize = 43,
      .reloc_type = S43_LO10_UP27_EX6,
      .reloc_lo10 = BFD_RELOC_LVX_S43_PCREL_LO10,
      .reloc_up27 = BFD_RELOC_LVX_S43_PCREL_UP27,
      .reloc_ex = BFD_RELOC_LVX_S43_PCREL_EX6,
      .single = BFD_RELOC_UNUSED,
      .kreloc = & ${core}_pcrel_signed43_reloc,
    }
  },
  {
    .name = "pcrel",
    .pseudo_relocs = {
      .avail_modes = PSEUDO_64_ONLY,
      .bitsize = 64,
      .reloc_type = S64_LO10_UP27_EX27,
      .reloc_lo10 = BFD_RELOC_LVX_S64_PCREL_LO10,
      .reloc_up27 = BFD_RELOC_LVX_S64_PCREL_UP27,
      .reloc_ex = BFD_RELOC_LVX_S64_PCREL_EX27,
      .single = BFD_RELOC_UNUSED,
      .kreloc = & ${core}_pcrel_signed64_reloc,
    }
  },
};

EOT
}

sub decode_opcodes {
    # Return a list of the opcodes found on a depth-first
    # walk (visiting default cases last) of the decode tree rooted at DECODING
    my $decode = shift;

    my @children = $decode->children('Decode');
    @children = sort { (defined $b->attribute("case"))
          <=> (defined $a->attribute("case")) } @children;
    my @opcodes = map { decode_opcodes ($_) } @children;

    if (defined $decode->attribute("opcodes")) {
        my @node_opcodes = map { &MDS::fetch($_) }
          (split ' ', $decode->attribute("opcodes"));
        # Sort aliases, so that synthetic ones appear first.
        @node_opcodes = sort { (isSynthetic $b) <=> (isSynthetic $a) } @node_opcodes;
        push @opcodes, @node_opcodes;
    }

    #    print STDERR "@opcodes \n";
    return @opcodes;
}

sub sort_decoding {
# Code in the binutils disassembler assumes it can decode an operation
# by a linear scan of the optab we produce.  However, we have some
# ambiguous cases, (e.g.  mov and add will both match add $rd = $rs, $r0)
# so we need to ensure that the more specialized version appears
# earlier in the table, e.g. mov must appear before add.
# We can find the required order by a depth-first walk of the Decode tree, where
# we visit the default children after all other children.
    my $core = shift;
    my @opcodes;

    foreach my $decodingID (@_) {
        my ($decode) = &MDS::fetch($decodingID)->children('Decode');
        push @opcodes, decode_opcodes ($decode);
    }

    # There may be multiple occurrences of an opcode in this list -
    # prune and order them by last occurrence.
    my %opcodes_seen;
    my @pruned_opcodes;
    foreach my $opcode (reverse @opcodes) {
        if (! defined $opcodes_seen{$opcode}) {
            unshift @pruned_opcodes, $opcode;
            $opcodes_seen{$opcode} = 1;
        }
    }
    return @pruned_opcodes;
}

sub clearMDSTables {
    @Bundle::table = ();
    @Bundling::table = ();
    @Decoding::table = ();
    @Encoding::table = ();
    @Immediate::table = ();
    @Modifier::table = ();
    @Opcode::table = ();
    @Operand::table = ();
    @Processor::table = ();
    @RegClass::table = ();
    @Register::table = ();
    @RegMask::table = ();
    @Relocation::table = ();
    @Reservation::table = ();
    @Resource::table = ();
}

sub main {
    my @Cores = split ' ', $ENV{CORES};
    printHeader(*STDOUT);

    for my $i (0 .. (scalar @Cores)-1) {
        open (mds_file, '<', $ARGV[$i]);
        clearMDSTables();
        &MDS::parse(*mds_file);

        my $core = $Cores[$i];

        printRegisters(*STDOUT, $core);
        printModifiers(*STDOUT, $core);
        printPseudoFuncs(*STDOUT, $core);
        printRelocations(*STDOUT);
        printOpndTypes(*STDOUT);
        printResources(*STDOUT, $core);
        printCoreInfo(*STDOUT, $core);
        printInstTab(*STDOUT, $core);
    }

    printCoreInfoTable(*STDOUT, @Cores);
    printCoreRegisterTable(*STDOUT, @Cores);
    printCoreModifierTable(*STDOUT, @Cores);
    printCoreRegFileTable(*STDOUT, @Cores);
}

main();
# vim: set ts=4 sw=4 et:
