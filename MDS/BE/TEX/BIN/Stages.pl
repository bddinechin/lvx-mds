#!/usr/bin/perl -w
# Machine Description System (MDS)
#
# Copyright (C) 2013 Kalray
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

use strict;
use warnings;

my $FAMILY = $ENV{FAMILY};
my $CORE = $ENV{CORE};

use Data::Dumper;
use MDS;
use Behavior;
use integer;
&MDS::parse(*ARGV);


my %opcodes;
my %mnemonics;

my $text_instruction_tables;
my $text_LSU_table;
my $text_instruction_index;

## Populate the %opcode data structure with interesting info for us, organized as shown by the Dumper print in comments below
## including, for each {mnemonic,opcode}:
## - list of the related operators
## - syntax, list of operands
## - list of the parameters of the related operators (+ their type, stages ...)
##
## Also build a revert data structure (%mnemonics) that will give us some info (including the kind) about each mnemonic (instead of listing all the mnemonics for each group)

OPERATOR_LOOP: foreach my $operator (@Operator::table) {
    my @cores = map($_->core(), $operator->access('processors'));
    my @cur_opcodes = $operator->access('origins');
    my $operator_name = $operator->name();
    my $i= 0;
    CORES_LOOP: foreach my $core (@cores) {
        next CORES_LOOP if $cur_opcodes[$i]->type() ne 'Opcode';
        my $opcode = $cur_opcodes[$i]->name();
        my $mnemonic = $cur_opcodes[$i]->attribute('mnemonic');
        next CORES_LOOP if $mnemonic =~ /_$/;
        my $kind = (($cur_opcodes[$i]->access('scheduling'))[0]->access('reservation'))[0]->name();
        ## Sort the opcodes in 4 "kinds", using their reservation classes:
#  - KV4: ALU, BCU, LSU, EXT (TINY is ALU, default is BCU (e.g. for reservation classes like k1-ALL))
        my $reservation = $kind;
        $kind =~ s/^TINY/ALU/;
        $kind = 'BCU' unless ($kind =~ s/^(ALU|MAU|LSU|EXT).*/$1/);
        $reservation =~ s/\..*//;
        if (exists $opcodes{$core}{$kind}{$mnemonic}{$opcode}) {
            ## we already encountered the opcode of this operator => just add the operator's name in the list of the opcode
            push @{$opcodes{$core}{$kind}{$mnemonic}{$opcode}{'operators_list'}}, $operator_name;
            next CORES_LOOP;
        } else {
            push @{$opcodes{$core}{$kind}{$mnemonic}{$opcode}{'operators_list'}}, $operator_name;
        }
        $mnemonics{$core}{$mnemonic}{'exu'} = $kind;
        $mnemonics{$core}{$mnemonic}{'reservation'} = $reservation;
        $opcodes{$core}{$kind}{$mnemonic}{$opcode}{'syntax'} = $cur_opcodes[$i]->attribute('syntax');
        my @operands = map($_->name(), $cur_opcodes[$i]->access('operands'));
        $opcodes{$core}{$kind}{$mnemonic}{$opcode}{'operands'} = \@operands;

        my @parameters;
        foreach my $parameter ($operator->children('Parameter')) {
            my %param;
            ## we are only interested in reg parameters as there are no dependancies on immediates
            my $method_type = ($parameter->access('method'))[0]->type();
            next unless (grep(/$method_type/, ("RegClass", "Register")));
            $param{'double'} = (($parameter->access('method'))[0]->name() eq "pairedReg") ? "d" : "";
            ## also filter out "Partial" usage parameters as they are not "real" accesses
            next if (defined($parameter->attribute('usage')) and $parameter->attribute('usage') eq "Partial");
            ## (dirty, temporary): filter out reads of $CS at E4 since they are not regularly/correctly described in mds for now
            next if (defined(($parameter->access('method'))[0]) and ($parameter->access('method'))[0]->name() eq "CS" and $parameter->attribute('action') eq "Read" and (split(' ', $parameter->attribute('stages')))[$i] == 5);
            ## (dirty, temporary): filter out reads of $CS at RR for MAUs as they represent FPU reads of $CS.RM that should not be exposed as it is pseudo-static
            next if (defined(($parameter->access('method'))[0]) and ($parameter->access('method'))[0]->name() eq "CS" and $parameter->attribute('action') eq "Read" and (split(' ', $parameter->attribute('stages')))[$i] == 1 and $kind eq "MAU");


            $param{'type'} = $parameter->attribute('action');
            $param{'stage'} = (split(' ', $parameter->attribute('stages')))[$i];

            ## if the parameter has a proxy, we will name it after its operand, otherwise we will name it after its method name
            if (defined($parameter->attribute('proxy'))) {
                $param{'proxy'} = $parameter->attribute('proxy');
            } else {
                $param{'method'} = ($parameter->access('method'))[0]->name();
            }
            push @parameters, \%param;
        }
        $opcodes{$core}{$kind}{$mnemonic}{$opcode}{'parameters'} = \@parameters;
        $i++;
    }
}

my @Kinds;
if ($CORE =~ /kvx/i) {
    @Kinds = ('ALU', 'EXT', 'LSU', 'BCU');
}

print "\\newpage\\section{Detailed operands read/write stages tables for instructions}\n";
print "\\label{sec:instructions\_tables}\n";
print $text_instruction_tables;
print "\\begin{landscape}\n";
foreach my $kind (@Kinds) {
    print "\\subsection{$kind instructions}\n";
    print $text_LSU_table if ($kind eq 'LSU');
    print "\\begin{small}\n";
    &print_tex_table($CORE, $kind);
    print "\\end{small}\n";
    print "\\newpage\n";
}
print "\\end{landscape}\n";

print "\\section{Instructions index}\n";
print $text_instruction_index;
print "\\label{sec:instructions_index}\n";
print "\\begin{small}\n";
print "\\begin{longtable}[l]{l l l}\n";
print "\\textbf{Mnemonic} & \\textbf{Execution Unit} & \\textbf{Reservation} \\\\\n";
print "\\endhead\n";
foreach my $mnemonic (sort keys %{$mnemonics{$CORE}}) {
    print "\\hyperlink{$FAMILY.". &stringtolatex($mnemonic, 1). "}{" . &stringtolatex($mnemonic). "} & $mnemonics{$CORE}{$mnemonic}{'exu'} & ". &stringtolatex($mnemonics{$CORE}{$mnemonic}{'reservation'}). " \\\\ \n";
}
print "\\end{longtable}";
print "\\end{small}\n";

#print STDERR scalar keys(%{$opcodes{'k1a'}})."\n";
#print Dumper(\%opcodes);

sub print_tex_table {
    my ($core, $kind) = @_;
    &print_tex_table_header($kind);
    my $color_bg = 1;
    foreach my $mnemonic (sort keys %{$opcodes{$core}{$kind}}) {
        print '\\hline'."\n";
        print "\\hypertarget{$core." . &stringtolatex($mnemonic) . "}\n";
        foreach my $opcode_name (sort keys %{$opcodes{$core}{$kind}{$mnemonic}}) {
            #print "\n\n$opcode_name\n";
            my %opcode = %{$opcodes{$core}{$kind}{$mnemonic}{$opcode_name}};
            my $syntax = $opcode{'syntax'};
            my @operands = @{$opcode{'operands'}};
            $syntax =~ s/%0/$mnemonic/;
            $syntax =~ s/%(\d+)/$operands[$1-1]/g;
            my @parameters = @{$opcode{'parameters'}};
            my @readops;
            my @writeops;
            my $nb_rd_lines = 0;
            my $nb_wr_lines = 0;
            my $rd_stage_max = 0;
            my $wr_stage_max = 0;
            ## Build two arrays of arrays: one for the read operands and one for the write operands
            ## The indexes of the primary arrays correspond to the stages where read/write operands are read/written
            ## Then, for each stage, we build an array containing the concerned read/write operands
            foreach my $param (@parameters) {
                my $opname = $param->{'method'};
                if (exists $param->{'proxy'}) {
                    my $proxy = $param->{'proxy'};
                    my $index = substr($proxy, 1, 1) - 1;
                    $opname = $operands[$index];
                }
                if ($param->{'type'} eq 'Write') {
                    push(@{$writeops[$param->{'stage'}]}, "(w".$param->{'double'}.") ".&stringtolatex($opname));
                    $nb_wr_lines = @{$writeops[$param->{'stage'}]} if (@{$writeops[$param->{'stage'}]} > $nb_wr_lines);
                } else {
                    push(@{$readops[$param->{'stage'}]}, "(r".$param->{'double'}.") ".&stringtolatex($opname));
                    $nb_rd_lines = @{$readops[$param->{'stage'}]} if (@{$readops[$param->{'stage'}]} > $nb_rd_lines);
                }
            }
            my $nb_tot_line = $nb_rd_lines + $nb_wr_lines;
            my $instruction_print_line = 0;
            ## trying to print the instruction's syntax around the middle of the box
            $instruction_print_line = int(($nb_tot_line-1)/2) if ($nb_tot_line > 0);
            my $cline = 0;
            if ($nb_tot_line == 0) {
                print "\\crb\n" if $color_bg;
                if ($kind eq 'LSU') {
                    print &stringtolatex($syntax)." & & & & & & & & \\\\*\n";
                } else {
                    print &stringtolatex($syntax)." & & & & & & \\\\*\n";
                }
            }
            ## print the read operands for all stages (one new line as soon as there is a new operand to print in the same stage)
            for (my $i = 0; $i < $nb_rd_lines; $i++) {
                print "\\crb\n" if $color_bg;
                print &stringtolatex($syntax) if ($cline == $instruction_print_line);
                my @readopstex;
                ## prepare to print the read operands with the format corresponding to their nature
                for (my $j = 0; $j <= 13; $j++) {
                    if (defined($readops[$j][$i])) {
                        if ($readops[$j][$i] =~ /\(rd\) /) {
                            $readopstex[$j] = "\\rdf{$readops[$j][$i]}";
                        } else {
                            $readopstex[$j] = "\\rsf{$readops[$j][$i]}";
                        }
                    } else {
                        $readopstex[$j] = "";
                    }
                }
                if ($kind eq 'LSU') {
                    print " & $readopstex[0] & $readopstex[1] & $readopstex[2] & $readopstex[3] & $readopstex[4] & $readopstex[5] & & \\\\\*\n";
                } else {
                    print " & $readopstex[0] & $readopstex[1] & $readopstex[2] & $readopstex[3] & $readopstex[4] & $readopstex[5] \\\\\*\n";
                }
                $cline ++;
            }
            for (my $i = 0; $i < $nb_wr_lines; $i++) {
                print "\\crb\n" if $color_bg;
                print &stringtolatex($syntax) if ($cline == $instruction_print_line);
                my @writeopstex;
                ## prepare to print the write operands with the format corresponding to their nature
                for (my $j = 0; $j <= 13; $j++) {
                    if (defined($writeops[$j][$i])) {
                        if ($writeops[$j][$i] =~ /\(wd\) /) {
                            $writeopstex[$j] = "\\wdf{$writeops[$j][$i]}";
                        } else {
                            $writeopstex[$j] = "\\wsf{$writeops[$j][$i]}";
                        }
                    } else {
                        $writeopstex[$j] = "";
                    }
                }
                ## streaming loads return their result at "E11" (= stage 12)
                if ($kind eq 'LSU') {
                    print " & $writeopstex[0] & $writeopstex[1] & $writeopstex[2] & $writeopstex[3] & $writeopstex[4] & $writeopstex[5] & & $writeopstex[12] \\\\\*\n";
                } else {
                    print " & $writeopstex[0] & $writeopstex[1] & $writeopstex[2] & $writeopstex[3] & $writeopstex[4] & $writeopstex[5] \\\\\*\n";
                }
                $cline ++;
            }
            print '\\hline'."\n";
        }
        $color_bg = not($color_bg);
    }
    &print_tex_table_footer();
}


sub print_tex_table_header {
    my ($kind) = @_;
    my $last_stages = ($kind eq 'LSU') ? '\\textbf{E4} & \\textbf{...} & \\textbf{E11}' : '\\textbf{E4}';
    my $header = "\\begin{longtable}{|l|P{1.5cm}|P{1.5cm}|P{1.5cm}|P{1.5cm}|P{1.5cm}|P{1.5cm}|}";
    if ($kind eq 'LSU') {
        $header = "\\begin{longtable}{|l|P{1.5cm}|P{1.5cm}|P{1.5cm}|P{1.5cm}|P{1.5cm}|P{1.5cm}|P{1.5cm}|P{1.5cm}|}";
    } elsif ($kind eq 'BCU') {
        $header = "\\begin{longtable}{|l|P{1.5cm}|P{1.5cm}|P{1.5cm}|P{1.5cm}|P{1.5cm}|P{1.5cm}|}";
    }
    print $header;
    print "
\\hline \\textbf{Instruction} & \\textbf{ID} & \\textbf{RR} & \\textbf{E1} & \\textbf{E2} & \\textbf{E3} & $last_stages \\\\
\\hline
\\hline
\\endfirsthead
\\hline \\textbf{Instruction} & \\textbf{ID} & \\textbf{RR} & \\textbf{E1} & \\textbf{E2} & \\textbf{E3} & $last_stages \\\\
\\hline
\\endhead
";
}


sub print_tex_table_footer {
    print <<'EOT';
\end{longtable}
EOT
}


sub stringtolatex {
    my ($string, $nomarkup) = @_;
    $string =~ s/upper22L_lower10L/imm32/g;
    $string =~ s/upper27M_lower5M/imm32/g;
    $string =~ s/upper22_lower10/imm32/g;
    $string =~ s/upper22L_lower10/imm32/g;
    $string =~ s/upper22L_bits_9_8_bits_7_5_signed5M/imm32/g;
    $string =~ s/upper22_bits_9_8_bits_7_5_lower5/imm32/g;
    $string =~ s/systemPS/PS/g;
    $string =~ s/onlypsReg/PS/g;
    $string =~ s/systemRA/RA/g;
    $string =~ s/onlyraReg/RA/g;
    $string =~ s/comparison/comp/g;
    $string =~ s/register/reg/g;
    $string =~ s/unsigned/u/g;
    $string =~ s/signed/s/g;
    $string =~ s/system/sys/g;
    $string =~ s/modulo/mod/g;
    $string =~ s/scaling/scal/g;
    $string =~ s/negate/neg/g;
    $string =~ s/condition/cond/g;
    $string =~ s/highbit/hbit/g;
    $string =~ s/lowbit/lbit/g;
    $string =~ s/\.(\w+)/.\\emph{$1}/g unless $nomarkup;
    $string =~ s/_/\\_/g;

    return $string;
}

BEGIN {
    $text_instruction_tables=<<'EOT';
The tables of this section show at which stage the (register) read operands of an instruction are read and at which stage its results are ready.
The immediate operands, having no effect whatsoever on the pipeline flow (except taking the place of a register operand that could have stalled), are only mentionned in the syntax of the instruction but not in the pipeline part of the tables.
The color code used respects the syntax conventions defined in section \ref{sec:syntax}. In particular: \\\\
\begin{tabular}{l l}
\rsf{(r) regZ} & the simple (32b) register regZ is read \\
\rdf{(rd) regP} & the double (64b) register regP (a.k.a. pair P) is read \\
\wsf{(w) regW} & the simple (32b) result that will be written back into regW is ready for bypass \\
\wdf{(wd) regM} & the double (64b) result data that will be written back into regM is ready for bypass \\
\end{tabular} \\\\

All the instructions of the instruction set have been grouped in four tables, according to the kind of EXU they execute on. Inside each table, instructions are sorted alphabetically.
Section \ref{sec:instructions_index} contains an alphabetical index of all the instructions, mentionning their associated EXU (as well as simplified reservation class) and linking to their description in the following tables.

When an alu instruction is sent to a double LIGHT/TINY ALU unit, it exhibits exactly the same behaviour as if it were executed on a big ALU. \\

Compared to the architecture manual, some names have been shortened (e.g. register $\rightarrow$ reg, systemPS $\rightarrow$ PS, etc.) and some complicated immediate names have been simplified (e.g. upper22L\_lower10 $\rightarrow$ imm32) for the sake of readability.


EOT

    $text_LSU_table=<<'EOT';
In the table below, an "E11" column has been added to show when the results of uncached loads are available for the typical case if streaming is activated. If streaming is not activated, then uncached loads are blocking and will stall at E3 (and the upstream stages of the pipeline with them) for 7 cycles (typical), see section \ref{sec:uncached_loads} for more details.

EOT

    $text_instruction_index=<<'EOT';
This section is an alphabetical index of all the instructions, giving, for each of them, its associated EXU (i.e. the EXU on which this instruction executes), the (simplified) reservation class it belongs to and linking to its operands'stages description in the relevant table of section \ref{sec:instructions_tables}.

The reservation classes that are used here are the real ones (as defined in the Instruction Reservation Tables of the architecture manual) except that the last part of the names (like ".X")  have been trimmed as it relates solely to the presence or the absence of immediate extensions, whereas our table only deals with mnemonics, not complete formats, so it would not make sense.
These pieces of reservation information are very interesting in that they tell us:\\

\begin{tabular}{| l |  l |}
\hline
information & reservation pattern \\
\hline
alu instruction is supported in double TINY ALU unit & TINY \\
instruction uses the shared double read port \rdf{RPD2} & *\_ACC\_* \\
instruction uses the carry & *\_ODD\_* \\
instruction must be issued alone in their bundle & ALL \\
\hline
\end{tabular} \\\\

These point have to be taken into account to form correct bundles when writing assembly. Of course, the bundling of instructions is further constrained by the issue ressource (8 syllables maximum per bundle) as detailed in the Instruction Reservation Tables section of the architecture manual. \\\\

EOT
}
#'

# $VAR1 = {
#           'k1a' => {
#                       'ALU' => {
#                                  'satw' => {
#                                            'SATW_registerW_registerS_registerZ_registerV' => {
#                                                                                              'parameters' => [
#                                                                                                                {
#                                                                                                                  'double' => '',
#                                                                                                                  'stage' => 2,
#                                                                                                                  'type' => 'Write',
#                                                                                                                  'proxy' => %1
#                                                                                                                },
#                                                                                                                {
#                                                                                                                  'double' => '',
#                                                                                                                  'stage' => 2,
#                                                                                                                  'type' => 'Write',
#                                                                                                                  'proxy' => %2
#                                                                                                                },
#                                                                                                                {
#                                                                                                                  'double' => '',
#                                                                                                                  'stage' => 1,
#                                                                                                                  'type' => 'Read',
#                                                                                                                  'proxy' => %3
#                                                                                                                },
#                                                                                                                {
#                                                                                                                  'double' => '',
#                                                                                                                  'stage' => 1,
#                                                                                                                  'type' => 'Read',
#                                                                                                                  'proxy' => %4
#                                                                                                                }
#                                                                                                              ],
#                                                                                              'operands' => [
#                                                                                                              'registerW',
#                                                                                                              'registerS',
#                                                                                                              'registerZ',
#                                                                                                              'registerV'
#                                                                                                            ],
#                                                                                              'syntax' => '%0 %1:%2 = %3:%4',
#                                                                                              'operators_list' => [
#                                                                                                                    'SATW_1singleReg_2singleReg_3singleReg_4singleReg'
#                                                                                                                  ]
#                                                                                            }
#                                          },
# vim: set ts=4 sw=4 et:
