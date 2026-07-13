#!/usr/bin/perl -w
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
my $FAMILY = uc($family);

use Carp;
use strict;
use Data::Dumper;

use MDS;
&MDS::parse(*ARGV);

# List of Register(s) in canonical GCC order (DWARF order).
my %Register;
foreach my $register (@Register::table) {
    my $dwarfId = $register->attribute("dwarfId");
    next unless defined $dwarfId;
    my ($regFile) = $register->access("regFile");
    next if $regFile->regFileName() =~ /RV_/;
    $Register{$dwarfId} = $register;
}
my @Registers = map {$Register{$_}} sort { $a <=> $b } keys %Register;

# Print the list of Register REGNO.
print << "EOT";
(define_constants [
EOT
my $regno = 0;
foreach my $register (@Registers) {
    my $name = $register->name();
    my $NAME = uc($name);
    print << "EOT";
  (${FAMILY}_${NAME}_REGNO $regno)
EOT
    $regno++;
}
print << "EOT";
])
EOT

# vim: set ts=4 sw=4 et:
