#
# Build the Format.tex LaTeX file.
# Benoit Dupont de Dinechin 2009.
#

use YAML::XS;

use Data::Dumper;
do 'display.pl';

open(INPUT, "<", $ARGV[0]) || die "can't open $ARGV[0]\n";

local $/;
my $Load = Load(<INPUT>);
my $Format = $$Load{Format};
#print STDERR Dumper($Format);

# Order the Format(s) by increasing number.
my @Format = sort { $$a{number} <=> $$b{number} } values %{$Format};
#print STDERR Dumper(@Format);

# Emit the LaTeX code on STDOUT.
foreach my $format (@Format) {
  #print STDERR Dumper($format);
  my $ID = $$format{ID};
  my $what = $$format{what};
  # Do not print format only used to validate HW
  next if($what =~ /\[ONLY_FOR_HW\]/);
  (my $latex_what = $what) =~ s/_/\\_/g;
  (my $label = $ID) =~ s/_/-/g;
  print "\n\\subsubsection[{\\small $latex_what}]{$latex_what} \\label{sec:format-$label}\n";
  my $fields = $$format{fields};
  print &display($fields);
}

close(INPUT) || die $!;

