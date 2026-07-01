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
 * $FAMILY/Reservation.tuple
${copyrights}
 * Automatically generated from the Machine Description System (MDS).
 */

#ifndef Reservation
#define Reservation(ID, TABLE)
#else /*Reservation*/
EOT

my @resourceNames;
foreach my $resource (@Resource::table) {
  push @resourceNames, $resource->fullName('_');
}

my %reservationTable;
my @reservationTableColumns;
my $Reservation_COLUMNS_MAX = 0;
foreach my $reservation (@Reservation::table) {
  my $reservationName = $reservation->fullName('_');
  my $ID = $reservationName;
  my @resources = $reservation->access("resources");
  my @requirements = split ' ', $reservation->attribute("requirements");
  my @resourceTable = ();
  my $cycleCount = 0;
  while (@resourceTable < @requirements) {
    push @resourceTable, map {[ $cycleCount, $_->fullName('_') ]} @resources;
    $cycleCount++;
  }
  my %reservationEntry;
  while (@requirements) {
    my $resourceEntry = shift @resourceTable;
    my $cycle = $resourceEntry->[0];
    my $resourceName = $resourceEntry->[1];
    my $required = shift @requirements;
    $reservationEntry{$cycle}{$resourceName} = $required;
  }
  my @reservationRequirements;
  for (my $cycle = 0; $cycle < $cycleCount; $cycle++) {
    my @reservationRequired;
    foreach my $resourceName (@resourceNames) {
      my $required = $reservationEntry{$cycle}{$resourceName} || 0;
      push @reservationRequired, "REQUIRED(RESOURCE($resourceName),$required)";
    }
    my $reservationRequired = join ' ', @reservationRequired;
    push @reservationRequirements, $reservationRequired;
  }
  my $reservationRequirements = join ' ', @reservationRequirements;
  unless (defined $reservationTable{$reservationRequirements}) {
    my $columnIndex = @reservationTableColumns;
    $reservationTable{$reservationRequirements} = $columnIndex;
    push @reservationTableColumns, @reservationRequirements;
  }
  my $columnIndex = $reservationTable{$reservationRequirements};
  my $TABLE = "TABLE(COLUMNCOUNT($cycleCount), COLUMNINDEX($columnIndex))";
  print<<"EOT";
Reservation($ID, $TABLE)
EOT
  if ($Reservation_COLUMNS_MAX < $cycleCount) {
    $Reservation_COLUMNS_MAX = $cycleCount;
  }
}

print<<"EOT";
#endif/*Reservation*/
#undef Reservation\n
EOT

print<<"EOT";
#ifndef ReservationColumn
#define ReservationColumn(COLUMNINDEX, REQUIREMENTS)
#else /*ReservationColumn*/
EOT

my $columnIndex = 0;
foreach my $reservationTableColumn (@reservationTableColumns) {
  print<<"EOT";
ReservationColumn(COLUMNINDEX($columnIndex), REQUIREMENTS($reservationTableColumn))
EOT
  $columnIndex++;
}

print<<"EOT";
#endif/*ReservationColumn*/
#undef ReservationColumn\n
EOT

print<<"EOT";
#ifndef Reservation_COLUMNS_MAX
#define Reservation_COLUMNS_MAX $Reservation_COLUMNS_MAX
#endif/*Reservation_COLUMNS_MAX*/\n
EOT

