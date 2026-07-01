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

package Test;

use strict;
use warnings "FATAL" => "all";

use GBUTarget;
use MDS;
use BitString;
use bignum;
use Carp;

my %operandSelect;

my %registerIndex;
my %getFirstRegisterName;

sub initRegFile {
    foreach my $regFile (@_) {
        my $index = 0;
        my @registers = $regFile->access("registers");
        map {
            my $ID = $_->attribute("ID");
            die "Index already defined as $registerIndex{$ID} for $ID" if defined $registerIndex{$ID};
            $registerIndex{$ID} = $index++;
        } @registers;
    }
}

sub initRegClass {
    foreach my $regClass (@_) {
        my $regClassID = $regClass->attribute("ID");
        my $shift = $regClass->attribute("shift") || 0;
        my $bias = $regClass->attribute("bias") || 0;
        my @registers = $regClass->access("registers");
        $operandSelect{$regClass->attribute("ID")}{first} = 0;
        $operandSelect{Syntax}{$regClassID}{current} = 0;
        $operandSelect{Coding}{$regClassID}{current} = 0;
        $operandSelect{$regClassID}{last} = 0;
        map {
            my $ID = $_->attribute("ID");
            my @regnames = split(' ',$_->attribute("names"));
            my $registerIndex = $registerIndex{$ID};
            unless (defined $registerIndex) {
                $regnames[0] =~ /(\d+)/;
                $registerIndex = $1 || 0;
                warn "Missing attribute index for $ID, assuming index=$registerIndex";
            }
            my $encoded_value = ($registerIndex - $bias) >> $shift;
            map {
                push @{$operandSelect{$regClassID}{values}}, $encoded_value;
                push @{$operandSelect{$regClassID}{names}}, $_;
                $operandSelect{$regClassID}{last}++;
                $getFirstRegisterName{$regClassID}{$_} = $regnames[0];
            }@regnames;
            
        } @registers;
    }
}

sub initModifier {
    foreach my $modifier (@_) {
        my $modifierID = $modifier->attribute("ID");
        my @names = split(' ',$modifier->attribute("members"));
        my @values = split(' ',$modifier->attribute("values"));
        $operandSelect{$modifier->attribute("ID")}{first} = 0;
        $operandSelect{Syntax}{$modifierID}{current} = 0;
        $operandSelect{Coding}{$modifierID}{current} = 0;
        $operandSelect{$modifierID}{last} = 0;
        map {
            push @{$operandSelect{$modifierID}{names}}, lc($_);
        }@names;
        map {
            push @{$operandSelect{$modifierID}{values}}, $_;
            $operandSelect{$modifierID}{last}++;
        }@values;
    }
}

sub initImmediate {
    foreach my $immediate (@_) {
        my $immediateID = $immediate->attribute("ID");
        my $minValue = 0;
        my $maxValue = 0;

        my $shiftValue = 0;
        $shiftValue = $immediate->attribute("shift")
            if defined $immediate->attribute("shift") and &GBUTarget::ConsiderScaling();

        my @bitmask = $immediate->access("bitmask") if defined $immediate->attribute("bitmask");

        my $width = $immediate->attribute("width");

        croak "Bitmask cannot have shift attribute"
            if(defined $immediate->attribute("shift") and
               defined $immediate->attribute("bitmask"));

        if(scalar @bitmask) {
            # Try to get value that cannot match other immediate variant ...
            my $start = $bitmask[0];
            my $end = $bitmask[1];
            my $start_width = $start->attribute("width");
            my $end_width = $end->attribute("width");
            my $start_pos = int(((1<<$start_width)-1)/4);
            my $end_pos = int(((1<<$end_width)-1)-3);
            my $end_value = (1<<($end_pos+1)) - 1;
            my $start_value = (1<<$start_pos) - 1;
            my $mask = $end_value & ~$start_value;
            $operandSelect{$immediateID}{value} = $mask;
            $operandSelect{$immediateID}{encoded_value} = ($end_pos << $start_width) | $start_pos;
        }
        else {
            my $removeShiftLowBits = ~0;
            $removeShiftLowBits = ~((1 << $shiftValue) -1) if($shiftValue != 0);
            if($immediate->attribute("extend") eq "Signed") {
                # Use ~$removeShiftLowBits because we do ~$maxValue to get $minValue ...
                $maxValue = int(((1<<($width+$shiftValue-1)) - 1)>>3) | ~$removeShiftLowBits;
                $minValue = ~$maxValue;
                $operandSelect{$immediateID}{value} = $minValue;
                $operandSelect{$immediateID}{encoded_value} = $minValue;
            }
            else {
                $maxValue = int(((1<<($width+$shiftValue)) - 1)>>3) & $removeShiftLowBits;
                $operandSelect{$immediateID}{value} = $maxValue;
                $operandSelect{$immediateID}{encoded_value} = $maxValue;
            }
        }
    }
}

sub getSyntax {
    my ($opcode,$mnemonic,$syntax,$pc_relative,$objdump) = @_;
    
    # Flag is set when have to generate syntax corresponding to objdump output:
    # - Choose the first variant of register names.
    $objdump = 0 if(not defined $objdump);

    $$pc_relative = 0 if(defined $pc_relative);
    $mnemonic = $opcode->attribute("mnemonic") if(not defined $mnemonic);
    $syntax = $opcode->attribute("syntax") if(not defined $syntax);

    my $encoding = &MDS::fetch($opcode->attribute("encoding"));
    my $mnemo = lc($mnemonic);
    my $isa=$encoding->attribute("wordWidth") * $encoding->attribute("wordCount") * 
        $syntax =~ s|%0|$mnemo|g;
    
    my $opnd_id = 1;
    foreach my $operand ( $opcode->access('operands') ) {
        my $proxy = "%".$opnd_id++;
        my $method = $operand->attribute("method");

        if ($method =~ /^Modifier/ or $method =~ /^RegClass/) {
            my @names = @{$operandSelect{$method}{names}};
            my $name = $names[$operandSelect{Syntax}{$method}{current}++];
            if($objdump and $method =~ /^RegClass/) {
                croak "Unable to get first register name for $method::$name"
                    if(not defined $getFirstRegisterName{$method});
                $name = $getFirstRegisterName{$method}{$name};
            }
            if($operandSelect{Syntax}{$method}{current} == $operandSelect{$method}{last}) {
                $operandSelect{Syntax}{$method}{current} = $operandSelect{$method}{first};
            }
            $syntax =~ s|$proxy|$name|g;
            if ($method =~ /^Modifier/) {
                # Assume empty modifiers are '.', and remove them from $syntax
                undef while $syntax =~ s/\.\./\./g;
                $syntax =~ s/\.(\s)/$1/;
                $syntax =~ s/\.$//;
            }
        }
        elsif ( $method =~ /^Immediate/ ) {
            $syntax =~ s|$proxy|$operandSelect{$method}{value}|g;
            if(defined $pc_relative) {
                my @relocations = $operand->access("relocations");
                if(@relocations) {
                    foreach my $relocation (@relocations) {
                        if(defined $relocation->attribute("relative") &&
                           $relocation->attribute("relative") eq "PC") {
                            $$pc_relative = &GBUTarget::PCRelativeOperand($operand);
                        }
                    }
                }
            }
        }
        else {
            $syntax =~ s/$proxy/[ERROR][$opnd_id=$method]/g;
        }
    }
    
    return $syntax;
}

sub insert_value {
    my ($bitstring,$value,@bitfields) = @_;
    foreach my $bitfield (reverse @bitfields) {
        $bitstring->insert($bitfield,$value);
        $value = $value >> $bitfield->attribute("width");
    }
}

sub getCoding {
    my $opcode = shift;

    my $encoding = &MDS::fetch($opcode->attribute("encoding"));
    my $isa=$encoding->attribute("wordWidth") * $encoding->attribute("wordCount");
    my $encoded = BitString->new($isa,$opcode->attribute("encoded"));

    my $opnd_id = 1;
    foreach my $operand ( $opcode->access('operands') ) {
        my $proxy = "%".$opnd_id++;
        my $methodID = $operand->attribute("method");

        my @bitfields = $operand->access("fields");
        if ( $methodID =~ /^Modifier/ or
             $methodID =~ /^RegClass/) {
            my @values = @{$operandSelect{$methodID}{values}};
            my $value = $values[$operandSelect{Coding}{$methodID}{current}++];
            if($operandSelect{Coding}{$methodID}{current} == $operandSelect{$methodID}{last}) {
                $operandSelect{Coding}{$methodID}{current} = $operandSelect{$methodID}{first};
            }
            insert_value($encoded,$value,@bitfields);
        }
        elsif ( $methodID =~ /^Immediate/ ) {
            my $value = $operandSelect{$methodID}{encoded_value};
            my $method = &MDS::fetch($methodID);
            if(defined $method->attribute("shift") and &GBUTarget::ConsiderScaling()) {
            $value >>= $method->attribute("shift");
        }
            insert_value($encoded,$value,@bitfields);
        }
        else {
            croak "[ERROR][$opnd_id=$methodID]";
        }
    }
    my $coding = join('',$encoded->hex_value($isa));
    return $coding;
}

1;


