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

package CHESS;
use Carp;
use warnings;
use integer;

# Parse a CHESS file in <> and return a record list by reference.
# Each record is a HASH of $field => $value. The special values
# KEY and FIELDS are the record key and its list of fields.
sub parse {
    my $handle = shift;
    my @records = ();
    my $record = { };
    my $field;
    my @comments = ();
    while (<$handle>) {
        my $line = join ' ', (split ' ', $_);
        if ($line =~ s/^\+\s+//) {
            push @comments, $line;
        } elsif ($line =~ /^\+\=([\w\.]+)/) {
            if ($$record{KEY}) {
                push @records, $record;
            }
            $record = {};
            $$record{KEY} = $1;
            $$record{FIELDS} = [];
            push @{$$record{COMMENT}}, @comments;
            $field = {};
            @comments = ();
        } elsif ($line =~ s/^\+(\w+)\s*//) {
            $field = $1;
            $$record{$field} = $line;
            push @{$$record{FIELDS}}, $field;
        } elsif (defined $field) {
            if ($line =~ /\S/) {
                $$record{$field} .= "\n$line";
            }
        } elsif ($line =~ /\S/) {
            croak "leftover input:\t$line\n";
        }
    }
    if ($$record{KEY}) {
        push @records, $record;
    }
    return \@records;
}

# Clone a CHESS record.
sub clone {
    my $record = shift;
    my $clone = { };
    foreach my $key (keys %{$record}) {
        my $value = $$record{$key};
        if (ref($value) =~ /^ARRAY/) {
            my @value = @{$value};
            $value = \@value;
        }
        $$clone{$key} = $value;
    }
    return $clone;
}

1

# vim: set ts=4 sw=4 et:
