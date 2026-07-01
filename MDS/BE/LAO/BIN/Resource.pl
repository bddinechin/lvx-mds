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

use integer;

my $copyrights = &MDS::get_copyrights(" *  ","");

print<<"EOT";
/*
 * $FAMILY/Resource.tuple
${copyrights}
 * Automatically generated from the Machine Description System (MDS).
 */

#ifndef Resource
#define Resource(ID, AVAILABILITY)
#else /*Resource*/
EOT

my $MDS_SPLIT_MODE = 0;
if ($ARGV[0] eq "--split") {
    $MDS_SPLIT_MODE = 1;
    shift @ARGV;
}

use MDS;
use Behavior;
&MDS::parse(*ARGV);

my %available;
foreach my $resource (@Resource::table) {
    my $ID = $resource->fullName('_');
    unless ($MDS_SPLIT_MODE) {
        my @processors = $resource->access("processors");
        my @availability = split ' ', $resource->attribute("availability");
        while (@processors) {
            my $processor = shift @processors;
            my $available = (shift @availability) || 0;
            my $processorName = $processor->fullName('_');
            $available{$processorName} = $available;
        }
    }
    @availability = ();
    foreach my $processor (@Processor::table) {
        my $processorName = $processor->fullName('_');
        my $available;
        if ($MDS_SPLIT_MODE) {
            $available = $resource->attribute("availability");
        } else {
            $available = $available{$processorName}
        }
        push @availability, "AVAILABLE(PROCESSOR($processorName),$available)";
    }
    my $availability = join ' ', @availability;
    my $AVAILABILITY = "AVAILABILITY($availability)";
    print<<"EOT";
Resource($ID,
         $AVAILABILITY)
EOT
}

print<<"EOT";
#endif/*Resource*/
#undef Resource\n
EOT

# vim: set ts=4 sw=4 et:
