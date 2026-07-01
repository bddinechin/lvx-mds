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
 * $FAMILY/Decoding.tuple
${copyrights}
 * Automatically generated from the Machine Description System (MDS).
 */

#ifndef Decoding
#define Decoding(ID, PROCESSOR, WORDTYPE, WORDCOUNT)
#else /*Decoding*/
EOT

my %processorName;
foreach my $processor (@Processor::table) {
    my $core = $processor->core();
    $processorName{$core} = $processor->fullName('_');
}

my $Decoding_SIZE_MAX = 0;
foreach my $decoding (@Decoding::table) {
    my ($encoding) = $decoding->access("encoding");
    my $ID = $decoding->fullName('_');
    my $processorName = $processorName{$decoding->core()};
    my $PROCESSOR  = "PROCESSOR($processorName)";
    my $wordWidth = $encoding->attribute("wordWidth");
    my $wordType = "uint${wordWidth}_t";
    my $WORDTYPE = "WORDTYPE($wordType)";
    my $wordCount = $encoding->attribute("wordCount");
    my $WORDCOUNT = "WORDCOUNT($wordCount)";
    print <<"EOT";
Decoding($ID, $PROCESSOR, $WORDTYPE, $WORDCOUNT)
EOT
    my $size = ($wordWidth*$wordCount + 7)/8;
    $Decoding_SIZE_MAX = $size if $Decoding_SIZE_MAX < $size;
}

print<<"EOT";
#endif/*Decoding*/
#undef Decoding\n
EOT

print<<"EOT";
#ifndef Decoding_SIZE_MAX
#define Decoding_SIZE_MAX $Decoding_SIZE_MAX
#endif/*Decoding_SIZE_MAX*/\n
EOT

# vim: set ts=4 sw=4 et:
