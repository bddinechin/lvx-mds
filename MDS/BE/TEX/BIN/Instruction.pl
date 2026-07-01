#
# Build the Instruction.tex LaTeX file.
# Benoit Dupont de Dinechin 2009.
#

use YAML::XS;

use Data::Dumper;
#use strict;
use Carp;
use Opcode;
use Behavior;
do 'display.pl';

open(INPUT, "<", $ARGV[0]) || die "can't open $ARGV[0]\n";

local $/;
my $Load = Load(<INPUT>);
my $Register = $$Load{Register};
my $RegClass = $$Load{RegClass};
my $RegFile = $$Load{RegFile};
my $Immediate = $$Load{Immediate};
my $Modifier = $$Load{Modifier};
my $Operand = $$Load{Operand};
my $Format = $$Load{Format};
my $Instruction = $$Load{Instruction};
my $Scheduling = $$Load{Scheduling};
my $Processor = $$Load{Processor};

my $order = 0;
my %Order = (
    BCU=>$order++,
    LSU=>$order++,
    ALU=>$order++,
    MAU=>$order++,
    FPU=>$order++,
    TCA=>$order++,
    EXT=>$order++,
    #
    RV32A=>$order++,
    RV32B=>$order++,
    RV32D=>$order++,
    RV32F=>$order++,
    RV32H=>$order++,
    RV32I=>$order++,
    RV32M=>$order++,
    RV64A=>$order++,
    RV64B=>$order++,
    RV64D=>$order++,
    RV64F=>$order++,
    RV64H=>$order++,
    RV64I=>$order++,
    RV64M=>$order++,
    RVZI=>$order++,
    RV64KV=>$order++,
  );

# Get Processor pipeline
my @pipeline = @{$$Processor{cpu}{pipeline}};
my %pipeline;

$Behavior::ignore_errors = 1;
$Behavior::partial_initialization = 1;
# Global list of operands to document
my %operands_list;
for (my $stage = 0; $stage < @pipeline; $stage++) {
    $Behavior::pipeline{$pipeline[$stage]} = $stage;
    $pipeline{$pipeline[$stage]} = $stage;
}
#print STDERR Dumper(%pipeline);

# Order the Instruction(s) alphabetically by class then ID.
my @Instruction = sort { ($Order{$$a{class}} <=> $Order{$$b{class}}) || ($$a{ID} cmp $$b{ID}) } values %{$Instruction};
#print STDERR Dumper(@Instruction);

# Emit the LaTeX code on STDOUT.
my $prev_class = '';

my $latex_allow_break = "\\discretionary{}{}{}";

# Change
#   - line spacing tolerance (to avoid overfull boxes)
#   - vertical and horizontal badness reports
print "{\n\\tolerance=4000\n\\hbadness=10000\n\\vbadness=10000\n";
#   - color of subsubsections
#print "\\subsubsectionfont{\\color{kalrayblue}}\n";

my %Numbers = (
    "0" => "Zero", "1" => "One", "2" => "Two", "3" => "Three",
    "4" => "Four", "5" => "Five", "6" => "Six", "7" => "Seven",
    "8" => "Eight", "9" => "Nine",
  );

sub latex_syntax {
    my ($syntax,@operands) = @_;
    $syntax =~ s/(?<!\%)\%([1-9]\d*)/\\emph{$operands[$1]}/g;
    $syntax =~ s/:\\emph/:$latex_allow_break\\emph/g;
    return $syntax;
}

sub latex_description {
    my ($description,@operands) = @_;
    $description =~ s/(?<!\%)\%([1-9])/\\emph{$operands[$1]}/g;
    $description =~ s/<</\\hbox{\$<\\!\\!<\$}/g;
    $description =~ s/>>/\\hbox{\$>\\!\\!>\$}/g;
    $description =~ s/:\\emph\{\}//g; # remove things like 'signed10:.' in '%5:%6'
    # Allow line-breaking afer ':' in args like '%5:%6'
    $description =~ s/:\\emph/:$latex_allow_break\\emph/g;
    return $description;
}

=item find_stages()

  This function find the pipeline stages at which a command is performed.

  Arguments:
    - $tree: a reference to a command.

=cut

sub find_stages {
    my ($tree) = @_;

    my @node = @{$tree};
    my ($node_type) = @node;
    my $res = -1;

    my @with_stages = (
        'ACCESS', 'COMMIT', 'EFFECT', 'LOAD', 'PROBE', 'STORE', 'THROW'
      );

    return $node[1] if (grep(/^$node_type$/, @with_stages));

    my ($len0, $i) = ($#node, 0);
    foreach $elt (@node) {
        return $res if ($res != -1);
        $res = &find_stages($elt) if (ref($elt) eq 'ARRAY');
    }

    return $res;
}

=item distribute_over_stages ()

  This function takes a toplevel command and returns an array of commands
  distributed over each pipeline stage.

  Arguments:
    - $tree: a reference to a command.  The command should be a toplevel SEQ or
    a single command.  Each command in the toplevel SEQ will be dispatched to
    its corresponding pipeline stage.

  Return value:
    An array with containing a list of commands for each pipeline stages.

=cut

sub distribute_over_stages {
    my ($tree, $depth) = @_;
    my @node = @{$tree};
    my ($node_type) = @node;
    my %stages = ();
    my $once = 0;
    my $default_exu = 1;
    my $exu = -1;

    if ($depth == 0 && $node_type ne 'SEQ') {
        my $new_exu = &find_stages($tree);
        if ($new_exu != -1) {
            $exu = $new_exu;
        }
        if ($new_exu == -1 && $exu == 0) {
            $exu = $default_exu;
        }
    }

    my ($len0, $i) = ($#node, 0);
    foreach $elt (@node) {
        if (ref $elt eq 'ARRAY') {
            if ($depth == 0 && $node_type eq 'SEQ') {
                my $new_exu = &find_stages($elt);
                if ($new_exu != -1) {
                    $exu = $new_exu;
                }
                if ($new_exu == -1 && $exu == 0) {
                    $exu = $default_exu;
                }
            }
            push(@{$stages{$exu}}, $elt) if $exu >= 0;
            push(@{$stages{$default_exu}}, $elt) if $exu < 0;
        } else {
            if ($depth == 0 && !$once && $node_type ne 'SEQ') {
                push(@{$stages{$exu}}, $elt) if $exu >= 0;
                push(@{$stages{$default_exu}}, $elt) if $exu < 0;
            }
        }
    }

    return %stages;
}

sub dump_behavior {
    my ($tree, $indent) = @_;
    my @node = @{$tree};
    my ($node_type) = @node;
    my $once = 0;

    my $exu = -1;

    print STDERR " " x $indent;
    my ($len0, $i) = ($#node, 0);
    foreach $elt (@node) {
        if (ref $elt eq 'ARRAY') {
            print STDERR "\n" if $i++ > 0;
            &dump_behavior($elt, $indent + 2);
        } else {
            print STDERR " " if $i++ > 0;
            print STDERR "$elt";
        }
    }
}

my %seen_syms = {};
sub execution_slot_for_stage {
    my $res = "";
    my ($tree, $indent, $skip_indent, $skip_paren) = @_;
    if (ref $tree ne 'ARRAY') { return ""; }
    my @node = @{$tree};
    my ($node_type) = @node;
    my @stages_id = ('ID', 'RR', 'E1', 'E2', 'CR', 'E3', 'E4', 'E5', 'WB', 'SF', 'SR');
    my $once = 0;
    my %binops = (
        'ADD' => ' + ',
        'SUB' => ' - ',
        'MUL' => ' * ',
        'DIV' => ' / ',
        'MOD' => ' % ',
        'SHR' => ' >> ',
        'SHL'  => ' << ',
        'AND' => ' & ',
        'IOR' => ' | ',
        'XOR' => ' ^ ',
        'NE' => ' != ',
        'EQ' => ' == ',
        'GT' => ' < ',
        'LE'  => ' <= ',
        'GE'  => ' >= ',
        'LT'  => ' < ',
        'ANDL' => ' && ',
        'IORL' => ' || ',
      );
    my %unops = (
        'NOT' => '~',
        'NEG' => '-',
        'NOTL' => '!',
      );
    my @unary_sized_fns = ('ZX', 'SX', 'SAT', 'SATU', 'CLZ', 'CLS', 'CBS', 'CTZ', 'SWAP');
    my @binary_sized_fns = ('ROL', 'ROR');
    my @binary_fns = ('MIN', 'MAX');

    my $followed_by_if = 0;
    my $expand_F2I = 0;
    my $expand_load = 0;
    my $expand_aggl = 1;
    my $expand_I2F = 0;
    my $explicit_I2B = 0;
    my $expand_apply_access = 0;

    if ($node_type eq 'SEQ') {
        my $once = 0;
        foreach $elt (splice @node, 1) {
            $res .= "\n" if $once++ != 0;
            $res .= &execution_slot_for_stage($elt, $indent) . ';';
        }
    } elsif ($node_type eq 'SECTION') {
        my (undef, $section, $index) = @node;
        $res .= "$section";
        $res .= "[";
        $res .= (ref $index eq 'ARRAY') ? &execution_slot_for_stage($index, 0) : $index;
        $res .= "]";
    } elsif ($node_type eq 'INDEX') {
        my (undef, $index) = @node;
        $res .= "$index";
    } elsif ($node_type eq 'WRITE') {
        $res .= " " x $indent;
        if (!(defined $seen_syms{$node[2]}) && !(ref $node[1] eq 'ARRAY')) {
            $res .= "new ";
            $seen_syms{$node[2]} = 1;
        }
        $res .= "$node[2]";
        if (ref $node[1] eq 'ARRAY') {
            $res .= ".";
            $res .= &execution_slot_for_stage($node[1], 0);
        }
        $res .= " = ";
        $res .= &execution_slot_for_stage($node[3], 0, 0, 1);
    } elsif ($node_type eq 'READ') {
        $res .= " " x $indent;
        $res .= "$node[2]";
        if (ref $node[1] eq 'ARRAY') {
            $res .= ".";
            $res .= &execution_slot_for_stage($node[1], 0, 0, $skip_paren);
        }
        $res .= &execution_slot_for_stage([$node[3]], $indent + 2);
    } elsif ($node_type eq 'STORE') {
        $res .= " " x $indent;
        $res .= &execution_slot_for_stage($node[2], 0);
        $res .= " = ";
        $res .= &execution_slot_for_stage($node[3], 0, 0, 1);
    } elsif ($node_type eq 'ACCESS') {
        $res .= " " x $indent;
        $res .= "$node[2]";
    } elsif ($node_type eq 'F2I') {
        $res .= " " x $indent;
        $res .= &execution_slot_for_stage($node[2], 0);
        $res .= "[0:$node[1]]" if $expand_F2I;
    } elsif ($node_type eq 'B2I') {
        $res .= " " x $indent;
        $res .= &execution_slot_for_stage($node[1], 0, 0, 1);
    } elsif ($node_type eq 'LOAD') {
        $res .= " " x $indent;
        $res .= &execution_slot_for_stage($node[2], 0);
        $res .= "[0:$node[1]]" if $expand_load;
    } elsif ($node_type eq 'AGGL') {
        $res .= " " x $indent;
        $res .= "$node[1]";
        if ($expand_aggl) {
            my $sub_res = "";
            if (!($node[2]->[0] eq 'CONST' && $node[2]->[1] eq '0')) {
                $sub_res .= &execution_slot_for_stage($node[2], 0);
            }
            if ($node[3]->[0] eq 'CONST' && $node[3]->[1] ne '1') {
                $sub_res .= ":";
                $sub_res .= &execution_slot_for_stage($node[3], 0);
            }
            $res .= "[$sub_res]" if $sub_res ne '';
        }
    } elsif ($node_type eq 'COMMIT') {
        $res .= " " x $indent;
        $res .= "$node[2] = ";
        $res .= &execution_slot_for_stage($node[3], 0, 0, 1);
    } elsif ($node_type eq 'IF') {
        $indent = 2 if $indent == 0;
        $res .= " " x $indent unless $skip_indent;
        $res .= "if (";
        $res .= &execution_slot_for_stage($node[1], 0, 0, 1);
        $res .= ") {\n";
        $res .= &execution_slot_for_stage($node[2], $indent + 2);
        $res .= ';' unless $node[2]->[0] eq 'SEQ';
        $res .= "\n" . " " x $indent . "}";
        unless ($node[3]->[0] eq 'SKIP' or $node[3]->[0] eq 'CANCEL') {
            $followed_by_if = $node[3]->[0] eq 'IF';
            my $new_indent = $followed_by_if ? $indent : $indent + 2;
            $res .= " else ";
            $res .= "{\n" unless $followed_by_if;
            $res .= &execution_slot_for_stage($node[3], $new_indent, 1);
            $res .= ";" unless $followed_by_if || $node[3]->[0] eq 'SEQ';
            $res .= "\n" unless $followed_by_if;
            $res .= " " x $indent . "}" unless $followed_by_if;
        }
    } elsif ($node_type eq 'SKIP') {
        $indent = 2 if $indent == 0;
        $res .= " " x $indent;
        $res .= ";";
    } elsif ($node_type eq 'I2F') {
        $res .= " " x $indent;
        $res .= &execution_slot_for_stage($node[2], 0, 0, 1);
        if (defined $node[3] and ref $node[3] eq 'ARRAY') {
            $res .= &execution_slot_for_stage($node[3], 0);
        }
        $res .= "[0:$node[1]]" if $expand_I2F;
    } elsif ($node_type eq 'I2B') {
        $res .= " " x $indent;
        $res .= '(' if $explicit_I2B;
        $res .= &execution_slot_for_stage($node[1], 0);
        $res .= ' != 0)' if $explicit_I2B;
    } elsif ($node_type eq 'TEST') {
        $res .= " " x $indent;
        $res .= "$node[1]";
        $res .= '(';
        if (defined $node[2] && ref $node[2] ne 'HASH') {
            my $once = 0;
            foreach $elt (splice @node, 2) {
                $res .= ", " if $once++ != 0 && ref $elt ne 'HASH';
                if (ref $elt eq 'ARRAY') {
                    $res .= &execution_slot_for_stage($elt, 0);
                } else {
                    $res .= &execution_slot_for_stage([$elt], 0);
                }
            }
        }
        $res .= ')';
    } elsif ($node_type eq 'EFFECT') {
        my $semicolon = ";" if $indent == 0;
        $indent = 2 if $indent == 0;
        $res .= " " x $indent;
        $node[2] =~ s/MEM_/MEM./;
        $res .= "$node[2](";
        my $once = 0;
        foreach $elt (splice @node, 3) {
            my @elt = @{$elt};
            $res .= ", " if $once++ != 0;
            $res .= &execution_slot_for_stage(\@elt, 0, 0, 1);
        }
        $res .= ")$semicolon";
    } elsif ($node_type eq 'CONST') {
        $res .= " " x $indent;
        #print STDERR "$node[1]: ", ${$node[2]}{REPR}, "\n";
        if (${$node[2]}{REPR} eq 'HEXADECIMAL' && $node[1] != 0) {
            $res .= sprintf("0x%X", $node[1]);
        } else {
            $res .= "$node[1]";
        }
    } elsif ($node_type eq 'METHOD') {
        $res .= " " x $indent;
        $node[1] =~ s/%/@/;
        $res .= "$node[1]";
    } elsif ($node_type eq 'SELECT') {
        $res .= " " x $indent;
        my (undef, $cond, $true, $false) = @node;
        $res .= &execution_slot_for_stage($cond, 0, 0, 1);
        $res .= ' ? ';
        $res .= &execution_slot_for_stage($true, 0, 0, 1);
        $res .= ' : ';
        $res .= &execution_slot_for_stage($false, 0, 0, 1);
    } elsif (grep(/^$node_type$/, keys %unops)) {
        $res .= " " x $indent;
        $res .= "$unops{$node_type}";
        $res .= &execution_slot_for_stage($node[1], 0);
    } elsif ($node_type eq 'ABS') {
        $res .= " " x $indent;
        $res .= "_ABS(";
        $res .= &execution_slot_for_stage($node[1], 0, 0, 1);
        $res .= ")";
    } elsif (grep(/^$node_type$/, @unary_sized_fns)) {
        $res .= " " x $indent;
        $res .= "_$node[0]_$node[1](";
        $res .= &execution_slot_for_stage($node[2], 0, 0, 1);
        $res .= ")";
    } elsif (grep(/^$node_type$/, @binary_sized_fns)) {
        $res .= " " x $indent;
        $res .= "_$node[0]_$node[1](";
        $res .= &execution_slot_for_stage($node[2], 0, 0, 1);
        $res .= ", ";
        $res .= &execution_slot_for_stage($node[3], 0, 0, 1);
        $res .= ")";
    } elsif (grep(/^$node_type$/, @binary_fns)) {
        $res .= " " x $indent;
        $res .= "_$node[0](";
        $res .= &execution_slot_for_stage($node[1], 0, 0, 1);
        $res .= ", ";
        $res .= &execution_slot_for_stage($node[2], 0, 0, 1);
        $res .= ")";
    } elsif (grep(/^$node_type$/, keys %binops)) {
        my $once = 0;
        $res .= "(" unless $skip_paren;
        foreach $arg (splice @node, 1) {
            $res .= $binops{$node_type} if $once++ != 0 && ref $arg eq 'ARRAY';
            $res .= &execution_slot_for_stage($arg, 0, 0, 0);
        }
        $res .= ")" unless $skip_paren;
        $res .= &execution_slot_for_stage($node[1], 0);
    } elsif ($node_type eq 'THROW') {
        my $semicolon = ';' if $indent == 0;
        $indent = 2 if $indent == 0;
        $res .= " " x $indent;
        $res .= "_THROW(" . $node[2] . ")$semicolon";
    } elsif ($node_type eq 'FOR') {
        $res .= " " x $indent;
        $ident = $node[1];
        $lower = $node[2]->[1];
        $upper = $node[2]->[2];
        $step = $node[2]->[3];
        $op = $step > 0 ? "<" : ">";
        $res .= "for ($ident = $lower; $ident $op $upper; $ident += $step)";
        $res .= " {\n";
        foreach $elt (splice @node, 3) {
            $res .= "\n" if $once++ != 0;
            $res .= &execution_slot_for_stage($elt, $indent + 2);
        }
        $res .= "\n" . " " x $indent;
        $res .= "}";
    } elsif ($node_type eq 'CANCEL') {
        $res .= " " x $indent;
        $res .= "cancel()";
    } elsif ($node_type eq 'APPLY') {
        $res .= " " x $indent;
        if ($node[1] =~ /^[0-9]+$/) {
            $node[2] =~ s/MEM_/MEM./;
            $res .= "$node[2](";
            my $once = 0;
            foreach $arg (splice @node, 3) {
                $res .= ", " if $once++ != 0 && ref $arg eq 'ARRAY';
                $res .= &execution_slot_for_stage($arg, 0, 0, 1);
            }
            $res .= ")";
            $res .= "[0:$node[1]]" if $expand_apply_access;
        } else {
            $res .= &execution_slot_for_stage($node[1], 0);
            $res .= "(";
            my $once = 0;
            foreach $arg (splice @node, 2) {
                $res .= ", " if $once++ != 0;
                $res .= &execution_slot_for_stage($arg, 0, 0, 1);
            }
            $res .= ")"
        }
        $res .= &execution_slot_for_stage($node[1], 0);
        $res .= &execution_slot_for_stage($node[2], 0);
    } else {
        if (ref $node_type eq 'ARRAY') {
            my $once = 0;
            foreach $elt (@node) {
                $res .= "\n" if $once++ != 0;
                $res .= &execution_slot_for_stage($elt, $indent + 2);
                $res .= ';' if $elt->[0] ne 'IF';
            }
        } else {
            die "unknown node type $node_type\n" unless ref $node_type eq 'HASH';
        }
    }
    return $res;
}

sub create_execution_slot {
    my ($insn_id, $tree, $AccessTable, $CommitTable, $replaceTable) = @_;
    my $actions;
    #print STDERR "$insn_id\n";
    #print STDERR &Pretty($tree, " ");
    my %bla = &distribute_over_stages($tree, 0);
    my @stages_id = ('ID', 'RR', 'E1', 'E2', 'CR', 'E3', 'E4', 'E5', 'WB', 'SF', 'SR');
    my @res = ("\n");
    foreach $key (sort {$a <=> $b} keys %bla) {
        push @res, "stage $stages_id[$key]:\n";
        my $tmp = $bla{$key};
        my $actions;
        if (defined $AccesTable && defined $CommitTable && defined $relaceTable) {
            ($tmp, $actions) = &Expand($tmp, $AccessTable, $CommitTable, 'METHOD', $replaceTable, 0);
        }
        %seen_syms = {};
        my $tmp_res = &execution_slot_for_stage($tmp, 0);

        # Apply a cosmetic filter to be just as before
        $tmp_res =~ s/CS\[([A-Z]*)_([A-Z0-9]*)(:\d*)?\]/$1.$2/g;
        $tmp_res =~ s/PS\[([A-Z]*)_([A-Z0-9]*)(:\d*)?\]/$1.$2/g;
        $tmp_res =~ s/IXC\[([A-Z]*)_([A-Z0-9]*)(:\d*)?\]/$1.$2/g;
        $tmp_res =~ s/SFR\[([A-Z_]*)\]/$1/g;
        push @res, $tmp_res;
        push @res, "\n";
    }
    return @res;
}

sub dumpFormat {
    my ($formatID, $instruction, $reservation) = @_;

    my $what = $$instruction{what};
    my ($class, $ID) = split /:/, $$instruction{ID};
    my $class = $$instruction{class};
    my $instruction_syntax = $$instruction{syntax};
    my $instruction_mnemonic = $$instruction{mnemonic};
    my $instruction_formats = $$instruction{formats};
    my $instruction_description = $$instruction{description};
    my $instruction_execution = $$instruction{execution};
    my $instruction_behavior = $$instruction{behavior};
    my $instruction_schedulings = $$instruction{schedulings};
    my $instruction_properties = $$instruction{properties};
    my %properties;

    (my $name = $ID) =~ s/_/\\_/g;
    (my $mnemonic = $instruction_mnemonic) =~ s/_/\\_/g;
    my $loc_what = $what;

    # Do not print format only used to validate HW
    next if($$Format{$formatID}{what} =~ /\[ONLY_FOR_HW\]/);

    (my $format_label = $formatID) =~ s/_/-/g;
    (my $format_latex = $formatID) =~ s/_/\\_/g;
    (my $format_cmd = $formatID) =~ s/_/U/g;
    $format_cmd =~ s/\./P/g;

    $format_cmd = "" if(@{$instruction_formats} == 1);

    my $builtins_id = ucfirst(lc($ID)) . "Descr" . ucfirst($format_cmd);
    $builtins_id =~ s/([0-9])/$Numbers{$1}/g;
    $builtins_id =~ s/_/U/g;

    my $format_fields = $$Format{$formatID}{fields};
    my $format_operands = $$Format{$formatID}{operands};
    my $format_properties_str = $$Format{$formatID}{properties};


    # Resolve properties
    # print STDERR "\tformat_properties=", %$format_properties, "\n";
    # print STDERR "\tinstruction_properties=", %$instruction_properties, "\n";
    while (my ($key, $value) = each %$instruction_properties) {
        delete $format_properties{$key} if $value =~ s/\b_\b//;
        push @{$properties{$key}}, (split /[-;]/, $value);
        #print STDERR "\tPUSHI($key,$value)\n";
    }
    while (my ($key, $value) = each %$format_properties) {
        push @{$properties{$key}}, (split /[-;]/, $value);
        #print STDERR "\tPUSHF($key,$value)\n";
    }
    my @properties; map {
        my $value = join ';', grep {$_} @{$properties{$_}};
        push @properties, "$_: $value" if $value;
      } sort { substr($a,1) cmp substr($b,1) } keys %properties;
    my $properties = join ', ', @properties if @properties;
    map {
        #print STDERR "ATTRLIST(", @{$$properties{$_}}, ")\n";
        foreach my $attribute (@{$properties{$_}}) {
            my $value = ($attribute =~ s/=?(\d+)$//)? $1: 1;
            #print STDERR "$attribute => $value\n";
            &Behavior::Symbol($_, { $attribute=>$value})
        }
      } keys %properties;

    (my $reservation_label = $reservation) =~ s/_/-/g;
    (my $reservation_latex = $reservation) =~ s/_/\\_/g;
    my ($match_field, $match_offset, $match_width, $match_opcode);
    my $forced_fields = "";
    my %saved_fields;
    while (my ($offset, $array) = each %{$format_fields}) {
        if (ref $array eq 'ARRAY') {
            my ($field, $width, $contents) = @{$array};
            if (ref $contents eq 'HASH') {
                while (my ($opcode, $names) = each %{$contents}) {
                    foreach my $name (@$names) {
                        if ($name eq $ID) {
                            ($match_field, $match_offset, $match_width, $match_opcode) = ($field, $offset, $width, $opcode);
                            my $specialized = sprintf("\%0${match_width}b", $match_opcode);
                            $forced_fields .= ", \\verb|${match_field} = $specialized|";
                            $saved_fields{$match_offset} = $$format_fields{$match_offset}->[2];
                            $$format_fields{$match_offset}->[2] = $specialized;
                        }
                    }
                }
            }
        }
    }
    # Encoding
    #print STDERR "FIELDS($ID):\t", Dumper($format_fields);
    print "\n\\paragraph{Encoding} Format \\textsf{${format_latex}} (Section~\\ref{sec:format-${format_label}})";
    print "$forced_fields\\\\\n";
    print &display($format_fields);

    # Preprocessing for syntax and description
    my $syntax = $$Format{$formatID}{syntax} || $instruction_syntax ;
    $syntax =~ s/(?<!\%)\%0\b/\\texttt{$mnemonic}/;
    my @operands_latex; my @builtin_operands; my $operand_index = 0; map {
        ++$operand_index;
        my $operand = $_;
        # Shorter builtin operand names.
        my $builtin_operand = $_;
        my $method = $$Operand{$operand}{method};
        my ($method_type) = keys %{$method};
        my $method_name = $$method{$method_type};
        if ($method_type eq 'Immediate') {
            my $extend = $$Immediate{$method_name}{extend};
            my $width = $$Immediate{$method_name}{width};
            $extend =~ s/Signed/s/;
            $extend =~ s/Unsigned/u/;
            $builtin_operand = $_ . "(" . $extend . $width . ")";
        }
        elsif ($method_type eq 'RegClass') {
            my $opnd_reg = $method_name;
            $opnd_reg =~ s/pairedReg/PR/;
            $opnd_reg =~ s/singleReg/GPR/;
            $builtin_operand = $_ . "(" . $opnd_reg . ")";
        }
        $operand =~ s/_/\\_$latex_allow_break/g;
        $builtin_operand =~ s/_/\\_$latex_allow_break/g;
        $operands_list{$method_type}{$operand} = $method_name;
        $operands_latex[$operand_index] = $operand;
        $builtin_operands[$operand_index] = $builtin_operand;
      } @{$format_operands};

    # Syntax
    my $builtin_syntax = &latex_syntax($syntax, @builtin_operands);
    $syntax = &latex_syntax($syntax, @operands_latex);
    print "\n\\paragraph{Syntax} $syntax\n";

    # Description
    my $description = $$Format{$formatID}{description} || '';
    $description .= $instruction_description if $instruction_description;
    my $builtin_description = &latex_description($description, @builtin_operands);
    my $description = &latex_description($description, @operands_latex);
    print "\n\\paragraph{Description} $description\n";

    # Modifiers
    my @modifiers;
    foreach my $operandID (@{$format_operands}) {
        my $method = $$Operand{$operandID}{method};
        my ($method_type) = keys %{$method};
        my $method_name = $$method{$method_type};
        if ($method_type eq 'Modifier') {
            push @modifiers, { METHOD=>$method_name, OPERAND=>$operandID };
        }
        $operank++;
    }

    if (@modifiers) {
        print "\n\\paragraph{Modifier(s)}";
        print "\n\\noindent\\begin{itemize}";
        foreach my $modifier (@modifiers) {
            my $method_name = $$modifier{METHOD};
            my $operandID = $$modifier{OPERAND};
            my $ID = $$Modifier{$method_name}{ID};
            (my $latex_modifier = $method_name) =~ s/_/\\_/g;
            (my $latex_operand = $operandID) =~ s/_/\\_/g;
            print "\n\\item $latex_operand (cf. $latex_modifier in section \\ref{par:modifier-${latex_modifier}} on page \\pageref{par:modifier-${latex_modifier}})";
        }
        print "\n\\end{itemize}\n"
    }

    # Execution
    my $res_table = $reservation;
#print "\n\\paragraph{Execution} \\hyperlink{Reservation-table-$res_table} {Reservation table $reservation (Section~\\ref{Reservation_table_$res_table})}\n";
    print "\n\\paragraph{Execution} {Reservation table \\textsf{$reservation_latex}";
    print " (Section~\\ref{sec:reservation-$reservation_label})}\n";
    my @methods = @{$$Format{$formatID}{methods}};
    my $method_index = 0;
    my @execution_operands = map {
        my $operand = $$format_operands[$method_index++];
        my $execution = $$RegClass{$_}{execution} || $$Immediate{$_}{execution} || $$Modifier{$_}{execution} || 'FIXME!';
        $execution =~ s/(?<!\%)\%0\b/$operand/;
        $execution;
      } @methods;
    unshift @execution_operands, 'MICROCODE';
    # Same code as in mds/MDS/MDD/MDE/BIN/Opcode.pl
    my @instruction_lines = grep {/\S/} split /\n/, $instruction_execution;
    my @format_lines = grep {/\S/} split /\n/, $$Format{$formatID}{execution};
    push @format_lines, "\@Instruction\n" unless grep {/\@Instruction\b/} @format_lines;
    my @lines; map {
        if (s/(\s*)\@Instruction\b(.*)\b//) {
            my ($prefix, $suffix) = ($1, $2);
            push @lines, map {"$prefix$_$suffix\n"} @instruction_lines;
        } else {
            push @lines, "$_\n";
        }
      } @format_lines;
    my ($stage, @stages) = (0); map {
        if (s/\bstage\s+(\d+):\s*//) { $stage = $1; }
        elsif (s/\bstage\s+(\w+):\s*//) {
            $stage = $pipeline{$1};
            die "unknown pipeline stage $1" unless defined $stage;
        }
        push @{$stages[$stage]}, "  $_" if $_ =~ /\S/;
      } @lines;

    my @contents = $$Format{$formatID}{behavior};
    if (grep {/\(MACRO\.Instruction\)/} @contents) {
        #print STDERR "Found MACRO in $instructionID\n" if $dump;
        @contents = map {
            my ($head, $tail) = split /\(MACRO\.Instruction\)/;
            if (defined $head && defined $tail) {
                ($head, $instruction_behavior, $tail);
            } else {
                $_;
            }
          } @contents;
    } else {
        unshift @contents, "(SEQ";
        push @contents, $instruction_behavior, ")";
    }
    &Behavior::yyin(@contents);
    if (&Behavior::yyparse) {
        print STDERR $instructionID, "\n", @contents, "\n";
        die "syntax error:\t", &Behavior::yylval, "\n";
    }
    &Behavior::yyflush;
#print STDERR "$ID:\n", "contents: @contents\n", &Pretty(&Behavior::yytree, " "), "\n";
    my @execution_contents = &create_execution_slot($ID, &Behavior::yytree);
    map {
        s/(?<!\%)\%([1-9]\d*)/$execution_operands[$1]/g;
        s/(?<!\@)\@([1-9]\d*)/$$format_operands[$1-1]/g;
      } @execution_contents;
    #print STDERR "$ID:\n";
    #print STDERR @execution_contents, "\n";

    my @execution = ("\n");
    for (my $stage = 0; $stage < @stages; $stage++) {
        next unless defined $stages[$stage];
        my $pipestage = $pipeline[$stage] || $stage;
        push @execution, "stage $pipestage:\n";
        push @execution, @{$stages[$stage]};
    }
    if (@execution) {
        map {
            s/(?<!\%)\%([1-9]\d*)/$execution_operands[$1]/g;
            s/(?<!\@)\@([1-9]\d*)/$$format_operands[$1-1]/g;
          } @execution;
        # new:
        print "~\n{\\begin{lstlisting}", @execution_contents, "\\end{lstlisting}}\n";
        # old:
        # print "~\n{\\begin{lstlisting}", @execution, "\\end{lstlisting}}\n";
    } else {
        print "\\textbf{MISSING}\n";
    }

    # Restore format_fields
    while (my ($offset, $old_value) = each %saved_fields) {
        $$format_fields{$offset}->[2] = $old_value;
    }
}

foreach my $instruction (@Instruction) {
    #print STDERR Dumper($instruction);
    my $what = $$instruction{what};
    my $ID = $$instruction{ID};
    my $class = $$instruction{class};
    die "Unknown class '$class' for instrution $ID" unless defined $class && defined $Order{$class};
    my $instruction_syntax = $$instruction{syntax};
    my $instruction_mnemonic = $$instruction{mnemonic};
    my $instruction_formats = $$instruction{formats};
    my $instruction_description = $$instruction{description};
    my $instruction_execution = $$instruction{execution};
    my $instruction_schedulings = $$instruction{schedulings};

    next if $ID =~ /_$/;	# Assume trailing _ means dummy Instruction.

    if ($prev_class ne $class) {
        $prev_class = $class;
        print "\\subsection{$class Instructions}\n";
        print "\\label{sec:$class-instructions}\n\n";
    }
    my ($class, $name) = split /:/, $ID;
    $name =~ s/_/\\_/g;
    (my $mnemonic = $instruction_mnemonic) =~ s/_/\\_/g;
    my $loc_what = $what;
    $loc_what =~ s/\$\\times\$/\\texorpdfstring{\$\\times\$}{x}/;
    print "\\subsubsection[{\\small $name: $loc_what}]{$name\\hfill $what}\n";
    print "\\label{instr:$name}\\index{$mnemonic}\n " unless $class =~ /^RV/; # Skip RISC-V strange mnemonics.
    my @reservations = map {
        $$Scheduling{$_}{reservation}
      } @{$instruction_schedulings};
    foreach my $formatID (@{$instruction_formats}) {
        my $reservation = shift @reservations;
        &dumpFormat($formatID, $instruction, $reservation);
        print "\\newpage\n";
    }
}
#print "\\subsubsectionfont{}\n}\n"; # end of kalrayblue color

print "\\subsection{Instruction operands}\n";
print "\\label{sec:Instruction-operands}\n\n";
foreach my $operand_type (sort keys %operands_list) {
    my $operand_title = "";
    if ($operand_type eq "Modifier") {
        $operand_title = "Operand Modifiers";
    }
    elsif ($operand_type eq "RegClass") {
        $operand_title = "Register Classes";
    }
    elsif ($operand_type eq "Immediate") {
        $operand_title = "Immediate classes";
    }
    else {
        croak("Unknown operand type: $operand_type");
    }

    my $operand_label = $operand_title;
    $operand_label =~ s/_/\\_/g;
    $operand_label =~ s/\s/\-/g;

    print "\\subsubsection{$operand_title}\n";
    print "\\label{opnd:$operand_label}\n";

    my $list = $operands_list{$operand_type};
    my %operand_classes;
    foreach my $operand (sort { $$list{$a} cmp $$list{$b} } keys %$list) {
        push @{$operand_classes{$$list{$operand}}}, $operand
    }

    if ($operand_type eq "Immediate") {
        print "{\\scriptsize\n";
        print "\\begin{tabular}{|l|l|l|} \\hline\n";
        print "\\bf{$operand_title} & \\bf{Operands} & \\bf{What} \\\\ \\hline\n";

        foreach my $operand_class (sort keys %operand_classes) {
            my $operands = $operand_classes{$operand_class};
            my $immediate = $$Immediate{$operand_class};
            my $what = $$immediate{what};
            print  "$operand_class & ". join(", ", sort(@{$operands})) ." & \\verb| $what |\\\\\n";
        }

        print "\\hline \\end{tabular}\n";
        print "}\n";
        print "\\newpage\n";

        print "{\\scriptsize\n";
        print "\\begin{tabular}{|l|l|l|l|l|} \\hline\n";
        print "\\bf{$operand_title} & \\bf{Extend} & \\bf{Shift} & \\bf{Width} & \\bf{Values} \\\\ \\hline\n";

        foreach my $operand_class (sort keys %operand_classes) {
            my $immediate = $$Immediate{$operand_class};
            my $extend = $$immediate{extend};
            my $width = int($$immediate{width});
            my $shift =  $$immediate{shift};
            my $mask = (1 << $width) - 1;
            my $max_signed = (1 << ($width-1)) - 1;
            my $min_signed = ~((1 << ($width-1)) - 1) & $mask;
            my $max_unsigned = (1 << $width) - 1;
            my $max = 0, $min = 0;

            if ($width == 64) {
                # Perl max value
                $mask = 0x7fffffffffffffff;
                $min_signed   = 0x8000000000000000;
                $max_unsigned = 0x7fffffffffffffff;
            }

            if(defined $$immediate{shift}) {
                $shift = int($shift);
                $shift_mask = ~((1 << $shift) -1);
                $max_signed = ($max_signed << $shift) & $shift_mask;
                $min_signed = ($min_signed << $shift) & $shift_mask;
                $max_unsigned = ($max_unsigned << $shift) & $shift_mask;
            }
            else {
                $shift = 0;
            }

            if($extend eq "Signed") {
                $max = $max_signed;
                $min = $min_signed;
            }
            elsif($extend eq "Unsigned") {
                $max = $max_unsigned;
                $min = 0;
            }
            elsif($extend eq "Wrap") {
                $max = $max_unsigned;
                $min = $min_signed;
            }
            else {
                croak("$operand_class: Unknown immediate extend: $extend");
            }

            printf("%s & %s & %d & %d & 0x%x to 0x%x \\\\\n", $operand_class, $extend, $shift, $width, $min, $max);
        }
        print "\\hline \\end{tabular}\n";
        print "}\n";
        print "\\newpage\n";
    }
    elsif($operand_type eq "RegClass") {
        print "{\\scriptsize\n";
        print "\\begin{tabular}{|l|l|l|} \\hline\n";
        print "\\bf{$operand_title} & \\bf{Instances} & \\bf{Width} \\\\ \\hline\n";

        foreach my $operand_class (sort keys %operand_classes) {
            my $operands = $operand_classes{$operand_class};
            my $regclass = $$RegClass{$operand_class};
            my $regfile = $$RegFile{$$regclass{regFile}};
            my $width = $$regfile{width};
            print  "$operand_class & ". join(", ", sort(@{$operands})) ." & $width \\\\\n";
        }

        print "\\hline \\end{tabular}\n";
        print "}\n";
        print "\\newpage\n";

        foreach my $operand_class (sort keys %operand_classes) {
            my $regclass = $$RegClass{$operand_class};
            my $regfileID = $$RegFile{$$regclass{regFile}}{ID};
            my $registers = $$regclass{registers};

            print "{\\scriptsize\n";
            print "\\begin{tabular}{|l|l|l|} \\hline\n";
            print "\\bf{Register Class} & \\bf{Register File} & \\bf{Registers} \\\\ \\hline\n";
            (my $operand_class_latex = $operand_class) =~ s/_/\\_/g;
            (my $regfileID_latex = $regfileID) =~ s/_/\\_/g;
            my $first = 1;
            my @reg_info;
            foreach my $reg (@{$registers}) {
                my $names = $$Register{$reg}{names};
                my @names_latex = map { s/_/\\_/g } @{$names};
                if($first) {
                    print " $operand_class_latex & $regfileID_latex & \\texttt{".join(" ",@names_latex)."} \\\\\n";
                    $first = 0;
                }
                else {
                    print " & & \\texttt{".join(" ",@names_latex)."} \\\\\n";
                }
            }
            print "\\hline \\end{tabular}\n";
            print "}\n";
            print "\\newpage\n";
        }
    }
    elsif($operand_type eq "Modifier") {
        print "{\\scriptsize\n";
        print "\\begin{tabular}{|l|l|l|} \\hline\n";
        print "\\bf{$operand_title} & \\bf{Instances} \\\\ \\hline\n";

        foreach my $operand_class (sort keys %operand_classes) {
            (my $operand_class_latex = $operand_class) =~ s/_/\\_/g;
            my $operands = $operand_classes{$operand_class};
            my @operands_latex = map { s/_/\\_/g } @{$operands};
            print  "$operand_class_latex & ". join(", ", sort(@operands_latex)) ." \\\\\n";
        }

        print "\\hline \\end{tabular}\n";
        print "}\n";
        print "\\newpage\n";

        foreach my $operand_class (sort keys %operand_classes) {
            my $modifier = $$Modifier{$operand_class};
            my $ID = $$modifier{ID};
            my @members = @{$$modifier{members}};
            my @cases = @{$$modifier{cases}};
            my @values = @{$$modifier{values}};
            (my $latex_modifier = $ID) =~ s/_/\\_/g;
            (my $latex_operand = $operandID) =~ s/_/\\_/g;
            print "\n\\paragraph{Modifier} \\textsf{$ID}:\\\\";
            print "\n\\phantomsection";
            print "\n\\label{par:modifier-$latex_modifier}";
            print "\n\\noindent \\begin{tabular}{|l|l|r|} \\hline\n";
            print "\\bf{Name} & \\bf{Case} & \\bf{Value} \\\\ \\hline\n";
            while (@members) {
                my $name = shift @members;
                (my $latex_name = $name)  =~ s/_/\\_/g;
                my $case = shift @cases;
                my $value = shift @values;
                print "$latex_name & $case & $value \\\\\n";
            }
            print "\\hline \\end{tabular}\n";
            print "\\newpage\n";
        }
    }
}

close(INPUT) || die $!;

# vim: set ts=4 sw=4 et:
