#
# Build the Instruction.tex LaTeX file.
# Benoit Dupont de Dinechin 2009.
#

use YAML::XS;

use Data::Dumper;
#use strict;
do 'display.pl';

open(INPUT, "<", $ARGV[0]) || die "can't open $ARGV[0]\n";

local $/;
my $Load = Load(<INPUT>);
my $Register = $$Load{Register};
my $RegClass = $$Load{RegClass};
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
for (my $stage = 0; $stage < @pipeline; $stage++) {
    $pipeline{$pipeline[$stage]} = $stage;
}
#print STDERR Dumper(%pipeline);

# Order the Instruction(s) alphabetically by class then ID.
my @Instruction = sort { ($Order{$$a{class}} <=> $Order{$$b{class}}) || ($$a{ID} cmp $$b{ID}) } values %{$Instruction};
#print STDERR Dumper(@Instruction);

# Emit the LaTeX code on STDOUT.
my $prev_class = '';

my $latex_allow_break = "\\discretionary{}{}{}";

my %Nums = (
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
    # allow line-breaking afer ':' in args like '%5:%6'
    $description =~ s/:\\emph/:$latex_allow_break\\emph/g;
    return $description;
}

foreach my $instruction (@Instruction) {
    #print STDERR Dumper($instruction);
    my $what = $$instruction{what};
    my $ID = $$instruction{ID};
    my $class = $$instruction{class};
    die "Unknown class '$class' for instrution $ID" unless defined $class && defined $Order{$class};
    next if $ID =~ /_$/;	# Assume trailing _ means dummy Instruction.
    if ($prev_class ne $class) {
        $prev_class = $class;
        print "\\sect{$class}\n";
    }
    my ($class, $name) =  split /:/, $ID;
    $name =~ s/_/\\_/g;
    my $loc_what = $what;
    $loc_what =~ s/\$\\times\$/\\texorpdfstring{\$\\times\$}{x}/;
    print "\\cm{$name}{$what}\n";
}

close(INPUT) || die $!;
# vim: set ts=4 sw=4 et:
