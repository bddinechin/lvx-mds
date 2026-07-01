#!/usr/bin/perl -w
# Machine Description System (MDS)
#
# Copyright (C) 2005 STMicroelectronics
#
# Benoit Dupont de Dinechin (Benoit.Dupont-de-Dinechin@st.com).
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

package Bundles;

use strict;
use warnings "FATAL" => "all";

# Internally in this file, we represent a bundling as
# a bit in an integer.  This allows us to represent a
# set of bundlings as an integer with multiple bits set.

# These are the bundling rules we support.
my $ALONE = 1;
my $ALONEX = 2;
my $FIRST = 4;
my $ODD = 8;
my $EVEN = 16;
my $MEM = 32;
my $ANY = 64;
my $ANYX = 128;
my $MEMX = 256;

# Map from bundling name to the integer that represents it.
my %bundling_bit = (
                ALONE=>    $ALONE,
                ALONEX=>   $ALONEX,
                FIRST=>    $FIRST,
                ODD=>      $ODD,
                EVEN=>     $EVEN,
                MEM=>      $MEM,
                ANY=>      $ANY,
                ANYX=>     $ANYX,
                MEMX=>     $MEMX,
                );

my %bundling_name = reverse %bundling_bit;

# List of bundlings used on this target.
my @all_bundlings;

# Number of dispersals per bundling, indexed by bundling bit.
my %dispersals;

# Textual description of bundling, indexed by bundling bit.
my %bundling_desc;

# Number of lanes supported.
my $max_lanes;

sub oddP {
    my $val = shift;
    return ($val & 1) != 0;
}

sub bitcnt {
    my $val = shift;
    my $cnt = 0;
    while ($val != 0) {
        $val -= $val & -$val;
        $cnt++;
    }
    return $cnt;
}

sub stepped_list {
    my ($start, $end, $step) = @_;
    my $count = int (($end - $start) / $step);
    return map {
        $start + $_ * $step;
    } (0..$count);
}

sub log2 {
    my $val = shift;
    my $result = 0;
    for my $bit (0..31) {
        return $bit if ((1 << $bit)  == $val);
    }
    die "Invalid arg to log2", $val;
}

# Return the number of dispersals required for a sequence of
# bundling sets.
sub dispersals {
    my $r = 0;
    foreach my $bundling (@_) {
        my $highbit = $bundling & -$bundling;
        $r += $dispersals{$highbit};
    }
    return $r;
}

sub legalBundleP {
    my $bundle_lane = shift;
    my @bundlings = @_;
    my $dispersal = 0;
    my $opnum = 0;
    my $n_bundlings = scalar(@bundlings);
    my %count = map { $_ => 0; } values %bundling_bit;

    return 0 if $n_bundlings == 0;
    return 0 if &dispersals(@bundlings) > $max_lanes;
    foreach my $bundling (@bundlings) {
        my $lane = ($bundle_lane + $dispersal) % $max_lanes;
        return 0 if (($bundling & $FIRST) && $opnum != 0);
        return 0 if ($bundling & $ODD) && ! &oddP($lane);
        return 0 if ($bundling & $EVEN) && &oddP($lane);
        return 0 if ($bundling & ($ALONE|$ALONEX)) && ($n_bundlings > 1);
        if ($bundling & ($MEM|$MEMX)) {
            my $mem_lane = ((($bundling & $MEMX) && ! &oddP($lane))
                             ? (($lane + 1) % $max_lanes)
                             : $lane);
            # operation in mem_lane will be swapped with operation in lane 0,
            # so ensure that mem_lane is legal for the operation in lane 0.
            my $other_lane = $bundle_lane;
            foreach my $other_bundling (@bundlings) {
                if ($other_lane == 0) {
                    return 0 if (($other_bundling & $ODD) && ! &oddP($mem_lane));
                    return 0 if (($other_bundling & $EVEN) && &oddP($mem_lane));
                }
                $other_lane = ($other_lane
                               + &dispersals($other_bundling)) % $max_lanes;
            }
        }
        foreach my $bit (values %bundling_bit) {
            $count{$bit}++ if ($bundling & $bit);
        }
        $dispersal += &dispersals($bundling);
        $opnum++;
    }
    # This is really resource checking and so should be done by the scheduler,
    # but it lets us discard some unused bundles early.
    return 0 if ($count{$MEM} + $count{$MEMX}) > 1;

    return 1;
}

sub makeBundle {
    my $lane = shift;
    my @bundlings = @_;
    return { lane => $lane, bundlings => \@bundlings };
}

sub bundle {
    my $lane = shift;
    my @bundlings = @_;
    my @bundle_list;
    foreach my $bundling (@all_bundlings) {
        my @new_bundlings = (@bundlings, $bundling);
        if (&legalBundleP ($lane, @new_bundlings)) {
            push @bundle_list, &makeBundle ($lane, @new_bundlings);
            push @bundle_list, &bundle ($lane, @new_bundlings);
        }
    }
    return @bundle_list;
}

my @all_bundles;
sub makeBundles {
    foreach my $lane (0..$max_lanes-1) {
        push @all_bundles, &bundle($lane);
    }
}

my $next_dispersal = 0;

my %dispersal_offset;
my %dispersal_bundling;
my %dispersal_align;
sub newDispersal {
    my ($offset, $bundling, $align) = @_;
    my $name = "s$next_dispersal";
    $next_dispersal++;
    $dispersal_offset{$name} = $offset;
    $dispersal_bundling{$name} = $bundling;
    $dispersal_align{$name} = $align;
#    print STDERR "newDispersal $name offset $offset align $align ";
#    &printBundlings (*STDERR, $bundling);
#    print STDERR "\n";
    die if &dispersals($bundling) == 2 && $align eq "any";
    return $name;
}

my $next_template = 0;
my %template_lane;
my %template_bundlings;
my %template_dispersals;

sub newTemplate {
    my $bref = shift;
    my @bundlings = @{$$bref{"bundlings"}};
    my $lane = $$bref{"lane"};
    my $name = "t$next_template";

    $next_template++;
    $template_lane{$name} = 1 << $lane;
    @{$template_bundlings{$name}} = @bundlings;

    return $name;
}

sub cmpTemplateBundling {
    # Compare two templates by their bundlings.

    my $sig1 = &signature($a);
    my $sig2 = &signature($b);
    return $sig1 cmp $sig2 if $sig1 ne $sig2;
    
    my @bundlings1 = @{$template_bundlings{$a}};
    my @bundlings2 = @{$template_bundlings{$b}};
    # Bundling counts should match, otherwise signatures differ above.
    die "Bundling counts mismatch" if scalar @bundlings1 != scalar @bundlings2;
    
    foreach my $bundling1 (@bundlings1) {
        my $bundling2 = shift @bundlings2;
        my $s_bundling1 = &dispersals($bundling1);
        my $s_bundling2 = &dispersals($bundling2);
        # Dispersal sizes should match, otherwise signatures differ above.
        die "Dispersal size mismatch" if $s_bundling1 != $s_bundling2;
        my $b_bundling1 = &bitcnt($bundling1);
        my $b_bundling2 = &bitcnt($bundling2);
        return $b_bundling2 <=> $b_bundling1 if $b_bundling1 != $b_bundling2;
    }

    return $a cmp $b;
}

sub canMergeP {
    my $t1 = shift;
    my $t2 = shift;
    my $bundlingnum_to_check = shift;

#    print STDOUT "canMergeP (bundling $bundlingnum_to_check):\n";
#    printTemplates (*STDOUT, $t1, $t2);

    my @t1_bundlings = @{$template_bundlings{$t1}};
    my @t2_bundlings = @{$template_bundlings{$t2}};
    die "Laning mistmatch" if ($template_lane{$t1} != $template_lane{$t2});
    die "Bundling count mismatch" if (scalar @t1_bundlings
                                      != scalar @t2_bundlings);
    my $n_diffs = 0;
    my $t1_subset = 1;
    my $t2_subset = 1;
    my $bundlingnum = 0;
    my $diff_bundlingnum = -1;

    foreach my $t1_bundling (@t1_bundlings) {
        my $t2_bundling = shift (@t2_bundlings);
        my $common_bundling = $t1_bundling & $t2_bundling;
        die if &dispersals($t1_bundling) != &dispersals($t2_bundling);
        if ($t1_bundling != $t2_bundling) {
            $n_diffs++;
            $diff_bundlingnum = $bundlingnum;
        }
        $t1_subset = 0 if ($common_bundling != $t1_bundling);
        $t2_subset = 0 if ($common_bundling != $t2_bundling);
        $bundlingnum++;
    }
#    print STDOUT "  n_diffs = $n_diffs t1_subset = $t1_subset t2_subset = $t2_subset\n";
    return ($t1_subset || $t2_subset
            || (($n_diffs == 1) &&
                ($diff_bundlingnum == $bundlingnum_to_check)));
}

sub doMerge {
    # Merge into t1 all following templates.
    my $t1 = shift;

    foreach my $t2 (@_) {

#    print STDERR "Merging templates:\n";
#    printTemplates (*STDERR, $t1, $t2);

        $template_lane{$t1} |= $template_lane{$t2};
        my @t1_bundlings = @{$template_bundlings{$t1}};
        my @t2_bundlings = @{$template_bundlings{$t2}};
        @{$template_bundlings{$t1}} = map {
            $_ | shift @t2_bundlings;
        } @t1_bundlings;
        delete $template_bundlings{$t2};
        delete $template_lane{$t2};

#    print STDERR "into:\n";
#    printTemplates (*STDERR, $t1);
    }

    return $t1;
}

sub signature {
    my $template = shift;
    my $lane = $template_lane{$template};
    my @s;

    foreach (0..$max_lanes-1) {
        push @s, $_ if $lane & (1 << $_);
    }
    push @s, "-";
    push @s, map {
        &dispersals($_);
    } @{$template_bundlings{$template}};
    return join "", @s;
}

sub mergeTemplatesByBundling {
    # Merge pairs of templates that differ by just a
    # single dispersal, or where one is a subset of another.

    # Partition templates by their laning and dispersal structure,
    # because we cannot merge templates with differing
    # laning, dispersal sizes or counts.
    my %template_partition;

    foreach my $template (keys %template_lane) {
        my $sig = &signature($template);
        push @{$template_partition{$sig}}, $template;
    }

    foreach my $partition (sort keys %template_partition) {

        my $changed = 1;
        my $pass = 0;

        my %templates = map { ( $_ => 1); } @{$template_partition{$partition}};

        while ($changed) {
            $changed = 0;
            ++$pass;
#            print STDOUT "Template merging, partition $partition pass $pass\n";

#            print STDOUT "Templates contains:\n";
#            printTemplates (*STDOUT, keys %templates);
            foreach my $bundlingnum (0..$max_lanes-1) {
                my @templates_to_do = sort cmpTemplateBundling keys %templates;
                while (@templates_to_do) {
                    my $t1 = shift @templates_to_do;
                    my @t2_done;
                     while (@templates_to_do) {
                        my $t2 = shift @templates_to_do;
                        # Can t1 and t2 be merged?
                        if (&canMergeP($t1, $t2, $bundlingnum)) {
                            # Yes, so merge t2 into t1.
                            doMerge($t1, $t2);
                            delete $templates{$t2};
                            # Rebuild templates_to_do.
                            unshift @templates_to_do, @t2_done;
                            @t2_done = ();
                            $changed = 1;
                        } else {
                            push @t2_done, $t2;
                        }
                    }
                    unshift @templates_to_do, @t2_done;
                }
            }
        }
    }
}

sub buildTemplateHash {
    my %template_hash;

    foreach my $template (keys %template_lane) {
#        print STDERR "buildTemplateHash: ";
#        printTemplates (*STDERR, $template);
        my $lanes = $template_lane{$template};
        my $b = join ',', @{$template_bundlings{$template}};
        foreach my $ln (0..$max_lanes-1) {
            $template_hash{$ln}{$b} = $template if ($lanes & (1 << $ln));
#            print STDERR "  adding to template_hash{$ln}{$b}\n" if ($lanes & (1 << $ln));
        }
    }
    return %template_hash;
}

sub mergeTemplatesByLane {
    my @lanes = @_;
    my %template_hash = &buildTemplateHash;
    my $align;
    # Set align to be the smallest alignment that we will preserve
    # if we merge the lanes.
    for my $i (0..scalar @lanes - 2) {
        my $lane_diff = $lanes[$i+1] - $lanes[$i];
        $align = $lane_diff if !defined $align || ($lane_diff < $align);
    }
#    print STDERR "Merge templates by lane (@lanes):\n";
    my $first_lane = shift @lanes;
template:
    foreach my $t (keys %{$template_hash{$first_lane}}) {
        my @bundlings = split ',', $t;
#        print STDERR "Trying $t ";
#        printBundlings (*STDERR, @{$template_bundlings{$template_hash{$first_lane}{$t}}});
#        print STDERR ":\n";
        # Multi-dispersal attrs cannot be given a different alignment
        # because the position of the extension words may change
        # depending on the alignment, and the template encodes the position
        # of the extension words in the patterns field.
        foreach my $bundling (@bundlings) {
            next template if &dispersals($bundling) > $align;
        }
        foreach my $lane (@lanes) {
            next template if (!exists $template_hash{$lane}{$t});
        }
        
        # Merge all templates on the different lanes
        # into a single template that is allowed on the union
        # of the lanes.
        my $template = $template_hash{$first_lane}{$t};
        my %to_merge;
        foreach my $ln (@lanes) {
            $to_merge{$template_hash{$ln}{$t}} = 1;
        }
        delete $to_merge{$template} if exists $to_merge{$template};
        &doMerge ($template, keys %to_merge);
        # Fix up template_hash
        foreach my $ln2 (@lanes) {
            $template_hash{$ln2}{$t} = $template;
        }
    }
}
            
sub cmpTemplate {
    # Used for sorting templates.
    my $lane1 = $template_lane{$a};
    my $lane2 = $template_lane{$b};
    return $lane1 <=> $lane2 if $lane1 != $lane2;
    my @bundlings1 = @{$template_bundlings{$a}};
    my @bundlings2 = @{$template_bundlings{$b}};
    my $n_bundlings1 = scalar @bundlings1;
    my $n_bundlings2 = scalar @bundlings2;
    return $n_bundlings1 <=> $n_bundlings2 if $n_bundlings1 != $n_bundlings2;
    foreach my $bundling1 (@bundlings1) {
        my $bundling2 = shift @bundlings2;
        return $bundling1 <=> $bundling2 if $bundling1 != $bundling2;
    }
    return 0;
}

sub cmpDispersal {
    my $syl1 = $a;
    my $syl2 = $b;

#    print STDOUT "cmpDispersal $syl1 $syl2";
    my $off1 = $dispersal_offset{$syl1};
    my $off2 = $dispersal_offset{$syl2};

    return $off1 <=> $off2 if $off1 != $off2;

    my $bundling1 = $dispersal_bundling{$syl1};
    my $bundling2 = $dispersal_bundling{$syl2};
    my $b_bundling1 = &bitcnt($bundling1);
    my $b_bundling2 = &bitcnt($bundling2);
    return $b_bundling2 <=> $b_bundling1 if $b_bundling1 != $b_bundling2;

    return $bundling1 <=> $bundling2 if $bundling1 != $bundling2;
    return $dispersal_align{$syl1} cmp $dispersal_align{$syl2};
}

my @all_templates;
sub makeTemplates {
    # Build a set of templates that all legal bundles can match.
    # A template has the attributes:
    #    - alignment
    #    - a list of "dispersals" (in the MDS sense, not the
    # st200 sense).
    # A dispersal has the attributes:
    #   - offset from start of bundle
    #   - set of Bundlings that can use it
    # A Bundling has as an attribute the set of dispersals
    # to which the Bundling can be allocated.
    # Each instruction has a Bundling attribute.
    #
    # In the extreme case, we could create a separate dispersal for
    # each unique dispersal of each bundle, but we want to
    # factorize this as much as possible, to reduce the number
    # of dispersals.
    # The unique properties of a dispersal are:
    #  1. position  2. set of bundlings that use it
    #  3. alignment
    # whenever these properties are the same, we can use a single
    # dispersal. (Note alignment affects the contents of a dispersal
    # when it affects the coding: e.g. on st200, immediate extensions
    # are coded differently for odd and even alignment.)
    
    foreach my $bundle (@all_bundles) {
        &newTemplate ($bundle);
    }

#    printf STDERR "Templates before merging (%d off):\n",
#                  scalar keys %template_lane;
#    &printTemplates (*STDERR, sort cmpTemplate keys %template_lane);

#    print STDERR "Merge templates by lane\n";
    # The idea here is to merge the strictest laning requirements first,
    # then the next most strict etc.
    # so that we gradually relax the laning requirements.
    # In practice, on st200, this merges lanes 0 and 2, then lanes 1 and 3,
    # and finally lanes 0,1,2 and 3.

    foreach my $pow (reverse (0..&log2($max_lanes)-1)) {
        my $step = 1 << $pow;
        foreach my $bias (0..$step-1) {
            my @lanes = map {
                $_+$bias;
            } (&stepped_list(0, $max_lanes-1, $step));
            &mergeTemplatesByLane (@lanes);
        }
    }

#    printf STDERR "Templates after lane merging (%d off):\n",
#                  scalar keys %template_lane;
#    &printTemplates (*STDERR, sort cmpTemplateBundling keys %template_lane);

#    print STDERR "Merge templates by bundlings\n";
    &mergeTemplatesByBundling;
#    printf STDERR "Templates after merging bundlings (%d off):\n",
#                  scalar keys %template_lane;
#    &printTemplates (*STDERR, sort cmpTemplate keys %template_lane);

    @all_templates = sort cmpTemplateBundling keys %template_lane;
}

my @all_dispersals;
sub makeDispersals {
    # The unique properties of a dispersal are:
    #  1. position
    #  2. set of bundlings that use it
    # whenever these properties are the same, we can use a single
    # dispersal.
    # Index by position, set of bundlings.
    my %dispersal_hash;
    my $next_dispersal = 0;

    foreach my $template (@all_templates) {
        my $lane = 0;
        until ($template_lane{$template} & (1 << $lane)) { $lane++; }
        my @bundlings = @{$template_bundlings{$template}};
        my $offset = 0;
        foreach my $bundling (@bundlings) {
            my $size = &dispersals($bundling);
            my $align = ($size > 1) ? ("even", "odd")[&oddP($offset+$lane)]
                                    : "any";
#            print STDERR "makeDispersals $size $align \n";
#            printBundlings(*STDERR, $bundling);
#            print STDERR "\n";
            if (!exists $dispersal_hash{$offset}{$bundling}{$align}) {
                my $name = &newDispersal ($offset, $bundling, $align);
                $dispersal_hash{$offset}{$bundling}{$align} = $name;
                push @all_dispersals, $name;
            }
            push @{$template_dispersals{$template}},
            $dispersal_hash{$offset}{$bundling}{$align};
            $offset += &dispersals($bundling);
        }
    }
    @all_dispersals = sort cmpDispersal @all_dispersals;
}
    
my %template_name;
sub nameTemplates {
    my $num = 0;
    foreach my $template (@all_templates) {
        $template_name{$template} = "T$num";
        $num++;
    }
}

my %dispersal_name;
sub nameDispersals {
    my $num = 0;
    foreach my $dispersal (@all_dispersals) {
        $dispersal_name{$dispersal} = "S$num";
        $num++;
    }
}

our @MDSBundlings;
sub makeMDSBundlings {
    
    my %bundle_dispersals;
    foreach my $dispersal (@all_dispersals) {
        my $dispersal_bundling = $dispersal_bundling{$dispersal};
        foreach my $bundling (@all_bundlings) {
            if ($dispersal_bundling & $bundling) {
                push @{$bundle_dispersals{$bundling}}, $dispersal;
            }
        }
    }

    foreach my $bundling (@all_bundlings) {
        my $ID = $bundling_name{$bundling};
        my $dispersals = join " ", (map { $dispersal_name{$_}; } 
                                   @{$bundle_dispersals{$bundling}});
        push @MDSBundlings, &MDS::make("Bundling", {
            ID=>     &Bundling::ID($ID),
            what=>   $bundling_desc{$bundling},
            dispersals=> &Dispersal::IDs($dispersals),
        });
    }
}

our @MDSDispersals;
sub makeMDSDispersals {
    foreach my $dispersal (@all_dispersals) {
        my $ID = $dispersal_name{$dispersal};
        my $word_offset = $dispersal_offset{$dispersal};
        my $byte_offset = $word_offset * 4;
        my $size = &dispersals($dispersal_bundling{$dispersal});
        my $fromFields = join ' ', map { "ENCODE.$_"; } (0..$size-1);
        my @toFields = map { "ENCODE.$_"; } ($word_offset..$word_offset+$size-1);
        # Even aligned dispersals have the immediate extension in the first
        # word.
        @toFields = reverse @toFields if ($dispersal_align{$dispersal} eq "even");
        my $toFields = join ' ', @toFields;
        die "$dispersal $size ", $dispersal_align{$dispersal} if $size == 2 && $dispersal_align{$dispersal} eq "any";
        my $attributes = {
            ID=>    &Dispersal::ID($ID),
            fromFields=> &BitField::IDs($fromFields),
            toFields=>   &BitField::IDs($toFields),
            distance=>   $byte_offset,
        };
        $$attributes{nopValues} = "0x00000000" if ($size == 1);
        push @MDSDispersals, &MDS::make("Dispersal", $attributes);
    }
}

our @MDSTemplates;
sub makeMDSTemplates {
    foreach my $template (@all_templates) {
        my $ID = $template_name{$template};
        my @bundlings = @{$template_bundlings{$template}};
        my $size_in_words = &dispersals(@bundlings);
        my %alignBaseBias = (
                             0xf => [ 4,  0],
                             0x5 => [ 8,  0],
                             0xa => [ 8,  4],
                             0x1 => [16,  0],
                             0x2 => [16,  4],
                             0x4 => [16,  8],
                             0x8 => [16, 12], );
        my ($alignBase, $alignBias) = @{$alignBaseBias{$template_lane{$template}}} or die "Unexpected lanes in printTemplateTable";
        my $increment = $size_in_words * 4;
        my $dispersals = join ' ', (map { $dispersal_name{$_}; }
                                   @{$template_dispersals{$template}});
        my @imms;
        my $offset = 0;
        my $odd_aligned = ($alignBias != 0);
        foreach (@bundlings) {
            # Insert a pattern for each immediate extension.
            my $dispersals = &dispersals($_);
            if ($dispersals == 2) {
                # Immediate extension on the even lane.
                my $imm_extn = (oddP($offset + $odd_aligned)
                                ? "IMML" : "IMMR");
                my $imm_extn_offset = (($imm_extn eq "IMMR")
                                       ? $offset
                                       : ($offset + 1));
                push @imms, "$imm_extn.32.$imm_extn_offset";
            }
            $offset += $dispersals;
        }
        my $stopbit_word = $size_in_words - 1;
        my $patterns = join ' ', @imms, "STOPBIT.32.$stopbit_word";
        my $nopallow = int (scalar @bundlings / 2);
        $nopallow = 1 if $nopallow == 0;
        push @MDSTemplates, &MDS::make("Template", {
            ID=>      &Template::ID($ID),
            wordWidth=> 32,
            alignBase=> $alignBase,
            alignBias=> $alignBias,
            dispersals=> &Dispersal::IDs($dispersals),
            patterns=>  &Pattern::IDs($patterns),
            increment=> $increment,
            nopAllow=>  $nopallow,
        });
    }
}

# Mapping from chess resource to MDS Bundling name.
my %rename = (
    ALU=>        "ANY",
    ASM=>        "ANY",
    ASM_ALU=>        "ANY",
    ASM_MUL=>        "ODD",
    CTL=>        "FIRST",
    EVEN=>        "EVEN",
    MEM=>        "MEM",
    FPU=>        "ANY",
    ODD=>        "ODD",
    ALL=>        "ALONE",
    PSW=>        "FIRST",
);

sub makeMDSBundleInformation {
    my $records = shift;
    my @bundling_names;

    $max_lanes = 1;

    foreach my $record (@{$records}) {
        my $key = $$record{KEY};
        if (defined $key) {
            (my $name = $key) =~ s/\W/_/g;
            next if $name =~ /^(ASM|ASM_ALU|ASM_MUL|FPU)$/;        # CHESS
            my $mdsname = $rename{$name};
            my $bundling = $bundling_bit{$mdsname};
            if (! defined $dispersals{$bundling}) {
                push @bundling_names, $mdsname;
                push @all_bundlings, $bundling;
                $dispersals{$bundling} = 1;
            }
            my $what;
            my @fields = @{$$record{FIELDS}};
            foreach my $field (@fields) {
                $what = $$record{$field};
                if ($field eq "desc") {
                    $bundling_desc{$bundling} = $what;
                }
                elsif ($field eq "position") {
                    foreach my $position (split ' ', $what) {
                        my ($nm,$value) = (split '=', $position);
                        foreach my $posn (split /\|/, $value) {
                            $max_lanes = $posn+1 if (($posn+1) > $max_lanes);
                        }
                    }
                }
            }
#            print STDERR "name = $name \n";
            if ($name =~ /^(ALL|ALU|MEM)$/) {
                my $mdsnameX = $mdsname."X";
                my $bundlingX = $bundling_bit{$mdsnameX};
                if (! defined $dispersals{$bundlingX}) {
                    push @bundling_names, $mdsnameX;
                    push @all_bundlings, $bundlingX;
                    $dispersals{$bundlingX} = 2;
                    $bundling_desc{$bundlingX} = $bundling_desc{$bundling};
                }
            }
        }
    }

#    print STDERR "max_lanes = $max_lanes\n";
    &makeBundles;
    &makeTemplates;
#    &printTemplates (*STDERR, @all_templates);
    &makeDispersals;
    &nameTemplates;
    &nameDispersals;
#    &printDispersals(*STDERR, @all_dispersals);
#    &printTemplates (*STDERR, @all_templates);
    &makeMDSBundlings;
    &makeMDSDispersals;
    &makeMDSTemplates;
}

# Pretty print a sequence of sets of bundlings.
sub printBundlings {
    my $file = shift;
    my @strings = map {
        my $bundling = $_;
        my @names;
        while ($bundling) {
            my $highbit = $bundling & -$bundling;
            push @names, $bundling_name{$highbit};
            $bundling -= $highbit;
        }
        join "+", @names;
    } @_;
    print $file (join ",", @strings);
}

sub printLane {
    my ($file, $lane) = @_;
    my @lanes;
    foreach (0..$max_lanes-1) {
        push @lanes, $_ if ($lane & (1 << $_));
    }
    print $file (join '+', @lanes);
}

sub printBundle {
    my $file = shift;
    foreach my $bundle (@_) {
        my %b = @{$bundle};
        my $lane = $b{"lane"};
        my $bundlings = $b{"bundlings"};
        print $file "L$lane: @$bundlings \n";
    }
}

sub printDispersals {
    my $file = shift;
    my @dispersals = @_;
    printf $file "Dispersals (%d off):\n", scalar @dispersals;
    foreach my $dispersal (@dispersals) {
        my $bundling = $dispersal_bundling{$dispersal};
        printf $file "%4s %4s offs %d align %-4s: ", $dispersal,
                $dispersal_name{$dispersal} || "",
               $dispersal_offset{$dispersal}, $dispersal_align{$dispersal};
        printBundlings ($file, $bundling);
        print $file "\n";
    }
}

sub printTemplates {
    my $file = shift;
    my @templates = @_;

    printf $file "Templates (%d off):\n", scalar @templates;
    foreach my $template (@templates) {
        printf $file "%4s %4s lane ", $template, ($template_name{$template} || "");
        printLane ($file, $template_lane{$template});
        print $file ": ";
        if (exists $template_dispersals{$template}) {
            print $file (join ' ', @{$template_dispersals{$template}});
        } else {
            printBundlings ($file, @{$template_bundlings{$template}});
        }
        print $file "\n";
    }
}


1;

