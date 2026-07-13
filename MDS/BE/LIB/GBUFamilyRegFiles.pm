#!/usr/bin/perl -w
# Machine Description System (MDS)
#
# Copyright (C) 2025 Kalray SA
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

use strict;

# gdb needs SFR first
my %Families_regfiles = (
    LVX => [ 'SFR', 'GPR' ],
  );

sub get_family_regfilenames {
    my $family = shift;
    my @family_regfiles = ();

    if ($Families_regfiles{$family}) {
        push (@family_regfiles, @{$Families_regfiles{$family}});
    }

    return @family_regfiles;
}

sub get_sorted_regfiles {
    my $family = shift;
    my $regfiles = shift;
    my @regfiles = @{$regfiles};
    my @sorted_regfiles = ();

    my @family_regfilenames = get_family_regfilenames($family);
    my %family_regfilenames = map { $_ => 1 } @family_regfilenames;

    # All family registers must exists in every core otherwise
    # it will break later (files will not be coherents)
    my %regfiles = map { uc($_->regFileName()) => $_ } @regfiles;
    foreach my $regfile_name (@family_regfilenames) {
        if (! exists $regfiles{$regfile_name}) {
            die "Fatal error: Family regfiles '$regfile_name' is missing";
        }
        push (@sorted_regfiles, $regfiles{$regfile_name});
    }

    # add remaining regfiles from the description
    my @regfilenames_core = ();
    foreach my $regfile (@regfiles) {
        my $regfile_name = $regfile->regFileName();
        if (! exists $family_regfilenames{$regfile_name}) {
            push (@regfilenames_core, $regfile_name);
        }
    }

    foreach my $regfile_name (sort @regfilenames_core) {
        push (@sorted_regfiles, $regfiles{$regfile_name});
    }

    return @sorted_regfiles;
}

sub get_sorted_regfilenames {
    my $family = shift;
    my $regfiles = shift;
    my @regfiles = get_sorted_regfiles($family, $regfiles);

    my @regfilenames = map { uc($_->regFileName()) } @regfiles;
    return @regfilenames;
}

1;
# vim: set ts=4 sw=4 et:
