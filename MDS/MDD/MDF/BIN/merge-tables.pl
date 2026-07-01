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

# [JV]: Tables are merged from bottom to top in hierarchie order, so from Storage to Operator.
# This ordering is specified in MDS/configure.ac using MDT_names variable.
# Merge is accumulated in $(FAMILY)/MDT.xml file.
# All XML files that ends with X.table are empty after merge.
# Some entries have cyclic dependencies like Instruction and Synthetic. To fix that, we use
# X.table to remerge the table. This is done by replacing old table in MDT.xml using remove_table.pl. 

use strict "vars";
use strict "subs";

use MDS;
&MDS::parse(*ARGV);

my $debug = 0;
my $TABLE = $ENV{TABLE};
my $FAMILY = $ENV{FAMILY};

# Merge status log
my $merge_log = "merge.log";
my $merge_log_fh;
if(-e $merge_log) {
    open($merge_log_fh,">>",$merge_log) or die "Unable to open $merge_log";
}
else {
    open($merge_log_fh,">",$merge_log) or die "Unable to open $merge_log";
}

sub print_log {
    my @msgs = @_;
    map {
        print STDERR "$_";
        print $merge_log_fh "$_";
      } @msgs;
}

# Import dynamically constructed Perl code that includes %MDT and sub fixIDs.
do './MDT.pl';

# Soft reference, e.g if $TABLE eq 'Operator' then $table = \@Operator::table.
my $table = \@{"${TABLE}::table"};
my $noname = \@{"${TABLE}::noname"};

my %coreTables = (
    "Processor" => "ID",
    "Opcode" => "ID",
    "Decoding" => "ID",
  );

my %hasProcessors = (
    "Instruction" => "ID",
    "Synthetic" => "ID",
    "Scheduling" => "ID",
    "Resource" => "ID",
    "RegFile" => "ID",
    "RegClass" => "ID",
    "Register" => "ID",
    "Relocation" => "ID",
    "Convention" => "ID",
    "Builtin" => "ID",
  );

my %processors;
foreach my $processor (@Processor::table) {
    my $processorCore = $processor->core();
    $processors{$processorCore} = $processor;
}

my %table = ();
#foreach my $element (sort { $a->attribute("ID") cmp $b->attribute("ID") } @{$noname}, @{$table}) {
foreach my $element (@{$noname}, @{$table}) {
    &process($element);
}

my @elements = sort {
    $$a{ORDERING} <=> $$b{ORDERING}
  } grep {defined} values %table;
foreach my $element (@elements) {
    print $element->emit();
}

sub fixElement {
    my $element = shift;
    my $element_type = $element->type();
    my $element_core = $element->core();
    my $element_processor = $processors{$element_core} if(defined $element_core);
    my $attlist = $element->attlist();
    # Fix the ID names in the $element attributes.
    my $attributes = $$element{ATTRIBUTES};
    my %tmp_attributes = %{$attributes};
    while (my ($name, $value) = each %tmp_attributes) {
        if ($$attlist{$name}[0] =~ /^ID(REF|REFS)?\b/) {
            if ($value =~ s/\-[^\-]+\-$/\-$FAMILY\-/) {
           # Special case the 'undefined' elements (whose ID is Element-$core-).
                $$attributes{$name} = $value;
            } else {
# [JV] Try first core elements. This is because some tables are merged twice due to cyclic dependencies.
                my $orig_processor = $element_processor;
                my $orig_core = $element_core;
                if(defined $orig_core and $orig_core eq $FAMILY
                    and defined $$element{ATTRIBUTES}{processors}) {
                    my @processors = $element->access("processors");
                    $orig_processor = $processors[0];
                }
                $value =~ s/\-$FAMILY\-/-${orig_core}-/g if(defined $orig_core);
# Special case the 'undefined' elements (whose ID is Element-$core-).
# If ref on current table type (i.e Immediate canExtend field, get the merged IDs
                if($name ne "ID" and defined $element_type and $value =~ /^$element_type/) {
                    my @vals = $element->access($name);
                    my @merged_values;
                    map { push @merged_values, &fixIDs("ID",$_->attribute("ID")); } @vals;
                    $$attributes{$name} = join(' ',@merged_values);
                } else {
    # For Opcode we want to keep one Opcode per core but with merged attributes.
                    if(!(defined $element_type and defined $coreTables{$element_type} and $coreTables{$element_type} eq $name)) {
                        $$attributes{$name} = &fixIDs($name,$value);
                        if(defined $element_type and $hasProcessors{$element_type} and
                            defined $element_processor and $name eq "ID") {
                            my $element_processorID = $element_processor->attribute("ID");
                            if(defined $$element{ATTRIBUTES}{processors} and $$element{ATTRIBUTES}{processors} !~ /${element_processorID}/) {
                                $$element{ATTRIBUTES}{processors} .= " ${element_processorID}";
                            } else {
                                $$element{ATTRIBUTES}{processors} = "${element_processorID}";
                            }
                        }
                    }
                }
            }
        }
    }
    my $contents = $$element{CONTENTS};
    map {&fixElement($_) if ref $_} @{$contents};
    return $element;
}

my $ordering = 0;
sub process {
    my $element = shift;
    my $elementID = $$element{ATTRIBUTES}{ID};
    if (defined $elementID) {
        my $clone = $element->clone();
        $$clone{MERGED} = [ $element ];
        $$clone{ELEMENTID} = $elementID;
        # Fix the ID names in the $clone.
        &fixElement($clone);
        my $ID = $$clone{ATTRIBUTES}{ID};
        if (exists $table{$ID}) {
            if (defined $table{$ID}) {
                my $merged = $table{$ID};
                my @errors = &merge($merged, $clone);
                if (@errors) {
                    # Merge errors.
                    print_log(@errors);
                    # Enter the clone with $elementID.
                    my $cloneID = $elementID;
                    $$clone{ATTRIBUTES}{ID} = $cloneID;
                    $$clone{ORDERING} = ++$ordering;
                    $table{$cloneID} = $clone;
                } else {
                    # Merge OK.
                    push @{$$merged{MERGED}}, @{$$clone{MERGED}};
                }
            } else {
               # $table{$ID} undefined but entry exists, meaning must not merge.
               # Fix and enter the original element in %table to get it emitted.
                my $fixedID = $$element{ATTRIBUTES}{ID};
                my $fixed = &fixElement($element->clone());
                $$fixed{ATTRIBUTES}{ID} = $fixedID;
                $$fixed{ORDERING} = ++$ordering;
                $table{$fixedID} = $fixed;
            }
        } else {
            # Enter the fixed $clone in the %table.
            $$clone{ORDERING} = ++$ordering;
            $table{$ID} = $clone;
        }
    } else {
        die "missing ID for element:\n", $element->emit();
    }
}

sub merge {
    my @errors = &maybe_merge(0, @_);
    return @errors if (@errors);
    return &maybe_merge (1, @_);
}

sub maybe_merge {
    my @errors;
    my $do_merge = shift;
    my ($this, $that) = @_;
    my $element = ref $this;
    my $attlist = $this->attlist();
    my $this_attributes = $$this{ATTRIBUTES};
    my $that_attributes = $$that{ATTRIBUTES};
    while (my ($name, $declare) = each %{$attlist}) {
        my $this_value = $$this_attributes{$name};
        my $that_value = $$that_attributes{$name};
        my ($type, $option) = @{$declare};
        if (defined $this_value) {
            if (defined $that_value) {
# print STDERR "$element:\tmerging $name ($type, $option) ($this_value <=> $that_value)\n";
# Hard-code how to merge elements: should be modularized.
                if (   ($element eq 'Parameter' && $name eq 'stages')
                    || ($element eq 'Operator' && $name eq 'origins')
                    || ($element eq 'Resource' && $name eq 'availability')
                    || $name eq "processors") {
                    # Append attributes.
                    $$this_attributes{$name} .= " $that_value" if ($do_merge);
                } elsif (   ($element eq 'Dispersal' && $name eq 'contains')
                    || ($element eq 'Register' && $name =~ /^(classes|aliases)$/)) {
                    # Union attributes.
                    my @this_value = split ' ', $this_value;
                    my @that_value = split ' ', $that_value;
                    my %value; map {++$value{$_}} @this_value, @that_value;
                    my $value = join ' ', (sort keys %value);
                    $$this_attributes{$name} = $value if ($do_merge);
                } elsif ($this_value ne $that_value) {
                    if ($name ne 'what') {
                        push @errors, "$element\@$name '$this_value' and '$that_value' differ\n";
                    }
                }
            }
        } else {
            $$this_attributes{$name} = $that_value if ($do_merge);
        }
    }
    my $this_contents = $this->contents();
    my $that_contents = $that->contents();
    my $length = @{$this_contents};
    if ($length != @{$that_contents}) {
        push @errors, "contents length differ\n";
    } else {
        for (my $i = 0; $i < $length; $i++) {
            my $this_child = $$this_contents[$i];
            my $that_child = $$that_contents[$i];
            if (ref $this_child eq ref $that_child) {
                if (ref $this_child) {
                    push @errors, &maybe_merge($do_merge, $this_child, $that_child);
                } else {
                    if ($element eq 'Semantics') {
                        # Purge the Semantics dates before comparing.
                        $this_child =~ s/\b(EFFECT|THROW|LOAD|STORE|PROBE)\.\d+/$1\./g;
                        $that_child =~ s/\b(EFFECT|THROW|LOAD|STORE|PROBE)\.\d+/$1\./g;
                    }
                    if ($this_child ne $that_child) {
                        push @errors, "$element contents '$this_child' and '$that_child' differ\n";
                    }
                }
            } else {
                push @errors, "$element contents differ\n";
            }
        }
    }
    my $firstID = $$this{ELEMENTID};
    my $secondID = $$that{ELEMENTID};
    # Special cases to merge even in case of errors.
    if (@errors) {
        if ($element eq 'Operator') {
            my $name = $this->name();
            if ($FAMILY eq 'st200') {
                if (   $name eq 'mov_bdest_1branch_2general'
                    || $name eq 'mov_bsrc_1general_2branch'
                    || $name eq 'bswap_1general_2general'
                    || $name eq 'sxtb_1general_2general'
                    || $name eq 'sxth_1general_2general'
                    || $name eq 'zxth_1general_2general'
                    || $name eq 'syncins'
                  ) {
                    &print_log("Force merge of $firstID and $secondID\n");
                    @errors = ();
                }
            }
        }
    }
    if (@errors) {
        if (defined $firstID && defined  $secondID) {
            &print_log("Could not merge $firstID and $secondID because ");
        }
    }
    return @errors;
}

close($merge_log_fh);
# vim: set ts=4 sw=4 et:
