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


my $FAMILY = $ENV{FAMILY};
my $CORES = $ENV{CORES};

my $MDS_SPLIT_MODE = 0;
if ($ARGV[0] eq "--split") {
  $MDS_SPLIT_MODE = 1;
  shift @ARGV;
}

use MDS;
use integer;
#&MDS::parse(*ARGV);

my $copyrights = &MDS::get_copyrights(" *  ","");

print<<"EOT";
/*
 * $FAMILY/MDT.c
${copyrights}
 * Automatically generated from the Machine Description System (MDS).
 */

#include "MDT/MDT_.h"

EOT

print<<"EOT";
#ifdef \$XCC_h
#define MDT_FAMILY_RAW $FAMILY
#define MDT_FAMILY \"$FAMILY\"
#define MDT_FAMILY_$FAMILY
EOT

my $target = $FAMILY;
if ($MDS_SPLIT_MODE) {
  $target = $CORES;
}
print<<"EOT";
#define MDT_TARGET_RAW $target
#define MDT_TARGET \"$target\"
#define MDT_TARGET_$target
EOT

map {
  print<<"EOT";
#define MDT_CORE_$_
EOT
} split ' ', $CORES;

print<<"EOT";
#endif//\$XCC_h
EOT

