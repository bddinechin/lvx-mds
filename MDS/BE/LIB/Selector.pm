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

package Selector;

use strict;
use warnings "FATAL" => "all";
use Carp;

use MDS;
use BitString;
use TargInfo;


sub buildOpen64InstructionGroups {
    my $ignores = shift;

    # Partition all the operators into groups that have
    # identical operand types except 'ignores' conditions and
    # same syntax except 'ignores' conditions.

    my %instruction_groups;
    my %instr_grps_wo_o64_props;
    my %grp_wo_props_2_grp;

    foreach my $operator (@Operator::table) {
        my ($origin) = $operator->access("origins");

        if($origin->attribute("ID") !~ /^Generic/ and
            $origin->attribute("ID") !~ /^Simulated/) {
            my $syntax_wo_o64_props;
            my $syntax = lc($operator->attribute("syntax") || '');
            my $implicit_operands;
            my $mnemo = lc($operator->attribute("mnemonic"));
            $syntax =~ s|%0|$mnemo|;

            if(defined $ignores->{syntax}{spaces}) {
                $syntax =~ s|\s||g;
            }

            $syntax_wo_o64_props = $syntax;

            #	print STDERR $operator->attribute("ID"), "\n";
            foreach my $parameter (&TargInfo::operator_parameters ($operator)) {
                # Ignore parameters that have dummy method
                # (can happen for simulated operators).
                my ($method) = $parameter->access("method");
                if (defined $method and defined $method->name()) {
                    my $param_proxy = $parameter->attribute("proxy");
                    my $param_method = $parameter->attribute("method");
                    my $operatorID = $operator->attribute("ID");
                    my $opnd_name;
                    my $opnd_name_wo_o64_props;

                    # MDS check
                    croak "Register is given as parameter method ($param_method)".
"for operator $operatorID. Should add RegClass or RegFile."
                      if($parameter->attribute("method") =~ /^Register/);

                    if(defined $ignores->{Parameter}{action}) {
                        $opnd_name .= "<action>";
                    }
                    else {
                        $opnd_name .= "<".$parameter->attribute("action").">";
                    }

                    if($parameter->attribute("method") =~ /^RegClass/) {
                        if(defined $ignores->{Parameter}{RegClass}) {
                            $opnd_name .= "<regclass>";
                        }
                        else {
                            $opnd_name .= "<".$parameter->attribute("method").">";
                        }
                    }

                    if($parameter->attribute("method") =~ /^RegFile/) {
                        if(defined $ignores->{Parameter}{RegFile}) {
                            $opnd_name .= "<regfile>";
                        }
                        else {
                            $opnd_name .= "<".$parameter->attribute("method").">";
                        }
                    }

                    if($parameter->attribute("method") =~ /^Immediate/) {
                        if(defined $ignores->{Parameter}{Immediate}) {
                            $opnd_name .= "<imm>";
                        }
                        else {
                            $opnd_name .= "<".$parameter->attribute("method").">";
                        }
                    }

                    if($parameter->attribute("method") =~ /^Modifier/) {
                        if(defined $ignores->{Parameter}{Modifier}) {
                            $opnd_name .= "<imm>";
                        }
                        else {
                            $opnd_name .= "<".$parameter->attribute("method").">";
                        }
                    }

                    if(defined $ignores->{Parameter}{stages}) {
                        $opnd_name .= "<stages>";
                    }
                    else {
                        $opnd_name .= "<".$parameter->attribute("stages").">";
                    }

                    if(defined $ignores->{Parameter}{O64}{PROPERTIES}) {
                        $opnd_name .= "<o64_properties>";
                    }
                    else {
                        $opnd_name_wo_o64_props = $opnd_name;
                        $opnd_name .= "<".$parameter->{O64}{PROPERTIES}.">";
                        $opnd_name_wo_o64_props .= "<o64_properties>";
                    }

                    if(defined $param_proxy and $param_proxy ne "") {
                        $syntax =~ s|$param_proxy|$opnd_name|g;
                        if(defined $opnd_name_wo_o64_props) {
                            $syntax_wo_o64_props =~ s|$param_proxy|$opnd_name_wo_o64_props|g;
                        }
                        else {
                            $syntax_wo_o64_props = $syntax;
                        }
                    }
                    else {
                        $implicit_operands .= "|".$opnd_name;
                    }
                }
            }

            $syntax_wo_o64_props .= "<o64_op_properties>";
            if(defined $ignores->{Operator}{O64}{PROPERTIES}{ALL}) {
                $syntax .= "<o64_op_properties>";
            }
            else {
                my $op_props = $operator->{O64}{PROPERTIES};
                my @unwanted_props = split(' ',$ignores->{Operator}{O64}{PROPERTIES}{SOME})
                  if(defined $ignores->{Operator}{O64}{PROPERTIES}{SOME});
                foreach my $unwanted_prop (@unwanted_props) {
                    $op_props =~ s|$unwanted_prop||;
                }
                $op_props =~ s|\s+| |g;
                $op_props =~ s|\s$||g;
                $op_props =~ s|^\s||g;
                $syntax .= "<$op_props>";
            }

            my $group_key = $syntax;
            my $group_key_wo_o64_props = $syntax_wo_o64_props;
            $group_key .= $implicit_operands if defined $implicit_operands;
            $group_key_wo_o64_props .= $implicit_operands if defined $implicit_operands;

            push @{$instruction_groups{$group_key}}, $operator;
            push @{$instr_grps_wo_o64_props{$group_key_wo_o64_props}}, $operator;
            $grp_wo_props_2_grp{$group_key_wo_o64_props} = $group_key;
        }
    }

    if(not defined $ignores->{Parameter}{O64}{PROPERTIES}) {
        foreach my $group_key_wo_o64_props (keys %instr_grps_wo_o64_props) {
            my $group_key = $grp_wo_props_2_grp{$group_key_wo_o64_props};
            my @ops = @{$instruction_groups{$group_key}};
            my @ops_wo_o64_props = @{$instr_grps_wo_o64_props{$group_key_wo_o64_props}};
            my $ops_are_equal = 1;

            if(@ops == @ops_wo_o64_props) {
                foreach my $op (@ops) {
                    my $find_op = 0;
                    map { $find_op = 1 if($_ == $op); } @ops_wo_o64_props;
                    if(not $find_op) {
                        $ops_are_equal = 0;
                    }
                }
            }
            else {
                $ops_are_equal = 0;
            }

            if(not $ops_are_equal) {
                print STDERR "WARNING: Some TOPs cannot be grouped due to O64 properties:\n";
                print STDERR "\t",$ops[0]->{O64}{NAME},": ",$ops[0]->{O64}{PROPERTIES},":\n";
                foreach my $op (@ops_wo_o64_props) {
                    print STDERR "\t\t",$op->{O64}{NAME},": ",$op->{O64}{PROPERTIES},"\n";
                }
            }
        }
    }

## sort instructions in group so that first instruction in a subset can be
## used as the representative for this subset (gp16/gp32/g48 handling on xp70)
    foreach my $group (sort keys %instruction_groups) {
        my @operators = (sort { Target::cmpSelectorMnemos($a, $b) } @{$instruction_groups{$group}});
        foreach my $operator (@operators) {
            my $o64_name = $operator->{O64}{NAME};
        }
        @{$instruction_groups{$group}} =  @operators ;

    }


    return %instruction_groups;
}

###############################################
# End of relocation Target dependent routines
###############################################

1;
# vim: set ts=4 sw=4 et:
