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
 * $FAMILY/Operator.tuple
${copyrights}
 * Automatically generated from the Machine Description System (MDS).
 */

#ifndef Operator
#define Operator(ID, ATTRIBUTES, MODIFIED, OPCODES, MNEMONIC, SYNTAX, PARAMETERARRAY)
#else /*Operator*/
EOT

my %processorName;
my @processorNames;
foreach my $processor (@Processor::table) {
  my $core = $processor->core();
  push @processorNames, ($processorName{$core} = $processor->fullName('_'));
}

my $OperatorModify_MAXCOUNT = 0;
foreach my $operator (@Operator::table) {
  # ID
  my $name = $operator->name();
  my $ID = $operator->fullName('_');
  my $attributes = $operator->attribute("attributes") || '';
  my @origins = $operator->access("origins");
  $ID = '_'.$name if grep {$_->type() eq 'Generic'} @origins;
  $ID =~ s/\W/_/g;
  # ATTRIBUTES
#print STDERR "Properties($ID)\t$attributes\n" if $attributes;
  my @attributes = map {s/=//;$_} split ' ', $attributes if $attributes;
  my $attribute_list = @attributes? (join ' ', map {"ATTRIBUTE($_)"} @attributes): "/**/";
  my $ATTRIBUTES = "ATTRIBUTES(". scalar @attributes. ", $attribute_list)";
  # MODIFIED
  my @modifiers = $operator->access("modifiers");
  my @expanded = split ' ', ($operator->attribute("expanded") || '');
  my @members = split ' ', ($operator->attribute("members") || '');
  die "Mismatch of modifiers and expanded in $ID" unless @modifiers == @expanded;
  die "Mismatch of modifiers and members in $ID" unless @modifiers == @members;
  $OperatorModify_MAXCOUNT = scalar @modifiers if scalar @modifiers > $OperatorModify_MAXCOUNT;
  my @modified;
  while (@modifiers) {
    my $modifier = shift @modifiers;
    my $proxy = shift @expanded;
    my $member = shift @members;
    my $name = $member;
    $name =~ s/\W/_/g;
    $name =~ s/^_//;
    push @modified, "MODIFY(RANK(". substr($proxy, 1). "), ". $modifier->fullName('_'). "_$name)";
  }
  my $modified = @modified? (join ' ', @modified): "/**/";
  my $MODIFIED = "MODIFIED(". (scalar @modified). ", $modified)";
  # OPCODES
  my @opcodes = grep {$_->type() =~ /^(Opcode|Simulated)/} @origins;
  my %opcode; map { $opcode{$_} = "PROCESSOR($_),_UNDEF" } @processorNames;
  map {
    my $core = $_->core();
    my $processorName = $processorName{$core};
    my $opcodeName = $_->fullName('_');
    $opcode{$processorName} = "PROCESSOR($processorName),$opcodeName";
  } @opcodes;
  my @opcodeNames = map {"OPCODE($opcode{$_})"} @processorNames;
  my $OPCODES = "OPCODES(". (join ' ', @opcodeNames).  ")";
  # MNEMONIC
  my $mnemonic = $operator->attribute("mnemonic");
  my $MNEMONIC = "MNEMONIC(\"$mnemonic\")";
  # SYNTAX
  my $syntax = $operator->attribute("syntax");
  my $SYNTAX = "SYNTAX(\"$syntax\")";
  # PARAMETERARRAY
  my $PARAMETERARRAY = &parameterArray($operator);
  print<<"EOT";
Operator($ID, $ATTRIBUTES, $MODIFIED,
         $OPCODES,
         $MNEMONIC, $SYNTAX, $PARAMETERARRAY)
EOT
}

print<<"EOT";
#endif/*Operator*/
#undef Operator\n
EOT

print<<"EOT";
#ifndef OperatorModify_MAXCOUNT
#define OperatorModify_MAXCOUNT $OperatorModify_MAXCOUNT
#endif/*OperatorModify_MAXCOUNT*/\n
EOT

my %parameterArray;
my @parameterArrays;
my $operatorParameterIndex;
my $OperatorParameterArray_MAXCOUNT;
sub parameterArray {
  my ($operator) = @_;
  $operatorParameterIndex += 0;
  $OperatorParameterArray_MAXCOUNT += 0;
  my $immediateCount = 0;
  my @parameters = $operator->children("Parameter");
  my (@readParameters, @writeParameters);
  foreach my $parameter (@parameters) {
    my @usage = split ' ', ($parameter->attribute("usage") || '');
    my $proxy = $parameter->attribute("proxy") || '';
    my ($rank) = ($proxy =~ /\%([1-9]\d*)/g, 0);
    my ($method) = $parameter->access("method");
    my $methodName = defined $method->name()?
                     $method->type(). ",". $method->fullName('_'):
                     $method->type(). ",_UNDEF";
    $immediateCount++ if $method->type() eq 'Immediate';
    my $action = $parameter->attribute("action");
    my $kind = join '', ($action, @usage);
    my $parameterItem = {
      KIND=>$kind,
      RANK=>$rank,
      METHOD=>$methodName,
      PROXY=>$parameter->attribute("proxy"),
    };
    if ($action =~ /^Read/) {
      push @readParameters, $parameterItem;
    } elsif ($action =~ /^Write/) {
      push @writeParameters, $parameterItem;
    } else { die "Unknown action $action\n" }
  }
  my $readProxyIndex = &proxyIndex(\@readParameters);
  my $writeProxyIndex = &proxyIndex(\@writeParameters);
  #map {
    #my $proxy = $_->{PROXY};
    #my $writeIndex = $$writeProxyIndex{$proxy} if defined $proxy;
    #$_->{SAME} = $writeIndex + 0 if defined $writeIndex;
  #} @readParameters;
  map {
    my $proxy = $_->{PROXY};
    my $readIndex = $$readProxyIndex{$proxy} if defined $proxy;
    $_->{SAME} = $readIndex + @writeParameters if defined $readIndex;
  } @writeParameters;
  my $indent = "\n                   ";
  my $parameterList = (join $indent, map {
    my $kind = $_->{KIND};
    my $rank = $_->{RANK};
    my $method = $_->{METHOD};
    my $same = $_->{SAME} || -1;
    my $proxy = $_->{PROXY};
    join $indent, "PARAMETER(KIND($kind),RANK($rank),METHOD($method),SAME($same))";
  } @writeParameters, @readParameters) || "/**/";
  unless (defined $parameterArray{$parameterList}) {
    $parameterArray{$parameterList} = [ $operatorParameterIndex, $indent.$parameterList ];
    push @parameterArrays, $parameterArray{$parameterList};
    my $operatorParameterCount = @readParameters + @writeParameters;
    $operatorParameterIndex += $operatorParameterCount;
    if ($OperatorParameterArray_MAXCOUNT < $operatorParameterCount) {
      $OperatorParameterArray_MAXCOUNT = $operatorParameterCount;
    }
  }
  my $parametersIndex = $parameterArray{$parameterList}->[0];
  return "PARAMETERARRAY(".
         "WRITECOUNT(". @writeParameters. "), ".
         "READCOUNT(". @readParameters. "), ".
         "PARAMETERSINDEX($parametersIndex))";
}

sub proxyIndex {
  my ($parameters) = @_;
  my $index = 0;
  my %proxyIndex;
  map {
    my $proxy = $_->{PROXY};
    my $kind = $_->{KIND};
    $proxyIndex{$proxy} = $index if defined $proxy;# && $kind !~ /Partial/;
    ++$index;
  } @{$parameters};
  return \%proxyIndex;
}

print<<"EOT";
#ifndef OperatorParameters
#define OperatorParameters(INDEX, PARAMETERS)
#else /*OperatorParameters*/
EOT

foreach my $parameterArray (@parameterArrays) {
  my ($index, $parameterList) = @{$parameterArray};
  print<<"EOT";
OperatorParameters(PARAMETERSINDEX($index),$parameterList)
EOT
}

print<<"EOT";
#endif/*OperatorParameters*/
#undef OperatorParameters\n
EOT

print<<"EOT";
#ifndef OperatorParameterArray_MAXCOUNT
#define OperatorParameterArray_MAXCOUNT $OperatorParameterArray_MAXCOUNT
#endif/*OperatorParameterArray_MAXCOUNT*/\n
EOT

