#
# Build the RegFile.tex LaTeX file.
# Benoit Dupont de Dinechin 2009.
#

use YAML::XS;
use File::Basename;
use Data::Dumper;

use strict;

open(INPUT, "<", $ARGV[0]) || die "can't open $ARGV[0]\n";
my ($name,$path,$suffix) = fileparse($ARGV[0]);

local $/;
my $Load = Load(<INPUT>);
my $RegClass = $$Load{RegClass};
my $Register = $$Load{Register};

# The register files are the RegClass(es) carrying a regFileName. Order them by
# increasing regFileNumber, which is the order they are declared in.
my @RegFile = sort {
    $$a{regFileNumber} <=> $$b{regFileNumber}
  } grep { defined $$_{regFileName} } values %{$RegClass};
#print STDERR Dumper(@RegFile);

# Emit the LaTeX code on STDOUT.
foreach my $regFile (@RegFile) {
    #print STDERR Dumper($regFile);
    my $ID = $$regFile{regFileName};
    open(FILE, '>', "${path}RegFile-$ID.tex") || die $!;
    my $registers = $$regFile{registers};
    print FILE << 'EOT';
{\scriptsize
\begin{tabular}{|l|l|l|l|l|} \hline
ID & Names & Index & Description & Reset Value \\ \hline
EOT

    my %ignoredRegisters;
    my %indexedRegisters;
    my $prefixID = "";
    my $currentID = "";
    my $reset = undef;
    foreach my $register (@$registers) {
        my $names = $$Register{$register}{names};
        my $ID = uc(@{$names}[0]);
        $ID =~ s/^\$//g;
        if($ID !~ /^RES/) {
            $ID = $$Register{$register}{ID};
        }

        if($ID =~ /^([^0-9]+)([0-9]+)$/) {
            my $prefix = $1;
            my $index = $2;

            if($prefixID eq "") {
                # New prefixed register
                $currentID = $ID;
                $prefixID = $prefix;
                $reset = $$Register{$register}{reset};
                push @{$indexedRegisters{$currentID}}, $register;
            }
            elsif(($prefixID eq $prefix) && ($reset == $$Register{$register}{reset})) {
                # Continue with same prefix and mark it as printed
                push @{$indexedRegisters{$currentID}}, $register;
                $ignoredRegisters{$ID} = $register;
            }
            else {
                # Another prefixed register
                $currentID = $ID;
                $prefixID = $prefix;
                $reset = $$Register{$register}{reset};
                push @{$indexedRegisters{$currentID}}, $register;
            }
        }
        else {
            $currentID = "";
            $prefixID = "";
        }
    }

    foreach my $register (@$registers) {
        my $names = $$Register{$register}{names};
        my $ID = uc(@{$names}[0]);
        $ID =~ s/^\$//g;
        if($ID !~ /^RES/) {
            $ID = $$Register{$register}{ID};
        }
        my $what = $$Register{$register}{what};
        if(not defined $ignoredRegisters{$ID}) {
            if($what) {
                my $names = $$Register{$register}{names};
                $names = join(' ',@{$names}) if ref $names;
                my $index = $$Register{$register}{index};
                my $reset = $$Register{$register}{reset} || '';
                $what =~ s/[_]{1}/\\\_/;
                $what =~ s/[<]{1}/\\textless /;
                $what =~ s/[>]{1}/\\textgreater/;

                if($ID =~ /^([^0-9]+)([0-9]+)$/) {
                    my $prefix = $1;
                    my $index = $2;

                    die "Undefined indexedRegisters for $ID" if(not defined $indexedRegisters{$ID});

                    my @prefixedRegisters = @{$indexedRegisters{$ID}};
                    my $registerID = "${prefix}\\textless i\\textgreater";
                    $registerID =~ s/[_]{1}/\\\_/;
                    my @registerNames = @{$$Register{$prefixedRegisters[0]}{names}};
                    my @regNames;
                    my $first_reg = $$Register{$prefixedRegisters[0]};
                    my $last_reg = $$Register{$prefixedRegisters[-1]};
                    my $first_register_index = $$first_reg{index};
                    my $last_register_index = $$last_reg{index};
                    my $regRange = $last_register_index - $first_register_index;

                    my $firstID = $$first_reg{ID};
                    my $lastID = $$last_reg{ID};
                    $firstID =~ /^([^0-9]+)([0-9]+)$/;
                    my $first_regID_index = $2;
                    $lastID =~ /^([^0-9]+)([0-9]+)$/;
                    my $last_regID_index = $2;
                    foreach my $regName (@registerNames) {
                        if($regName =~ /^([^0-9]+)([0-9]+)$/) {
                            my $reg_name = $regName . "-" . $1 . ($2 + $regRange);
                            push @regNames, $reg_name;
                        }
                        else {
                            die "Unable to specify register name ranges for $regName";
                        }
                    }
                    $names = join(' ',@regNames);

                    $what =~ s/${first_regID_index}/\\textless i\\textgreater [$first_regID_index, $last_regID_index]/;

                    print FILE << "EOT";
$registerID & \\verb|$names| & $first_register_index - $last_register_index & $what & \\verb|$reset| \\\\
EOT

                }
                else {
                    $ID =~ s/[_]{1}/\\\_/;
                    print FILE << "EOT";
$ID & \\verb|$names| & $index & $what & \\verb|$reset| \\\\
EOT
                }
            }
        }
    }
    print FILE << 'EOT';
\hline \end{tabular}
}
EOT
    close(FILE)  || die $!;
}

close(INPUT) || die $!;
# vim: set ts=4 sw=4 et:
