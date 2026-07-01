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

use strict;

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
 * $FAMILY/NativeBlock.xcc
${copyrights}
 * Automatically generated from the Machine Description System (MDS).
 */

#include "MDT/MDT_.h"
#include "AIR/AIR_.h"

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

my %seen;
foreach my $opcode (@Opcode::table) {
  my @operands = $opcode->access("operands");
  my @operandNames = map {$_->name()} @operands;
  my $operands = "";
  if (@operands) {
    my $core = $operands[0]->core();
    $operands = join '_', ($core, @operandNames);
  }
  unless ($seen{$operands}++) {
    (my $NAME = $operands) =~ s/\W/_/g;
    my @arglist = ( "NativeBlock this", "Opcode opcode" );
    my @relocations = ( );
    my @decmove = ( );
    my $index = 0;
    my @methods = map {$_->access("method")} @operands;
    foreach my $method (@methods) {
      my $type = $method->type();
      my $actual = $operandNames[$index];
      if ($type eq 'RegClass') {
        push @arglist, "Register $actual";
        push @decmove, "decoded\[$index\] = (OperandDecoded)$actual";
      } elsif ($type eq 'Immediate') {
        push @arglist, "ImmediateValue $actual";
        push @decmove, "decoded\[$index\] = (OperandDecoded)$actual";
        push @relocations, @{$relocations{$method->attribute("ID")}{RELOCS}}
            if (defined $relocations{$method->attribute("ID")});
      } elsif ($type eq 'Modifier') {
        push @arglist, "ModifierMember $actual";
        push @decmove, "decoded\[$index\] = (OperandDecoded)$actual";
      } elsif ($type eq 'RegMask') {
        print STDERR "WARNING: RegMask not supported\n";
      }
      $index++;
    }
    my $ARGLIST = join ', ', @arglist;
    my $ARGMOVE = join ";\n  ", @decmove;
    print<<"EOT";
#ifdef \$XCC__h
extern Instruction
NativeBlock_makeInstruction_$NAME($ARGLIST);
#endif//\$XCC__h

Instruction
NativeBlock_makeInstruction_$NAME($ARGLIST)
{
  Memory memory = NativeBlock_MEMORY(this);
  Instruction instruction = Memory_alloc(memory, sizeof(Instruction_));
  OperandDecoded *decoded = OperandsBuffer_DECODED(Instruction_BUFFER(instruction));
  $ARGMOVE;
  Instruction_Ctor(instruction, opcode, NULL);
  InstructionStack_push2(NativeBlock_INSTRUCTIONS(this), instruction);
  return instruction;
}\n
EOT
  }
}

