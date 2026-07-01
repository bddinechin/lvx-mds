# Machine Description System (MDS)
#
# Copyright (C) 2005 STMicroelectronics.
#
# Stephen Clarke (Stephen.Clarke@st.com).
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

package Decode;
use Carp;
use warnings;
use bignum;

# Construction and manipulation of decode trees.

# Issues:
#  1.  The tests select a sparse set of values.  They could
#      be made more dense by shifting the bitfield that is tested.
#  2.  TODO: Subroutine to write a decode tree as XML.

use strict;

sub coding_size {
  my $opcode = shift;
  my $encoding = MDS::fetch($opcode->attribute("encoding"));
  my $width = $encoding->attribute("wordWidth") * $encoding->attribute("wordCount");
  return $width;
}

sub popcount {
  my $value = $_[0];
  my $popcount = 0;
  my $v;
  while (($v = ($value & -$value)) != 0) {
    $popcount++;
    $value -= $v;
  }
  return $popcount;
}

my %cached_opcode_bits;
sub opcode_bits {
  # For each opcode we use two pieces of information:
  # sigbits = the significant bits
  # valbits = the values that significant bits must take
  # Return the list ( $sigbits, $valbits );
  my $opcode = shift;
  if (! exists $cached_opcode_bits{$opcode}) {
    my $encoded = $opcode->attribute("encoded");
    my $encoding = MDS::fetch($opcode->attribute("encoding"));
    my $width = $encoding->attribute("wordWidth") * $encoding->attribute("wordCount");
    my $bitstring = BitString->new(0, $encoded);
    my ($sigbits, $valbits) = (0, 0);
    map {
      die "Encodings > $width bits not supported" if $sigbits != 0;
      $sigbits = ($sigbits << $width) | $_;
    } (reverse $bitstring->mask($width));
    map {
      die "Encodings > $width bits not supported" if $valbits != 0;
      $valbits = ($valbits << $width) | $_;
    } (reverse $bitstring->value($width));
    @{$cached_opcode_bits{$opcode}} = ($sigbits, $valbits);
  }
  return @{$cached_opcode_bits{$opcode}};
}

sub printHex {
  my ($value) = @_;
  my $str;
  my $low = $value & 0xffffffff;
  my $high = ($value >> 32) & 0xffffffff;
  if($high != 0) {
    $str = "0x".sprintf("%08x",$high).sprintf("%08x",$low);
  }
  else {
    $str = "0x".sprintf("%08x",$low);
  }
  return $str;
}

sub find_fields {
  my $val = shift;
  my $coding_size = shift || 32;
  my @fields;
  my $current_start = 0;
  my $current = 0;
  foreach my $pos (0..($coding_size-1)) {
    my $bitpos = 1 << $pos;
    if ((($val & $bitpos) ? 1 : 0) != $current) {
      # We are changing value, so push the previous field.
      my $width = $pos - $current_start;
      push @fields, "$current $current_start $width" if $width > 0;
      $current_start = $pos;
      $current = (($val & $bitpos) ? 1 : 0);
    }
  }
  my $width = $coding_size - $current_start;
  push @fields, "$current $current_start $width";
  # Return a list of tuples { bitval start width } indicating contiguous bit-fields.
  return @fields;
}

sub longest_field {
  my $val = shift;
  my @fields = @_;
  @fields = sort {
    my @a_fields = split ' ', $a;
    my @b_fields = split ' ', $b;
    ($b_fields[0] == $val) <=> ($a_fields[0] == $val) || ($b_fields[2] <=> $a_fields[2])
  } @fields;
  return $fields[0];
}

sub makeTree {
  my ($gmask, $defaults, $opcodes) = @_;
  my $contiguous_fields = $_[3] || 0;
  my $field_limit = $_[4] || 0;
  my $coding_size = $_[5] || 32;
  if (scalar @{$opcodes} == 0) {
    return {};
  }
  my $mask = $gmask;
  my $all_identical = 1;
  my ($valbits, $sigbits) = (0, 0);
  # Calculate mask: the intersection of gmask and the significant bits over all opcodes.
  # Set all_identical true iff all opcodes have an identical encoding, false otherwise.
  foreach my $opcode (@{$opcodes}) {
    my ($opcode_sigbits, $opcode_valbits) = opcode_bits $opcode;
    $mask &= $opcode_sigbits;
    if ($sigbits != 0) {
      $all_identical = 0 unless (($valbits == $opcode_valbits) && ($sigbits == $opcode_sigbits));
    } else {
      $valbits = $opcode_valbits;
      $sigbits = $opcode_sigbits;
    }
  }
  if ($mask == 0) {
    if ($all_identical) {
      # Build and return a terminal node.
      # Note: we allow multiple opcodes here iff they all have
      # an identical encoding, e.g. return and igoto on st200.
      return { opcode => (join ' ', map { $_->{ATTRIBUTES}->{ID} } @{$opcodes}) };
    } else {
      # Compute a new mask.
      my @new_opcodes = @{$opcodes};
      my ($new_gmask, $new_mask) = ($gmask);
      do {
        my ($min_count, $min_sigbits) = (1000);
        map {
          my ($opcode_sigbits) = opcode_bits $_;
          my $sigbits = $new_gmask & $opcode_sigbits;
          my $count = popcount $sigbits;
          if ($count < $min_count) {
            $min_count = $count;
            $min_sigbits = $sigbits;
          }
        } @new_opcodes;
        $new_gmask &= ~$min_sigbits;
        $new_mask = $new_gmask;
        @new_opcodes = grep {
          my ($opcode_sigbits) = opcode_bits $_;
          my $sigbits = $new_gmask & $opcode_sigbits;
          my $include = $sigbits != 0;
          $new_mask &= $opcode_sigbits if $include;
          $include
        } @new_opcodes;
      } until $new_mask;
      # Set a new default.
      my (@sub_opcodes, @new_defaults) = ();
      foreach my $opcode (@{$opcodes}) {
        my ($opcode_sigbits) = opcode_bits $opcode;
        if (($new_gmask & $opcode_sigbits) == 0) {
          push @new_defaults, $opcode;
        } else {
          push @sub_opcodes, $opcode;
        }
      }
      croak "No default found" if (scalar @new_defaults == 0);
      # Recurse with the new default.
      return makeTree ($gmask, \@new_defaults, \@sub_opcodes,
               $contiguous_fields, $field_limit, $coding_size);
    }
  }
  # Some hacking to restrict the tree to meet the needs of clients -
  # - force the bitfield tested to be contiguous if $contiguous_fields set
  # - force the bitfield tested to be no wider than $field_limit.
  my @best_field = split ' ', longest_field (1, find_fields ($mask,$coding_size));
  my $len = $best_field[2];
  if ($len > $field_limit) {
#    print STDERR "Warning: limiting field length ($len => $field_limit)\n";
    $len = $field_limit;
  }
  my $new_mask = ((1 << $len) - 1) << $best_field[1];
  if ($new_mask != $mask) {
#    print STDERR "Warning: splitting mask to assure contiguous fields (".
#    printHex($mask)." => ".printHex($new_mask).")\n";
    $mask = $new_mask;
  }
  # Partition the opcodes by their bit values.
  my %partition_map;
  foreach my $opcode (@{$opcodes}) {
    my ($opcode_sigbits, $opcode_valbits) = opcode_bits $opcode;
    my $valbits = $opcode_valbits & $mask;
    push @{$partition_map{$valbits}}, $opcode;
  }
  # Build a child node for each partition.
  my $children = {};
  foreach my $partition (sort { $a <=> $b } keys %partition_map) {
    my @sub_opcodes = @{$partition_map{$partition}};
    ${$children}{$partition}
    = makeTree ($gmask & ~$mask, $defaults, \@sub_opcodes,
          $contiguous_fields, $field_limit, $coding_size);
  }
  # Make an internal node.
  my $result = { test =>   $mask, children => $children };
  # Set default iff some bitvalues do not select a child.
  if (scalar keys %partition_map < (1 << popcount ($mask))) {
    ${$result}{default} = makeTree ($gmask, [], $defaults, $contiguous_fields, $field_limit, $coding_size);
  }
  return $result;
}

#
# Build a decode tree for a list of opcodes.
# The algorithm is based on Theiling, LCTES 2001 (Sigplan Notices 36(8)).
# with a modification in the handling of defaults: defaults
# are propagated down to all levels of the tree instead
# of requiring the tree client to track the most recent default.
# This makes the decode tree a more conventional decision tree
# and avoids the need for a backtracking step in the client.
#
sub makeDecodeTree {
  my $coding_size = shift;
  my $all_bits = -1;
  return makeTree $all_bits, [], \@_, 0, $coding_size, $coding_size;
}

#
# Variant of makeDecodeTree that ensures that all fields
# tested are contiguous, and no wider than $length.
#
sub makeDecodeTreeContig {
  my $length = shift;
  my $coding_size = shift;
  my $all_bits = -1;
  return makeTree $all_bits, [], \@_, 1, $length, $coding_size;
}

sub printDecodeTreeNode {
  my ($file, $depth, $indent, $tree, $coding_size) = @_;
  my $constant_type = "";
  $constant_type = "LL" if $coding_size > 32;
  if (exists ${$tree}{children}) {
    my $children = ${$tree}{children};
    print $file "\n${indent}switch (codeWord & ",printHex(${$tree}{test}),"$constant_type) {\n";
    foreach my $child (sort { $a <=> $b } keys %{$children}) {
     print $file "$indent case ",printHex($child),"$constant_type:";
     &printDecodeTreeNode($file, $depth + 1, "$indent  ", ${$children}{$child}, $coding_size);
    }
    if (exists ${$tree}{default}) {
      my $default = ${$tree}{default};
      print $file "$indent default:    ";
      &printDecodeTreeNode($file, $depth + 1, "$indent  ", $default, $coding_size);
    }
    print $file "$indent}\n";
  } elsif (exists ${$tree}{opcode}) {
    print $file " return \"${$tree}{opcode}\";\n";
  } else {
    print $file " return \"undefined\";\n";
  }
}

#
# Pretty-print a decode tree to file.
#
sub printDecodeTree {
  my ($file, $tree, $coding_size) = @_;
  &printDecodeTreeNode ($file, 0, "", $tree, $coding_size);
}

1;
