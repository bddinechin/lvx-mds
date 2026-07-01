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
use bignum;
&MDS::parse(*ARGV);

my $copyrights = &MDS::get_copyrights(" *  ","");

print<<"EOT";
/*
 * $FAMILY/Decode.c
${copyrights}
 * Automatically generated from the Machine Description System (MDS).
 */

#include "MDT/MDT_.h"

EOT

my ($wordWidth, $wordCount);
foreach my $decoding (@Decoding::table) {
    my ($encoding) = $decoding->access("encoding");
    my ($decode) = $decoding->children('Decode');
    my $name = $decoding->fullName('_');
    $wordWidth = $encoding->attribute("wordWidth");
    $wordCount = $encoding->attribute("wordCount");
    my $wordType = "uint${wordWidth}_t";
    print << "EOT";
#ifdef \$XCC__h
#ifndef NDECODE
extern Opcode
Decode_Decoding_$name(const void *buffer);
#endif//NDECODE
#endif//\$XCC__h

#ifndef NDECODE
Opcode
Decode_Decoding_$name(const void *buffer)
{
  const $wordType *codeWords = (const $wordType *)buffer;
EOT
    for (my $index = 0; $index < $wordCount; $index++) {
        print "  $wordType codeWord_$index = codeWords[$index];\n";
    }
    &decodeTree($decode, 0, 0);
    print << "EOT";
}
#endif//NDECODE

EOT
}

sub decodeTree {
    my ($decode, $switch, $level) = @_;
    my $indent = '  ' x $level;
    my $case = $decode->attribute("case");
    my $mask = $decode->attribute("mask");
    my $shift = $decode->attribute("shift") || 0;
    my @children = $decode->children('Decode');
    my @opcodes = $decode->access("opcodes");
    if (defined $case) {
        if ($case eq 'default') {
            print $indent, "default:\n";
        } else {
            print $indent, "case $case:\n";
        }
    }
    if ($mask) {
        use integer;
        my $index = $shift/$wordWidth;
        my $amount = $shift%$wordWidth;
        print $indent, "  switch ((codeWord_$index >> $amount) & $mask) {\n";
    }
    map {&decodeTree($_, $mask, $level + 1)} @children;
    if (@opcodes) {
        print $indent, "  return Opcode_", $opcodes[0]->fullName('_'), ";\n";
    }
    if ($mask) {
        print $indent, "    break;\n";
        print $indent, "  }\n";
        print $indent, "  return Opcode__UNDEF;\n";
    }
}

# vim: set ts=4 sw=4 et:
