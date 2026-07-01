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

package Intrinsics;

use strict;
use warnings "FATAL" => "all";
use Carp qw(croak cluck confess);

use TargInfo;
use O64Target;

sub getHeader {
    return &Target::getCopyright();
}

sub hasIntrinsic {
    my $operator = shift;

    return defined $operator->{O64}{INTRN_NAME};
}

sub operators {
    my $operator = shift;

    return @{$operator->{O64}{INTRN_OPRS}};
}

sub hasSideEffects {
    my $operator = shift;

    if($operator->{O64}{PROPERTIES} =~ /barrier/ or
        $operator->{O64}{PROPERTIES} =~ /side_effects/) {
        return 1;
    }

    return &Target::builtinHasSideEffects($operator);
}

sub isTempParam {
    my $parameter = shift;
    my $param_info = $parameter->{O64}{INTRN_PARAM_INFO};

    croak("Parameter not defined\n") if ( not defined $param_info );
    return $$param_info{TYPE} eq "implicit";
}

sub isDedicatedRegister {
    my $parameter = shift;

    my $param_info = $parameter->{O64}{INTRN_PARAM_INFO};

    croak("Parameter not defined\n") if ( not defined $param_info );
    my $name;

    if(defined $$param_info{REG_IDX_RANGE}) {
        return $$param_info{REG_IDX_RANGE};
    }
    return 0;
}

sub isDedicatedRegisterClass {
    my $method = shift;

    if($method !~ /^RegClass/) {
        return 0;
    }

    my $reg_class = &MDS::fetch($method);

    # [JV] Consider multi register classes as allocatable
    if(defined $method->attribute("multi")) {
        return 0;
    }

    if(&Target::isDedicatedRegisterClass($reg_class->{O64}{NAME})) {
        my @registers = split(/\s+/,$method->attribute("registers"));
        return @registers;
    }

    my @unallocatable_registers;
    my @registers = split(/\s+/,$method->attribute("registers"));
    my $conv_idx = 0;

    my @callee;
    my @caller;
    my @reserved;

    $conv_idx = 0;
    foreach my $conv (@Convention::table) {
        my @array = split(/\s+/,$conv->attribute("callee"));
        foreach my $elem (@array) {
            $callee[$conv_idx]{$elem} = 1;
        }
        @array = split(/\s+/,$conv->attribute("caller"));
        foreach my $elem (@array) {
            $caller[$conv_idx]{$elem} = 1;
        }
        @array = split(/\s+/,$conv->attribute("reserved"));
        foreach my $elem (@array) {
            $reserved[$conv_idx]{$elem} = 1;
        }
        $conv_idx++;
    }

    $conv_idx = 0;
    foreach my $conv (@Convention::table) {
        $unallocatable_registers[$conv_idx] = 0;
        foreach my $reg (@registers) {
            if( defined $reserved[$conv_idx]{$reg} ) {
                croak("$reg is mark reserved and defined as callee or caller saved")
                  if(defined $callee[$conv_idx]{$reg} or defined $caller[$conv_idx]{$reg});
                $unallocatable_registers[$conv_idx]++;
            }
            if(not defined $callee[$conv_idx]{$reg} and
                not defined $caller[$conv_idx]{$reg}) {
                $unallocatable_registers[$conv_idx]++;
            }
        }
        $conv_idx++;
    }

    my $allocatable = 0;
    # RegClass is allocatable if it is in at least one convention

    $conv_idx = 0;
    my $reg_nb = 0;
    foreach my $conv (@Convention::table) {
        if( $unallocatable_registers[$conv_idx] == 0) { return 0; }
        if( $unallocatable_registers[$conv_idx] != @registers ) {
            if(&Target::isDedicatedRegisterClass($reg_class->{O64}{NAME})) {
                my @registers = split(/\s+/, $method->attribute("registers"));
                return @registers;
            }
            else {
                return 0;
            }
        }
        if( $unallocatable_registers[$conv_idx] == @registers ) {
            $reg_nb = $unallocatable_registers[$conv_idx];
        }
        $conv_idx++;
    }

    return $reg_nb;
}

sub getBuiltinName {
    my $operator = shift;

    my @names = split ' ', $operator->{O64}{INTRN_NAME};

    return join ' ', map { "__builtin_".$_ } @names;
}

sub getBuiltinComment {
    my $operator = shift;

    return $operator->{O64}{INTRN_COMMENT};
}

sub getBuiltinGeneralComment {
    my $txt = <<EOS;
/* Note on dedicated registers: as these registers are not allocated by the compiler,
 * it is necessary to pass the index of such register. When it is passed as builtin
 * operand, an immediate of the form 'u[0..n]' is expected in place of dedicated register.
 * 'n' is the size of the register file minus one.
 * When dedicated register is the result, one additional operand of the same form 'u[0..n]'
 * is placed as first parameter to select the result register index.
 *
 * Note on immediates: some builtins may accept constant value as parameter. Programmer must
 * respect the immediate range given by the bits number and signess.
 * Immediates are given under the form '[su][0-9]+'
 * - [su] for signed and unsigned respectively.
 * - [0-9]+ the bits number associated to the immediate.
 */
EOS

    return $txt;
}

sub isMultiParameter {
    my $parameter = shift;

    croak "Not defined parameter" if(not defined $parameter);
    my ($method) = $parameter->access("method");
    # FIXME! multi is now a RegClass attribute.
    return 1
      if(ref $method eq "RegClass" and defined $method->attribute("multi"));
    return 0;
}

sub getOpndSyntheticNames {
    my $parameter = shift;
    my $param_info = $parameter->{O64}{INTRN_PARAM_INFO};

    croak("Parameter not defined\n") if ( not defined $param_info );
    my @names;

    if($$param_info{TYPE} eq "explicit") {
        if($parameter->attribute("action") eq "Write") {
            if(isMultiParameter($parameter)) {
                push @names, "ol".$$param_info{INDEX};
                push @names, "oh".$$param_info{INDEX};
            }
            else {
                push @names, "o".$$param_info{INDEX};
            }
        }
        if($parameter->attribute("action") eq "Read") {
            if(isMultiParameter($parameter)) {
                push @names, "il".$$param_info{INDEX};
                push @names, "ih".$$param_info{INDEX};
            }
            else {
                push @names, "i".$$param_info{INDEX};
            }
        }
    }
    elsif($$param_info{TYPE} eq "implicit") {
        push @names, "tmp".$$param_info{INDEX};
    }

    croak("Parameter name not defined\n") if (@names == 0);
    return @names;
}

sub getSameRes {
    my $parameter = shift;
    my $param_info = $parameter->{O64}{INTRN_PARAM_INFO};

    my $same_res;

    croak("Parameter not defined\n") if ( not defined $param_info );

    if(defined $$param_info{PARAMETER}{Write} and defined $$param_info{PARAMETER}{Read}) {
        $same_res = { SOURCE => $$param_info{PARAMETER}{Read},
            DEST   => $$param_info{PARAMETER}{Write},
          };
    }
    return $same_res;
}

sub getRegClass {
    my $parameter = shift;
    my $reg_class = &MDS::fetch($parameter->attribute("method"));
    if(exists $reg_class->{O64}{SUPERSETS}) {
        $reg_class = &MDS::fetch($reg_class->{O64}{SUPERSETS});
    }
    return $reg_class->{O64}{NAME};
}

sub isValidOutputParameter {
    my $parameter = shift;

    my $param_info = $parameter->{O64}{INTRN_PARAM_INFO};
    croak("Parameter not defined\n") if ( not defined $param_info );

    return ($$param_info{TYPE} eq "explicit" and
          $parameter->attribute("action") eq "Write");
}

sub isValidInputParameter {
    my $parameter = shift;

    my $param_info = $parameter->{O64}{INTRN_PARAM_INFO};
    croak("Parameter not defined\n") if ( not defined $param_info );

    return ($$param_info{TYPE} eq "explicit" and
          $parameter->attribute("action") eq "Read");
}

sub isPairedParameter {
    my $parameter = shift;

    my $param_info = $parameter->{O64}{INTRN_PARAM_INFO};
    croak("Parameter not defined\n") if ( not defined $param_info );

    return ($$param_info{TYPE} eq "explicit" and
          defined $$param_info{PAIRED0});
}

sub isPredicateParameter {
    my $parameter = shift;

    return ($parameter->attribute("action") eq "Read" and
          $parameter->{O64}{PROPERTIES} =~ /predicate/);
}

sub getProtoParameterType {
    my $operator = shift;
    my $parameter = shift;

    my %paired_cvt = (
        "VOID"     => "VOID",
        "SHORT"    => "INT",
        "SHORT"    => "INT",
        "USHORT"   => "UNSIGNED",
        "USHORT"   => "UNSIGNED",
        "INT"      => "LONGLONG",
        "UNSIGNED" => "ULONGLONG",
        "FLOAT"    => "DOUBLE",
      );

    my $param_info = $parameter->{O64}{INTRN_PARAM_INFO};
    if(defined $param_info and defined $$param_info{CTYPE}) {
        my $ctype = $$param_info{CTYPE};
        if(defined $$param_info{PAIRED1}) {
            $ctype = $paired_cvt{$ctype};
        }
        return $ctype;
    }

    my %type_cvt = (
        "IRETURN_V" => "VOID",
        "IRETURN_I1"=> "SHORT",
        "IRETURN_I2"=> "SHORT",
        "IRETURN_U1"=> "USHORT",
        "IRETURN_U2"=> "USHORT",
        "IRETURN_I4"=> "INT",
        "IRETURN_U4"=> "UNSIGNED",
        "IRETURN_I8"=> "LONGLONG",
        "IRETURN_U8"=> "ULONGLONG",
        "IRETURN_F4"=> "FLOAT",
        "IRETURN_F8"=> "DOUBLE",
      );

    my $ret_type;
    if($parameter->attribute("method") =~ /Immediate/) {
        my $immediate = &MDS::fetch($parameter->attribute("method"));
        my $width = $immediate->attribute("width");
        $ret_type = "IRETURN_";
        croak("Immediate size greater than 32 bits") if($width > 32);
        $ret_type .= $immediate->attribute("extend") eq "Signed" ? "I" : "U";
        $ret_type .= $width % 8 ? int(($width / 8) + 1) : int($width / 8);
    } elsif ($parameter->attribute("method") =~ /Modifier/) {
        my $enum =  $parameter->attribute("method");
        $enum =~ s/Modifier\-.*\-//;
   #      print STDERR "Modifier ", $parameter->attribute("method"), " $enum\n";
        ## map enum to int. 
        ## '#' is used as a separator instead '_' because '_' is already
        ##  used as an array separator in the flow.
        return lc ("intrn#$enum");
    } else {
        $ret_type = &Target::get_possible_types_for_reg_class($operator,$parameter->attribute("method"),$parameter);
    }
    croak("Undefined type for $ret_type") if (not defined $type_cvt{$ret_type});
    return $type_cvt{$ret_type};
}

sub getBuiltinPrototype {
    my $operator = shift;


    my @parameters = &TargInfo::operator_parameters ($operator);
    my $proto = "BT_FN";
    my $result_defined;
## has_dedicated_return contains proxy "%i" if defined
    my $has_dedicated_return = undef;
    my $has_dedicated_same_res = 0;
    my @dedicated_reg_param;

    foreach my $param (@parameters) {
        if (defined $has_dedicated_return and isValidInputParameter($param) and
            $param->attribute("proxy") eq $has_dedicated_return) {
            my $name = $operator->{O64}{INTRN_NAME};
            $has_dedicated_same_res = 1;
        }
        if(isValidOutputParameter($param)) {
            if(not isPairedParameter($param)) {
                if(isDedicatedRegister($param)) {
                    $has_dedicated_return = $param->attribute("proxy");
                    $proto .= "_VOID";
                }
                else {
                    $proto .= "_".getProtoParameterType($operator,$param);
                    $result_defined = $param;
                }
            }
        }
    }

    if(defined $has_dedicated_return) {
        foreach my $param (@parameters) {
            if(isValidOutputParameter($param)) {
                if(isDedicatedRegister($param) and
                    not isPairedParameter($param) and
                    (not ($has_dedicated_same_res or
                            $has_dedicated_return ne $param->attribute("proxy")))
                  ) {
                    $proto .= "_UNSIGNED";
                }
            }
        }
    }

    if(not defined $result_defined) {
        croak("No result defined and intrinsic is not declared side effects for ".$operator->attribute("ID")) if( not hasSideEffects($operator));
        if(not defined $has_dedicated_return) {
            $proto .= "_VOID";
        }
    }

    foreach my $param (@parameters) {
        if(isValidInputParameter($param)) {
            if(not isPredicateParameter($param) and
                not isPairedParameter($param)) {
                if(isDedicatedRegister($param)) {
                    $proto .= "_UNSIGNED";
                }
                else {
                    $proto .= "_".getProtoParameterType($operator,$param);
                }
            }
        }
    }

    return $proto;
}

sub getMacroPrototype {
    my $operator = shift;

    my @parameters = &TargInfo::operator_parameters ($operator);
    my $result_defined;
## has_dedicated_return contains proxy "%i" if defined
    my $has_dedicated_return = undef;
    my $has_dedicated_same_res = 0;
    my @dedicated_reg_param;
    my $opnd_name = 'a';
    my @macro_operands;

    foreach my $param (@parameters) {
        if (defined $has_dedicated_return and isValidInputParameter($param) and
            $param->attribute("proxy") eq $has_dedicated_return) {
            $has_dedicated_same_res = 1;
        }
        if(isValidOutputParameter($param)) {
            if(isDedicatedRegister($param)) {
                $has_dedicated_return = $param->attribute("proxy");
            }
            else {
                push @macro_operands, { PARAM=> $param, OPND=> $opnd_name, };
                $result_defined = $param;
                $opnd_name++;
            }
        }

    }

    if(defined $has_dedicated_return) {
        my $name = $operator->{O64}{INTRN_NAME};
        foreach my $param (@parameters) {
            if(isValidOutputParameter($param)) {
                if(isDedicatedRegister($param)
                    and (not ($has_dedicated_same_res or
                            $has_dedicated_return ne $param->attribute("proxy")))) {
                    push @macro_operands, { PARAM=> $param, OPND=> $opnd_name, };
                    $opnd_name++;
                }
            }
        }
    }

    if(not defined $result_defined) {
        croak("No result defined and intrinsic is not declared side effects for ".$operator->attribute("ID")) if( not hasSideEffects($operator));
    }

    foreach my $param (@parameters) {
        my $method = $param->attribute("method");
        if (defined $method and
            $method =~ /^Modifier/ ) {
            push @macro_operands, { PARAM=> $param, OPND=> $opnd_name, };
            $opnd_name++;
        } else {
            if(isValidInputParameter($param)) {
                if(not isPredicateParameter($param) ) {
                    # Do not duplicate same_res parameters
                    if(not (&Target::doNotSplitInOutParameterInMacros() and
                            defined $result_defined and
                            $result_defined->attribute("proxy") eq $param->attribute("proxy"))) {
                        push @macro_operands, { PARAM=> $param, OPND=> $opnd_name, };
                        $opnd_name++;
                    }
                }
            }
        }
    }
    return \@macro_operands;
}

sub getReturnType {
    my $operator = shift;
    my $return_opd;

    my %paired_cvt = (
        "IRETURN_V" => "IRETURN_V",
        "IRETURN_I1"=> "IRETURN_I2",
        "IRETURN_I2"=> "IRETURN_I4",
        "IRETURN_U1"=> "IRETURN_U2",
        "IRETURN_U2"=> "IRETURN_U4",
        "IRETURN_I4"=> "IRETURN_I8",
        "IRETURN_U4"=> "IRETURN_U8",
        "IRETURN_F4"=> "IRETURN_F8",
      );


    foreach my $param (&TargInfo::operator_parameters ($operator)) {
        if(defined $param->attribute("proxy") and
            $param->attribute("action") eq "Write" and not defined $return_opd) {
            $return_opd = $param;
        }
    }
    if(defined $return_opd and not isDedicatedRegister($return_opd)) {
        my $mtype =
          &Target::get_possible_types_for_reg_class($operator,
            $return_opd->attribute("method"),
            $return_opd);
        my $param_info = $return_opd->{O64}{INTRN_PARAM_INFO};
        if(defined $param_info->{PAIRED0}) {
            $mtype = $paired_cvt{$mtype};
        }
        return $mtype;
    }
    return "IRETURN_V";
}

sub hasImmediateOpnd {
    my $operator = shift;
    my @parameters = &TargInfo::operator_parameters ($operator);
    foreach my $param (@parameters) {
        if($param->attribute("method") =~ /Immediate/) {
            return 1;
        }
    }
    return 0;
}

sub immediateOpndAccepted {
    my ($operator) = @_;

    if(hasImmediateOpnd($operator)) {
        if(&Target::genIntrnWithImmediateOpnd($operator)) {
            return 1;
        }
        else {
            return 0;
        }
    }
    return 1;
}

sub buildIntrinsicNames {
    my $operators = shift;
    my %intrinsicNames;

    foreach my $operator (@$operators) {
        #print STDERR $operator->attribute("ID"), "\n";
        my $syntax = $operator->attribute("syntax");
        if (&Target::generate_intrinsic($operator) and
            &immediateOpndAccepted($operator)) {
            my @parameters = &TargInfo::operator_parameters ($operator);

            # Get parameters with proxy
            my %proxies;
            foreach my $parameter (@parameters) {
                if (defined $parameter->attribute("proxy")) {
                    if(defined $proxies{$parameter->attribute("proxy")}) {
                        my $params = $proxies{$parameter->attribute("proxy")};

                        die ($operator->name(),": Action already defined for proxy: ",
                            $parameter->attribute("proxy"))
                          if(defined $$params{$parameter->attribute("action")});

                        $$params{$parameter->attribute("action")} = $parameter;
                    }
                    else {
                        my $proxy = $parameter->attribute("proxy");
                        if(defined $syntax and ($syntax =~ /$proxy:(\%[0-9]+)/ or $syntax =~ /(\%[0-9]+):$proxy/)) {
                            if($syntax =~ /$proxy:(\%[0-9]+)/) {
                                $proxies{$proxy} = { $parameter->attribute("action") => $parameter, PAIRED0 => $1 };
                            }
                            elsif($syntax =~ /(\%[0-9]+):$proxy/) {
                                $proxies{$proxy} = { $parameter->attribute("action") => $parameter, PAIRED1 => $1 };
                            }
                        }
                        else {
                            $proxies{$proxy} = { $parameter->attribute("action") => $parameter };
                        }
                    }
                }
            }

            # Get explicit parameters
            my $intrinsic_comment;
            my $results;
            my $has_paired_result=0;
            my $operands;
            my $opnd_separator="";
            my $rslt_separator="";
            my $explicit_results_nb = 0;
            my @explicit_parameters;
            $intrinsic_comment = "/* $syntax";
            $syntax =~ s|(%\d+)| $1 |g;
            $syntax =~ s|\s+| |g;
            foreach my $syntax_item (split /[%\s]/, $syntax) {
                if ($syntax_item =~ /^(\d+)/) {
                    my $proxy = "%".$1;
                    my $proxy_id = $1-1;
                    #print STDERR "SYNTAX=$syntax\n";
                    if ($proxy ne "%0") {
                        die "Unknown proxy $proxy" if not defined $proxies{$proxy};
                        my $parameter = defined $proxies{$proxy}{"Write"} ? $proxies{$proxy}{"Write"} : $proxies{$proxy}{"Read"};
                        my $reg_class = &MDS::fetch($parameter->attribute("method"))->{O64}{NAME};
                        if($reg_class =~ /^LC_(.*)$/) {
                            $reg_class = "<".&Target::getSimplifiedImmediate(&MDS::fetch($parameter->attribute("method"))).">";
                        }
                        $reg_class =~ s/^ISA_REGISTER_CLASS_(.*)$/$1/;
                        $reg_class =~ s/^ISA_EC_(.*)$/intrn_$1/;

                        $explicit_parameters[$proxy_id] = $proxies{$proxy};
                        if (defined $proxies{$proxy}{"Write"}) {
                            $explicit_results_nb++;
                            if(my $reg_file_size = isDedicatedRegisterClass($parameter->attribute("method")) and
                                not defined $proxies{$proxy}{"Read"}) {
                                # Dedicated same res must be given only one time
                                $operands .= $opnd_separator."u[0..".eval($reg_file_size-1)."]";
                                $opnd_separator = ", ";
                            }
                            else {
                                $results .= $rslt_separator.$reg_class;
                                if(defined $proxies{$proxy}{PAIRED0}) {
                                    $has_paired_result=1;
                                    $rslt_separator = ":";
                                }
                            }
                        }
                        if(defined $proxies{$proxy}{"Read"} and not isPredicateParameter($proxies{$proxy}{"Read"})) {
                            if(my $reg_file_size = isDedicatedRegisterClass($parameter->attribute("method"))) {
                                $operands .= $opnd_separator."u[0..".eval($reg_file_size-1)."]";
                                $opnd_separator = ", ";
                            }
                            else {
                                $operands .= $opnd_separator.$reg_class;
                                $opnd_separator = ", ";
                                if(defined $proxies{$proxy}{PAIRED0}) {
                                    $opnd_separator = ":";
                                }
                            }
                        }
                        if(defined $proxies{$proxy}{"Read"} and isPredicateParameter($proxies{$proxy}{"Read"})) {
                            $intrinsic_comment =~ s/$proxy//;
                        }
                        else {
                            $intrinsic_comment =~ s/$proxy/$reg_class/;
                        }
                    }
                    else {
                        my $mnemonic = $operator->attribute("mnemonic");
                        $intrinsic_comment =~ s/%0/$mnemonic/;
                    }
                }
            }

            if ($explicit_results_nb > 1 and not $has_paired_result) {
                print STDERR "WARNING: ".$operator->attribute("ID")." contains more than one explicit result. Cannot generate intrinsic.\n";
            } else {

                $intrinsic_comment .= "\n * ";
                $intrinsic_comment .= $results if defined $results;
                $intrinsic_comment .= " ".$operator->attribute("mnemonic")."( ";
                $intrinsic_comment .= $operands if defined $operands;
                $intrinsic_comment .= ");\n";
                $intrinsic_comment .= " */\n";

                my $intrinsic_name = &Target::intrinsicName($operator) || $operator->{O64}{NAME};
                $intrinsic_name = join ' ', map { $_ =~ s|^TOP_||; $_ } split ' ', $intrinsic_name;
                if(not defined $intrinsicNames{$intrinsic_name}) {
                    $operator->{O64}{INTRN_NAME} = $intrinsic_name;
                    $operator->{O64}{INTRN_COMMENT} = $intrinsic_comment;
                    $intrinsicNames{$intrinsic_name} = $operator;
                }
                push @{$intrinsicNames{$intrinsic_name}->{O64}{INTRN_OPRS}}, $operator;

                my $i_index = 0;
                my $o_index = 0;
                my $param;
                foreach $param (@explicit_parameters) {
                    if (defined $$param{"Write"}) {
                        if(my $reg_file_size = isDedicatedRegisterClass($$param{"Write"}->attribute("method"))) {
                            $$param{"Write"}->{O64}{INTRN_PARAM_INFO} = { PARAMETER => $param,
                                TYPE => "explicit",
                                CTYPE => getProtoParameterType($operator,$$param{"Write"}),
                                PAIRED0=> $$param{PAIRED0},
                                PAIRED1=> $$param{PAIRED1},
                                INDEX => $o_index,
                                REG_IDX_RANGE => $reg_file_size
                              };
                        }
                        else {
                            $$param{"Write"}->{O64}{INTRN_PARAM_INFO} = { PARAMETER => $param,
                                TYPE => "explicit",
                                CTYPE => getProtoParameterType($operator,$$param{"Write"}),
                                PAIRED0=> $$param{PAIRED0},
                                PAIRED1=> $$param{PAIRED1},
                                INDEX => $o_index };
                        }
                        $o_index++;
                    }
                    if (defined $$param{"Read"}) {
                        if(my $reg_file_size = isDedicatedRegisterClass($$param{"Read"}->attribute("method"))) {
                            $$param{"Read"}->{O64}{INTRN_PARAM_INFO} = { PARAMETER => $param,
                                TYPE => "explicit",
                                CTYPE => getProtoParameterType($operator,$$param{"Read"}),
                                PAIRED0=> $$param{PAIRED0},
                                PAIRED1=> $$param{PAIRED1},
                                INDEX => $i_index,
                                REG_IDX_RANGE => $reg_file_size };
                        }
                        else {
                            $$param{"Read"}->{O64}{INTRN_PARAM_INFO} = { PARAMETER => $param,
                                TYPE => "explicit",
                                CTYPE => getProtoParameterType($operator,$$param{"Read"}),
                                PAIRED0=> $$param{PAIRED0},
                                PAIRED1=> $$param{PAIRED1},
                                INDEX => $i_index };
                        }
                        $i_index++;
                    }
                }

                my $tmp_index = 0;
                foreach $param (@parameters) {
                    if (not defined $param->attribute("proxy")) {
                        $param->{O64}{INTRN_PARAM_INFO} = { PARAMETER => $param, TYPE => "implicit", INDEX => $tmp_index };
                        $tmp_index++;
                    }
                }
            }
        }
    }
}

1;
# vim: set ts=4 sw=4 et:
