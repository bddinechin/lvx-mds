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

package BitString;
use Carp;
use warnings;
use bignum;

sub new {
    my $this = shift;
    my $width = shift;
    my $init = shift;
    my $self = bless {
        WIDTH=> $width,
        BITS=> [ ],
      };
    if (defined $init) {
        my @bits = reverse (split //, $init);
        !grep {/[^-01]/} @bits or croak "wrong BitString initializer $init";
        $width = @bits unless $width;
        if (@bits > $width) {
            splice @bits, ($width - @bits);
        }
        $$self{BITS} = \@bits;
        $$self{WIDTH} = $width;
    }
    my $start = scalar @{$$self{BITS}};
    for (my $i = $start; $i < $width; $i++) {
        $$self{BITS}[$i] = '-';
    }
    return $self;
}

sub width {
    my ($this) = @_;
    return $$this{WIDTH};
}

sub merge {
    my ($this, $a, $b, $error) = @_;
    $error = " different widths" unless defined $error;
    my $width = $$a{WIDTH};
    $width == $$b{WIDTH} or croak "BitString: cannot merge $error";
    my $bitstring = BitString->new($width);
    my $conflict = 0;
    for my $i (0 .. $width-1) {
        if ($$a{BITS}[$i] eq '-') {
            $$bitstring{BITS}[$i] = $$b{BITS}[$i];
        } elsif ($$b{BITS}[$i] eq '-') {
            $$bitstring{BITS}[$i] = $$a{BITS}[$i];
        } elsif ($$a{BITS}[$i] eq $$b{BITS}[$i]) {
            $$bitstring{BITS}[$i] = $$a{BITS}[$i];
        } else {
            $$bitstring{BITS}[$i] = $$a{BITS}[$i];
            $conflict = 1;
        }
    }
    if ($conflict) {
        warn "BitString: merge conflict $error";
        warn "\t", $a->pretty(), "\t", $b->pretty(), "\n";
    }
    return $bitstring;
}

sub bitwiseAnd {
    my ($a, $b, $error) = @_;
    $error = " different widths" unless defined $error;
    my $width = $$a{WIDTH};
    $width == $$b{WIDTH} or croak "BitString: cannot do and $error";
    my $bitstring = BitString->new($width);
    for my $i (0 .. $width-1) {
        if ($$a{BITS}[$i] eq '-') {
            $$bitstring{BITS}[$i] = '-';
        } elsif ($$b{BITS}[$i] eq '-') {
            $$bitstring{BITS}[$i] = '-';
        } elsif ($$a{BITS}[$i] eq $$b{BITS}[$i]) {
            $$bitstring{BITS}[$i] = $$a{BITS}[$i];
        } else {
            $$bitstring{BITS}[$i] = '-';
        }
    }
    return $bitstring;
}

sub equal {
    my ($a, $b, $error) = @_;
    $error = " different widths" unless defined $error;
    my $width = $$a{WIDTH};
    $width == $$b{WIDTH} or croak "BitString: cannot do equal $error";
    my $equal = 1;
    for my $i (0 .. $width-1) {
        if (not $$a{BITS}[$i] eq $$b{BITS}[$i]) {
            $equal = 0;
        }
    }
    return $equal;
}

sub clone {
    my $self = shift;
    my $width = $$self{WIDTH};
    my @bits = @{$$self{BITS}};
    my $clone = {
        WIDTH=> $width,
        BITS=> \@bits,
      };
    my $class = ref($self);
    bless $clone, $class;
    return $clone;
}

sub mask {
    my ($self, $width) = @_;
    $width = $width || 32;
    my @bits = map {
        my $char = $_;
        $char =~ s/[01]/1/g;
        $char =~ s/\-/0/g;
        $char;
      } @{$$self{BITS}};
    my @format;
    while (@bits) {
        my $value = 0;
        my @word = reverse splice(@bits, 0, $width);
        my $tmp_width = $width;
        while(@word) {
            my $field_width = $tmp_width < 32 ? $tmp_width : 32;
            my @sub_word = splice(@word, 0, $field_width);
            my $word = join '', "0b", grep {defined} @sub_word;
            $tmp_width = $tmp_width - $field_width < 0 ? 0: $tmp_width - $field_width;
            $word = oct($word) if $word =~ /^0/;
            $value |= $word << $tmp_width;
        }
        push @format, $value;
    }
    return @format;
}

sub hex_mask {
    my ($self, $width) = @_;
    $width = $width || 32;
    my @bits = map {
        my $char = $_;
        $char =~ s/[01]/1/g;
        $char =~ s/\-/0/g;
        $char;
      } @{$$self{BITS}};
    my @format;
    while (@bits) {
        my $value = "0x";
        my @word = reverse splice(@bits, 0, $width);
        my $tmp_width = $width;
        while(@word) {
            my $field_width = $tmp_width < 32 ? $tmp_width : 32;
            my @sub_word = splice(@word, 0, $field_width);
            my $word = join '', "0b", grep {defined} @sub_word;
            $tmp_width = $tmp_width - $field_width < 0 ? 0: $tmp_width - $field_width;
            my $format = sprintf("%%0.%dlx",($field_width+3)/4);
            $word = oct($word) if $word =~ /^0/;
            $value .= sprintf($format, $word);
        }
        push @format, $value;
    }
    return @format;
}

sub value {
    my ($self, $width) = @_;
    $width = $width || 32;
    my @bits = map {
        my $char = $_;
        $char =~ s/\-/0/g;
        $char;
      } @{$$self{BITS}};
    my @format;
    while (@bits) {
        my $value = 0;
        my @word = reverse splice(@bits, 0, $width);
        my $tmp_width = $width;
        while(@word) {
            my $field_width = $tmp_width < 32 ? $tmp_width : 32;
            my @sub_word = splice(@word, 0, $field_width);
            my $word = join '', "0b", grep {defined} @sub_word;
            $tmp_width = $tmp_width - $field_width < 0 ? 0: $tmp_width - $field_width;
            $word = oct($word) if $word =~ /^0/;
            $value |= $word << $tmp_width;
        }
        push @format, $value;
    }
    return @format;
}

sub hex_value {
    my ($self, $width) = @_;
    $width = $width || 32;
    my @bits = map {
        my $char = $_;
        $char =~ s/\-/0/g;
        $char;
      } @{$$self{BITS}};
    my @format;
    while (@bits) {
        my $value = "0x";
        my @word = reverse splice(@bits, 0, $width);
        my $tmp_width = $width;
        while(@word) {
            my $field_width = $tmp_width < 32 ? $tmp_width : 32;
            my @sub_word = splice(@word, 0, $field_width);
            my $word = join '', "0b", grep {defined} @sub_word;
            $tmp_width = $tmp_width - $field_width < 0 ? 0: $tmp_width - $field_width;
            my $format = sprintf("%%0.%dlx",($field_width+3)/4);
            $word = oct($word) if $word =~ /^0/;
            $value .= sprintf($format, $word);
        }
        push @format, $value;
    }
    return @format;
}

sub insert {
    my ($self, $bitfield, $value, $error) = @_;
    $error = "" unless defined $error;
    ref($bitfield) eq 'BitField' or
      croak "BitString insertion requires a BitField $error";
    my $width = $bitfield->attribute("width");
    my $offset = $bitfield->attribute("offset");
    if ($width + $offset > $$self{WIDTH}) {
        croak "BitString insertion overflow with width=$width offset=$offset $error";
    }
    my @value = map {'.'} (0 .. $width-1);
    if (defined $value) {
        my $tmp_width = $width;
        my $binary;
        while($tmp_width) {
            my $field_width = $tmp_width > 32 ? 32 : $tmp_width;
            my $format = sprintf("%%0.%db",$field_width);
            my $field_mask = (1<<$field_width)-1;
            my $tmp_value = ($value>> ($tmp_width - $field_width)) & $field_mask;
            my $tmp_binary = sprintf($format, $tmp_value);
            $tmp_value == oct("0b$tmp_binary") or
              croak "BitString conversion of $value to binary failed $error";
            $binary .= $tmp_binary;
            $tmp_width -= $field_width;
        }
        my @bits = split '', $binary;
        croak "BitString: bits number (",scalar @bits,") not equal to width ($width)\n" if(scalar @bits != $width);
        for my $i (0 .. $width-1) {
            my $bit = pop @bits || '0';
            $value[$i] = $bit;
        }
        @bits == 0 or croak "BitString fill value too large";
    }
    for my $i (0 .. $width-1) {
        my $index = $offset + $i;
        $$self{BITS}[$index] =~ /\-/ or
          $$self{BITS}[$index] == $value[$i] or
          warn "BitString position $index overriden $error";
        $$self{BITS}[$index] = $value[$i];
    }
}

sub pretty {
    my $self = shift;
    my $bitfield = shift;
    return join '', reverse @{$$self{BITS}} unless defined $bitfield;
    ref $bitfield eq 'BitField' or croak "BitString pretty requires a BitField";
    my $offset = $bitfield->attribute("offset");
    my $width = $bitfield->attribute("width");
    return join '', reverse splice(@{$$self{BITS}},$offset,$width);
}

sub right_shift {
    my ($self, $shift_amount) = @_;
    $$self{WIDTH} = $shift_amount < $$self{WIDTH} ? $$self{WIDTH} - $shift_amount : 0;
    splice @{$$self{BITS}},0,$shift_amount;
}

1;

# vim: set ts=4 sw=4 et:
