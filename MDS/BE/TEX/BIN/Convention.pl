#
# Build the Convention.tex LaTeX file.
# Benoit Dupont de Dinechin 2009.
#

use YAML::XS;
use File::Basename;
use Data::Dumper;

do 'display.pl';

open(INPUT, "<", $ARGV[0]) || die "can't open $ARGV[0]\n";
my ($name,$path,$suffix) = fileparse($ARGV[0]);

local $/;
my $Load = Load(<INPUT>);
my $Register = $$Load{Register};
my $Convention = $$Load{Convention};
#print STDERR Dumper($Convention);

my @roles = qw{
  reserved
  argument
  result
  struct
  caller
  callee
  program
  handler
  veneer
  return
  stack
  static
  frame
  global
  local
  wired
  zero
  fzero
  one
  true
  };

# Emit the LaTeX code on STDOUT.
foreach my $convention (values %$Convention) {
    #print STDERR Dumper($convention);
    my $ID = $$convention{ID};
    open(FILE, '>', "${path}Convention-$ID.tex") || die $!;
    print FILE << 'EOT';
{\scriptsize
\begin{tabular}{|l|l||} \hline
Role & Registers \\ \hline
EOT
    foreach my $role (@roles) {
        my ($Role, $counter) = ("$role &\t", 0);
        my $registers = $$convention{$role};
        foreach my $register (@{$registers}) {
            unless ($counter & 0x7) {
                print FILE $Role;
                $Role = "\\\\\n &\t";
            }
            my $register_names = $$Register{$register}{names};
            if (ref $register_names eq 'ARRAY') {
                print FILE "\\verb|$$register_names[0]| ";
            } else {
                my ($register_name) = split ' ', $register_names;
                print FILE "\\verb|$register_name| ";
            }
            $counter++;
        }
        print FILE "\\\\\n" if @{$registers};
    }
    print FILE << 'EOT';
\hline \end{tabular}
}
EOT
    close(FILE)  || die $!;
}

close(INPUT) || die $!;

# vim: set ts=4 sw=4 et:
