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

# This package contains target-specific subroutines.

# Issues:
#  1.  The subroutine makeTargetISAProperties
#      synthesizes ISA properties in a target-specific
#      way, but all these properties ought to be
#      derived in a target-independent way.  But none
#      of this information is available yet in MDS.
#  2.  The same is true for makeTargetOperandProperties,
#      which synthesizes operand properties in a
#      target-specific way.
#      Operand usage information is now appearing in
#      MDS, but treat it with care, it has some
#      problems:
#        - Condition is missing
#        - offset and base for cache ops is missing
#        - left and right only appears for shl and sub,
#        - and the usage for sub is reversed compared to
#          what open64 wants
package Target;

my $Family = $ENV{FAMILY};
my $family = lc $Family;

use strict;
use Carp;

sub getCopyright {
  my $txt = <<'EOT';
/*
 *      Copyright 2010, Kalray.
 *      All rights reserved.
 *
 * Kalray, INCORPORATED PROPRIETARY INFORMATION
 * This software is supplied under the terms of a license agreement
 * or nondisclosure agreement with Kalray and may not be
 * copied or disclosed except in accordance with the terms of that
 * agreement.
 */

#ifndef __K1IO__
#define __builtin_k1_hfx(arg1,arg2,arg3,arg4) {				\
    switch(arg1) {							\
    case 0: __builtin_k1_hfxb(arg2,((int)(arg3)<<16) | ((int)(arg4)&0xffff)); break; \
    case 1: __builtin_k1_hfxt(arg2,((int)(arg3)<<16) | ((int)(arg4)&0xffff)); break; \
    default:								\
      while(1) {}                                                       \
    }									\
  }
#endif /* ! __K1IO__ */

EOT
  return $txt;
}

# Return convention name
sub getConventionName {
    my ($convention,$Family) = @_;
    my $name = $convention->attribute("ID");
    $name =~ /Convention\-(\w+)\-(.*)/;
    if(lc($1) eq lc($Family)) {
	$name = "$2";
    }
    else {
	$name = "${1}_${2}";
    }
    return $name;
}

# Returns true if have to generate builtins from Builtin table.
sub newIntrinsicGen {
    return 1;
}

# Returns RegisterClass renaming
sub get_register_class {
    my ($name) = @_;
    return "integer" if $name eq "singlereg";
    return $name;
}

# Called from O64.pm
sub do_not_append_parameter_types {
  my (@origins) = @_;

  return grep {/^(Generic|Simulated)/} @origins;
}

# Called by isa_operands.pl
# If return true, print TOP syntax as comment
sub isa_operand_syntax_in_comment {
  return 0;
}

# Called by isa_operands.pl
# If return true, print MDS Operator ID as comment
sub isa_operand_mds_operator_in_comment {
  return 0;
}

# Get corresponding slot numbers for given 
# Dispersal when is multi slots/bitfields.
sub getSlots {
  my ($dispersal) = @_;

  # Hack: compute slots using ENCODE.[0-3] 'toFields' names.
  my @toFields = $dispersal->access("toFields");
  my $lowest = 3;
  my @slots;
  foreach my $field (@toFields) {
    $field->name() =~ /ENCODE.([0-9]{1})$/;
    push @slots,$1;
  }
  return @slots;
}

# Target specific function that fixes the output syntax given as input.
# typically lowcase some strings.
sub fixSyntax {
    my $s = shift;
    return $s;
}

#
# Get Bundle Template Name
sub GenBundleTemplateName {
    my $id = shift;
    my $count = shift;
    $id = "Template_$count";
    return $id;
}


#
# returns whether current resource given as a parameter is used
# by core given as parameter
sub ResourceDefinedForProcessor {
    my $resource = shift;
    my $core = shift;
    my @processors = split(' ',$resource->attribute("processors"));
    if ( grep  {/$core/} @processors) {
	return 1
    }
    return 0;
}

#
# Evaluate effective availibility of a resource for a processor.
# in case of processor variants (with similar subset), it may have some 
# variations like xp70_v4_single/xp70_v4_dual/xp70_v4_dual_arith
sub getEffectiveAvailabilityForProc {
    my $core = shift;
    my $resourcename = shift;
    my $available = shift;

    return "$available";
}


# build target specific variants (empty if unused).
sub makeSpecificVariants {
  my ($variant_map) = @_;
}

## Force target specific properties
sub addRequiredProperties {
    my $open64_properties = shift;
#    $$open64_properties{"shlu"} = [];
}

# Indicates if parameter same_res should be only one parameter in macros and
# repeated on builtin/cmodel calls.
sub doNotSplitInOutParameterInMacros {
  return 0;
}

# =================================
# Begin of isa_selector generation
#
# isa_selector is used to help code
# selection when the compiler have
# to select multiple tops (for the
# same target operation) depending
# on the activated isa_subset.
# Ex:
# TOP_add_r is a target operator
# mapped on TOP_v3_add_r when subset
# v3 is selected or TOP_v4_add_r
# when subset v4 is selected.
# So the target operator must not
# have same name as TOPs and must
# be unique.
# =================================

# This routine activate isa_selector generation
sub genSelector {
  return 0;
}

# This routine must return a common operator usable for
# isa_selector.
sub getSelectorOperator {
    my @operators = @_;
    return $operators[0];
}
# This routine must return a common operator name usable for
# isa_selector.
sub getSelectorOperatorName {
    my $operator = getSelectorOperator(@_);
    return $operator->{O64}{NAME};
}

# This routine must help to choose compatible
# instruction groups.
# The routine must return a ref on hash that
# specify things to ignore.
# MDS operators fields that can be ignored are:
# - syntax -> spaces
# - Parameter -> stages
# - Parameter -> Immediate
# - Parameter -> RegFile
# - Parameter -> RegClass
# - Parameter -> action
# - Parameter -> O64 -> PROPERTIES
my %ignores;
sub getSelectorIgnores {

  return \%ignores;
}

# =================================
# End of isa_selector generation
# =================================

# Specific to st200
sub isExtended {
  my $opcode = shift;
  my $formatID = $opcode->attribute("format");
  return $formatID =~ /.*X/;
}

# Allow operand width to be the width of the register, for
# a register operand.
sub useDynamicOperandWidth {
    return 1;
}

# Remove common operand suffixes when choosing TOP names.
sub pruneInstructionOperandSuffixes {
    return 1;
}

# Generic operator target dependent filter
sub usefulGeneric {
  my $mnemonic = shift;
  my %target_gen_op = (
		       DUMMY_MULTI => 1,
		       HWBRANCH => 1,
		       COMPOSE => 1,
		       EXTRACT => 1,
		       WIDEMOVE => 1,
		      );
  return $target_gen_op{$mnemonic};
}

# Return the list of intrinsic classes by defining their names
# and preprocessor flags.
sub getIntrinsicsClasses {
  my %k1 = ( name => "K1",
	     flag => "__K1__",
	   );
  my @classes = ( \%k1,
		);

  return \@classes;
}

# Return true if C models have been written by hand for the given
# class 'class_name'
sub c_model_defined_for_class {
  my ($class_name) = @_;

  return 0;
}

# Return true if operator is of class 'class_name'
sub genIntrnMacro {
  my $operator = shift;
  my $class_name = shift;

  return 1;
}

# Return macro name for each operator of class 'class_name'
sub getBuiltinsHeaderMacroName {
  my $operator = shift;
  my $class_name = shift;
  my $enum0 = shift;
  my $enum1 = shift;

  $enum0 = "" if not defined $enum0;
  $enum1 = "" if not defined $enum1;

  $enum0 =~ s|.*_(.*)|_$1|;
  $enum1 =~ s|.*_(.*)|_$1|;

  my $op_name = $operator->{O64}{NAME};

  $op_name =~ s|TOP_||;
  $op_name = lc($class_name)."_".$op_name.$enum0.$enum1;
  return $op_name;
}

# return whether parameter given as input is a boolean.
sub param_is_boolean {
    my $parameter = shift;
    my $method = $parameter->attribute("method");
    return 0;
}

# return an hash table with entry 'code' 
# and 'message' to use in Is_True compiler assertion.
sub getConditionForIntrinsic {
 my $operator = shift;

 return undef;
}

# Must return hash for possible type corresponding to method (reg class)
sub get_possible_types_for_reg_class {
  my $operator = shift;
  my $method = shift;
  my $parameter = shift;

  my $mnemonic = $operator->attribute("mnemonic");

  my $i4 = ($operator->{O64}{PROPERTIES} =~ /flop/) ? "IRETURN_F4" : 
      (($operator->{O64}{PROPERTIES} =~ /unsign/) ? "IRETURN_U4" : "IRETURN_I4");

  if($operator->attribute("mnemonic") =~ /comp/ and
     $parameter->attribute("action") eq "Write") {
      $i4 = "IRETURN_I4";
  }

  my $i8 = ($operator->{O64}{PROPERTIES} =~ /flop/) ? "IRETURN_F8" : 
      (($operator->{O64}{PROPERTIES} =~ /unsign/) ? "IRETURN_U8" : "IRETURN_I8");

  if($mnemonic =~ /^fixed/ and
     $method =~ /singleReg$/ and
     $parameter->attribute("action") eq "Read") {
      if($mnemonic eq "fixedd" or
	 $mnemonic eq "fixedud" ) {
	  return "IRETURN_F8";
      }
      else {
	  return "IRETURN_F4";
      }
  }

  if($mnemonic =~ /^float/ and
     $method =~ /singleReg$/ and
     $parameter->attribute("action") eq "Write") {
      if($mnemonic eq "floatd" or
	 $mnemonic eq "floatud") {
	  return "IRETURN_F8";
      }
      else {
	  return "IRETURN_F4";
      }
  }

  if ($method =~ /singleReg$/) {
      return $i4;
  }
  elsif ($method =~ /remoteReg$/) {
      return $i4;
  } elsif ($method =~ /pairedReg$/) {
      return $i8;
  } elsif ($method =~ /(systemReg|nopcpsReg|onlypsReg|onlyfxReg)$/) {
      return $i4;
  } else {
      die "get_possible_types_for_reg_class ", $operator->attribute("ID"),
      ": ",$method;
  }

  return undef;
}

# Map from mnemonic to intrinsic name.
my %intrinsics_map = (
);

# by default specifying builtin with name "__builtin_BBBB" defines 2 builtins
# in the frontend "__builtin_BBBB" and "BBBB".
# To avoid the second definition the above function should return 1.
sub builtin_has_single_definition {
    return 1;
}

# return whether a compatility include file should included in
# generated builtins include files of $class_name.
#
sub addBuiltinsCompatibilityLayer {
    my $class_name = shift;
    return 0;
}

# table that associates an operator (selected as representative for
# an operator group) to the list of subsets for which it is the representative.
# examples:
# $builtinProcs{TOP_add_r} = "k1dp k1io"

sub builtin_procs_ifdef {
    my $operator = shift;
    my @processors = $operator->access("processors");

    my @defines;
    map {
	my $proc = $_->attribute("ID");
	$proc =~ /Processor-([a-zA-Z0-9]+)-.+/;
	push @defines, "defined(__".uc($1)."__)"; 
    } @processors;
    
    if(@defines) {
	my $defines = "#if ".join(" || ",@defines);
	return $defines;
    }

    return undef;
}

# Called from Intrinsic.pm
# Return 1 to generate intrinsic for operator, else 0.
sub generate_intrinsic {
  my $operator = shift;
  my ($opcode) = $operator->access("origins");
  return 0 if($operator->name() =~ /HFX/);
  return 0 if($operator->attribute("mnemonic") eq "set");
  return 0 if($operator->name() =~ /^MULTI_/);
  return 0 if(not (defined $operator->attribute("origins") and 
		   $operator->attribute("origins") =~ /^Opcode/));
  return 0 if(defined $operator->attribute("modifiers"));
  my $instruction = &MDS::fetch($opcode->attribute("instruction"));
  return 1 if(defined $instruction->attribute("properties") and
	      $instruction->attribute("properties") =~ /intrinsic/ and
	      $instruction->attribute("properties") !~ /notimplemented/);
  print STDERR "Do not generate intrinsic for: ".$operator->name().", opcode: ".$opcode->attribute("ID")." (".$instruction->attribute("properties").")\n";
  return 0;

}

# Called from Intrinsics.pm to know if must generate
# intrinsic for operator that has immediate operand(s)
sub genIntrnWithImmediateOpnd {
  my $operator = shift;

  my @parameters = $operator->children("Parameter");
  my @methods = grep {defined $_} map {$_->access("method")} @parameters;

  my %methods = (
      signed32=>1,
# Do not generate intrinsic for 64 bits. Have to split immediates in lowering.
#      signed32M=>1,
      unsigned32L=>1,
      unsigned32=>1,
      sysnumber=>1,
      signed10=>1,
      signed16=>1,
      unsigned5=>1,
      unsigned6=>1,
      );

  my $allowed_methods = 1;
  foreach my $method (@methods) {
      if($method =~ /^Immediate/ and not defined $methods{$method->name()}) {
	  $allowed_methods = 0;
      }
  }

  my ($opcode) = $operator->access("origins");
  my $instruction = &MDS::fetch($opcode->attribute("instruction"));
  return 1 if(defined $instruction->attribute("properties") and
	      $instruction->attribute("properties") =~ /side_effects/);
  print STDERR "Do not generate intrinsic ".$operator->name()." due to immediate parameter\n"
      if(not $allowed_methods);
  return $allowed_methods;
}

# Called from Intrinsics.pm to get immediate name of
# the form [us][0-9]+
sub getSimplifiedImmediate {
  my $immediate = shift;

  my $imm_name;
  if($immediate->attribute("extend") eq "Signed") {
      $imm_name = "s";
  }
  else {
      $imm_name = "u";
  }

  $imm_name .= $immediate->attribute("width");
  return $imm_name;
}

# Called from Intrinsics.pm to allow target to override
# default intrinsic naming scheme.
# Return undef to use default naming scheme for operator.
sub intrinsicName {
    my $operator = shift;

    my $intrn_name = $operator->{O64}{NAME};
    $intrn_name =~ s|TOP_||;

    $intrn_name =~ s/k1dp_//;
    $intrn_name =~ s/set_ps/set/;
    $intrn_name =~ s/get_ps/get/;
    $intrn_name =~ s/ldc_s32/ldc_s32_p/;
    $intrn_name =~ s/ldu_s10/ldu_s10_p/;
    $intrn_name =~ s/ldd_s10/ldd_s10_p/;

    $intrn_name = $family."_".$intrn_name;
    return $intrn_name;
}

#
# Can the enum parameter be reprensented by an integer in the builtin ?
#
sub isBuiltinEnumNumerical {
    return 0;
}

#
# Some instructions (multiplications under xp70) require a specific relocation that is specified here.
#
sub ExtensionRelocation {
    return undef;
}

###
# subset specifications for target.
#  void ISA_Binutils_Create(ISA_SUBSET subset,
#		             const char *abstract,
#			     const char *short_abstract,
#			     mUINT32 magic_key,
#			       INT   last_scratch,
#                           mUINT32 emul_byte_nr,
#                           mUINT32 DWARF_reg_nr,
#                           mUINT32 xversion,
#                           ... );
#      Create a binary utility type for <subset> by setting the 
#      following attributes:
#        - abstract:       string summarizing the subset features
#                          (long version).
#        - short_abstract: string summarizing the subset features 
#                          (short version).
#        - magic_key:      unique identifier of subset (0 means generic).
#        - last_scratch:   last register assumed as scratch by ABI. -1 for
#                          all register scratch (default).
#        - emul_byte_nr:   number of bytes reserved for emulation purposes
#                          at stack section end.
#        - DWARF_reg_nr:   number of DWARF registers defined by extension.
#        - xversion:       CORXpert version used for extension building (0
#                          when CORXpert not used).
#        - ...             list of couples of [port number, extension name]
#                          (port numbers are 0 to 7 for extensions, and 8 
#                           for core). [-1, NULL] is the ending couple.
#
sub printIsaBinutilsSubSetInfo {
    my $file = shift;
    print $file <<'EOT';
 ISA_Binutils_Create(ISA_SUBSET_k1dp,
                      "K1DP core",
                      "K1DP core",
                      0,
                      0,
                      0,
                      0,
                      0,
                      -1, NULL
                      );

 ISA_Binutils_Create(ISA_SUBSET_k1io,
                      "K1IO core",
                      "K1IO core",
                      0,
                      0,
                      0,
                      0,
                      0,
                      -1, NULL
                      );
EOT
}

# Called from isa_lits.pl to allow the target to override the extend
# property of a literal, in the case that the assembly language is more
# permissive than the architecture.
# Return undef if no override required.
sub Asm_Literal_Range {
    my $lit = shift;

    my $width = $lit->attribute("width");
    my $extend = $lit->attribute("extend");

    if ($width eq 32) {
	return ("Wrap", 32);
    }

    return undef;
}

# Called from Intrinsics.pm to use immediate value intrinsic operand
# as register index to specify a dedicated register.
# It returns true if given register class must be considered to contain
# only dedicated registers.
# This routine is called only if Intrinsics.pm cannot know if reg class
# is not fully unallocatable. This is done by scanning convention table.
sub isDedicatedRegisterClass {
  my $regclass = shift;

  return 0;
}

## empty contents for st200
sub get_top_name_for_builtin {
    return undef;
}

sub prepareIntrinsics {
}


# Called from Instrinsice.pm to know if intrinsic has side effects
sub builtinHasSideEffects {
  my $operator = shift;
  return 1 if($operator->{O64}{PROPERTIES} =~ /(barrier|side_effects)/);
  my ($origin) = $operator->access("origins");
  if($origin->attribute("ID") =~ /^Opcode/) {
      my ($instruction) = $origin->access("instruction");
      my $properties = $instruction->attribute("properties");
      return 1 if($properties =~ /store/);
  }
  return 1 if($operator->name() =~ /remote/);
  return 0;
}

# Called from isa_register.pl to generate isa_register.cxx targinfo.
sub synthesizeIsPtr {
    my $rc = shift;

    return ($rc->{O64}{NAME} eq "ISA_REGISTER_CLASS_integer") ? "true" : "false";
}

sub synthesizeCanStore {
    my $rc = shift;

    return "true";
}

sub synthesizeMultipleSave {
    my $rc = shift;

    return "false";
}

# Called from O64 module to generate O64 instruction names.
# This suffix instruction mnemonic with its register operands.
sub instructionRegisterSuffix {
  my $suffix = '_UNDEF_';
  my ($method,$proxy,$opcode) = @_;
	my @operands = $opcode->access("operands");
  my $methodID = $method->attribute("ID");
  if ($methodID =~ /(systemReg|nopcpsReg|onlyfxReg)$/) {
      $suffix = "";
  } elsif ($methodID =~ /(onlypsReg)$/) {
      $suffix = "ps";
  } elsif ($methodID =~ /(onlyraReg)$/) {
      $suffix = "ra";
  } elsif ($proxy =~ /(\d+)/) {
      my $operand = $operands[$1-1];
      $suffix = $operand->attribute("shortName");
  }
  my ($format) = $opcode->access("format");
  my $syntax=$format->attribute("syntax");
  if($syntax =~ /$proxy\s*:\s*\%([0-9]+)/) {
      my $operand = $operands[$1-1];
      my ($method) = $operand->access("method");
      confess "Not RegClass method: ".$method->attribute("ID") if(ref $method !~ /RegClass/);
      $suffix = "D";
  }
  if($syntax =~ /\%([0-9]+)\s*:\s*$proxy/) {
      $suffix = "";
  }
  return $suffix;
}

# Called from O64 module to generate O64 instruction names.
# This prefix instruction mnemonic with its enum (Modifier) operands.
sub instructionModifierSuffix {
  my ($modifier,$proxy,$opcode) = @_;
  my $name = lc($modifier->name());
  if($name eq "bytea") {
      $name = "";
  }
  return $name;
}

# Called from O64 module to generate O64 instruction names.
# This prefix instruction mnemonic with its immediate operands in case of RegMask.
sub instructionRegMaskSuffix {
  my ($regmask,$proxy,$opcode) = @_;
  die "Should not get regmask";
  return lc($regmask->name());
}

# Called from O64 module to generate O64 instruction names.
# This suffix instruction mnemonic with its immediate operands.
sub instructionImmediateSuffix {
  my ($immediate,$proxy,$opcode) = @_;
  my $width = $immediate->attribute("width");
  my $suffix;
  my ($format) = $opcode->access("format");
  my $syntax=$format->attribute("syntax");

  if($immediate->attribute("extend") eq "Signed") {
      $suffix = "s";
  }
  else {
      $suffix = "u";
  }
  $suffix .= "$width";
  
  if($syntax =~ /$proxy\s*:\s*\%([0-9]+)/) {
      my @operands = $opcode->access("operands");
      my $operand = $operands[$1-1];
      my ($method) = $operand->access("method");
      confess "Not Immediate method: ".$method->attribute("ID")
	  if(ref $method !~ /Immediate/);
      $width += $method->attribute("width");
      if($method->attribute("extend") eq "Signed") {
	  $suffix = "s";
      }
      else {
	  $suffix = "u";
      }
      $suffix .= "$width";
  }
  if($syntax =~ /\%([0-9]+)\s*:\s*$proxy/) {
      $suffix = "";
  }

  return $suffix;
}

# Called from O64 module to generate O64 instruction names.
# This suffix instruction mnemonic operands using syntaxic information.
sub instructionSyntaxicSuffix {
  my $sy_item = shift;

  if($sy_item =~ /\.[0-9a-zA-Z\.]+\b/) {
      $sy_item =~ s/\.//g;
      return $sy_item;
  }
  return "";
}

# Called from O64 module to generate O64 instruction names.
# This prefix O64 TOP mnemonic.
sub instructionMnemonicPrefix {
  my $operator = shift;
  my ($origin) = $operator->access("origins");
  my $prefix = "";

  if($origin->attribute("ID") =~ /^Opcode/) {
      my @operands = $origin->access("operands");
      foreach my $operand (@operands) {
	  if($operand->attribute("method") =~ /remoteReg$/) {
	      $prefix = "r_" . $prefix;
	  }
      }
      my ($encoding) = $origin->access("encoding");
      $prefix = $encoding->name() . "_" . $prefix;
  }

  return $prefix;
}


