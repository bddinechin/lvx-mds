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

my $debug = 0;
my $TABLE = $ENV{TABLE};
my $FAMILY = $ENV{FAMILY};

use MDS;
&MDS::parse(*ARGV);

# Import dynamically constructed Perl code that includes %MDT and sub fixIDs.
do './MDT.pl';

# Soft reference, e.g if $TABLE eq 'Operator' then $table = \@Operator::table.
my $table = \@{"${TABLE}::table"};
my $noname = \@{"${TABLE}::noname"};

my %table = ();
foreach my $element (@{$noname}, @{$table}) {
    &fixElement($element);
    my $elementID = $$element{ATTRIBUTES}{ID};
    print $element->emit() unless $table{$elementID}++;
}

sub fixElement {
    my $element = shift;
    my $attlist = $element->attlist();
    # Fix the ID names in the $element attributes.
    my $attributes = $$element{ATTRIBUTES};
    while (my ($name, $value) = each %{$attributes}) {
        if ($$attlist{$name}->[0] =~ /^ID(REF|REFS)?\b/) {
            if ($value =~ s/\-[^\-]+\-$/\-$FAMILY\-/) {
           # Special case the 'undefined' elements (whose ID is Element-$core-).
                $$attributes{$name} = $value;
            } else {
           # Special case the 'undefined' elements (whose ID is Element-$core-).
                $$attributes{$name} = &fixIDs($name,$value);
            }
        }
    }
    my $contents = $$element{CONTENTS};
    map { &fixElement($_) if ref $_; } @{$contents}
}

# vim: set ts=4 sw=4 et:
