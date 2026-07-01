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
use Carp;

use BitString;

sub get_synthetic_patterns {
    my ($synthetic,$format) = @_;
    my @forced_operands;
    my $synthetic_name = $synthetic->name();
    my $format_name = $format->name();
    my @synthetic_patterns;
    my @patterns = @Pattern::table;
    my @forced = split(' ',$synthetic->attribute("forced")) if(defined $synthetic->attribute("forced"));
    my @values = split(' ',$synthetic->attribute("values")) if(defined $synthetic->attribute("values"));
    croak "Not same number of forced (@forced)/values (@values)" if(@forced != @values);
    my ($encoding) = $format->access("encoding");
    my $encoding_width = $encoding->attribute("wordCount") * $encoding->attribute("wordWidth");
    my @operands = $format->access("operands");
    for(my $i=0; $i < @forced; $i++) {
        my $forced = $forced[$i];
        my $value = $values[$i];
        $value = oct($value) if $value =~ /^0/;
        if($forced !~ /^\%([0-9]+)$/) {
            croak "Unrecognized forced proxy: $forced";
        }
        my $operand = $operands[$1-1];
        next unless defined $operand;
        my $operand_name = $operand->name();
        my $new_pattern = &MDS::fetch($patterns[0]->attribute("ID"))->clone(&Pattern::ID("${format_name}:${synthetic_name}.${operand_name}"));
        my @pattern_values;
        my @fields = $operand->access("fields");
        my $fields_width = 0;
        map { $fields_width += $_->attribute("width"); } @fields;
        my $value_offset = $fields_width;
        foreach my $field (@fields) {
            my $width = $field->attribute("width");
            my $offset = $field->attribute("offset");
            $value_offset -= $width;
            my $field_value = ($value >> $value_offset) & ((1<<$width)-1);
            my $pattern = BitString->new($encoding_width);
            $pattern->insert($field,$field_value);
            push @pattern_values, "0b".$pattern->pretty($field);
        }
        $new_pattern->attribute(fields=> $operand->attribute("fields"));
        $new_pattern->attribute(values=> join(' ',@pattern_values));
        push @synthetic_patterns, $new_pattern;
    }
    return @synthetic_patterns;
}

1;

# vim: set ts=4 sw=4 et:
