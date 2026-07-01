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
 * $FAMILY/Relocation.tuple
${copyrights}
 * Automatically generated from the Machine Description System (MDS).
 */

#ifndef Relocation
#define Relocation(ID, RELATIVE, ENCODE, DECODE, LINKER)
#else /*Relocation*/
EOT

foreach my $relocation (@Relocation::table) {
  my $ID = $relocation->fullName('_');
  my $relative = $relocation->attribute("relative") || '';
  my $RELATIVE = $relative? "RELATIVE($relative)": "RELATIVE(_UNDEF)";
  my $ENCODE = "ENCODE(/**/)";
  my $DECODE = "DECODE(/**/)";
  my $linker = $relocation->attribute("linker") || '';
  my $LINKER = $linker? "LINKER($linker)": "LINKER(/**/)";
  print <<"EOT";
Relocation($ID, $RELATIVE,
           $ENCODE,
           $DECODE,
           $LINKER)
EOT
}

print<<"EOT";
#endif/*Relocation*/
#undef Relocation\n
EOT

