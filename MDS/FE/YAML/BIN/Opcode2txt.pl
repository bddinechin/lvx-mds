#
# Build the Opcode.xt file.
# Benoit Dupont de Dinechin 2009.
#

use Data::Dumper;

use YAML::XS;
#use Module::Load::Conditional qw[can_load];
#if(not can_load(modules => { 'YAML::XS' => undef })) {
#  print STDERR "********************************************\n";
#  print STDERR "* YAML::XS not found.                      *\n";
#  print STDERR "* Fall back to regular YAML module instead *\n";
#  print STDERR "* Compilation will be much slower.         *\n";
#  print STDERR "********************************************\n";
#  die "Please install YAML::XS (package perl-YAML-LibYAML)!";
#} else {
#  YAML::XS->import;
#  print STDERR "YAML::XS was found.\n";
#}

open(INPUT, "<", $ARGV[0]) || die "can't open $ARGV[0]\n";

local $/;
my $Load = Load(<INPUT>);
my $Format = $$Load{Format};
my $Encoding = $$Load{Encoding};
my $Instruction = $$Load{Instruction};

# Order the Format(s) by increasing number.
my @Format = sort { $$a{number} <=> $$b{number} } values %{$Format};
#print STDERR Dumper(@Format);

# Order the Encoding(s) by increasing wordCount.
my @Encoding = sort {
    $$a{wordCount} <=> $$b{wordCount} || $$a{number} <=> $$b{number}
  } values %{$Encoding};
#print STDERR Dumper(@Format);

# Map Format ID to Instruction(s).
my %instructions;
while (my ($instruction_ID, $instruction) = each %{$Instruction}) {
    my @formatIDs = @{$$instruction{formats}};
    my @schedulingIDs = @{$$instruction{schedulings}};
    my @pruned_formatIDs = grep { ! ($_ =~ /^\*/) } @formatIDs;
    print STDERR "prune: @pruned_formatIDs\n";
    die "$instruction_ID: mismatched formats and schedulings" unless (@pruned_formatIDs == @schedulingIDs);
# If die above, either fix description or fix @schedulingIDs like in ./MDD/MDE/BIN/Instruction.X.pl
    foreach my $format_ID (@{$$instruction{formats}}) {
        next if $format_ID =~ /^\*/;
        my $schedulingID = shift @schedulingIDs;
        my ($class, $name) = split /:/, $instruction_ID;
        $instructions{$format_ID}{$name} = $schedulingID;
    }
}
#print STDERR Dumper(\%instructions);

# Emit the LaTeX code on STDOUT.
my $table = '';
my $line_length;
my $prev_length;
foreach my $encoding (@Encoding) {
    #print STDERR "Encoding $$encoding{ID}\n";
    my $wordWidth = $$encoding{wordWidth};
    my $wordCount = $$encoding{wordCount};
    my $totalWidth = $wordCount*$wordWidth;
    $line_length = 4*$totalWidth - 1;
    foreach my $format (@Format) {
        if ($$format{encoding} eq $$encoding{ID}) {
            #print STDERR "Format $$format{ID}, encoding $$encoding{ID}:\n";
            my %matches = ();
            my @matches_keys = ();
            my $format_ID = $$format{ID};
            my $encoding_ID = $$encoding{ID};
            my $format_fields = $$format{fields};
            my ($newtable) = split '_', $format_ID;
            if ($newtable ne $table) {
                if ($table) {
                    my $length = $prev_length || $line_length;
                    print ' ' x 16, '+', '-' x $length, "+\n\n";
                }
                printf "%-15s", $encoding_ID;
                for (my $i = $totalWidth - 1; $i >= 0; --$i) {
                    printf "%4d", $i;
                }
                print "\n";
                $table = $newtable;
            }
            printf "%-16s+", $format_ID;
            print '-' x $line_length, "+\n";
            $prev_length = $line_length;
            foreach my $offset (sort keys %{$format_fields}) {
                my $array = $$format_fields{$offset};
                if (ref $array eq 'ARRAY') {
                    my ($field, $width, $contents) = @{$array};
                    if (ref $contents eq 'HASH') {
                        foreach my $opcode (sort { $a <=> $b } keys %{$contents}) {
                            my $names = $$contents{$opcode};
                            foreach my $name (@$names) {
                                if (!ref $name) {
                                    my $schedulingID = $instructions{$format_ID}{$name};
                                    if (! exists $matches{$name}) {
                                        $matches{$name} = [];
                                        push @matches_keys, $name;
                                    }
                                    push @{$matches{$name}}, [ $field, $offset, $width, $opcode, $schedulingID ];
                                    unless ($schedulingID) {
                                  #print STDERR "Orphan for $format_ID:$name\n";
                                  #$instructions{$format_ID}{$name} = 0;
                                    }
                                } else {
                #push @matches, [ $field, $offset, $width, $opcode, "FORMAT*" ];
                                }
                            }
                        }
                    }
                }
            }
            foreach my $name (@matches_keys) {
                my $desc = $matches{$name};
                my %saved_offsets = ();
                my $scheduling;
                foreach my $match (@{$desc}) {
                    my ($field, $offset, $width, $opcode, $schedulingID) = @{$match};
                    if (defined $scheduling) {
                        if ($schedulingID ne $scheduling) {
                            die "Scheduling class mismatch for $name.";
                        }
                    } else {
                        $scheduling = $schedulingID;
                    }
                    $saved_offsets{$offset} = $$format_fields{$offset}->[2];
                    my $specialized = sprintf("\%0${width}b", $opcode);
                    $$format_fields{$offset}->[2] = $specialized;
                }
                &print_opcode($format_fields, $name, $scheduling);
                while (my ($offset, $old_value) = each %saved_offsets) {
                    $$format_fields{$offset}->[2] = $old_value;
                }
            }
            # Warn for the orphan instructions.
            my @orphans = grep { !$instructions{$format_ID}{$_} }
              keys %{$instructions{$format_ID}};
            if (@orphans) {
                print STDERR "Orphans for $format_ID: ", (join ' ', sort @orphans), "\n";
            }
        }
    }
}
print ' ' x 16, '+', '-' x $line_length, "+\n\n" if $table;
#print STDERR Dumper(%instructions);

sub print_opcode {
    my ($fields, $ID, $schedulingID) = @_;
    my $rename = {
        parallel2=>'P',
        parallel=>'P',
        remote2=>'R',
        remote=>'R',
        SIMD2=>'S',
        SIMD=>'S',
      };
    my @offsets = sort {$a <=> $b} keys %{$fields};
    my @words; map { push @{$words[$_/32]}, $_ } @offsets;
    my $flag = defined $schedulingID? ' ': '*';
    printf " $flag%-14s|", $ID;
    foreach my $word (reverse @words) {
        foreach my $offset (reverse @{$word}) {
            my $name = $$fields{$offset}[0];
            my $width = $$fields{$offset}[1];
            my $contents = $$fields{$offset}[2];
            if ($contents =~ /^[01_]+$/) {
                my $field = join '   ', (split //, $contents);
                print " $field |";
            } else {
                my $resize = 4*$width - 1;
                my $field = $$rename{$name} || $name;
                while (length($field) > $resize) {
                    $field =~ s/.$//;
                }
                while (length($field) < $resize) {
                    $field .= ' ';
                    $field = " $field" if length($field) < $resize;
                }
                print "$field|";
            }
        }
    }
    print "\t$schedulingID" if defined $schedulingID;
    print "\n";
}

close(INPUT) || die $!;

# vim: set ts=4 sw=4 et:
