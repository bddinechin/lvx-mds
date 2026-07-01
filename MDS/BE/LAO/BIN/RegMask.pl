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
 * $FAMILY/RegMask.tuple
${copyrights}
 * Automatically generated from the Machine Description System (MDS).
 */

#ifndef RegMask
#define RegMask(ID, REGISTERS, REGFILE, ENCODE, DECODE)
#else /*RegMask*/
EOT

my $Register__ = 0;
foreach my $register (@Register::table) {
  $$register{NUMBER} = $Register__++;
}

foreach my $regFile (@RegFile::table) {
  my @registers = $regFile->access("registers");
  foreach my $register (@registers) {
    my $registerNumber = $$register{NUMBER};
    my $lowNumber = $$regFile{LOWNUMBER};
    if (!defined $lowNumber || $lowNumber > $registerNumber) {
      $$regFile{LOWNUMBER} = $registerNumber;
    }
  }
}

# FIXME: The following details about the RegisterSet implementation are
# defined in Register.pl:
sub RegisterSet_WORDBITS  { return 32; }  # sizeof(uint32_t)*8
sub RegisterSet_MAJOR     { return $_[0] / &RegisterSet_WORDBITS(); }
sub RegisterSet_MINOR     { return $_[0] & (&RegisterSet_WORDBITS() - 1); }
sub RegisterSet_WORDCOUNT { return &RegisterSet_MAJOR($Register__) + 1; }

foreach my $regMask (@RegMask::table) {
  my ($regFile) = $regMask->access("regFile");
  my $first = $regMask->attribute("first");
  my $count = $regMask->attribute("count");
  my $ID = $regMask->fullName('_');
  my $regFileName = $regFile->fullName('_');
  my @regFileRegisters = $regFile->access("registers");
  die "Illegal first $first for $ID" if $first >= @regFileRegisters;
  die "Illegal count $count for $ID" if $first+$count > @regFileRegisters;
  my @registers = splice @regFileRegisters, $first, $count;
  my @registerNames = map { $_->fullName('_') } @registers;
  my $registerNames = join ' ', map { "REGISTER($_)" } @registerNames;
  my $REGISTERS = "REGISTERS(". @registerNames. ", $registerNames)";
  my $REGFILE = "REGFILE($regFileName)";
  my $mask = ~(~0 << $count);
  my $registerLow = $$regFile{LOWNUMBER} + $first;
  my $registerHigh = $$regFile{LOWNUMBER} + $first + $count - 1;
  my $major = &RegisterSet_MAJOR($registerLow);
  my $minor = &RegisterSet_MINOR($registerLow);
  die "not implemented: RegMask spans several words in RegisterSet."
      unless $major == &RegisterSet_MAJOR($registerHigh);
  die "internal error: Register outside RegisterSet."
      unless $major < &RegisterSet_WORDCOUNT();
  my @encode = (
    "WORD = (WORDS[$major]>>$minor)&$mask",
  );
  my $ENCODE = "ENCODE(". (@encode? (join '; ', @encode): "/**/"). ")";
  my @decode = (
    "WORDS[$major] = WORD<<$minor",
  );
  my $DECODE = "DECODE(". (@decode? (join '; ', @decode): "/**/"). ")";
  print<<"EOT";
RegMask($ID,
        $REGISTERS,
        $REGFILE,
        $ENCODE,
        $DECODE)
EOT
}

print<<"EOT";
#endif/*RegMask*/
#undef RegMask\n
EOT

