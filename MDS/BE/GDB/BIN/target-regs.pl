##!/usr/bin/perl -w
# Machine Description System (MDS)
#
# Copyright (C) 2018 Kalray
#
# Benoît Dupont de Dinechin (benoit.dinechin@kalray.eu).
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
my $family = lc($ENV{FAMILY});
my @cores  = split(/\s/,$ENV{CORES});
my $FAMILY = uc($family);

#print STDERR "Cores: @cores\n";

use Carp;
use strict;
use Data::Dumper;
use GBUFamilyRegFiles;

use MDS;
&MDS::parse(*ARGV);

print << "EOT";
/* (c) Copyright 2010-2025 Kalray SA. */
struct reg_desc {
	char *name;
	char *desc;
};
EOT

my %regs;
foreach my $reg (@Register::table) {
  my @procs = $reg->access("processors");
  foreach my $proc (@procs) {
    $regs{$reg->name()}{$proc->core()} = $reg
  }
}

foreach my $core (@cores) {
  $core = lc($core);

  print "\nstruct reg_desc ${core}_mds_registers_description[] = {\n";

  my $regno = 0;
  foreach my $regFile (get_sorted_regfiles($FAMILY, \@RegFile::table)) {
    my @processors = $regFile->access("processors");
    my @local_cores = map { $_->core(); } @processors;
    my $count = scalar(grep {/$core/} @local_cores);
    next if $count == 0;

    my $regFileName = $regFile->name();
    next if $regFileName =~ /RV_/;

    my @registers = $regFile->access("registers");
    foreach my $register (@registers) {
      next unless defined $register->attribute("dwarfId");

      my @reg_procs = $register->access("processors");
      my @reg_cores = map { $_->core(); } @reg_procs;
      my $cores_count = scalar(grep {/$core/} @reg_cores);
      if ($cores_count == 0) {
        if(defined $regs{$register->name()}{$core}) {
          $register = $regs{$register->name()}{$core};
        }
        else {
          croak "Undefined register for ".$regFile->attribute("ID").", register: ".$register->attribute("ID"). " and core $core\n";
        }
      }

      my ($name) = split ' ', $register->attribute("names");
      $name =~ s/^\$//;
      my $width = $register->attribute("width");
      my $type = ($name =~ /sps$/)? "ps_type": "int";
      my @regFields = $register->access("fields");
      if (@regFields) {
        $type = $name."_type";
        my $size = $width >> 3;
        print "\t{\"$name\", \"\"\n";
        print "\t\t\"<struct id=\\\"$type\\\" size=\\\"$size\\\">\\n\"\n";

        foreach my $regField (@regFields) {
          my $fieldname = lc($regField->name());
          $fieldname =~ s/^${name}_//;
          my $offset = $regField->attribute("offset");
          my $width = $regField->attribute("width");
          my ($start, $end) =  ($offset, $offset + $width - 1);
          print "\t\t\t\"<field name=\\\"$fieldname\\\" start=\\\"$start\\\" end=\\\"$end\\\" />\\n\"\n";
        }
        print "\t\t\"</struct>\\n\"\n";
        print "\t\t\"<reg name=\\\"$name\\\" regnum=\\\"%d\\\" bitsize=\\\"$width\\\" type=\\\"$type\\\" />\"}, /* regno=$regno */\n";
      } else {
        print "\t{\"$name\", \"<reg name=\\\"$name\\\" regnum=\\\"%d\\\" bitsize=\\\"$width\\\" type=\\\"$type\\\" />\"}, /* regno=$regno */\n";
      }
      $regno++;
    }
  }

  print "\t{0},\n";
  print "};\n";

  print "\nint ${core}_mds_registers_size[] = {";

  my $count = 0;
  foreach my $regFile (@RegFile::table) {
    my @processors = $regFile->access("processors");
    my @local_cores = map { $_->core(); } @processors;
    my $core_count = scalar(grep {/$core/} @local_cores);
    next if $core_count == 0;

    my $regFileName = $regFile->name();
    next if $regFileName =~ /RV_/;

    my @registers = $regFile->access("registers");
    foreach my $register (@registers) {
      next unless defined $register->attribute("dwarfId");

      my @reg_procs = $register->access("processors");
      my @reg_cores = map { $_->core(); } @reg_procs;
      my $cores_count = scalar(grep {/$core/} @reg_cores);
      if ($cores_count == 0) {
        if(defined $regs{$register->name()}{$core}) {
          $register = $regs{$register->name()}{$core};
        }
        else {
          croak "Undefined register for ".$regFile->attribute("ID").", register: ".$register->attribute("ID"). " and core $core\n";
        }
      }

      my ($name) = split ' ', $register->attribute("names");
      $name =~ s/^\$//;
      my $width = $register->attribute("width");
      print "\n\t" unless $count % 10;
      print "$width /*$name*/,";
      $count++;
    }
  }

  print "\n\t0,\n};\n";
}

print << "EOT";
static inline struct reg_desc*
get_register_descriptions (const char *arch)
{
EOT

foreach my $core (@cores) {
  $core = lc($core);
  my $reduce_core = $core;
  $reduce_core =~ s/_v/-/;
  my $gdb_core = "${reduce_core}";
  print "\tif (strcmp (arch, \"${gdb_core}\") == 0)\n";
  print "\t\treturn ${core}_mds_registers_description;\n";
}

print << "EOT";
	return NULL;
}

static inline int*
get_register_sizes (const char *arch)
{
EOT

foreach my $core (@cores) {
  $core = lc($core);
  my $reduce_core = $core;
  $reduce_core =~ s/_v/-/;
  my $gdb_core = "${reduce_core}";
  print "\tif (strcmp (arch, \"${gdb_core}\") == 0)\n";
  print "\t\treturn ${core}_mds_registers_size;\n";
}

print << "EOT";
	return NULL;
}

EOT
