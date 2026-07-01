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
use integer;
&MDS::parse(*ARGV);

my $copyrights = &MDS::get_copyrights(" *  ","");

print<<"EOT";
/*
 * $FAMILY/Operand.tuple
${copyrights}
 * Automatically generated from the Machine Description System (MDS).
 */

#ifndef Operand
#define Operand(ID, METHOD, WORDTYPE, ENCODE, DECODE)
#else /*Operand*/
EOT

my %encoding;
foreach my $opcode (@Opcode::table) {
    my $encodingID = $opcode->attribute("encoding");
    my @operandIDs = split ' ', ($opcode->attribute("operands") || ' ');
    map { $encoding{$_}{$encodingID} = 1 } @operandIDs;
}

my %wordWidth;
foreach my $operand (@Operand::table) {
    my $operandID = $operand->attribute("ID");
    foreach $encodingID (keys %{$encoding{$operandID}}) {
        my $encoding = &MDS::fetch($encodingID);
        my $wordWidth = $encoding->attribute("wordWidth");
        if (defined $wordWidth{$operandID}) {
            die "inconsistent Encoding\@wordWidth ($wordWidth{$operandID}!= $wordWidth) for $operandID"
              unless $wordWidth{$operandID} == $wordWidth;
        } else {
            $wordWidth{$operandID} = $wordWidth;
        }
    }
    unless (defined $wordWidth{$operandID}) {
        warn "no Encoding for $operandID";
        $wordWidth{$operandID} = 32; # FIXME! Should be 0.
    }
}

my %encode;
my %decode;
my %wordType;
foreach my $operand (@Operand::table) {
    my $operandID = $operand->attribute("ID");
    my @fields = $operand->access("fields");
    my $ID = $operand->fullName('_');
    my ($method) = $operand->access("method");
    my ($methodType, $methodName) = ($method->type(), $method->fullName('_'));
    my $METHOD = "METHOD($methodType,$methodName)";
    my $wordWidth = $wordWidth{$operandID};
    next unless $wordWidth;
    my $wordType = "uint${wordWidth}_t";
    my $WORDTYPE = "WORDTYPE($wordType)";
    my (@encode, @decode);
    while (@fields) {
        my $field = pop @fields;
        my $width = $field->attribute("width");
        my $offset = $field->attribute("offset");
        my $index = $offset/$wordWidth;
        my $shift = $offset%$wordWidth;
        my $mask = $width >= $wordWidth?
          "(($wordType)0-1)":
          "((($wordType)1<<$width)-1)";
        push @encode,
          "WORDS\[$index\] &= ~($mask<<$shift)",
          "WORDS\[$index\] |= (VALUE&$mask)<<$shift",
          "VALUE >>= $width";
        unshift @decode,
          "VALUE <<= $width",
          "VALUE |= (WORDS\[$index\]>>$shift)&$mask";
    }
    die "extra fields in $operandID" if @fields;
    pop @encode;		# Remove the last "VALUE >>= $width".
    shift @decode;	# Remove the first "VALUE <<= $width".
    $encode{$operandID} = [ @encode ];
    $decode{$operandID} = [ @decode ];
    $wordType{$operandID} = $wordType;
    #@encode = () unless $methodType eq 'Immediate';
    #@decode = () unless $methodType eq 'Immediate';
    my $ENCODE = "ENCODE(". (@encode? (join '; ', @encode): "/**/"). ")";
    my $DECODE = "DECODE(". (@decode? (join '; ', @decode): "/**/"). ")";
    print <<"EOT";
Operand($ID, $METHOD, $WORDTYPE,
        $ENCODE,
        $DECODE)
EOT
}

print<<"EOT";
#endif/*Operand*/
#undef Operand\n
EOT

print<<"EOT";
#ifndef Operands
#define Operands(ID, OPERANDS, RELOCATABLE, ENCODE, DECODE)
#else /*Operands*/
EOT

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

my %operands;
my $Operands_MAXCOUNT = 0;
foreach my $opcode (@Opcode::table) {
    my $opcodeID = $opcode->attribute("ID");
    my @operands = $opcode->access("operands");
    next unless @operands;
    my $ID = join '_', (map {$_->fullName("_")} @operands);
    my @operandNames;
    foreach my $operand (@operands) {
        my $operandName = $operand->fullName('_');
        push @operandNames, "OPERAND($operandName)"
    }
    my $operandNames = join ' ', @operandNames;
    my $OPERANDS = "OPERANDS(". @operandNames. ", $operandNames)";
    my ($relocatableRank, $relocatableOperand, $relocatableImmediate);
    my ($rank, $relocatable) = (1, 0);
    foreach my $operand (@operands) {
        my ($method) = $operand->access("method");
        if (ref $method eq 'Immediate' &&
            defined $relocations{$method->attribute("ID")}) {
            $relocatableRank = "RANK($rank)";
            $relocatableOperand = "OPERAND(". $operand->fullName('_'). ")";
            $relocatableImmediate = "IMMEDIATE(". $method->fullName('_'). ")";
            $relocatable++;
        }
        $rank++;
    }
    ($relocatableRank, $relocatableOperand, $relocatableImmediate) =
      ("RANK(0)", "OPERAND(_UNDEF)", "IMMEDIATE(_UNDEF)") if $relocatable != 1;
    my $RELOCATABLE =
"RELOCATABLE($relocatableRank, $relocatableOperand, $relocatableImmediate)";
    my (@wordTypes, @encode, @decode, $operandIndex);
    $operandIndex = 0;
    foreach my $operand (@operands) {
        my $operandID = $operand->attribute("ID");
        my $wordType = $wordType{$operandID};
        push @wordTypes, $wordType;
        my ($method) = $operand->access("method");
        my ($methodType, $methodName) = ($method->type(), $method->fullName('_'));
        push @encode,
          "{ OperandDecoded __decoded = decoded\[$operandIndex\]",
"OperandEncoded VALUE = ${methodType}_Encode_${methodName}(__decoded)",
          grep {!/\&\=/} @{$encode{$operandID}}, " }";
        push @decode,
          "{ OperandEncoded VALUE = 0", @{$decode{$operandID}},
"OperandsBuffer_DECODED(buffer)[$operandIndex] = ${methodType}_Decode_${methodName}(VALUE)", " }";
        $operandIndex++;
    }
    my %wordType; map {$wordType{$_}=1} @wordTypes;
    my ($wordType) = keys %wordType;
    die "inconsistent WORDTYPEs" if (scalar keys %wordType) > 1;
    unshift @encode,
      "$wordType *restrict WORDS = codeWords";
    unshift @decode,
      "const $wordType *restrict WORDS = codeWords";
    my $ENCODE = "ENCODE(". (@encode? (join '; ', @encode): "/**/"). ")";
    my $DECODE = "DECODE(". (@decode? (join '; ', @decode): "/**/"). ")";
    print <<"EOT" unless $operands{$ID}++;
Operands($ID, $OPERANDS, $RELOCATABLE,
         $ENCODE,
         $DECODE)
EOT
    my ($behavior) = $opcode->children('Behavior');
    my $proxies = $behavior->attribute("proxies");
    my @proxies = split ' ', $proxies;
    my @splits = grep {/\%\d+:\d+/} @proxies;
    my $maxcount = (scalar @operands) + (scalar @splits);
    if ($Operands_MAXCOUNT < $maxcount) {
        $Operands_MAXCOUNT = $maxcount;
    }
}

print<<"EOT";
#endif/*Operands*/
#undef Operands\n
EOT

print<<"EOT";
#ifndef Operands_MAXCOUNT
#define Operands_MAXCOUNT $Operands_MAXCOUNT
#endif/*Operands_MAXCOUNT*/\n
EOT

# vim: set ts=4 sw=4 et:
