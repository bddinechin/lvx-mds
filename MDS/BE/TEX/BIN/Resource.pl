#
# Build the Resource.tex LaTeX file.
# Benoit Dupont de Dinechin 2011.
#

use YAML::XS;

use Data::Dumper;

open(INPUT, "<", $ARGV[0]) || die "can't open $ARGV[0]\n";

local $/;
my $Load = Load(<INPUT>);
my $Resource = $$Load{Resource};

my @Resources = sort { $$a{number} <=> $$b{number} } values %{$Resource};

print "\\begin{table}\n";
print "\\begin{center}\n";
print "\\begin{tabular}{|l|r|} \\hline\n";
print "Resource\t& Availability ";
print "\\\\ \\hline\n";
foreach my $resource (@Resources) {
  my $resourceID = $$resource{ID};
  my $availability = $$resource{availability};
  print "$resourceID\t& $availability\t\\\\\n";
}
print "\\hline \\end{tabular}\n";
print "\\end{center}\n";
print "\\label{table:resources}\n";
print "\\caption{Kalray-1 processor execution resources.}\n";
print "\\end{table}\n";

close(INPUT) || die $!;

