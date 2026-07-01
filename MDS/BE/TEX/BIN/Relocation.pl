#
# Build the Opcode.tex LaTeX file.
# Benoit Dupont de Dinechin 2009.
#

use YAML::XS;

use Data::Dumper;
use strict;
use Carp;
use File::Basename;
#do 'display.pl';

open(INPUT, "<", $ARGV[0]) || die "can't open $ARGV[0]\n";

my $dirname = dirname($ARGV[0]);
open(PHABRICATOR, ">", "$dirname/Relocation.phab") || die "can't open $dirname/Relocation.phab";

local $/;
my $Load = Load(<INPUT>);
my $Format = $$Load{Format};
my $Instruction = $$Load{Instruction};
my $Operand = $$Load{Operand};
my $Relocation = $$Load{Relocation};

# Order the Format(s) by increasing number.
my @Format = sort { $$a{number} <=> $$b{number} } values %{$Format};
#print STDERR Dumper(@Format);

# Order the Relocation(s) by increasing number.
my @Relocation = sort { $$a{number} <=> $$b{number} } values %{$Relocation};
#print STDERR Dumper(@Relocation);

# Map Format ID to Instruction(s).
my %instructions;
while (my ($instruction_ID, $instruction) = each %{$Instruction}) {
    foreach my $format_ID (@{$$instruction{formats}}) {
        my ($class, $name) = split /:/, $instruction_ID;
        $instructions{$format_ID}{$name} = 1;
    }
}
#print STDERR Dumper(\%instructions);

# Map Relocation ID to Operend(s)
my %operands;
while (my ($operandID, $operand) = each %{$Operand}) {
    foreach my $relocationID (@{$$operand{relocations}}) {
        $operands{$relocationID}{$operandID} = 1;
    }
}

my %relocations;
foreach my $format (@Format) {
    my $operands = $$format{operands};
    my $formatID = $$format{ID};
    foreach my $operand (@{$operands}) {
        while (my ($relocationID, $reloc_operands) = each %operands) {
            foreach my $reloc_operand (keys %{$reloc_operands}) {
                if($reloc_operand eq $operand) {
                    my $format_instructions = $instructions{$formatID};
                    foreach my $format_instruction (keys %{$format_instructions}) {
                        $relocations{$relocationID}{$format_instruction} = 1;
                    }
                }
            }
        }
    }
}

# Emit the LaTeX code on STDOUT.
my $maxRows = 80;
my $numRows = 0;

# Change
#   - vertical and horizontal badness reports
print PHABRICATOR "== Relocations for $dirname ==\n";
print PHABRICATOR "| Relocation | Linker relocations | Syntax | Symbol | Symbol + addend | PC | GP | TP | GOT | LOAD BASE | Instructions |\n";

print "{\\tiny\n\\begin{tabular}{|l|l|l|l|l|l|l|l|l|l|l|} \\hline\n";
my $header = "\\textsf{Relocation} & \\textsf{Linker relocations} & \\textsf{Syntax} & \\textsf{Symbol} & \\textsf{Symbol + addend} & \\textsf{PC} & \\textsf{GP} & \\textsf{TP} & \\textsf{GOT} & \\textsf{Instructions} \\\\";
print "$header\n";
print "\\hline\n";

my %instruction_lists;
my $instruction_list_id = 0;
foreach my $relocation (@Relocation) {
    my $relocationID = $$relocation{ID};
    my @linker_relocs = @{$$relocation{linker}} if(defined $$relocation{linker});
    my @instructions = ();
    @instructions = sort { $a cmp $b } keys %{$relocations{$relocationID}} if(defined $relocations{$relocationID});
    my $syntax = "";
    $syntax = $$relocation{syntax} if(defined $$relocation{syntax});
    my $symbol = "";
    my $symbol_addend = "";
    if ($$relocation{type} eq "Rel_s_a") { $symbol_addend = "X"; }
    elsif ($$relocation{type} eq "Rel_s") { $symbol = "X"; }
    else { croak "Undefined relocation type: $$relocation{type}\n"; }
    my $relative = "undefined";
    $relative = $$relocation{relative} if(defined $$relocation{relative});
    my $pc = "";
    my $gp = "";
    my $tp = "";
    my $got = "";
    my $base_load_addr = "";
    if ($relative eq "PC") { $pc = "X"; }
    elsif ($relative eq "GP") { $gp = "X"; }
    elsif ($relative eq "TP") { $tp = "X"; }
    elsif ($relative eq "GOT") { $got = "X"; }
    elsif ($relative eq "BASE") { $base_load_addr = "X"; }
    elsif ($relative eq "undefined") { }
    else { croak "Undefined relocation relative attribute"; }
    my $instructions = "";

    if ($numRows > $maxRows) {
        print "\\hline";
        print "\\end{tabular}\n}\n";
        print "\\smallskip\n\n";
        print "{\\tiny\n\\begin{tabular}{|l|l|l|l|l|l|l|l|l|l|l|} \\hline\n";
        print "$header\n";
        print "\\hline\n";
        $numRows = 0;
    }

    my $instruction_list_str = "";
    if(@instructions) {
        my $instruction_key = join(" ",@instructions);
        if(not defined $instruction_lists{$instruction_key}) {
            $instruction_lists{$instruction_key} = $instruction_list_id;
            $instruction_list_id++;
        }
        $instruction_list_str = "List $instruction_lists{$instruction_key}";
    }
    print PHABRICATOR "| $relocationID | " . join(" ",@linker_relocs) . " | `$syntax` | $symbol | $symbol_addend | $pc | $gp | $tp | $got | $base_load_addr | $instruction_list_str |\n";

    map { s/_/\\_/g } @instructions;
    map { s/_/\\_/g } @linker_relocs;
    $syntax =~ s/_/\\_/g;
    $relocationID =~ s/_/\\_/g;

    my $current_reloc = "\\textsf{$relocationID} & \\textsf{$linker_relocs[0]} & \\textsf{$syntax} & \\textsf{$symbol} & \\textsf{$symbol_addend} & \\textsf{$pc} & \\textsf{$gp} & \\textsf{$tp} & \\textsf{$got} & \\textsf{$instructions[0]} \\\\";
    print "$current_reloc\n";
    $numRows++;

    my $index = 1;
    while(defined $linker_relocs[$index] or defined $instructions[$index]) {
        my $newline = " &";
        # Repeat relocation name
        if ($numRows > $maxRows) {
            $newline = "\\textsf{$relocationID} &";
        }
        if(defined $linker_relocs[$index]) {
            $newline = $newline . " \\textsf{$linker_relocs[$index]}";
        }
        $newline = $newline . " & & & & & & & & &";
        if(defined $instructions[$index]) {
            $newline = $newline . " \\textsf{$instructions[$index]}";
        }
        $newline = $newline . " \\\\\n";

        if ($numRows > $maxRows) {
            print "\\hline";
            print "\\end{tabular}\n}\n";
            print "\\smallskip\n\n";
            print "{\\tiny\n\\begin{tabular}{|l|l|l|l|l|l|l|l|l|l|l|} \\hline\n";
            print "$header\n";
            print "\\hline\n";
            $numRows++;
            $numRows = 0;
        }
        print $newline;
        $index = $index + 1;
        $numRows++;
    }
    print "\\hline\n";
}
print "\\end{tabular}\n}\n\n";

print PHABRICATOR "\n| Instruction List | Instructions |\n";
foreach my $instruction_list (sort { $instruction_lists{$a} <=> $instruction_lists{$b} } keys %instruction_lists) {
    print PHABRICATOR "| $instruction_lists{$instruction_list} | $instruction_list |\n";
}

(close(INPUT) && close(PHABRICATOR)) || die $!;
# vim: set ts=4 sw=4 et:
