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
 * $FAMILY/Storage.tuple
${copyrights}
 * Automatically generated from the Machine Description System (MDS).
 */

#ifndef StorageCell
#define StorageCell(ID, KIND, WIDTH)
#else /*StorageCell*/
EOT

# Find the Storage(s) used by Register(s).
my %registerStorage;
foreach my $register (@Register::table) {
  my $storageID = $register->attribute("storage");
  $registerStorage{$storageID}++;
}

my $StorageCell_Control;
my $StorageCell_Memory;

foreach my $storage (@Storage::table) {
  my $ID = $storage->attribute("ID");
  my $NAME = $storage->fullName('_');
  my $kind = $storage->attribute("kind");
  my $KIND = "KIND($kind)";
  my $width = $storage->attribute("width");
  my $WIDTH = "WIDTH($width)";
  if ($kind eq 'Control' || $kind eq 'Memory') {
    print<<"EOT";
StorageCell($NAME, $KIND, $WIDTH)
EOT
    $StorageCell_Control = "StorageCell_$NAME" if $kind eq 'Control';
    $StorageCell_Memory = "StorageCell_$NAME" if $kind eq 'Memory';
  } elsif ($kind ne 'Constant' && $registerStorage{$ID}) {
    my $count = $storage->attribute("count");
    for (my $i = 0; $i < $count; $i++) {
      print<<"EOT";
StorageCell($NAME$i, $KIND, $WIDTH)
EOT
    }
  }
}
print<<"EOT";
StorageCell(Volatile, Volatile, WIDTH(0))
EOT

print<<"EOT";
#endif/*Storage*/
#undef Storage\n
EOT

print<<"EOT";
#ifndef StorageCell_Control
#define StorageCell_Control $StorageCell_Control
#endif/*StorageCell_Control*/\n
#ifndef StorageCell_Memory
#define StorageCell_Memory $StorageCell_Memory
#endif/*StorageCell_Memory*/\n
EOT

