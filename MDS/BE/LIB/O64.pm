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

package O64;

use strict;
use warnings "FATAL" => "all";
use Carp;

use O64Target;

my $Family = uc $ENV{FAMILY};
my $family = lc $Family;
my $Cores  = uc $ENV{CORES};
my $cores  = lc $Cores;

my %translate_mnemonic = (
    'ADJUST'    => 'spadjust',
    'BEGIN_PREGTN' => 'begin_pregtn',
    'BWDBAR'    => 'bwd.bar',
    'COMPOSEP'  => 'composep',
    'END_PREGTN' => 'end_pregtn',
    'EXTRACTP'  => 'extractp',
    'FWDBAR'    => 'fwd.bar',
    'GETPC'     => 'getpc',
    'GNUASM'    => 'asm',
    'IFIXUP'    => 'ifixup',
    'APPLY'     => 'intrncall',
    'LABEL'     => 'label',
    'MOVC'      => 'movc',
    'MOVCF'     => 'movcf',
    'MOVP'      => 'movp',
    'SKIP'      => 'noop',
    'PHI'       => 'phi',
    'PSI'       => 'psi',
    'PCOPY'     => 'PCOPY',
    'PUSHREGS'  => 'pushregs',
  );

sub translate_mnemonic {
    # Translate some generic MDS mnemonics into generic targinfo ones.
    my ($mnemonic, $operator) = @_;
    $mnemonic = $translate_mnemonic{$mnemonic} || $mnemonic;
    return &Target::translateMnemonic ($mnemonic, $operator);
}

sub translate_name {
    # Instruction name is mnemonic, possibly suffixed by
    #   _r for general register operand
    #   _b for branch register operand
    #   _i for immediate operand
    #   _ii for extended immediate operand
    # Observe that MDS is already giving the instructions
    # unique names, e.g. and_idest_src1_isrc2.  It is tempting
    # to just use these, but that means modifying all the
    # references in the open64 back-end.  Instead map the
    # MDS name into an open64 name.

    my $operator = shift;
    my $operator_mnemonic = $operator->attribute("mnemonic");
    my $mnemonic = &translate_mnemonic ($operator_mnemonic, $operator);
    my @properties = split ' ', ($operator->attribute("attributes") || '');
    my $multi = (grep {/^Multi$/} @properties) ? "multi_" : "";
    my $mnemonic_prefix = $operator->{mnemonic_prefix} || $multi;
    $mnemonic_prefix .= Target::instructionMnemonicPrefix($operator);
    my $open64_name = $mnemonic_prefix . $mnemonic;
    my $mnemonic_suffix = Target::instructionMnemonicSuffix($mnemonic,$operator);
    $open64_name .= $mnemonic_suffix;

    my @origins = split ' ', $operator->attribute("origins");
    # Simulated and generic ops do not get parameter types appended.
    return $open64_name if Target::do_not_append_parameter_types(@origins);

    my %proxy2method; my @methods;
    my @parameters = &TargInfo::operator_parameters ($operator);
    foreach my $i (0 .. @parameters-1) {
        my $parameter = $parameters[$i];
        my ($method) = $parameter->access("method");
        my $proxy = $parameter->attribute("proxy");
        if(defined $proxy) {
            $proxy2method{$proxy} = $method;
        }
        push @methods, $method;
        #$proxy = $proxy || 'undef';
        #$method = $method || 'undef';
        #print STDERR "PROXY=$proxy METHOD=$method\n";
    }

    my $operator_target = $operator->core();
    if ($operator_target ne $family) {
        # If operator_target matches FAMILY then this is a
        # fully merged operator, and we do not need to distinguish
        # the specific core.  Otherwise, prepend the core name to
        # the mnemonic.
        $open64_name = $operator_target . "!" . $open64_name;
    }

    my @open64_suffix;
    my @syntax_items;

    my ($origin) = $operator->access("origins");
    my $sy_tmp = $operator->attribute("syntax");
    if(defined $sy_tmp) {
        $sy_tmp =~ s|(%\d+)| $1 |g;
        $sy_tmp =~ s|\s+| |g;
        foreach my $sy_item (split /[%\s]/, $sy_tmp) {
            if($sy_item =~ /^\d+/) { $sy_item = "%".$sy_item; }
            push @syntax_items, split /\s+/, $sy_item;
        }

        foreach my $sy_item ( @syntax_items ) {
            if($sy_item =~ /^%(\d+)$/) {
                my $method_idx = $1;
                if($method_idx != 0) {
                    if(@methods) {
                        # Found an operand
                        if(not defined $proxy2method{$sy_item}) {
                            die "Cannot find parameter for proxy $sy_item at ".$operator->attribute("ID")."\n";
                        }
                        else {
                            my $method = $proxy2method{$sy_item};
                            my $mtype = ref($method);
                            my $suffix = "";
                            if ($mtype =~ /RegClass/ && defined $method->name()) {
                     # Open64 suffix is lower case of first alphabetic character
                                $suffix = Target::instructionRegisterSuffix($method,$sy_item,$origin);
       #print STDERR "Register suffix $suffix for method:".$method->name()."\n";
                            } elsif ($mtype =~ /Immediate/) {
                # Open64 suffix is ii for an extended immediate, i for a
                # non-extended immediate.
                #print STDERR "attribute ID = ", $method->attribute("ID"), "\n";
                                $suffix = Target::instructionImmediateSuffix($method,$sy_item,$origin);
                            } elsif ($mtype =~ /Modifier/ && defined $method->name()) {
                                $suffix = Target::instructionModifierSuffix($method,$sy_item,$origin);
                                #print STDERR "Modifier suffix = $suffix\n";
                            } elsif ($mtype =~ /RegMask/ && defined $method->name()) {
                                $suffix = Target::instructionRegMaskSuffix($method,$sy_item,$origin);
                                #print STDERR "RegMask suffix = $suffix\n";
                            } # Other operand types do not get a suffix.
                            if ($suffix ne "") {
                                unshift @open64_suffix, $suffix;
                            }
                        }
                    }
                }
            }
            else {
                # Syntaxic element that do not correspond to parameter proxy
                my $suffix = Target::instructionSyntaxicSuffix($sy_item);
                die "Unexpected syntax item '$sy_item' for operator ".$operator->attribute("ID") if(not defined $suffix);
                if ($suffix ne "") {
                    unshift @open64_suffix, $suffix;
                }
            }
        }
    }

#print STDERR "open64 name is ", $open64_name .'+'. (join '+', @open64_suffix), "\n";
    return $open64_name . '+' . (join '+', @open64_suffix);
}

sub common_suffix {
    my @suffix_list = @_;
    #print STDERR "common_suffix: @suffix_list \n";
    my @leading_suffix = split /\+/, shift @suffix_list;
    my $leading_suffix = shift @leading_suffix;
    foreach my $suffix (@suffix_list) {
        my @suffixes = split /\+/, $suffix;
        if (!exists $suffixes[0]) {
            #print STDERR "NO common suffix: suffixes[0] does not exist\n";
            return 0;
        }
        if ($suffixes[0] ne $leading_suffix) {
           #print STDERR "NO common suffix: $suffixes[0] and $leading_suffix\n";
            return 0;
        }
    }
    #    print STDERR "Common suffix: $leading_suffix\n";
    return 1;
}

sub prune_suffixes {

    # Strip out the core specific names.
    # They will take the translation of the name
    # they are based on.
    my @core_specific_names;
    my @names;
    my %names;
    foreach my $name (@_) {
        if ($name =~ /!/) {
            push @core_specific_names, $name;
        } else {
            push @names, $name;
            $names{$name} = 1;
        }
    }

    # Check if core specific names has base name in names.
    # If not, push it in names.
    foreach my $name (@_) {
        if ($name =~ /!(.*)$/) {
            if(not defined $names{$1}) {
                push @names, $1;
            }
        }
    }

    my %pruned_name_mapping;
    while (@names) {
        my @split_inst = split /\+/, $names[0];
        my $mnemonic = $split_inst[0];
        my @suffixes;
        my @pruned_insts;
        my @unpruned_insts;

        #print STDERR "menmonic is ", $mnemonic, "\n";
        #print STDERR "inst is $names[0]\n";
        do {
            shift @split_inst;
            push @unpruned_insts, $names[0];
            push @pruned_insts, $mnemonic;
            #print STDERR "push suffix ", (join "+", @split_inst), "\n";
            push @suffixes, (join '+', @split_inst);
            shift @names;
            if (@names) {
                @split_inst = split /\+/, $names[0];
                #print STDERR "inst is $names[0]\n";
            }
          } while (@names && $split_inst[0] eq $mnemonic);
        # Now we have the base instruction in pruned_insts.
        # To each of these we append the suffices that differ
        # for some members of the group.
        # Suffices that are common to every member of the
        # group are removed.
        while ($suffixes[0] ne "") {
            my $remove_suffix = &Target::pruneInstructionOperandSuffixes && common_suffix @suffixes;
            foreach my $i (0..$#suffixes) {
                my @new_suffixes = split /\+/, $suffixes[$i];
                my $suffix = shift @new_suffixes;
                if (defined $suffix && ! $remove_suffix) {
                    $pruned_insts[$i] .= '+' . $suffix;
                }
                #print STDERR "pruned_insts[$i] = $pruned_insts[$i]\n";
                $suffixes[$i] = (join '+', @new_suffixes);
            }
        }
        foreach my $i (1..$#suffixes) {
            $pruned_insts[$i] .= '+' . $suffixes[$i] if ($suffixes[$i] ne "");
        }
        foreach my $i (0..$#pruned_insts) {
            # Translate any punctuation (including '.' in mnemonic and
            # the '+' suffix separator) into '_'.
            $pruned_insts[$i] =~ s/\W/_/g;
            $pruned_name_mapping{$unpruned_insts[$i]} = $pruned_insts[$i];
        }
    }

    # Now add mappings for the core-specific names
    foreach my $name (@core_specific_names) {
        my ($core, $basename, $tail) = split '!', $name;
        die "There is an ambiguity on $name" if(defined $tail);
        die "There is no pruned name mapping for $basename (name = $name)" if (!exists $pruned_name_mapping{$basename});
        die "There is already an existing identical pruned name for '$name'" if(defined $pruned_name_mapping{$name});
        $pruned_name_mapping{$name} = "${core}_".$pruned_name_mapping{$basename};
    }

    return %pruned_name_mapping;
}

