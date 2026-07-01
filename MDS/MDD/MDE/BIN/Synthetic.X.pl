#!/usr/bin/perl -w
# Machine Description System (MDS)
#
# Copyright (C) 2005 STMicroelectronics
#
# Benoit Dupont de Dinechin (Benoit.Dupont-de-Dinechin@st.com).
# Stefan Freudenberger (Stefan.Freudenberger@st.com).
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

use MDS;
use Behavior;

&MDS::parse(*ARGV);

exit if $MDD::FAMILY ne 'arm';  # only do this for ARM

# HACK: assume we know something about Operands, Modifiers ...
my $condOperand = &Operand::ID("cond");
my $condValue = "0b1110";
my $condName = 'al';

#
# Generate new Synthetic(s) by enumerating existing Synthetic(s):
#
foreach my $synthetic (@Synthetic::table) {
  my ($instruction) = $synthetic->access("instruction");
  &processInstruction($instruction, $synthetic);
}

#
# Generate the Synthetic(s) by enumerating the Format(s) of each Instruction:
#
foreach my $instruction (@Instruction::table) {
  &processInstruction($instruction);
}

sub processInstruction {
  my ($instruction, $synthetic) = @_;
  my $instructionID = $instruction->attribute("ID");
  my $mnemonic = ($synthetic || $instruction)->attribute("mnemonic");
  my $formats = ($synthetic || $instruction)->attribute("formats");
  my @specializeI = split ' ', ($instruction->attribute("specialize") || "");
  my @replacementI = split ' ', ($instruction->attribute("replacement") || "");
  my %overrideI;
  while (@specializeI && @replacementI) {
    my $specialize = shift @specializeI;
    my $replacement = shift @replacementI;
    $overrideI{$specialize} = $replacement;
  }
  die "mismatch in $instructionID specialize and replacement"
      if @specializeI || @replacementI;
  foreach my $formatID (split ' ', $formats) {
    my $format = &MDS::fetch($formatID);
    my $operandIDs = $format->attribute("operands") || '';
    my @operandIDs = map { $overrideI{$_} || $_ } (split ' ', $operandIDs);
    my $force;
    for my $i (1 .. @operandIDs) {
      $force = "%$i" if $operandIDs[$i-1] eq $condOperand;
      last if defined $force;
    }
    next unless defined $force;
    my $syntax = ($synthetic ? $synthetic->attribute("syntax") : undef) ||
        $instruction->attribute("syntax") ||
        $format->attribute("syntax") ||
        $mnemonic;
    $syntax =~ s/\b$mnemonic\b/%0/;
    my @proxies = ($syntax =~ /(?<!\%)(\%[1-9]\d*)/g);
    next unless grep { $_ eq $force } @proxies;
    (my $syntaxS = $syntax) =~ s/(?<!\%)(%\d+)/$1 ne $force? $1: ''/ge;
    my ($prefix) = split ' ', $syntax;
    $prefix =~ s/(?<!\%)(%0)/$mnemonic/;
    (my $prefixI = $prefix) =~ s/(?<!\%)(%\d+)//g;
    (my $prefixS = $prefix) =~ s/(?<!\%)(%\d+)/$1 eq $force? $condName: ''/ge;
    my $name = ($synthetic || $instruction)->name();
    (my $nameS = $name) =~ s/^$prefixI/$prefixS/;
    my $syntheticID = &Synthetic::ID($nameS);
    if (defined $synthetic) {
      $synthetic = $synthetic->clone($syntheticID);
      $synthetic->attribute(syntax=> $syntaxS);
      my $forcedS = join ' ', $synthetic->attribute("forced"), $force;
      $synthetic->attribute(forced=> $forcedS);
      my $valuesS = join ' ', $synthetic->attribute("values"), $condValue;
      $synthetic->attribute(values=> $valuesS);
    } else {
      $synthetic = MDS::make("Synthetic",
        {
          ID=>          $syntheticID,
          mnemonic=>    $mnemonic,
          instruction=> $instructionID,
          formats=>     $formatID,
          syntax=>      $syntaxS,
          forced=>      $force,
          values=>      $condValue,
        });
    }
    print $synthetic->emit();
  }
}

