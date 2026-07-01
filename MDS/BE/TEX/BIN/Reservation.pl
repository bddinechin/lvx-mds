#
# Build the Reservation.tex LaTeX file.
# Benoit Dupont de Dinechin 2011.
#

use YAML::XS;

use Data::Dumper;

open(INPUT, "<", $ARGV[0]) || die "can't open $ARGV[0]\n";

local $/;
my $Load = Load(<INPUT>);
my $Resource = $$Load{Resource};
my $Reservation = $$Load{Reservation};

my @Resources = sort { $$a{number} <=> $$b{number} } values %{$Resource};
my @Reservations = sort { $$a{ID} cmp $$b{ID} } values %{$Reservation};

foreach my $reservation (@Reservations) {
#print STDERR "Reservation $$reservation{ID}\n";
  my %required;
  my $ID = $$reservation{ID};
  my $what = $$reservation{what};
  my @resources = @{$$reservation{resources}};
  my @requirements = @{$$reservation{requirements}};
  my @stalls = @{$$reservation{stalls}};
  my ($index, $columns) = (0, 0);
  while (@requirements) {
    use integer;
    my $row = $index%(scalar @resources);
    my $column = $index/(scalar @resources);
    $columns = ($column + 1) if $column >= $columns;
    my $required = shift @requirements;
    my $resourceID = $resources[$row];
    $required{$resourceID}[$column] = $required;
    $index++;
  }
  (my $label = $ID) =~ s/_/-/g;
  (my $latex = $ID) =~ s/_/\\_/g;
  (my $name = $$reservation{ID}) =~ s/_/\\_/g;
  #print "\\hypertarget{Reservation-table-$res_table}{}\\subsubsection{Reservation Table $name}\n";
  print "\\subsubsection{Reservation Table $latex} \\label{sec:reservation-$label}\n";
  if ($what && $what =~ /\S/) {
    print "\n$what\n\\medskip\n";
  }
  print "\n\\begin{tabular}{|l|";
  print "r|" x $columns, "} \\hline\n";
  print "Resource";
  for my $cycle (0 .. $columns - 1) { print "\t& Cycle $cycle " }
  print "\\\\ \\hline\n";
  foreach my $resource (@Resources) {
    my $resourceID = $$resource{ID};
    print "\\textsf{$resourceID}";
    foreach my $column (0 .. $columns - 1) {
      my $required = $required{$resourceID}[$column] || '';
      print "\t& $required";
    }
    print "\t\\\\\n";
  }
  print "\\hline Stalls";
  foreach my $column (0 .. $columns - 1) {
    my $stalling = $stalls[$column] || '';
    print "\t& $stalling";
  }
  print "\t\\\\\n";
  print "\\hline \\end{tabular}\n\n";
}

close(INPUT) || die $!;

