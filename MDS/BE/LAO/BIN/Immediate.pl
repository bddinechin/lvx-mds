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


my $debug = $ENV{DEBUG} || 0;
my $FAMILY = $ENV{FAMILY};

my $MDS_SPLIT_MODE = 0;
if ($ARGV[0] eq "--split") {
    $MDS_SPLIT_MODE = 1;
    shift @ARGV;
}

use MDS;
use Behavior;
use bigint;
&MDS::parse(*ARGV);

my $copyrights = &MDS::get_copyrights(" *  ","");

print<<"EOT";
/*
 * $FAMILY/Immediate.tuple
${copyrights}
 * Automatically generated from the Machine Description System (MDS).
 */

#ifndef Immediate
#define Immediate(ID, MINVALUE, MAXVALUE, EXTEND, RELOCATIONS, ENCODE, DECODE)
#else /*Immediate*/
EOT

sub buildRelocations {
    my %relocations;
    # Init relocations from Operands.
    foreach my $operand (@Operand::table) {
        my ($method) = $operand->access("method");
        if(defined $method->name()) {
            if(defined $operand->attribute("relocations")) {
                my $methodID = $method->attribute("ID");
                my @relocations = $operand->access("relocations");
                $relocations{$methodID}{OPERAND} = $operand->name();
                $relocations{$methodID}{RELOCS} = \@relocations;
                $relocations{$methodID}{DEFAULT} = $operand->attribute("default");
            }
        }
    }
    return %relocations;
}

my %relocations = &buildRelocations();
my $ImmediateRelocations_MAXCOUNT = 0;
foreach my $immediate (@Immediate::table) {
    my $ID = $immediate->fullName('_');
    my $shift = $immediate->attribute("shift") || 0;
    my $bias = $immediate->attribute("bias") || 0;
    my $width = $immediate->attribute("width");
    my $extend = $immediate->attribute("extend");
    my $maxValue = (1 << ($width - 1)) - 1;
    my $minValue = -(1 << ($width - 1));
    my $signed = $extend eq 'Signed';
    my $wrap = $extend eq 'Wrap';
    unless ($signed) {
        $maxValue = (1 << $width) - 1;
        unless ($wrap) {
            $minValue = 0;
        }
    }
    $minValue <<= $shift;
    $minValue += $bias;
    $maxValue <<= $shift;
    $maxValue += $bias;
    my $MINVALUE = "MINVALUE($minValue)";
    my $MAXVALUE = "MAXVALUE($maxValue)";
    my @relocations = @{$relocations{$immediate->attribute("ID")}{RELOCS}}
      if(defined $relocations{$immediate->attribute("ID")});
    my @relocationItems = map {"RELOCATION(". $_->fullName('_'). ")"} @relocations;
    push @relocationItems, "RELOCATION(_UNDEF)" unless @relocationItems;
    my $relocationItems = @relocationItems? (join ' ', @relocationItems): "/**/";
    my $RELOCATIONS = "RELOCATIONS(". @relocationItems. ", $relocationItems)";
    my $EXTEND = "EXTEND($extend)";
    my $valueWidth = $shift + $width > 32? 64: 32;
    my $valueType = $signed? "int${valueWidth}_t": "uint${valueWidth}_t";
    my $mask = $width >= $valueWidth? "($valueType)-1": "(($valueType)1<<$width)-1";
    my (@encode, @decode);
    push @encode, "$valueType __value = VALUE";
    push @encode, "__value -= $bias" if $bias;
    push @encode, "__value >>= $shift" if $shift;
    push @encode, "__value &= $mask" unless $signed;
    push @encode, "VALUE = __value";
    my $ENCODE = "ENCODE(". (@encode? (join '; ', @encode): "/**/"). ")";
    push @decode, "$valueType __value = VALUE";
    if ($signed) {
        push @decode, "__value <<= (sizeof(__value)*8-$width)";
        push @decode, "__value >>= (sizeof(__value)*8-$width)";
    }
    push @decode, "__value <<= $shift" if $shift;
    push @decode, "__value += $bias" if $bias;
    push @decode, "VALUE = __value";
    my $DECODE = "DECODE(". (@decode? (join '; ', @decode): "/**/"). ")";
    print <<"EOT";
Immediate($ID, $MINVALUE, $MAXVALUE, $EXTEND,
          $RELOCATIONS,
          $ENCODE,
          $DECODE)
EOT
    if ($ImmediateRelocations_MAXCOUNT < @relocations) {
        $ImmediateRelocations_MAXCOUNT = @relocations;
    }
}

print<<"EOT";
#endif/*Immediate*/
#undef Immediate\n
EOT

print<<"EOT";
#ifndef ImmediateRelocations_MAXCOUNT
#define ImmediateRelocations_MAXCOUNT $ImmediateRelocations_MAXCOUNT
#endif/*ImmediateRelocations_MAXCOUNT*/\n
EOT

# vim: set ts=4 sw=4 et:
