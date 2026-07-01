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

package AsmTestLib;

# Common subroutines used by the asmtest creation code.

# Issues:
#   1.  Target instruction word width is hard-coded as 32 bits.
#   2.  Extended formats are matched by a trailing X in the name;
#       there must be a better way of doing this.

use strict;


my $Family = $ENV{FAMILY};

sub dispersal_width {
    my $width = 0;
    my $dispersal = shift;
    foreach my $fieldID (split ' ', $dispersal->attribute("fields")) {
        my $field = &MDS::fetch($fieldID);
        $width += $field->attribute("width");
    }
    return $width;
}

my $bundlings_initialized = 0;
my %leading_bundlings = ();
my %non_leading_bundlings = ();
my %even_bundlings = ();
my %odd_bundlings = ();


sub init_bundlings {
    # Cannot init. the bundlings until the MDS database has been read in
    # and parsed.

    return if $bundlings_initialized;

    # Build %contains table to map $dispersalID to @bundlingIDs.
    my %contains;
    foreach my $bundling (@Bundling::table) {
        my $bundlingID = $bundling->attribute("ID");
        my @dispersalIDs = split ' ', $bundling->attribute("dispersals");
        map {push @{$contains{$_}}, $bundlingID} @dispersalIDs;
    }

    # Find the set of bundlings that appear first in a bundle.
    foreach my $template (@Template::table) {
        my @dispersalIDs = split ' ', $template->attribute("dispersals");
        my $first_dispersalID = shift @dispersalIDs;
        foreach my $bundlingID (@{$contains{$first_dispersalID}}) {
            $leading_bundlings{$bundlingID} = 1;
        }
        foreach my $dispersalID (@dispersalIDs) {
            foreach my $bundlingID (@{$contains{$dispersalID}}) {
                $non_leading_bundlings{$bundlingID} = 1;
            }
        }
    }

    # Find the set of bundlings that are odd/even aligned.
    foreach my $template (@Template::table) {
        my ($bias, $base) = ($template->attribute("alignBias"),
                             $template->attribute("alignBase"));
        my $address = $bias*8;
        foreach my $dispersalID (split ' ', $template->attribute("dispersals")) {
            my $dispersal = &MDS::fetch($dispersalID);
            foreach my $bundlingID (@{$contains{$dispersalID}}) {
                # Issue 1: Hard-code instruction word width.
                if (($address % (32 * 2)) != 0) {
                    $odd_bundlings{$bundlingID} = 1;
                } else {
                    $even_bundlings{$bundlingID} = 1;
                }
            }
            $address += dispersal_width ($dispersal);
        }
    }
    $bundlings_initialized = 1;
}

sub isLeadingBundling {
    #  Bundling must appear at start of bundle only.
    my $bundlingID = shift;

    init_bundlings;
    return (exists $leading_bundlings{$bundlingID}
            && ! exists $non_leading_bundlings{$bundlingID});
}

sub isOddBundling {
    # Bundling must appear at odd alignment only.
    my $bundlingID = shift;

    init_bundlings;
    return (exists $odd_bundlings{$bundlingID}
            && ! exists $even_bundlings{$bundlingID});
}

sub isEvenBundling {
    # Bundling must appear at even alignment only.
    my $bundlingID = shift;

    init_bundlings;
    return (exists $even_bundlings{$bundlingID}
            && ! exists $odd_bundlings{$bundlingID});
}


sub validFormatID {
# Is this a format the assembler is interested in?
# No for extended formats.
# Yes for all other formats.
# Issue 2: There should be a better way of finding extended formats.
    my ($CORE, $formatID) = @_;
    my $f = &MDS::fetch($formatID);
    my $fname = $f->name();
    return $fname !~ /\.X$/;
}

sub expandSyntax {
    my ($CORE, $syntax, $mnemonic, $operands) = @_;

    $syntax =~ s/\%0/$mnemonic/g;

    # Instruction-specific hacks to fix up incorrect syntax coming
    # from MDS/chess.

    # $syntax =~ s/LR/\$r63/g;

    $syntax = $syntax ." " if ((index $syntax, " ") == -1);
    my $opd_bits = BitString->new(32);

    foreach my $i (1 .. @$operands) {
        my $operandID = $$operands[$i-1];
        my $operand = &MDS::fetch($operandID);
        my $fields = &MDS::fetch($operand->attribute("fields"));
        my $method = &MDS::fetch($operand->attribute("method"));
        my $mtype = ref($method);
        my $opd_string = ();
        my $opd_value;
        if ($mtype =~ /RegClass/ ) {
            my @registers = $method->access("registers");
            my $register = $registers[-1];
            my @names = split ' ', $register->attribute("names");
            # Chooses the last register syntax token, because this happens
            # to correspond with the syntax used by objdump.
            $opd_string = $names[@names - 1];
            $opd_value = @registers - 1;
        } elsif ($mtype =~ /Modifier/) {
            my @names = split ' ', $method->attribute("members");
            my @values   = split ' ', $method->attribute("values");
            $opd_string = shift @names;
            $opd_string = "" if ($opd_string =~ /^%$/);
            $opd_value = shift @values;
        } elsif ($mtype =~ /Immediate/) {
            my $width = $method->attribute("width");
            my $extend = $method->attribute("extend");
            my $relative = $method->attribute("relative");
            if ($extend =~ /Unsigned/) {
                $opd_string = ((1 << $width) - 1);
                $opd_value = ((1 << $width) - 1);
            } elsif ($extend =~ /Signed/) {
                $opd_string = -1;
                $opd_value = ((1 << $width) - 1);
            } else {
              die "unknown Immediate extension $extend";
            }
            if (defined $relative) {
                $opd_value = ((1 << $width-1) - 1) >> 2;
                $opd_string = ".+" . ($opd_value << 2);
            }
        }
        if ($syntax =~ /\%$i/) {
            $syntax =~ s/\%$i/$opd_string/g;
            # Ugh: even though we see an operand here, its value
            # may be overridden by a pattern in the instruction.
            # So only insert the operand if it is used.
            $opd_bits->insert($fields, $opd_value);
        }
    }
    my $value = ($opd_bits->value(32))[0];
    $value = oct($value) if $value =~ /^0/;
    return ($syntax, $value);
}

sub makeInstructionList {
    # Build a list of { syntax, encoding, bundling } tuples, one tuple for each
    # instruction.
    my $CORE = shift;

    my @result = ();

    foreach my $opcode (@Opcode::table) {
        my $formatID = $opcode->attribute("format");
        my $mnemonic = $opcode->attribute("mnemonic");
        my ($scheduling) = $opcode->access("scheduling");
        my $bundlingID = $scheduling->attribute("bundling");

        if (validFormatID ($CORE, $formatID)) {
            my $encoded = $opcode->attribute("encoded");
            my $bitstring = BitString->new(0, $encoded);
            my ($mask) = $bitstring->mask(32);
            my $encoding = hex(($bitstring->value(32))[0]);
            my $operands = $opcode->attribute("operands") || "";
            my @operands = (split ' ', $operands);
            my $syntax = $opcode->attribute("syntax");
            my $opd_bits;

            ($syntax, $opd_bits) = expandSyntax ($CORE, $syntax, $mnemonic, \@operands);
            $encoding |= $opd_bits;
            push @result, $syntax, $encoding, $bundlingID;
        }
    }

    return @result;
}

1;