# Called from O64 module to generate O64 instruction names.
# This suffix O64 TOP mnemonic.
sub instructionMnemonicSuffix {
  my $sy_item = shift;
  my $operator = shift;

  return "";
}

# Called from O64 module to prune Immediate names.
sub makeImmediateName {
  my ($name) = @_;
  return $name;
}

# Called from isa_variants to normalize instruction IDs, so that
# immediate variants map to same normalized instruction ID as
# register variants.
sub canonicalInstructionID {
    my $ID = shift;
    my $operator = shift;

    my $operatorID = $operator->attribute("ID");
    my $procs = join('_',map { $_->core(); } $operator->access("processors") );
    my @params = &TargInfo::operator_parameters($operator);
    my %pairedRC;
    my %emitted_proxies;
    my $methods ="";
    map {
	my ($method) = $_->access("method");
	if(defined $_->attribute("proxy")) {
	    my $proxy = $_->attribute("proxy");
	    $proxy =~ s/%//;
	    if(not defined $emitted_proxies{$proxy}) {
		if(defined $_->attribute("usage") and
		   ($_->attribute("usage") =~ /\bMulti\b/)) {
		    if(not defined $pairedRC{$method->name()}) {
			foreach my $rc (@RegClass::table) {
			    if(defined $rc->attribute("multi")) {
				foreach my $multi ($rc->access("multi")) {
				    $pairedRC{$multi->name()} = $rc->name();
				}
			    }
			}
		    }
		    croak "Undefined paired regclass"
			if(not defined $pairedRC{$method->name()});
		    $methods .= "_$proxy".$pairedRC{$method->name()};
		}
		else {
		    $methods .= "_$proxy".$method->name();
		}
		$emitted_proxies{$proxy} = 1;
	    }
	}
    } @params;

    $operatorID =~ s/^(.*)$methods/$1/;
#    print STDERR "$operatorID\n";
    return join("_",($procs,$operatorID));
}

# Called from isa_variants to normalize parameter methods.
# It can be used to accept more variantes under conditions.
sub acceptMethodVariant {
    my ($methodID1, $methodID2) = @_;
    return 0;
}

# Called from O64 module to generate O64 instruction names.
# This performs target-specific translations on the mnemonic.
sub translateMnemonic {
    my ($mnemonic, $operator) = @_;

    # Remove trailing _bdest, _isrc, _rsrc, _bsrc.
    while ($mnemonic =~ s/(.*)_(bdest|isrc|rsrc|bsrc)/$1/) {
    }

    my %name_translate = (
			  "icall" => "icall",
			  "igoto" => "igoto"
			  );
    $mnemonic = $name_translate{$operator->name()} || $mnemonic;

    return $mnemonic;
}

# Called by isa_pack.pl
sub instructionWordSize {
    return 32;
}

# Called by isa_pack.pl to know if a pack hook is needed
sub needPackHook {
  my ($method_name) = @_;
  my %methods = ();
  if(not defined $methods{$method_name}) {
    croak "Target.pm: Do we need pack hook for method $method_name?\n";
  }
  return $methods{$method_name};
}

# Called by isa_pack.pl
sub getPackHook {
  my ($pack_name,$method) = @_;
  my %pack_hooks = (
#		    Pack_GP_SP => "O_VAL == 15 ? 1:0",
		   );

  if(not defined $pack_hooks{$pack_name}) {
    croak "Target.pm: Undefined pack hook: $pack_name\n";
  }

  return $pack_hooks{$pack_name};
}

# Called by isa_pack.pl
sub getUnpackHook {
  my ($unpack_name,$method) = @_;
  my %unpack_hooks = (
#		    Unpack_GP_SP => "O_VAL == 0 ? 13:15",
		   );

  if(not defined $unpack_hooks{$unpack_name}) {
    croak "Target.pm: Undefined unpack hook: $unpack_name\n";
  }

  return $unpack_hooks{$unpack_name};
}

sub WordsInOpcode {
    my $opcode = shift;
    my ($encoding) = $opcode->access("encoding");
    return $encoding->attribute("wordCount");
}

sub AsmSyntax {
    my $construct = shift;

    my %asm_syntax = (
		      "BEGIN_BUNDLE" => "## {	 %s:",
		      "END_BUNDLE"   => "## };",
		      "END_GROUP"    => ";;" );

    return $asm_syntax{$construct};
}

sub is_predicate_parameter {
    my $parameter = shift;
    my $method = $parameter->attribute("method");
    if (defined $method
	&& $method =~ /^RegClass-\w+-predicate/) {
	return 1;
    } else {
	return 0;
    }
}

sub has_predicate_parameter {
    foreach my $parameter (@_) {
	if (is_predicate_parameter ($parameter)) {
	    return 1;
	}
    }
    return 0;
}

sub is_remote_parameter {
    my $parameter = shift;
    my $method = $parameter->attribute("method");
    if (defined $method
	&& $method =~ /^RegClass-\w+-remote/) {
	return 1;
    } else {
	return 0;
    }
}

sub makeTargetISAProperties {
    # For each operator, annotate with $operator->{O64}{PROPERTIES}
    # listing the open64 compiler properties the instruction has.
    # For each load/store operator, annotate with
    # $operator->{memaccess} and $operator->{memalign}, giving the
    # memory access width and memory alignment requirements of the
    # instruction.

    # When creating new properties, note that the following are
    # already used for ia64/st100 targets.  They should be reused
    # if appropriate, and avoided if not appropriate:
    #   defs_fcc, defs_fcr, refs_fcr, branch_predict, access_reg_bank,
    #   side_effects, unalign, mem_fill_type, likely, l_group, f_group,
    #   flop, madd, guard_t, guard_f, div, unsafe.

    foreach my $operator (@Operator::table) {

	my @properties = split ' ', ($operator->{O64}{PROPERTIES} || "");
#	print STDERR $operator->attribute("ID"), "\n";
        my ($origin) = $operator->access("origins");
	my $mnemonic = $operator->attribute("mnemonic");
	my $o64_name = $operator->{O64}{NAME};
        my @origins = split ' ', $operator->attribute("origins");

        push @properties, "simulated" if grep {/^Simulated/} @origins;
        push @properties, "dummy" if grep {/^Generic/} @origins;
	push @properties, "multi" if $operator->name() =~ /^MULTI.+/;
	push @properties, "side_effects" if($operator->name() =~ /remote/);
	push @properties, "barrier" if($mnemonic eq "SYSCALL");

	my %mnemonic_properties = (
            'BWDBAR' => 'barrier',
            'FWDBAR' => 'barrier',
	    'IFIXUP' => 'var_opnds',
            'SKIP'   => 'noop',
            'PHI'    => 'ssa',
            'PSI'    => 'ssa',
            'PUSHREGS' => 'barrier',
	    'MOVC'   => 'guard_t',
	    'MOVCF'  => 'guard_f',
	    'MOVPC'  => 'guard_t',
	    'MOVPCF' => 'guard_f',
	    'SYSCALL'=> 'side_effects',
	    );

	my $mnemonic_properties = $mnemonic_properties{$mnemonic} || "";
	push @properties, (split ' ', $mnemonic_properties);

	if($origin->attribute("ID") =~ /^Opcode/) {
	    my $instr = &MDS::fetch($origin->attribute("instruction"));
	    my $properties = $instr->attribute("properties");
	    
	    if($o64_name =~ /_u5_u5/) {
		my $new_properties = "";
		my $separator = "";
		# Remove standard properties when get bitmask low and high bits.
		if($properties =~ /(intop)/) {
		    $new_properties .= $separator."$1";
		    $separator = " ";
		}
		if($properties =~ /(intrinsic)/) {
		    $new_properties .= $separator."$1";
		    $separator = " ";
		}

		$properties = $new_properties;
	    }

	    if(defined $properties and $properties =~ /(load|store)([0-9]+)\.([0-9]+)/) {
		$operator->{O64}{MEMACCESS} = $2/8;
		$operator->{O64}{MEMALIGNMENT} = $3/8;
		$properties =~ s|load[0-9]+\.[0-9]+|load|g;
		$properties =~ s|store[0-9]+\.[0-9]+|store|g;
	    }
						    
	    push @properties, split(' ',$properties) if defined $properties;
	}

	push @properties, ("select") if ($mnemonic =~ /^SLCT/);
	    
        # Paired movp is a move, but multi-movp is not.
	push @properties, ("move", "widemove") if ($mnemonic eq "MOVP");
	push @properties, ("extract") if ($mnemonic eq "EXTRACTP");
	push @properties, ("compose") if ($mnemonic eq "COMPOSEP");

	# Remove duplicate properties
	my %property_map;
	map { $property_map{$_} = 1; } @properties;
	@properties = sort keys %property_map;

	$operator->{O64}{PROPERTIES} = join ' ', @properties;
    }
}

sub makeTargetOperandProperties {
    # Set open64 operand properties for each operator parameter.
    my %translate_usage = (
			   'Base'   => 'base',
			   'Cond'   => 'condition',
			   'Left'   => 'opnd1',
			   'Offset' => 'offset',
			   'Multi'  => 'multi',
			   'Pred'   => 'predicate',
			   'Right'  => 'opnd2',
			   'Stored' => 'storeval',
			   'Target' => 'target'
			   );
    foreach my $operator (@Operator::table) {
	my $isa_properties = $operator->{O64}{PROPERTIES};
	my @parameters = &TargInfo::operator_parameters ($operator);
	my $mnemonic = $operator->attribute("mnemonic");
#print STDERR $operator->attribute("ID"), "\t$mnemonic\n";
	my ($opcode) = $operator->access("origins");
	my ($format) = $opcode->access("format") if ref $opcode eq "Opcode";
	my $formatID = defined $format ? $format->attribute("ID") : "";
	my @properties;
	my $unpaired = 0;
	my @usages;
	foreach my $i (0 .. scalar @parameters - 1) {
	    my @usage = split ' ', ($parameters[$i]->attribute("usage") || "");
	    $properties[$i] = [ (map {$translate_usage{$_}} @usage) ];
	    $unpaired = 1 if grep {/\bMulti\b/} @usage;
	    push @{$usages[$i]}, @usage;
	}

	# Fix predicate parameters.
	foreach my $i (0 .. scalar @parameters - 1) {
	    if (is_predicate_parameter($parameters[$i])) {
		push @{$properties[$i]}, "predicate";
	    }
	    if (is_remote_parameter($parameters[$i])) {
		push @{$properties[$i]}, "remote";
	    }
	}

	# Fix some properties missing from MDS.
	# Issue 3.
	if ($mnemonic  =~ /\bcb\b/) {
	    push @{$properties[0]}, "condition";
	}

	if ($mnemonic  =~ /\bcjl\b/) {
	    push @{$properties[1]}, "target";
	    push @{$properties[2]}, "condition";
	}

	if ($mnemonic  =~ /\bcmoved\b/) {
	    push @{$properties[2]}, "opnd1";
	    push @{$properties[4]}, "condition";
	    push @{$properties[5]}, "opnd2";
	}

	if ($mnemonic  eq "fsbf" or $mnemonic eq "fsbfd") {
	    push @{$properties[1]}, "opnd2";
	    push @{$properties[2]}, "opnd1";
	}

	my $o64_name = $operator->{O64}{NAME};

	if ($isa_properties =~ /\bcmp\b/ and
	    $mnemonic =~ /comp/) {
	    push @{$properties[1]}, "opnd1";
	    push @{$properties[2]}, "opnd2";
	}

	if ($isa_properties =~ /\bstore\b/ and
	    $mnemonic !~ /\b(cds|cws)\b/) {
	    my $offset_idx = 0;
	    my $base_idx = 1;
	    if ($o64_name =~ /scaling_/) {
		$base_idx = 3;
	    }
	    if(not grep {defined && /offset/} @{$properties[$offset_idx]}) {
		push @{$properties[$offset_idx]}, "offset";
	    }
	    if(not grep {defined && /base/} @{$properties[$base_idx]}) {
		push @{$properties[$base_idx]}, "base";
	    }
	}

	if ($isa_properties =~ /\bload\b/ and
            $mnemonic !~ /\bcds\b/) {
	    my $offset_idx = 1;
	    my $base_idx = 2;
	    if($isa_properties =~ /\bmulti\b/) {
		$offset_idx = 2;
		$base_idx = 3;
		if ($o64_name =~ /scaling_/) {
		    $base_idx = 5;
		}
	    }
	    elsif ($o64_name =~ /scaling_/) {
		$base_idx = 4;
	    }
	    if(not grep {defined && /offset/} @{$properties[$offset_idx]}) {
		push @{$properties[$offset_idx]}, "offset";
	    }
	    if(not grep {defined && /base/} @{$properties[$base_idx]}) {
		push @{$properties[$base_idx]}, "base";
	    }
	}

	if ($mnemonic eq "ldwl") {
	    push @{$properties[1]}, "base";
	}
	if ($mnemonic  eq "stwl") {
	    push @{$properties[1]}, "base";
	    push @{$properties[2]}, "storeval";
	}
	
	if ($mnemonic =~ /\b(cds|cws)\b/) {
	    if($isa_properties =~ /\bmulti\b/) {
		push @{$properties[2]}, "offset";
		push @{$properties[3]}, "base";
		push @{$properties[4]}, "storeval";
	    }
	    else {
		push @{$properties[1]}, "offset";
		push @{$properties[2]}, "base";
		push @{$properties[3]}, "storeval";
	    }
	}

	if ($mnemonic eq "sradl" or
	    $mnemonic eq "srldl" or
	    $mnemonic eq "extfs" or
	    $mnemonic eq "extfz") {
	    while(@{$properties[3]}) { pop @{$properties[3]} }
	}

	if ($mnemonic =~ /^sbf[^c]/) {
	    if($formatID =~ /ALUD/) {
		if ($formatID =~ /\.N\b/) {
		    while(@{$properties[1]}) { pop @{$properties[1]} }
		    push @{$properties[1]}, "opnd2";
		    while(@{$properties[3]}) { pop @{$properties[3]} }
		    push @{$properties[3]}, "opnd1";
		} else {
		    while(@{$properties[2]}) { pop @{$properties[2]} }
		    push @{$properties[2]}, "opnd2";
		    while(@{$properties[4]}) { pop @{$properties[4]} }
		    push @{$properties[4]}, "opnd1";
		}
	    }
	}

	if ($isa_properties =~ /\bcache\b/) {
	    if (scalar @parameters == 3) {
		@properties = ( ["predicate"], ["offset"], ["base"] );
	    } elsif (scalar @parameters == 2) {
		@properties = ( ["offset"], ["base"] );
	    } elsif (scalar @parameters == 1) {
		@properties = ( ["base"] );
	    } else {
		print STDERR $operator->attribute("ID");
		die "Cannot handle cache op with ", (scalar @parameters), " operands";
	    }
	}

	if ($isa_properties =~ /\bselect\b/) {
	    if($isa_properties =~ /\bmulti\b/) {
		push @{$properties[2]}, "condition";
		push @{$properties[3]}, "opnd1";
		push @{$properties[5]}, "opnd2";
	    }
	    elsif($mnemonic eq "cmove") {
		push @{$properties[1]}, "opnd1";
		push @{$properties[2]}, "condition";
		push @{$properties[3]}, "opnd2";
	    }
	    else {
		push @{$properties[1]}, "condition";
		push @{$properties[2]}, "opnd1";
		push @{$properties[3]}, "opnd2";
	    }
	}

	if(not grep {defined && /opnd[12]/} @{$properties[1]}) {
	    if ($formatID !~ /ALUD/ and 
		($isa_properties =~ /\bintop\b/ or
		 $isa_properties =~ /\bflop\b/ or
		 $isa_properties =~ /\bpackedop\b/ or
		 $isa_properties =~ /\basmop\b/)) {
		if (scalar @parameters <= 3) {
		    if(defined $usages[2] and grep {/Left/} @{$usages[2]}) {
			push @{$properties[1]}, "opnd2";
		    }
		    else {
			push @{$properties[1]}, "opnd1";
		    }
		}
	    }
	    
	    if ($isa_properties =~ /\bmove\b/ && ! $unpaired) {
		push @{$properties[1]}, "opnd1";
	    }
	}

	if(not grep {defined && /opnd[12]/} @{$properties[2]}) {
	    if ($formatID !~ /ALUD/ and 
		($isa_properties =~ /\bintop\b/ or
		 $isa_properties =~ /\bflop\b/ or
		 $isa_properties =~ /\bpackedop\b/ or
		 $isa_properties =~ /\basmop\b/)) {
		if (scalar @parameters == 3) {
		    if(defined $usages[1] and grep {/Right/} @{$usages[1]}) {
			push @{$properties[2]}, "opnd1";
		    }
		    else {
			push @{$properties[2]}, "opnd2";
		    }
		}
	    }
	}

	if (not ($mnemonic =~ /^addc/ or
		 $mnemonic =~ /^sbfc/)) {
	    if(not grep {defined && /opnd[12]/} @{$properties[2]}) {
		if ($isa_properties =~ /\bintop\b/) {
		    if (scalar @parameters == 6 or scalar @parameters == 5) {
			if(not grep {/\bopnd1\b/} @{$properties[2]}) {
			    push @{$properties[2]}, "opnd1";
			}
		    }
		}
	    }
	}

	if (not ($mnemonic =~ /^addc/ or
		 $mnemonic =~ /^sbfc/)) {
	    if(not grep {defined && /opnd[12]/} @{$properties[4]}) {
		if ($isa_properties =~ /\bintop\b/) {
		    if (scalar @parameters == 6 or scalar @parameters == 5) {
			if(not grep {/\bopnd2\b/} @{$properties[4]}) {
			    push @{$properties[4]}, "opnd2";
			}
		    }
		}
	    }
	}
	foreach my $i (0 .. scalar @parameters - 1) {
	    my %property; map {$property{$_}++} grep {$_} @{$properties[$i]};
	    my $property = join ' ', sort keys %property;
	    $parameters[$i]->{O64}{PROPERTIES} = $property;
	}
    }
}

sub ProcProperties {

    my %proc_properties = (
			   "is_superscalar"        => "all",
			   "is_select"             => "all",
			   "has_bundles"           => "all",
#			   "has_prefetch"          => "all",
#			   "has_enable_prefetch"   => "all",
#			   "has_delayed_exception" => "all",
#			   "has_predicate_loads"   => "all",
#			   "has_predicate_stores"  => "all"
			   );

    return %proc_properties;
}

# Called from abi_properties.pl to print some additional info for DWARF on STxP70 as example.
sub print_ABI_target_properties {
  my ($file,$abi) = @_;

}

###############################################
# Begin of isa_syntax Target dependent routines.
###############################################

# Called from isa_syntax.pl to know if a specific must not be parsed.
sub mustNotBeParsed {
  my ($operator) = @_;

  my %tops = (
	     );

  return defined $tops{$operator->{O64}{NAME}} ? 1 : 0;
}

# Called from isa_syntax.pl to know if syntax item or parameter is part of mnemonic
# This is because syntax is not completely defined (mandatory space, optional space, ...)
sub isPartOfMnemonic {
  my ($operator,$parameter,$sy_item) = @_;

  my $method = $parameter->attribute("method") if defined $parameter;
  my $is_modifier = defined $method ? ($method =~ /^Modifier/) : 0;

  if($is_modifier and $method !~ /indexing/) {
    return 1;
  }

  if($operator->{O64}{PROPERTIES} !~ /(load)|(store)/ and $sy_item =~ /^\.$/) {
      return 1;
  }

  return 0;
}

# Called from isa_syntax.pl to get Result hook parameters:
#  - const char *print_action: a string or a call to routine returning a string for printing.
#  - const char *parse_operand: TN that must be taken when a parser hook is necessary.
#  - const char *parse_rule: additional parsing rule hook.
sub getResultHook {
  my ($operator,$res_nb,$method,$parameter) = @_;
  my $hook;
  return $hook;
}

# Called from isa_syntax.pl to get mangling suffix added to a predicate parameter
sub getPredicateClassIdentifier {
  return undef;
}

# Called from test_patterns.pl to get syntax suffix added to a predicate parameter
sub getPredicateClassSyntax {
  return undef;
}

# Called from isa_syntax.pl to get Operand hook parameters:
#  - const char *print_action: a string or a call to routine returning a string for printing.
#  - const char *parse_operand: TN that must be taken when a parser hook is necessary.
#  - const char *parse_rule: additional parsing rule hook.
sub getOperandHook {
  my ($operator,$opnd_nb,$method,$parameter) = @_;
  my $hook;
  return $hook;
}

# return the max number of extension ports in the chip
# called by isa_binutils.pl
sub getNumberOfExtensionPort {
    return 0;
}

# Called from isa_syntax.pl to get a port id.
# For cores, it should be 0.
sub getSubsetPort {
  my $subset = shift;
  return (8,$subset,"x.x.x");
}

# Called from isa_syntax.pl to get hook on globals for parser.
sub getParseGlobals {
  my ($core) = @_;
  my $parse_globals;
  return $parse_globals;
}

# Called from isa_syntax.pl to get hook on register class parsing.
sub getParseRegisters {
  my ($core) = @_;
  my $parse_registers;
  return $parse_registers
}

# Called from isa_syntax.pl to get hook on literal class parsing.
sub getParseLiterals {
  my ($core) = @_;
  my $parse_literals;
  return $parse_literals
}

# Called from isa_syntax.pl to get hook on additional parsing rules
sub getParseRules {
  my ($core) = @_;
  my $parse_rules;
  return $parse_rules
}

# Called from isa_syntax.pl to get hook on variable and routines used for printing
sub getPrintGlobals {
  my $print_globals;
  return $print_globals;
}

###############################################
# End of isa_syntax Target dependent routines.
###############################################

###############################################
# Begin of relocation Target dependent routines
###############################################

# Called by isa_operands to get the default applicable relocation
# on given immediate.
sub getDefaultReloc {
  my $imm_name = shift;

  return undef;
}

# Called by isa_operands to get the applicable relocations
# on given immediate. Default relocation must be also returned.
sub getRelocs {
  my $imm_name = shift;

  return undef
}

# Called from isa_relocs.pl to print relocations.
sub print_relocations {
  my $file = shift;

  my $txt = <<EOT;

EOT

  print $file $txt;
}

# Called from test_patterns.pl to patch patterns (token translation, spaces, ...)
sub test_patch_patterns {
	my $operator = shift;
	my $patterns = shift;
	return $patterns;
}

###############################################
# End of relocation Target dependent routines
###############################################

1;
