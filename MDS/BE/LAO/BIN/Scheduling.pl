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
 * $FAMILY/Scheduling.tuple
${copyrights}
 * Automatically generated from the Machine Description System (MDS).
 */

#ifndef Scheduling
#define Scheduling(ID, PROCESSOR, BUNDLING, RESERVATION)
#else /*Scheduling*/
EOT

my %processorName;
foreach my $processor (@Processor::table) {
    my $core = $processor->core();
    $processorName{$core} = $processor->fullName('_');
}

my $CORE;
if ($MDS_SPLIT_MODE) {
    my $size = scalar %processorName;
    if ($size != 1) {
        die "Expected a single processor not $size";
    }
    $CORE = (keys %processorName)[0];
}

my %Scheduling;
foreach my $scheduling (@Scheduling::table) {
    if ($MDS_SPLIT_MODE) {
        push @{$Scheduling{$CORE}}, $scheduling
    } else {
        my @processors = $scheduling->access("processors");
        foreach my $processor (@processors) {
            push @{$Scheduling{$processor->core()}}, $scheduling;
        }
    }
}

foreach my $core (sort keys %Scheduling) {
    my @schedulings = @{$Scheduling{$core}};
    foreach my $scheduling (@schedulings) {
        my $name = $scheduling->name("_");
        my $ID = $core."_".$name;
        my $processorName = $processorName{$core};
        my $PROCESSOR = "PROCESSOR($processorName)";
        my ($bundling) = $scheduling->access("bundling");
        my $bundlingName = defined $bundling?
          $bundling->fullName('_'):
          "_UNDEF";
        my $BUNDLING = "BUNDLING($bundlingName)";
        my ($reservation) = $scheduling->access("reservation");
        my $reservationName = $reservation->fullName('_');
        my $RESERVATION = "RESERVATION($reservationName)";
        print<<"EOT";
Scheduling($ID, $PROCESSOR, $BUNDLING, $RESERVATION)
EOT
    }
}

print<<"EOT";
#endif/*Scheduling*/
#undef Scheduling\n
EOT

# vim: set ts=4 sw=4 et:
