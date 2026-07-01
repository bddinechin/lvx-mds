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
use BitString;
use Behavior;
use integer;
&MDS::parse(*ARGV);

my $copyrights = &MDS::get_copyrights(" *  ","");

print<<"EOT";
/*
 * $FAMILY/Opcode.tuple
${copyrights}
 * Automatically generated from the Machine Description System (MDS).
 */

#ifndef Opcode
#define Opcode(ID, SCHEDULING, DECODING, CODEWORDS, OPERANDS, \\
               INCREMENT, MNEMONIC, SYNTAX, ACTIONARRAY)
#else /*Opcode*/
EOT

my %wordWidth;
foreach my $encoding (@Encoding::table) {
  my $encodingID = $encoding->attribute("ID");
  my $wordWidth = $encoding->attribute("wordWidth");
  $wordWidth{$encodingID} = $wordWidth;
}

# Map Opcode name to Operator.
my %operator;
foreach my $operator (@Operator::table) {
  my @origins = $operator->access("origins");
  my @opcodes = grep {$_->type() =~ /^(Opcode|Simulated)/} @origins;
  my @opcodeNames = map {$_->fullName('_')} @opcodes;
  foreach my $opcodeName (@opcodeNames) {
    $operator{$opcodeName} = $operator;
  }
}

foreach my $opcode (@Opcode::table) {
  my $ID = $opcode->fullName('_');
  #print STDERR "$ID\n";
  my $core = $opcode->core();
  my ($scheduling) = $opcode->access("scheduling");
  my $schedulingName = $core."_".$scheduling->name("_");
  my $SCHEDULING = "SCHEDULING($schedulingName)";
  my ($encoding) = $opcode->access("encoding");
  my ($decoding) = $opcode->access("decoding");
  my $decodingName = $decoding->fullName('_');
  my $DECODING = "DECODING($decodingName)";
  my $encoded = $opcode->attribute("encoded");
  my $bitString = BitString->new(0, $encoded);
  my $encodingID = $opcode->attribute("encoding");
  my @codeWords = $bitString->hex_value($wordWidth{$encodingID});
  my $codeWords = join ' ', map {"CODEWORD($_)"} @codeWords;
  my $CODEWORDS = "CODEWORDS(". @codeWords. ", $codeWords)";
  my @operands = $opcode->access("operands");
  my @operandNames = map {$_->fullName('_')} @operands;
  my $operands = "_UNDEF";
  if (@operands) {
    $operands = join '_', @operandNames;
  }
  my $OPERANDS = "OPERANDS($operands)";
  my $increment = $opcode->attribute("increment") || 0;
  my $INCREMENT = "INCREMENT($increment)";
  my $mnemonic = $opcode->attribute("mnemonic") || '';
  my $MNEMONIC = "MNEMONIC(\"$mnemonic\")";
  my $syntax = $opcode->attribute("syntax") || '';
  my $SYNTAX = "SYNTAX(\"$syntax\")";
  my $operator = $operator{$ID};
  warn "No Operator for Opcode $ID\n" unless $operator;
  my $ACTIONARRAY = &actionArray($operator, $opcode->core());
  print <<"EOT";
Opcode($ID, $SCHEDULING, $DECODING, $CODEWORDS, $OPERANDS, $INCREMENT, $MNEMONIC, $SYNTAX, $ACTIONARRAY)
EOT
}

foreach my $simulated (@Simulated::table) {
  my $ID = $simulated->fullName('_');
  my $core = $simulated->core();
  my ($scheduling) = $simulated->access("scheduling");
  my $schedulingName = $core."_".$scheduling->name("_");
  my $SCHEDULING = "SCHEDULING($schedulingName)";
  my $DECODING = "DECODING(_UNDEF)";
  my $CODEWORDS = "CODEWORDS(0,/**/)";
  my $OPERANDS = "OPERANDS(_UNDEF)";
  my $INCREMENT = "INCREMENT(0)";
  my $mnemonic = $simulated->attribute("mnemonic");
  my $MNEMONIC = "MNEMONIC(\"$mnemonic\")";
  my $syntax = $simulated->attribute("syntax");
  my $SYNTAX = "SYNTAX(\"$syntax\")";
  my $operator = $operator{$ID};
  warn "No Operator for Simulated $ID\n" unless $operator;
  my $ACTIONARRAY = &actionArray($operator, $simulated->core());
  print <<"EOT";
Opcode($ID, $SCHEDULING, $DECODING, $CODEWORDS, $OPERANDS, $INCREMENT, $MNEMONIC, $SYNTAX, $ACTIONARRAY)
EOT
}

print<<"EOT";
#endif/*Opcode*/
#undef Opcode\n
EOT

my %actionArray;
my @actionArrays;
my $opcodeActionIndex;
my $OpcodeAction_MAXCOUNT;
sub actionArray {
  $opcodeActionIndex += 0;
  $OpcodeAction_MAXCOUNT += 0;
  my ($object, $selectCore) = @_;
  my (@readActions, @writeActions);
  if ($object) {
    my ($argIndex, $resIndex) = (0, 0);
    my @parameters = $object->children("Parameter");
    foreach my $parameter (@parameters) {
      my $proxy = $parameter->attribute("proxy") || '';
      my ($rank) = ($proxy =~ /\%([1-9]\d*)/g, 0);
      my ($method) = $parameter->access("method");
      my $action = $parameter->attribute("action");
      my $xxxIndex = $action =~ /^Read/? $argIndex++: $resIndex++;
      if (defined $method && $method->type() =~ /^(Register|RegClass)/) {
        my ($regClass, $register, @registers);
        $regClass = $method if $1 eq 'RegClass';
        $register = $method if $1 eq 'Register';
        @registers = $method->access("registers") if $1 eq 'RegClass';
        $register = $registers[0] if @registers == 1;
        my $regClassName = $regClass && $regClass->name()? $regClass->fullName('_'): '_UNDEF';
        my $registerName = $register && $register->name()? $register->fullName('_'): '_UNDEF';
        my $stages = $parameter->attribute("stages");
        my @stages = split ' ', $stages if defined $stages;
        my @processors = $object->access("processors");
        while (@stages && @processors) {
          my $stage = shift @stages;
          my $processor = shift @processors;
          if ($processor->core() eq $selectCore) {
            my $actionItem = {
              REGISTER=>$registerName,
              REGCLASS=>$regClassName,
              XXXINDEX=>$xxxIndex,
              RANK=>$rank,
              STAGE=>$stage,
            };
            if ($action =~ /^Read/) {
              push @readActions, $actionItem;
            } elsif ($action =~ /^Write/) {
              push @writeActions, $actionItem;
            } else { die "Unknown action $action\n" }
          }
        }
      }
    }
  }
  my @readActionList = &makeActionList(\@readActions);
  my @writeActionList = &makeActionList(\@writeActions);
  my $indent = "\n                ";
  my $actionList = (join $indent, @readActionList, @writeActionList) || "/**/";
  unless (defined $actionArray{$actionList}) {
    $actionArray{$actionList} = [
        $opcodeActionIndex,
        $indent.$actionList,
    ];
    push @actionArrays, $actionArray{$actionList};
    my $opcodeActionsCount = @readActionList + @writeActionList;
    $opcodeActionIndex += $opcodeActionsCount;
    if ($OpcodeAction_MAXCOUNT < $opcodeActionsCount) {
      $OpcodeAction_MAXCOUNT = $opcodeActionsCount;
    }
  }
  my $readStart = grep {!$_->{RANK}} @readActions;
  my $writeStart = grep {!$_->{RANK}} @writeActions;
  my $actionsIndex = $actionArray{$actionList}->[0];
  return "ACTIONARRAY(READCOUNT(". @readActionList.
         "), READSTART($readStart".
         "), WRITECOUNT(". @writeActionList.
         "), WRITESTART($writeStart".
         "), ACTIONSINDEX($actionsIndex))";
}

sub makeActionList {
  my ($list) = @_;
  my %seen = ();
  grep { not $seen{$_}++ } map {
    my $registerName = $_->{REGISTER};
    my $regClassName = $_->{REGCLASS};
    my $xxxIndex = $_->{XXXINDEX};
    my $rank = $_->{RANK};
    my $stage = $_->{STAGE};
    "ACTION(REGISTER($registerName),REGCLASS($regClassName),".
    "XXXINDEX($xxxIndex),RANK($rank),STAGE($stage))";
  } sort {
    $a->{RANK} <=> $b->{RANK}
  }@{$list};
}

print<<"EOT";
#ifndef OpcodeActions
#define OpcodeActions(INDEX, ACTIONS)
#else /*OpcodeActions*/
EOT

foreach my $actionArray (@actionArrays) {
  my ($index, $actionList) = @{$actionArray};
  print<<"EOT";
OpcodeActions(ACTIONSINDEX($index),$actionList)
EOT
}

print<<"EOT";
#endif/*OpcodeActions*/
#undef OpcodeActions\n
EOT

print<<"EOT";
#ifndef OpcodeAction_MAXCOUNT
#define OpcodeAction_MAXCOUNT $OpcodeAction_MAXCOUNT
#endif/*OpcodeAction_MAXCOUNT*/\n
EOT

