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
 * $FAMILY/RegClass.tuple
${copyrights}
 * Automatically generated from the Machine Description System (MDS).
 */

#ifndef RegClass
#define RegClass(ID, REGFILE, REGISTERS, ENCODE, DECODE, MINREADSTAGES)
#else /*RegClass*/
EOT

my @processorNames;
my %processorNames;
foreach my $processor (@Processor::table) {
  my $processorName = $processor->fullName('_');
  my $processorCore = $processor->core();
  push @processorNames, $processorName;
  $processorNames{$processorCore} = $processorName;
}

my %minReadStage;
foreach my $operator (@Operator::table) {
  my @origins = $operator->access("origins");
  next if grep {$_->type() eq 'Generic'} @origins;
  my @parameters = $operator->children("Parameter");
  foreach my $parameter (@parameters) {
    my $action = $parameter->attribute("action");
    next unless $action eq 'Read';
    my ($method) = $parameter->access("method");
    next unless $method->type() eq 'RegClass';
    my $regClassName = $method->fullName('_');
    my @stages = split ' ', $parameter->attribute("stages");
    while (@origins && @stages) {
      my $origin = shift @origins;
      my $stage = shift @stages;
      my $originCore = $origin->core();
      my $processorName = $processorNames{$originCore};
      if (defined $minReadStage{$regClassName}{$processorName}) {
        my $minReadStage = $minReadStage{$regClassName}{$processorName};
        $minReadStage{$regClassName}{$processorName} = $stage if $stage < $minReadStage;
      } else {
        $minReadStage{$regClassName}{$processorName} = $stage;
      }
    }
  }
}

my $registerNumber = 0;
foreach my $register (@Register::table) {
  $$register{NUMBER} = $registerNumber++;
}
$registerNumber = undef;

my %regFileIDs;
foreach my $regFile (@RegFile::table) {
  my $regFileID = $regFile->attribute("ID");
  my @registers = $regFile->access("registers");
  $$regFile{LOWNUMBER} = $registers[0]{NUMBER};
}

foreach my $regClass (@RegClass::table) {
  my ($regFile) = $regClass->access("regFile");
  my @registers = $regClass->access("registers");
  my $lowNumber = $$regFile{LOWNUMBER};
  my $shift = $regClass->attribute("shift") || 0;
  my $bias = $regClass->attribute("bias") || 0;
  my $ID = $regClass->fullName('_');
  my $regFileName = $regFile->fullName('_');
  my $REGFILE = "REGFILE($regFileName)";
  my @registerNames = map {$_->fullName('_')} @registers;
  my $registerNames = join ' ', map {"REGISTER($_)"} @registerNames;
  my $REGISTERS = "REGISTERS(". @registerNames. ", $registerNames)";
  my $adjust = $lowNumber + $bias;
  my (@encode, @decode);
  push @encode, "VALUE -= $adjust" if $adjust;
  push @encode, "VALUE >>= $shift" if $shift;
  my $ENCODE = "ENCODE(". (@encode? (join '; ', @encode): "/**/"). ")";
  push @decode, "VALUE <<= $shift" if $shift;
  push @decode, "VALUE += $adjust" if $adjust;
  my $DECODE = "DECODE(". (@decode? (join '; ', @decode): "/**/"). ")";
  my @minReadStages;
  foreach $processorName (@processorNames) {
    my $minReadStage = $minReadStage{$ID}{$processorName};
    $minReadStage = "(unsigned)-1" unless defined $minReadStage;
    push @minReadStages, "MINREADSTAGE(PROCESSOR($processorName),$minReadStage)";
  }
  my $minReadStages = join ' ', @minReadStages;
  my $MINREADSTAGES = "MINREADSTAGES($minReadStages)";
  print<<"EOT";
RegClass($ID,
         $REGFILE,
         $REGISTERS,
         $ENCODE,
         $DECODE,
         $MINREADSTAGES)
EOT
}

print<<"EOT";
#endif/*RegClass*/
#undef RegClass\n
EOT