sub make_instruction_names {
    # For each instruction, derive the name of the instruction as used in the
    # open64 compiler, based on the MDS name of the instruction.
    # Save the open64 name in $operator->{O64}{NAME}.

    foreach my $operator (@Operator::table) {
        $operator->{O64}{NAME} = &translate_name ($operator);
#print STDERR "TOP: ", $operator->{O64}{NAME}, " for operator: ", $operator->attribute("ID"), "\n";
    }

    # Verify that all open64 operator names are unique.
    # Where they are not, add core prefixes.
    # The version supported on the earliest cores (based on the order
    # they appear in the CORES environment variable) gets no prefix.
    my %core_rank;
    my $rank = 0;
    foreach my $core (split ' ', $cores) {
        $core_rank{$core} = $rank++;
    }
    # Rank each operator with its earliest core.
    my %operator_primary_core;
    foreach my $operator (@Operator::table) {
        my @processors = $operator->access("processors");
        my @cores = map {$_->core()} @processors;
        @cores = sort { $core_rank{$a} <=> $core_rank{$b}; } @cores;
        $operator_primary_core{$operator} = $cores[0];
    }
    # Make a map from open64_name to the set of operators with that name.
    my %name_core_map;
    foreach my $operator (@Operator::table) {
        my $open64_name = $operator->{O64}{NAME};
        push @{$name_core_map{$open64_name}}, $operator;
    }
    foreach my $open64_name (keys %name_core_map) {
        my @operators = @{$name_core_map{$open64_name}};
        if (scalar @operators > 1) {
            # Sort the operators based on their primary core.
            # This is intended to ensure that when new cores are
            # added, the existing instruction names do not change.
            @operators = sort { $core_rank{$operator_primary_core{$a}} <=>
                  $core_rank{$operator_primary_core{$b}}; } @operators if $cores;
            # First entry gets the default name
            # Subsequent entries have the earliest core name prepended
            foreach my $operator (pop @operators) {
                my $core = $operator_primary_core{$operator};
                $operator->{O64}{NAME} = "$core!". $operator->{O64}{NAME};
             #print STDERR "Prefixing operator: ", $operator->{O64}{NAME}, "\n";
            }
        }
    }
    my @instruction_names = map { $_->{O64}{NAME}; } @Operator::table;
    my %pruned_name_mapping = prune_suffixes (sort @instruction_names);
    foreach my $operator (@Operator::table) {
        $operator->{O64}{NAME} = "TOP_".$pruned_name_mapping{$operator->{O64}{NAME}};
    }
}

sub make_operand_names {
    # For each operand type, derive the name of the operand type, as used in the
    # open64 compiler, based on the MDS name of the instruction.
    # Save the open64 name in $operand->{O64}{NAME};

# When manipulating operators the parameters specify directly methods.
# So the targinfo operand use must be derived directly from methods.
# For each possible method (RegClass, Immediate, Modifier), give it
# an open64 name.  Note that RegClass are given open64 names when
# building open64 register classes, so only Immediate, Modifiers and RegMask are
# treated here.
    foreach my $method (@Immediate::table,@RegMask::table) {
        my $name = "LC_" . (lc $method->name());
        $name =~ s/\W/_/g;
        # [JV] Do this due to relocation specification in MDS where relocs are
        # attached to immediate instead of operands (as in targinfo).
        $name = Target::makeImmediateName($name);
        $method->{O64}{NAME} = $name;
    }

    foreach my $method (@Modifier::table) {
        my $name = "ISA_EC_" . (lc $method->name());
        $name =~ s/\W/_/g;
        # [JV] Do this due to relocation specification in MDS where relocs are
        # attached to immediate instead of operands (as in targinfo).
        $method->{O64}{NAME} = $name;
    }
}

sub reg_class_contains {
    my ($rc1, $rc2) = @_;
    my $rc1_regshash = $rc1->{RegsHash};
    my $rc2_regshash = $rc2->{RegsHash};
    foreach my $reg (keys %$rc2_regshash) {
        return 0 if (! exists $$rc1_regshash{$reg})
    }
    return 1;
}


my %regclass_names;

sub make_register_classes {
    # for each register class, set $rc->{O64}{NAME}.
    foreach my $rc (sort {
            my $ida = $a->attribute("ID");
            my $idb = $b->attribute("ID");
            $ida cmp $idb;
        } @RegClass::table) {
        next unless defined $rc->name();
        my $name = $rc->attribute("ID");
        $name =~ s/RegClass\-(\w+)\-(.*)/$2/;
        my $core = $1;
        $name = lc $name;
        # open64 target-independent code assumes that the general purpose
        # register class is called "integer", so fix that here.
        $name = Target::get_register_class($name);
        $name = $core."_".$name if exists $regclass_names{$name};
        $regclass_names{$name} = 1;
        $rc->{O64}{NAME} = $name;
    }
    # for each register class, build a hash of the members to make
    # subsequent processing faster.
    foreach my $rc (@RegClass::table) {
        next unless defined $rc->name();
        my @registerIDs = split ' ', $rc->attribute("registers");
        my %regshash; map { ++$regshash{$_} } @registerIDs;
        $rc->{RegsHash} = \%regshash;
    }
    # Set $rc->{O64}{SUPERSETS} to be the set of supersets of $rc.
    foreach my $rc1 (@RegClass::table) {
        next unless defined $rc1->name();
        foreach my $rc2 (@RegClass::table) {
            next unless defined $rc2->name();
            my $sub_rc = $rc2;
            if(defined $rc2->attribute("multi")) {
                my @multi_rc = $rc2->access("multi");
                foreach my $m_rc (@multi_rc) {
                    $m_rc->{O64}{MULTIOF} = $rc2->attribute("ID");
                }
                $sub_rc = $multi_rc[0];
            }
            if ($rc1 != $sub_rc) {
                if (reg_class_contains ($rc1, $sub_rc)) {
                    $rc2->{O64}{SUPERSETS} .= " ".$rc1->attribute("ID");
                }
            }
        }
    }
    # Now in open64 terms, a Register Class has no supersets.
    # A Register SubClass has supersets.
    # For each SubClass, we need to find which of its supersets is
    # a register class - there should be only one.
    foreach my $rc (@RegClass::table) {
        next unless defined $rc->name();
        if (exists $rc->{O64}{SUPERSETS}) {
            # This is a register subclass.
            foreach my $supersetID (split ' ', $rc->{O64}{SUPERSETS}) {
                my $superset = &MDS::fetch($supersetID);
                if (!exists $superset->{O64}{SUPERSETS}) {
                    $rc->{O64}{SUPERSETS} = $supersetID;
                    last;
                }
            }
            $rc->{O64}{NAME} = "ISA_REGISTER_SUBCLASS_" . $rc->{O64}{NAME};
        } else {
            $rc->{O64}{NAME} = "ISA_REGISTER_CLASS_" . $rc->{O64}{NAME};
        }
    }

    # Label each register with its register class.
    foreach my $rc (@RegClass::table) {
        next unless defined $rc->name();
        my $rcID = $rc->attribute("ID");
        unless (exists $rc->{O64}{SUPERSETS}) {
            my $count = 0;
            my @registers = $rc->access("registers");
            foreach my $register (@registers) {
                $register->{O64}{REGCLASS} = $rcID;
                $register->{O64}{REGNUM} = $count++;
            }
        }
    }
}

