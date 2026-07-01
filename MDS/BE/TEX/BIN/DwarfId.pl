#
# Build the DwarfId.tex LaTeX file.
# Benoit Dupont de Dinechin 2011.
#

use YAML::XS;

use Carp;
use Data::Dumper;

open(INPUT, "<", $ARGV[0]) || die "can't open $ARGV[0]\n";

local $/;
my $Load = Load(<INPUT>);
my $Register = $$Load{Register};

my %RegFile; map { push @{$RegFile{$$_{regFile}}}, $_ }
             sort { $$a{dwarfId} <=> $$b{dwarfId} }
             grep {defined $$_{dwarfId}} values %{$Register};

#print STDERR Dumper(%RegFile);

foreach $regFile (sort keys %RegFile) {
  my $registers = $RegFile{$regFile};
  print << "EOT";
\\begin{table}
\\begin{center}
{\\small
\\begin{tabular}{|l|l|l||l|l|l|} \\hline
ID & Names & Number & ID & Names & Number \\\\ \\hline
EOT
  my $count = scalar @$registers;
  my $rows = 1; $rows <<= 1 while $rows << 1 < $count;
  for (my $index = 0; $index < $rows; $index++) {
    #
    my $register1 = $$registers[$index];
    my $dwarfId1 = $$register1{dwarfId} || '';
    my $names1 = $$register1{names} || [ "" ];
    my $ID1 = uc(@{$names1}[0]);
    $ID1 =~ s/^\$//g;
    if($ID1 !~ /^RES\d/) {
	$ID1 = $$register1{ID};
    }
    $names1 = join(' ',@{$names1}) if ref $names1;
    #
    my $register2 = $$registers[$index + $rows];
    my $dwarfId2 = $$register2{dwarfId} || '';
    my $names2 = $$register2{names} || [ "" ];
    my $ID2 = uc(@{$names2}[0]);
    $ID2 =~ s/^\$//g;
    if($ID2 !~ /^RES/) {
	$ID2 = $$register2{ID};
    }
    $names2 = join(' ',@{$names2}) if ref $names2;
    #
    print << "EOT";
$ID1 & \\verb|$names1| & $dwarfId1 &
$ID2 & \\verb|$names2| & $dwarfId2 \\\\
EOT
  }
  print << "EOT";
\\hline \\end{tabular}
}
\\end{center}
\\caption{DWARF register numbers for register file $regFile.}
\\label{table:DwarfId-$regFile}
\\end{table}\n
EOT
}

close(INPUT) || die $!;

