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

use GBUTarget;
use MDS;
use bignum;
use Carp;

use Test;
use File::Basename;

my ($CORE) = split ' ', $ENV{CORES};
my @core_names = &GBUTarget::CoreNames($CORE);

my $instrSeparator = GBUTarget::getInstructionSeparator();

# FIXME: Skip formats with splat32 if a format with signed37 was found.
my %skip;

sub printInstructions {
    my ($file, $define) = @_;
    foreach my $opcode ( sort { $a->attribute("ID") cmp $b->attribute("ID")}  @Opcode::table) {
        # Mnemonic with _ at the end are illegal.
        next if($opcode->attribute("mnemonic") =~ /_$/);
        $skip{$opcode->attribute("mnemonic")} = 0 if not defined $skip{$opcode->attribute("mnemonic")};
        $skip{$opcode->attribute("mnemonic")} = 1 if $opcode->attribute("ID") =~ /upper27_lower10/;
        next if $skip{$opcode->attribute("mnemonic")} && $opcode->attribute("ID") =~ /splat32/;

        my @flags = &GBUTarget::getEncodingFlags($opcode);
        my $has_define = grep {/${define}/} @flags;
        if(&GBUTarget::testIt($opcode) and $has_define) {
            my $syntax = &Test::getSyntax($opcode);
            print $file "\t$syntax \t#", $opcode->attribute("ID"), "\n";
            print $file "\t$instrSeparator\n" if defined $instrSeparator;
        }
    }
}

sub printAssemblyHeader {
    my ($file, $option) = @_;

    my $copyrights = &MDS::get_copyrights("	## ","\n");

    print $file "".
      "	##-----------------------------------------------------------\n".
      "	## Generating test.s from MDS\n".
      "$copyrights".
      "	##-----------------------------------------------------------\n".
      "\n".
      "#	Option: '$option'\n".
      "\n".
      "##	target-core:	$core_names[0]\n".
      "\n".
      "	.section .text\n".
      "\n".
      "	.align 8\n".
      "	.proc	main\n".
      "	.global	main\n".
      "main:\n";
}

sub printAssemblyFooter {
    my ($file) = @_;

    print $file "".
      "	.endp	main\n".
      "	.section .text\n";
}

################################################################################
# print test
################################################################################

open my $XML, "<", $ARGV[0];
&MDS::parse($XML);
close $XML;

&Test::initRegFile(&MDS::regFiles());
&Test::initRegClass(@RegClass::table);
&Test::initModifier(@Modifier::table);
&Test::initImmediate(@Immediate::table);

my %options = &GBUTarget::getGasDefineOptions();
my $define = basename($ARGV[1],".s");
if(not defined $options{$define}) {
    croak "Do not know how to generate test: $ARGV[1]";
}

my $option = $options{$define};
open my $FILE, ">", $ARGV[1];
printAssemblyHeader($FILE, $option);
printInstructions($FILE, $define);
printAssemblyFooter($FILE);
close($FILE);

# vim: set ts=4 sw=4 et:
