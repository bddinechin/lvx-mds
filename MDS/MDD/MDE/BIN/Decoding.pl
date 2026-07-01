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

use BitString;
use Decode;
use bignum;

use MDS;
&MDS::parse(*ARGV);

my %opcodes;
my %encodingID;
foreach my $opcode (@Opcode::table) {
  my ($encoding) = $opcode->access("encoding");
  my $decodingID = &Decoding::ID($encoding->name());
  $encodingID{$decodingID} = $encoding->attribute("ID");
  push @{$opcodes{$decodingID}}, $opcode;
}

foreach my $decodingID (sort keys %opcodes) {
  my $opcodes = $opcodes{$decodingID};
  my $encoding = MDS::fetch($encodingID{$decodingID});
  my $coding_size = $encoding->attribute("wordWidth") * $encoding->attribute("wordCount");
  if($coding_size % 8) {
    $coding_size -= ($coding_size % 8);
    $coding_size += 8;
  }
  &process($decodingID, Decode::makeDecodeTree($coding_size, @{$opcodes}));
}

sub process {
  my ($decodingID, $tree) = @_;
  print "<Decoding ID=\t\"$decodingID\"\n";
  print "  encoding=\t\"$encodingID{$decodingID}\">\n";
  &processNode($tree, undef, 1);
  print "</Decoding>\n\n";
  #print "<!--\n";
  #Decode::printDecodeTree(*STDOUT, $tree);
  #print "-->\n";
}

sub processNode {
  my ($node, $case, $level) = @_;
  my $indent = "  " x $level;
  print $indent, "<Decode";
  print " case=\"$case\"" if defined $case;
  if (exists ${$node}{children}) {
    my $test = ${$node}{test};
    die "null mask" unless $test;
    my $shift = &tzc($test);
    my $mask = Decode::printHex($test >> $shift);
    print " shift=\"$shift\"" if $shift;
    print " mask=\"$mask\"";
    print ">\n";
    my $children = ${$node}{children};
    foreach my $key (sort { $a <=> $b } keys %{$children}) {
      my $value = $key >> $shift;
      my $case = Decode::printHex($value);
      &processNode(${$children}{$key}, $case, $level + 1);
    }
    if (exists ${$node}{default}) {
      &processNode(${$node}{default}, "default", $level + 1);
    }
    print $indent, "</Decode>\n";
  } else {
    my $opcodes = ${$node}{opcode};
    print " opcodes=\"$opcodes\"" if $opcodes;
    print "/>\n";
  }
}

sub tzc {
  my $count = 0;
  my $value = shift;
  return undef unless $value;
  until ($value & 0x1) {
    $value >>= 1;
    ++$count;
  }
  return $count;
}

if ($debug) {
  for my $i (0..31) {
    my $n = 1<<$i;
    print STDERR "TZC($n = 1<<$i) = ", tzc($n), "\n";
  }
  print STDERR "TZC(0) = ", tzc(0), "\n";
}

