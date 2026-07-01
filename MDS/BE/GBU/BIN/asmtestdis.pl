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

use strict;
use warnings;

use MDS;
use BitString;
use AsmTestLib;

sub printObjDumpLine {
    
    my $file = shift;
    my $address = shift;
    my $syntax = shift;
    my $code = shift;
    my $stopbit = shift;

#    print STDERR "printObjDumpLine: syntax: ", $syntax, " code: ",
#    $code, "\n";

    if ($stopbit) {
	my $stopbitstring = BitString->new(32);
	$stopbitstring->insert(&MDS::fetch("BitField-$MDD::CORE-STOPBIT"), 1);
	$code |= $stopbitstring->value(32)[0];
    }

    printf $file "%4x:\t%02x %02x %02x %02x \tc0 ", $address,
           $code & 0xff, ($code >> 8) & 0xff, ($code >> 16) & 0xff,
           ($code >> 24) & 0xff;

    print $file $syntax;

    print $file ";;" if ($stopbit);
    print $file "\n";
}

sub printObjDumpOutput {

    my $file = shift;

    print $file <<'EOT';

a.out:     file format elf32-littlelx

Disassembly of section .text:

00000000 <asmtest>:
EOT

    my @instruction_list = AsmTestLib::makeInstructionList ($MDD::CORE);
    my $address = 0;

    my $nop_inst = &MDS::fetch("Opcode:$MDD::CORE:nop");

    my $encoded = $nop_inst->attribute("encoded");
    my $bitstring = BitString->new(0, $encoded);
    my $nop_encoding = $bitstring->value(32)[0];
    while (@instruction_list) {
	my $syntax = shift @instruction_list;
	my $encoding = shift @instruction_list;
	my $bundlingID = shift @instruction_list;

	if ((($address & 4) && AsmTestLib::isEvenBundling ($bundlingID))
	    || (! ($address & 4) && AsmTestLib::isOddBundling ($bundlingID))) {
	    printObjDumpLine ($file, $address, "nop",  $nop_encoding, 0);
	    $address += 4;
	}
	printObjDumpLine ($file, $address, $syntax, $encoding, 1);
	$address += 4;
    }
}

&MDS::parse(*ARGV);

printObjDumpOutput(*STDOUT);
