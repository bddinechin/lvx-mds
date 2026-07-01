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

use strict;

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
 * $FAMILY/Register.tuple
${copyrights}
 * Automatically generated from the Machine Description System (MDS).
 */

#ifndef Register
#define Register(ID, NAMES, REGFILES, WIRED, STORAGECELLS, MINREADSTAGES)
#else /*Register*/
EOT

my @processorNames;
my @processorCores;
my %processorNames;
foreach my $processor (@Processor::table) {
  my $processorName = $processor->fullName('_');
  my $processorCore = $processor->core();
  push @processorCores, $processorCore;
  push @processorNames, $processorName;
  $processorNames{$processorCore} = $processorName;
}

# Compute minReadStage of each RegClass or Register methods for each Processor.
my %minReadStage;
foreach my $operator (@Operator::table) {
  my @origins = $operator->access("origins");
  next if grep {$_->type() eq 'Generic'} @origins;
  my @parameters = $operator->children("Parameter");
  foreach my $parameter (@parameters) {
    my $action = $parameter->attribute("action");
    next unless $action eq 'Read';
    my ($method) = $parameter->access("method");
    my @stages = split ' ', $parameter->attribute("stages");
    my $methodName = $method->type(). "_". $method->fullName('_');
    if ($method->type() =~ /^RegClass|Register$/) {
      while (@origins && @stages) {
        my $origin = shift @origins;
        my $stage = shift @stages;
        my $originCore = $origin->core();
        my $processorName = $processorNames{$originCore};
        if (defined $minReadStage{$methodName}{$processorName}) {
          my $minReadStage = $minReadStage{$methodName}{$processorName};
          $minReadStage{$methodName}{$processorName} = $stage if $stage < $minReadStage;
        } else {
          $minReadStage{$methodName}{$processorName} = $stage;
        }
      }
    }
  }
}
# Refine minReadStage of Register using minReadStage of RegClass(es).
foreach my $regClass (@RegClass::table) {
  my $regClassName = $regClass->fullName('_');
  my @registers = $regClass->access("registers");
  foreach my $register (@registers) {
    my $registerName = $register->fullName('_');
    foreach my $processorName (@processorNames) {
      my $registerMinReadStage = $minReadStage{"Register_$registerName"}{$processorName};
      my $regClassMinReadStage = $minReadStage{"RegClass_$regClassName"}{$processorName};
      my $stage;
      if (defined $registerMinReadStage && defined $regClassMinReadStage) {
        $stage = $registerMinReadStage < $regClassMinReadStage?
                 $registerMinReadStage: $regClassMinReadStage;
      } elsif (defined $registerMinReadStage) {
        $stage = $registerMinReadStage;
      } else {
        $stage = $regClassMinReadStage;
      }
      if (defined $stage) {
        if (defined $minReadStage{$registerName}{$processorName}) {
          my $minReadStage = $minReadStage{$registerName}{$processorName};
          $minReadStage{$registerName}{$processorName} = $stage if $stage < $minReadStage;
        } else {
          $minReadStage{$registerName}{$processorName} = $stage;
        }
      }
    }
  }
}

# Compute the mapping from Register to RegFile.
# Also, number the Register(s) in the RegFile order.
my %regFileIDs;
my %registerNumber;
my $registerNumber = 0;
foreach my $regFile (@RegFile::table) {
  my $regFileID = $regFile->attribute("ID");
  my @registers = $regFile->access("registers");
  my @cores;
  if ($MDS_SPLIT_MODE) {
    @cores =  @processorCores; #only 1 item in split mode
  } else {
    foreach my $processor ($regFile->access("processors")) {
      push @cores, $processor->core();
    }
  }
  my @registerIDs = map {$_->attribute("ID")} @registers;
  foreach my $registerID (@registerIDs) {
    foreach my $core (@cores) {
      my $processorName = $processorNames{$core};
      die "$registerID in $regFileIDs{$registerID}{$core} and $regFileID"
          if(defined $regFileIDs{$registerID}{$processorName});
      $regFileIDs{$registerID}{$processorName} = $regFile->fullName('_');
      $registerNumber{$registerID}{$processorName} = $registerNumber++;
    }
  }
}
# Complete the Register numbering for those not in a RegFile.
# Also, identify the wired Register(s) or the Storage cells.
my %registerWired;
my %storageCells;
my %RegisterNames;
foreach my $register (@Register::table) {
  my $registerID = $register->attribute("ID");
  unless (defined $registerNumber{$registerID}) {
    $registerNumber{$registerID} = $registerNumber++;
  }
  my $storageID = $register->attribute("storage");
  my @RegisterProcNames;
  my @names = split ' ', $register->attribute("names") || '';
  my @cores;
  if ($MDS_SPLIT_MODE) {
    @cores =  @processorCores; #only 1 item in split mode
  } else {
    foreach my $processor ($register->access("processors")) {
      push @cores, $processor->core();
    }
  }
  foreach my $core (@cores) {
    foreach my $name (@names) {
      push @{$RegisterNames{$storageID}{$register->name()}{$processorNames{$core}}}, $name;
    }
  }

  my @addresses = split(' ',$register->attribute("addresses"));
  my $storage = &MDS::fetch($storageID);
  my $kind = $storage->attribute("kind");
  if ($kind eq 'Constant') {
    $registerWired{$registerID}++;
    $storageCells{$registerID} = [ ];
  } elsif ($kind eq 'Control') {
    my $storageName = $storage->fullName('_');
    push @{$storageCells{$registerID}}, $storageName;
  } elsif ($kind eq 'Register' ||
           $kind eq 'Special'  ||
           $kind eq 'Neighbor' ) {
    my $storageName = $storage->fullName('_');
    foreach my $cell (@addresses) {
      push @{$storageCells{$registerID}}, "$storageName$cell";
    }
  } else {
    die "Improper Storage $kind for $registerID";
  }
}
$registerNumber = undef;

my $RegisterStorageCells_MAXCOUNT = 0;
#my @Register_Table = sort {
  #sort {$registerNumber{$a} <=> $registerNumber{$b}
#} @Register::table;
foreach my $register (@Register::table) {
  my $ID = $register->fullName('_');
  my $storageID = $register->attribute("storage");
  my $registerID = $register->attribute("ID");
  my $regFileIDs = $regFileIDs{$registerID};
  my @regFileNames;
  my @procRegNames;
  foreach my $processorName (@processorNames) {
    my $regfileName = "_UNDEF";
    my @regNames;
    if(defined $regFileIDs and $$regFileIDs{$processorName}) {
      $regfileName = $$regFileIDs{$processorName};
      foreach my $regName (@{$RegisterNames{$storageID}{$register->name()}{$processorName}}) {
	push @regNames, "NAME($regName)";
      }
    }
    if (@regNames == 0) {
	push @regNames, "NAME(_UNDEF)";
    }
    push @procRegNames, "PNAMES(PROCESSOR($processorName), " . @regNames . ", " . (join ' ', @regNames) . ")";
    push @regFileNames, "REGFILE(PROCESSOR($processorName),$regfileName)";
  }
  my $NAMES = "NAMES(". @procRegNames. ", ". (join ' ', @procRegNames). ")";
  my $regfiles = join(' ',@regFileNames);
  my $REGFILES = "REGFILES($regfiles)";
  my $wired = $registerWired{$registerID};
  my $WIRED = $wired? "WIRED(true)": "WIRED(false)";
  my @storageCells = map {"STORAGECELL($_)"} @{$storageCells{$registerID}};
  my $storageCells = @storageCells? (join ' ', @storageCells): "/**/";
  my $STORAGECELLS = "STORAGECELLS(". @storageCells. ", $storageCells)";
  if ($RegisterStorageCells_MAXCOUNT < @storageCells) {
    $RegisterStorageCells_MAXCOUNT = @storageCells;
  }
  my @minReadStages;
  foreach my $processorName (@processorNames) {
    my $minReadStage = $minReadStage{$ID}{$processorName};
    $minReadStage = "(unsigned)-1" unless defined $minReadStage;
    push @minReadStages, "MINREADSTAGE(PROCESSOR($processorName),$minReadStage)";
  }
  my $minReadStages = join ' ', @minReadStages;
  my $MINREADSTAGES = "MINREADSTAGES($minReadStages)";
  print <<"EOT";
Register($ID, $NAMES, $REGFILES,
         $WIRED, $STORAGECELLS,
         $MINREADSTAGES)
EOT
}

print<<"EOT";
#endif/*Register*/
#undef Register\n
EOT

my $Register__ = 0;
my $RegisterList_MAXCOUNT = 0;
my $Register_NAMES_MAX = 0;
foreach my $register (@Register::table) {
  ++$Register__;
  ++$RegisterList_MAXCOUNT;
  my @names = split  ' ', $register->attribute("names");
  if ($Register_NAMES_MAX < @names) {
    $Register_NAMES_MAX = @names;
  }
}

print<<"EOT";
#ifndef RegisterStorageCells_MAXCOUNT
#define RegisterStorageCells_MAXCOUNT $RegisterStorageCells_MAXCOUNT
#endif/*RegisterStorageCells_MAXCOUNT*/\n
#ifndef RegisterList_MAXCOUNT
#define RegisterList_MAXCOUNT $RegisterList_MAXCOUNT
#endif/*RegisterList_MAXCOUNT*/\n
#ifndef RegisterSet_WORDBITS
#define RegisterSet_WORDBITS        (sizeof(RegisterSetWord)*8)
#endif/*RegisterSet_WORDBITS*/
#ifndef RegisterSet_MAJOR
#define RegisterSet_MAJOR(member)   ((Register)(member)/(RegisterSet_WORDBITS))
#endif/*RegisterSet_MAJOR*/
#ifndef RegisterSet_MINOR
#define RegisterSet_MINOR(member)   ((Register)(member)&(RegisterSet_WORDBITS - 1))
#endif/*RegisterSet_MINOR*/
#ifndef RegisterSet_WORDCOUNT
#define RegisterSet_WORDCOUNT       (RegisterSet_MAJOR($Register__) + 1)
#endif/*RegisterSet_WORDCOUNT*/\n
#ifndef Register_NAMES_MAX
#define Register_NAMES_MAX $Register_NAMES_MAX
#endif/*Register_NAMES_MAX*/\n
EOT

