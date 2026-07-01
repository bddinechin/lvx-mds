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

sub printAsmTest {
    my $file = shift;

    print $file <<'EOT';
	.text
	.align 8
	.proc asmtest
        .global asmtest
asmtest:
EOT

    my @instruction_list = AsmTestLib::makeInstructionList ($MDD::CORE);
    while (@instruction_list) {
	my $syntax = shift @instruction_list;
	my $encoding = shift @instruction_list;
	my $bundlingID = shift @instruction_list;

	printf $file "\t%s # %08x\n\t;;\n", $syntax, $encoding;
    }

    print $file <<'EOT';
	.endp asmtest
EOT
	
}

print STDERR "starts\n";

&MDS::parse(*ARGV);

printAsmTest(*STDOUT);

print STDERR "ends\n";
