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

use MDS;
use Behavior;
use PatternX;

&MDS::parse(*ARGV);

#
# Generate new Instruction(s) from the Synthetic(s).
#
foreach my $synthetic (@Synthetic::table) {
    my @formats = $synthetic->access("formats");
    my ($instruction) = $synthetic->access("instruction");
# Check if forced operands give same Patterns on all formats
# Previously, we tried to factorize the patterns if they were the "same"
# (i.e., same bitfields even though the name was not the same).
# This breaks when we want to track the origin of a bitfield.
# Generate one instruction by format ($encoded value depend on operand bitfields of each format.
    my @synthetic_patterns;
    my @formats_list;
    foreach my $format (@formats) {
        push @synthetic_patterns, &get_synthetic_patterns($synthetic, $format);
        push @formats_list, $format->attribute("ID");
    }
    my $format_list_str = join ' ', @formats_list;
    &emit_instruction($instruction, $synthetic, $format_list_str, @synthetic_patterns);
}

sub emit_instruction {
    my ($instruction, $synthetic, $formatIDs, @synthetic_patterns) = @_;
    my $nameS = $synthetic->name();
    my $mnemonicS = $synthetic->attribute("mnemonic");
    my $syntaxS = $synthetic->attribute("syntax");
    my $whatS = $synthetic->attribute("what");
    # Get scheduling info for each format
    my %schedulingID;
    my $schedulings = $synthetic->attribute("schedulings")
      || $instruction->attribute("schedulings");
    my @schedulingIDs = split ' ', $schedulings;
    my @formatIDs = split ' ', $instruction->attribute("formats");
    for my $i (0 .. (@formatIDs - 1)) {
        my $format = $formatIDs[$i];
        my $schedulingID = $schedulingIDs[$i] || $schedulingIDs[$i-1];
        $schedulingID{$format} = $schedulingID;
    }
    my $ID = &Instruction::ID($nameS);
    for (my $i = 1; defined $MDS::table{$ID}; $i++) {
        $ID = &Instruction::ID("$nameS.$i");
    }
    $instruction = $instruction->clone($ID);
    $instruction->attribute(what=> $whatS);
    $instruction->attribute(formats=> $formatIDs);
    my @schedulings; map { push @schedulings, $schedulingID{$_}; } split ' ', $formatIDs;
    $instruction->attribute(schedulings=> join ' ', @schedulings);
    my %patternIDs; my @patternIDs = grep {++$patternIDs{$_}}
      (split ' ', ($instruction->attribute("patterns") || '')),
      map { $_->attribute("ID"); } @synthetic_patterns;
    my $patternIDs = join ' ', @patternIDs;
    $instruction->attribute(patterns=> $patternIDs);
    $instruction->attribute(mnemonic=> $mnemonicS);
    $instruction->attribute(syntax=> $syntaxS) if defined $syntaxS;
    $instruction->attribute(synthetic=> $synthetic->attribute("ID"));
    $instruction->attribute(properties=> $synthetic->attribute("properties"));
    print $instruction->emit();
}

# vim: set ts=4 sw=4 et:
