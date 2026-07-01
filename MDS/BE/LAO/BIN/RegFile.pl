#!/usr/bin/perl -w
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

use MDS;
use Behavior;
use integer;
&MDS::parse(*ARGV);

my $copyrights = &MDS::get_copyrights(" *  ","");

print<<"EOT";
/*
 * $FAMILY/RegFile.tuple
${copyrights}
 * Automatically generated from the Machine Description System (MDS).
 */

#ifndef RegFile
#define RegFile(ID, WIDTH, LOWREGISTER, HIGHREGISTER, NATIVETYPES)
#else /*RegFile*/
EOT

foreach my $regFile (@RegFile::table) {
    my $ID = $regFile->fullName('_');
    my $width = $regFile->attribute("width");
    my $WIDTH = "WIDTH($width)";
    my @registers = $regFile->access("registers");
    my $lowRegister = $registers[0];
    my $lowRegisterName = $lowRegister->fullName('_');
    my $LOWREGISTER = "LOWREGISTER($lowRegisterName)";
    my $highRegister = $registers[-1];
    my $highRegisterName = $highRegister->fullName('_');
    my $HIGHREGISTER = "HIGHREGISTER($highRegisterName)";
    my @names = map {$_->fullName('_')} $regFile->access("nativeTypes");
    my $nativeTypes = @names? (join ' ', map { "NATIVETYPE($_)" } @names): "/**/";
    my $NATIVETYPES = "NATIVETYPES(". @names. ", $nativeTypes)";
    print<<"EOT";
RegFile($ID, $WIDTH, $LOWREGISTER, $HIGHREGISTER,
        $NATIVETYPES)
EOT
}

print<<"EOT";
#endif/*RegFile*/
#undef RegFile\n
EOT

# vim: set ts=4 sw=4 et:
