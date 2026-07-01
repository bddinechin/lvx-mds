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
 * $FAMILY/Platform.tuple
${copyrights}
 * Automatically generated from the Machine Description System (MDS).
 */

#ifndef Platform
#define Platform(ID, CHARWIDTH, ADDRWIDTH, ENDIAN, \\
                 ALIGNTEXT, ALIGNDATA, ALIGNHEAP, ALIGNSTACK, \\
                 NATIVEINT, NATIVEUINT, NATIVEFLOAT, NATIVEPTR)
#else /*Platform*/
EOT

my $IntWidth;
foreach my $platform (@Platform::table) {
  my $ID = $platform->fullName('_');
  my $charWidth = $platform->attribute("charWidth");
  my $CHARWIDTH = "CHARWIDTH($charWidth)";
  my $addrWidth = $platform->attribute("addrWidth");
  my $ADDRWIDTH = "ADDRWIDTH($addrWidth)";
  my $endian = $platform->attribute("endian") || '_UNDEF';
  my $ENDIAN = "ENDIAN($endian)";
  my $alignText = $platform->attribute("alignText") || "/**/";
  my $ALIGNTEXT = "ALIGNTEXT($alignText)";
  my $alignData = $platform->attribute("alignData") || "/**/";
  my $ALIGNDATA = "ALIGNDATA($alignData)";
  my $alignHeap = $platform->attribute("alignHeap") || "/**/";
  my $ALIGNHEAP = "ALIGNHEAP($alignHeap)";
  my $alignStack = $platform->attribute("alignStack") || "/**/";
  my $ALIGNSTACK = "ALIGNSTACK($alignStack)";
  my @nativeInt = $platform->access("nativeInt");
  my $NATIVEINT = "NATIVEINT(".$nativeInt[0]->fullName('_').")";
  my @nativeUInt = $platform->access("nativeUInt");
  my $NATIVEUINT = "NATIVEUINT(".$nativeUInt[0]->fullName('_').")";
  my @nativeFloat = $platform->access("nativeFloat");
  my $NATIVEFLOAT = "NATIVEFLOAT(".$nativeFloat[0]->fullName('_').")";
  my @nativePtr = $platform->access("nativePtr");
  my $NATIVEPTR = "NATIVEPTR(".$nativePtr[0]->fullName('_').")";
  print<<"EOT";
Platform($ID, $CHARWIDTH, $ADDRWIDTH, $ENDIAN,
         $ALIGNTEXT, $ALIGNDATA, $ALIGNHEAP, $ALIGNSTACK,
         $NATIVEINT, $NATIVEUINT, $NATIVEFLOAT, $NATIVEPTR)
EOT
  $IntWidth = $addrWidth;
}

print<<"EOT";
#endif/*Platform*/
#undef Platform\n
EOT

print<<"EOT";
#ifndef PlatformInt_TYPEDEF
#define PlatformInt_TYPEDEF typedef int${IntWidth}_t PlatformInt;
#endif/*PlatformInt_TYPEDEF*/\n
#ifndef PlatformUInt_TYPEDEF
#define PlatformUInt_TYPEDEF typedef uint${IntWidth}_t PlatformUInt;
#endif/*PlatformUInt_TYPEDEF*/\n
EOT

