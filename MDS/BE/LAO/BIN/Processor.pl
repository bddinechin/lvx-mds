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

my %availability;
my @resourceNames;
foreach my $resource (@Resource::table) {
    my $resourceName = $resource->fullName('_');
    push @resourceNames, $resourceName;
    if ($MDS_SPLIT_MODE) {
        $availability{$resourceName} = $resource->attribute("availability");
    } else {
        my @processors = $resource->access("processors");
        my @availability = split ' ', $resource->attribute("availability");
        while (@processors) {
            my $processor = shift @processors;
            my $availability = (shift @availability) || 0;
            my $processorName = $processor->fullName('_');
            $availability{$processorName}{$resourceName} = $availability;
        }
    }
}

my $copyrights = &MDS::get_copyrights(" *  ","");

print<<"EOT";
/*
 * $FAMILY/Processor.tuple
${copyrights}
 * Automatically generated from the Machine Description System (MDS).
 */

#ifndef Processor
#define Processor(ID, MINTAKEN, INTERLOCKS, AVAILABILITY)
#else /*Processor*/
EOT

my @bool = ("false", "true");
foreach my $processor (@Processor::table) {
    my $ID = $processor->fullName('_');
    my $minTaken = $processor->attribute("minTaken");
    my $MINTAKEN = "MINTAKEN($minTaken)" if defined $minTaken;
    my $interlocks = $processor->attribute("interlocks") || 0;
    my $INTERLOCKS = "INTERLOCKS($bool[$interlocks])";
    my @availability;
    foreach my $resourceName (@resourceNames) {
        my $available;
        if ($MDS_SPLIT_MODE) {
            $available = $availability{$resourceName};
        } else {
            $available = $availability{$ID}{$resourceName};
        }
        push @availability, "AVAILABLE(RESOURCE($resourceName),$available)";
    }
    my $availability = join ' ', @availability;
    my $AVAILABILITY = "AVAILABILITY($availability)";
    print<<"EOT";
Processor($ID, $MINTAKEN, $INTERLOCKS,
          $AVAILABILITY)
EOT
}

print<<"EOT";
#endif/*Processor*/
#undef Processor\n
EOT

# vim: set ts=4 sw=4 et:
