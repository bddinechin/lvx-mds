#!/usr/bin/perl -w
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

# Create include/opcodes/$Family.h file for binutils.


use strict;
use warnings "FATAL" => "all";

use MDS;
use BitString;
use AsmTestLib;
use GBUTarget;
use GBU;
use Carp;

my $Family = $ENV{FAMILY};
my $FAMILY = uc $Family;
my @Cores = split ' ', $ENV{CORES};
my $wordWidth = 32;

sub commonPrefix {
  my $prefix = $_[0];
  foreach my $word (@_) {
    while ($prefix ne "" && $word !~ m/^$prefix/) {
      $prefix = substr ($prefix, 0, -1);
    }
  }
  return $prefix;
}

sub printHeader {
    my $file = shift;

    my $copyrights = &MDS::get_copyrights("*** ","\n");

    print $file <<"EOT";
/**
$copyrights
***
*** This program is free software; you can redistribute it and/or
*** modify it under the terms of the GNU General Public License
*** as published by the Free Software Foundation; either version
*** 2 of the License, or (at your option) any later version.
***
*** This program is distributed in the hope that it will be useful,
*** but WITHOUT ANY WARRANTY; without even the implied warranty of
*** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
*** General Public License for more details.
***
*** You should have received a copy of the GNU General Public License
*** along with this program; if not, write to the Free Software
*** Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
***
**/

EOT

  print $file "#ifndef OPCODE_${FAMILY}_H\n";
  print $file "#define OPCODE_${FAMILY}_H\n\n";

}

# encodeInstMacro(opcode)
sub encodeInstMacro {
  my $opcode = shift;
  my $name = $opcode->attribute("ID");
  $name =~ s/^Opcode\-(.+)/$1/;
  $name =~ s/\W/_/g;

  my $encoded       = $opcode->attribute("encoded");
  my @operands      = $opcode->access("operands");
  my $format        = MDS::fetch($opcode->attribute("format"));
  my $encoding      = MDS::fetch($format->attribute("encoding"));
  my ($coding_size) = $encoding->attribute("wordCount")*$encoding->attribute("wordWidth");
  my $modifiers     = GBU::getModifiers($coding_size,@operands);
  my $argcount      = 1;
  my %terms         = ();
  my @args          = ();

  foreach my $operand (@operands) {
    # Skip the modifiers.
    if($operand->attribute("method") =~ /^Modifier/) { next; }

    my $name = $operand->attribute("ID");
    $name =~ s/Operand-(.+)-(.+)/$2/;
    $name =~ s/\W/_/g;
    my $val = "($name)";
    push @args, "$name";

    my $methodID = $operand->attribute("method");
    if ($methodID =~ /^Immediate/) {
      # Apply the inverse of the method to the immediate value.
      my $method = MDS::fetch($methodID);
      my $bias   = $method->attribute("bias");
      my $shift  = $method->attribute("shift");
      $val = "($val - $bias)" if $bias;
      $val = "($val >> $shift)" if $shift;
      # No need to apply width or extension, since we assume
      # the fields will ignore these upper bits.
    }

    # Now val contains the encoded value, we need to place it in
    # the appropriate fields.
    my @fields = split ' ', $operand->attribute("fields")
      if(defined $operand->attribute("fields"));
    my $i = @fields;
    foreach my $fieldID (reverse @fields) {
      my $fieldval = $val;
      my $field = MDS::fetch($fieldID);
      my $width = $field->attribute("width");
      if ($width) {
        my $mask = sprintf "0x%lx", (1 << $width) - 1;
        $fieldval = "($fieldval & $mask)";
      }
      my $offset = $field->attribute("offset");
      my $index = $offset / $wordWidth;
      my $shift = $offset % $wordWidth;
      $fieldval = "($fieldval << $shift)" if $shift;
      my $word = sprintf("%d", $offset >> 5);
      push @{$terms{$word}}, $fieldval;
      $val = "($val >> $width)";
    }
  }
  my $result = "";
  my @words = sort { $a <=> $b } keys %terms;
  if(keys %$modifiers) {
      # Push dummy opcode coding.
      if (@words) {
          unshift @{$terms{$words[0]}}, 0;
      } else {
          unshift @{$terms{"code"}}, 0;
      }
      foreach my $modifier (sort keys %$modifiers) {
          my @modifier_names = split(' ',$$modifiers{$modifier}{names});
          my @operand_names = split(' ',$$modifiers{$modifier}{opnd_names});
          my $bitstring = BitString->new(0, $encoded);
          my $new_name = $name;
          $bitstring = $bitstring->merge($bitstring,$$modifiers{$modifier}{coding});
          my ($code) = $bitstring->hex_value(32);
          for(my $i=0; $i<@modifier_names; $i++) {
              # Assume empty modifiers are '.', and remove them from $modifier_name
              (my $modifier_name = $modifier_names[$i]) =~ s/^\.//;
              $new_name =~ s|_$operand_names[$i]_|_${modifier_name}_|g;
              $new_name =~ s/\W/_/g;
          }
          # Put the code in the lexically first word, ugh!
          if (@words) {
              # Remove previous opcode coding
              shift @{$terms{$words[0]}};
              unshift @{$terms{$words[0]}}, $code;
          } else {
              # Remove previous opcode coding
              shift @{$terms{"code"}};
              unshift @{$terms{"code"}}, $code;
          }
          foreach my $word (@words) {
              my @wordterms = @{$terms{$word}};
              my $wordname = ((scalar @words) >= 2) ? "_$word" : "";
              $wordname =~ s/\W/_/g;
              $result .= "#define ${new_name}_insn$wordname(".(join ',', @args).") (unsigned)("
                  . (join ' | (unsigned)', @wordterms) . ")\n";
          }
      }
  } else {
      my $bitstring = BitString->new(0, $encoded);
      my ($code) = $bitstring->hex_value(32);

      if (@words) {
          unshift @{$terms{$words[0]}}, $code;
      } else {
          unshift @{$terms{"code"}}, $code;
      }
      foreach my $word (@words) {
          my @wordterms = @{$terms{$word}};
          my $wordname = ((scalar @words) >= 2) ? "_$word" : "";
          $wordname =~ s/\W/_/g;
          $result .= "#define ${name}_insn$wordname(".(join ',', @args).") (unsigned)("
              . (join ' | (unsigned)', @wordterms) . ")\n";
      }
  }
  return $result;
}

sub isInstMacro {
  my $opcode = shift;
  my $defines = "";
  my $name = $opcode->attribute("ID");
  $name =~ s/Opcode\-(.+)/$1/;
  $name =~ s/\W/_/g;
  my $encoded = $opcode->attribute("encoded");
  my @operands = $opcode->access("operands");
  my $format = &MDS::fetch($opcode->attribute("format"));
  my $encoding = &MDS::fetch($format->attribute("encoding"));
  my ($coding_size) = $encoding->attribute("wordCount")*$encoding->attribute("wordWidth");
  my $modifiers = &GBU::getModifiers($coding_size,@operands);
  if(keys %$modifiers) {
      foreach my $modifier (sort keys %$modifiers) {
          my $bitstring = BitString->new(0, $encoded);
          my @modifier_proxies = split(' ',$$modifiers{$modifier}{proxies});
          my @modifier_names = split(' ',$$modifiers{$modifier}{names});
          my @operand_names = split(' ',$$modifiers{$modifier}{opnd_names});
          my $new_name = $name;
          croak "Not same number of proxies/names (",scalar(@modifier_proxies),"/",scalar(@modifier_names),")"
              if(scalar(@modifier_proxies) != scalar(@modifier_names));
          for(my $i=0; $i<@modifier_proxies; $i++) {
              # Assume empty modifiers are '.', and remove them from $modifier_name
              (my $modifier_name = $modifier_names[$i]) =~ s/^\.//;
              $new_name =~ s|_$operand_names[$i]_|_${modifier_name}_|g;
              $new_name =~ s/\W/_/g;
          }
          $bitstring = $bitstring->merge($bitstring,$$modifiers{$modifier}{coding});
          my ($code) = $bitstring->hex_value(32);
          my ($mask) = $bitstring->hex_mask(32);
          $defines .= "#define is_${new_name}_insn(x) (((unsigned)(x) & $mask) == $code)\n";
      }
  } else {
      my $bitstring = BitString->new(0, $encoded);
      my ($code) = $bitstring->hex_value(32);
      my ($mask) = $bitstring->hex_mask(32);
      $defines = "#define is_${name}_insn(x) (((unsigned)(x) & $mask) == $code)\n";
  }
  return $defines;
}

sub extractBitFieldMacro {
  use bignum;
  my $bitfield = shift;

  my $name = $bitfield->attribute("ID");
  $name =~ s/BitField\-(.+)/$1/;
  $name =~ s/\W/_/g;
  my $width = $bitfield->attribute("width") || 0;
  my $offset = $bitfield->attribute("offset");
  my $index = $offset/$wordWidth;
  my $shift = $offset%$wordWidth;
  my $val = "(unsigned long)(x)";
  $val = "($val >> $shift)" if ($shift);
  my $mask = sprintf "0x%lx", (1 << $width) - 1;
  $val = "($val & $mask)";
  return "#define ${name}_fld(x) $val\n";
}

sub extractOperandMacro {
  my $operand = shift;

  my $name = $operand->attribute("ID");
  $name =~ s/Operand\-(.+)/$1/;
  $name =~ s/\W/_/g;
  my @fields = split ' ', $operand->attribute("fields")
    if(defined $operand->attribute("fields"));
  my $val;
  my %words;
  foreach my $fieldID (@fields) {
    my $field = &MDS::fetch($fieldID);
    my $width = $field->attribute("width");
    my $offset = $field->attribute("offset");
    my $index = $offset/$wordWidth;
    my $shift = $offset%$wordWidth;
    my $mask = sprintf "0x%lx", (1 << $width) - 1;
    my $word = sprintf("w%d", $offset >> 5);
    $words{$word} = 1;
    my $w = "(unsigned long)($word)";
    $w = "($w >> $shift)" if $shift;
    $w = "($w & $mask)";
    if ($val) {
      $val = "(($val << $width) | $w)";
    } else {
      $val = $w;
    }
  }
  my @words = sort keys %words;
  return "#define ${name}_opd(".(join ',', @words).") $val\n" if(@words);
}

sub printMacros {
  my $file = shift;
    foreach my $bitfield (@BitField::table) {
      print $file &extractBitFieldMacro($bitfield);
    }
    print $file "\n";
    foreach my $operand (@Operand::table) {
      print $file &extractOperandMacro($operand);
    }
    print $file "\n";
    foreach my $opcode (@Opcode::table) {
      print $file &encodeInstMacro($opcode);
      print $file &isInstMacro($opcode) if $opcode->name() =~ /^NOP_/;
    }
    print $file "\n";
    my %encoding_codes;
    foreach my $opcode (@Opcode::table) {
        my ($encoding) = $opcode->access("encoding");
        my $encoding_name = uc($encoding->name());

        if(defined $encoding_codes{$encoding_name}) {
            my $bitstring = BitString->new(0, $opcode->attribute("encoded"));
            $encoding_codes{$encoding_name} = $encoding_codes{$encoding_name}->bitwiseAnd($bitstring);
        }
        else {
            $encoding_codes{$encoding_name} = BitString->new(0, $opcode->attribute("encoded"));
        }
    }
    foreach my $encoding (sort keys %encoding_codes) {
        my @hex_value = $encoding_codes{$encoding}->hex_value();
        my @hex_mask = $encoding_codes{$encoding}->hex_mask();
        print $file "#define ${FAMILY}_${encoding}_MASK \t$hex_mask[0]\n";
        print $file "#define ${FAMILY}_${encoding}_VAL  \t$hex_value[0]\n";
   }
}

sub printTrailer {
  my $file = shift;

  print $file "\n#endif /* OPCODE_${FAMILY}_H */\n";
}


MDS::parse(*ARGV);

GBU::Init();

printHeader(*STDOUT);
printMacros(*STDOUT);
printTrailer(*STDOUT);