sub set_rc_name {
    my ($method) = @_;
    return if(defined $method->{O64}{NAME});
    my $name = $method->attribute("ID");
    $name =~ s/Reg[^\-]+\-(\w+)\-(.*)/$2/;
    my $core = $1;
    $name = lc $name;
    # open64 target-independent code assumes that the general purpose
    # register class is called "integer", so fix that here.
    $name = "integer" if $name eq "general";
    $name = $core."_".$name if exists $regclass_names{$name};
    $regclass_names{$name} = 1;
    $method->{O64}{NAME} = $name;

}

sub make_register_classes_from_registers {
    # Now Registers, RegFiles can get {O64}{NAME} as we enable 
    # singleton register to be present in a parameter of Operators.

    # for each register class, set $rc->{O64}{NAME}.
    my %reg2rc;
    # This hash must point to SUPERSETS regclass
    my %regfile2rc;
    foreach my $rc (@RegClass::table) {
        next unless defined $rc->name();
        map { $reg2rc{$_} = $rc; } split(' ',$rc->attribute("registers"));
        if(defined $regfile2rc{$rc->attribute("regFile")}) {
            my $rc2 = $regfile2rc{$rc->attribute("regFile")};
            if($rc2 != $rc) {
                if(reg_class_contains ($rc, $rc2)) {
                    $regfile2rc{$rc->attribute("regFile")} = $rc;
                }
                elsif(reg_class_contains ($rc2, $rc)) {
                    $regfile2rc{$rc->attribute("regFile")} = $rc2;
                }
                else {
                    $regfile2rc{$rc->attribute("regFile")} = $rc;
                    warn "Bug: Don't know which register class (".$rc->name()." or ".$rc2->name().") to associate to register file ".$rc->attribute("regFile")."\n";
                }
            }
        }
        else {
            $regfile2rc{$rc->attribute("regFile")} = $rc;
        }
    }

    my %abs_orpheline_regs;
    my %storage2regs;
    foreach my $reg (@Register::table) {
        next unless defined $reg->name();
        $abs_orpheline_regs{$reg->attribute("ID")} = 1 if(not defined $reg2rc{$reg->attribute("ID")});
        push @{$storage2regs{$reg->attribute("storage")}}, $reg;
    }

    my %used_orpheline_regs;
    foreach my $operator (@Operator::table) {
        my @parameters = &TargInfo::operator_parameters ($operator);
        my @methods = grep {defined $_} map {$_->attribute("method")} @parameters;
        map {
            # Force orpheline regs to create subclass for dedicated.
            if(defined $abs_orpheline_regs{$_} or $_ =~ /^Register/) {
                $used_orpheline_regs{$_} = 1
            }
          } @methods;
    }

    my @orpheline_regs;
    foreach my $orpheline_reg (keys %used_orpheline_regs) {
        push @orpheline_regs,&MDS::fetch($orpheline_reg);
    }

    my %reg2regfile;
    foreach my $regfile (@RegFile::table) {
        map { $reg2regfile{$_} = $regfile; } split(' ',$regfile->attribute("registers"));
    }

    my @open64_regclasses;
    foreach my $reg (@orpheline_regs) {
        #   print STDERR "Find orpheline reg: ",$reg->attribute("ID"),"\n";
        if(defined $reg2regfile{$reg->attribute("ID")}) {
            my $regfile = $reg2regfile{$reg->attribute("ID")};
     #     print STDERR "Get superset RegFile: ",$regfile->attribute("ID"),"\n";
            if(defined $regfile2rc{$regfile->attribute("ID")}) {
                my $rc = $regfile2rc{$regfile->attribute("ID")};
#print STDERR "Get a superset RegClass: ",$rc->attribute("ID")," attached to RegFile: ",$regfile->attribute("ID"),"\n";
# A regfile refers to this register and a regclass is associated with this regfile. We will create a singleton register subclass.
                $reg->{O64}{SUPERSETS} .= " ".$rc->attribute("ID");
            }
            else {
                set_rc_name($regfile);
#print STDERR "Get a superset RegClass: ",$regfile->{O64}{NAME}," build from RegFile: ",$regfile->attribute("ID"),"\n";
                $reg->{O64}{SUPERSETS} .= " ".$regfile->attribute("ID");
                push @open64_regclasses, $regfile;
            }
        }
#    else {
#      my $storage = &MDS::fetch($reg->attribute("storage"));
#      my @cells = split(' ',$reg->attribute("addresses"));
#      if(@cells != $storage->attribute("count")) {
#        # Have to search if there is a super register on wich this reg aliased.
#        my $regs = $storage2regs{$reg->attribute("storage")};
#        my %cells2reg;
#        foreach my $tmp_reg (@$regs) {
#          my @tmp_cells = split(' ',$tmp_reg->attribute("addresses"));
#          if(@tmp_cells == $storage->attribute("count")) {
#            set_rc_name($tmp_reg);
#            print STDERR "Get a superset RegClass: ",$tmp_reg->{O64}{NAME}," build from Register: ",$tmp_reg->attribute("ID"),"\n";
#            $reg->{O64}{SUPERSETS} .= " ".$tmp_reg->attribute("ID");
#            push @open64_regclasses, $tmp_reg;
#          }
#        }
#      }
#    }
        set_rc_name($reg);
        push @open64_regclasses, $reg;
    }

    # Now in open64 terms, a Register Class has no supersets.
    # A Register SubClass has supersets.
    # For each SubClass, we need to find which of its supersets is
    # a register class - there should be only one.
    foreach my $rc (@open64_regclasses) {
        next unless defined $rc->name();
        if (exists $rc->{O64}{SUPERSETS}) {
            # This is a register subclass.
            foreach my $supersetID (split ' ', $rc->{O64}{SUPERSETS}) {
                my $superset = &MDS::fetch($supersetID);
                if (!exists $superset->{O64}{SUPERSETS}) {
                    $rc->{O64}{SUPERSETS} = $supersetID;
                    last;
                }
            }
            $rc->{O64}{NAME} = "ISA_REGISTER_SUBCLASS_" . $rc->{O64}{NAME} if($rc->{O64}{NAME} !~ /^ISA_REGISTER_(SUB)??CLASS_/);
        } else {
            $rc->{O64}{NAME} = "ISA_REGISTER_CLASS_" . $rc->{O64}{NAME} if($rc->{O64}{NAME} !~ /^ISA_REGISTER_(SUB)??CLASS_/);
        }
    }

    # Label each register with its register class.
    foreach my $rc (@open64_regclasses) {
        next unless defined $rc->name();
        my $rcID = $rc->attribute("ID");
        unless (exists $rc->{O64}{SUPERSETS}) {
            my $count = 0;
            if($rc->attribute("ID") !~ /^Register/) {
                my @registers = $rc->access("registers");
                foreach my $register (@registers) {
                    $register->{O64}{REGCLASS} = $rcID;
                    $register->{O64}{REGNUM} = $count++;
                }
            }
            else {
                $rc->{O64}{REGCLASS} = $rcID;
                $rc->{O64}{REGNUM} = $count;
            }
        }
    }
}

sub make_resource_names {
    foreach my $resource (@Resource::table) {
        my $name = $resource->attribute("ID");
        $name =~ s/\W/_/g;
        $resource->{O64}{NAME} = $name;
    }
}

sub make_convention_names {
    foreach my $convention (@Convention::table) {
        my $name = &Target::getConventionName($convention,$Family);
        croak "Undefined convention name for ".$convention->attribute("ID")
          if(not defined $name);
        $convention->{O64}{NAME} = $name;
    }
}

sub makeNames {
    make_instruction_names;
    make_operand_names;
    make_register_classes;
    make_register_classes_from_registers;
    make_resource_names;
    make_convention_names;
}

1;
# vim: set ts=4 sw=4 et:
