
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

# Create tests/$CORE/tests.s test files for binutils.

use strict;
use warnings "FATAL" => "all";

################################################################################
# Read MDS database
################################################################################

use MDS;
use Test;
use bignum;
use Carp;

use File::Basename;

my $Family = $ENV{FAMILY};

my $instrSeparator = GBUTarget::getInstructionSeparator();

# FIXME: Skip formats with splat32 if a format with signed37 was found.
my %skip;

sub printInstructions {
    my ($file, $define) = @_;
    my $pc = 0;

    $define =~ /([0-9]+)$/;
    my $elf_type = "elf$1";

    print $file "\n$define.o:     file format $elf_type-$Family\n";
    print $file <<'EOT';

Disassembly of section .text:

EOT

    if ($elf_type eq "elf64") {
        print $file sprintf("%016x <main>:\n",0);
    }
    else {
        print $file sprintf("%08x <main>:\n",0);
    }
    foreach my $opcode (sort { $a->attribute("ID") cmp $b->attribute("ID")}  @Opcode::table) {
        # Mnemonic with _ at the end are illegal.
        next if($opcode->attribute("mnemonic") =~ /_$/);
        $skip{$opcode->attribute("mnemonic")} = 0 if not defined $skip{$opcode->attribute("mnemonic")};
        $skip{$opcode->attribute("mnemonic")} = 1 if $opcode->attribute("ID") =~ /upper27_lower10/;
        next if $skip{$opcode->attribute("mnemonic")} && $opcode->attribute("ID") =~ /splat32/;

        my @flags = &GBUTarget::getEncodingFlags($opcode);
        my $has_define = grep {/${define}/} @flags;
        if(&GBUTarget::testIt($opcode) and $has_define) {
            my $mnemonic = $opcode->attribute("mnemonic");
            my $syntax = $opcode->attribute("syntax");

            # Pure asm alias -> assembled instruction will not be the same as desassembled one
            # Origin instruction is given. So just get original mnemonic
            my ($instruction) = $opcode->access("instruction");
            my $syntheticID = $instruction->attribute("synthetic");
            if(defined $syntheticID) {
                my $synthetic = &MDS::fetch($syntheticID);
                my $forced = $synthetic->attribute("forced");
                if(not defined $forced) {
                    my ($orig_instr) = $synthetic->access("instruction");
                    $mnemonic = $orig_instr->attribute("mnemonic");
                }
                else {
                    my @formats = $synthetic->access("formats");
                    my @forced = split(' ', $forced);
                    my @values = split(' ', $synthetic->attribute("values"));
                    my @operands = $formats[0]->access("operands");
                    my $synth_syntax = $formats[0]->attribute("syntax");
                    my $all_opnd_modifiers = 1;
                    my $forced_idx = 0;
                    foreach my $f (@forced) {
                        $f =~ /%([0-9]+)/;
                        my $opnd_idx = $1 - 1;
                        my $operand = $operands[$opnd_idx];
                        next unless defined $operand;
                        if($operand->attribute("method") =~ /^Modifier/) {
                            my $modifier = &MDS::fetch($operands[$opnd_idx]->attribute("method"));
                            my $forced_value = $values[$forced_idx];
                            my $value_idx = 0;
                            my @mvalues = split(' ', $modifier->attribute("values"));
                            my @mmembers = split(' ', $modifier->attribute("members"));
                            foreach my $mvalue (@mvalues) {
                                if($forced_value eq $mvalue) {
                                    my $mmember = lc($mmembers[$value_idx]);
                                    if($mmember eq ".") {
                                        $mmember = "";
                                    }
                                    $synth_syntax =~ s/$f/$mmember/;
                                    last;
                                }
                                $value_idx = $value_idx + 1;
                            }
                        }
                        else {
                            $all_opnd_modifiers = 0;
                        }
                        $forced_idx = $forced_idx + 1;
                    }
                    if($all_opnd_modifiers) {
                        my ($orig_instr) = $synthetic->access("instruction");
                        $mnemonic = $orig_instr->attribute("mnemonic");
                        $syntax = $synth_syntax;
                    }
                }
            }

            my $pc_relative;
            $syntax = &Test::getSyntax($opcode,$mnemonic,$syntax,\$pc_relative,1);
            my $coding = &Test::getCoding($opcode);
            my $encoding = &MDS::fetch($opcode->attribute("encoding"));
            my $coding_size = ($encoding->attribute("wordCount") * $encoding->attribute("wordWidth")) / 8;
            my @codings;
            for(my $i=0; $i<$coding_size; $i++) {
                $codings[$i] = sprintf("%02x",$coding & 0xff);
                $coding >>= 8;
            }

            GBUTarget::ObjdumpPrint($file,$elf_type,$opcode,$instrSeparator,$pc,\@codings,$coding_size,$syntax,$pc_relative);
            $pc += $coding_size;
        }
    }
}

################################################################################
# print test
################################################################################

open my $XML, "<", $ARGV[0];
&MDS::parse($XML);
close $XML;

&Test::initRegFile(@RegFile::table);
&Test::initRegClass(@RegClass::table);
&Test::initModifier(@Modifier::table);
&Test::initImmediate(@Immediate::table);

my %options = &GBUTarget::getGasDefineOptions();
my $define = basename($ARGV[1],".bin");
if(not defined $options{$define}) {
    croak "Do not know how to generate test: $ARGV[1]";
}

my $option = $options{$define};

open my $FILE, ">", $ARGV[1];
printInstructions($FILE,$define);
close $FILE;
