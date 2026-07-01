# Display in LaTeX the fields of a format or an opcode.
# Parameter $fields: $$fields{$offset} = [ $name, $width, $contents ];
sub display {
    my ($fields) = @_;
    my $rename = {
        parallel4=>'P',
        parallel3=>'P',
        parallel2=>'P',
        parallel=>'P',
        steering=>'S',
        negate=>'N',
        rounding=>'rnd',
      };
    my @offsets = sort {$a <=> $b} keys %{$fields};
    #print STDERR "OFFSETS:", Dumper(@offsets);
    my @words; map { push @{$words[$_/32]}, $_ } @offsets;
    #print STDERR "WORDS:", Dumper(@words);
    my $result = "\n\\bitfields{";
    my $countwords=0;
    foreach my $word (reverse @words) {
        foreach my $offset (reverse @{$word}) {
            my $name = $$fields{$offset}[0];
            my $width = $$fields{$offset}[1];
            my $contents = $$fields{$offset}[2];
            # take a number divisible by 32 (less decimals for TeX)
            my $field_name = ($contents =~ /^[01_]+$/)? $contents: ($$rename{$name} || $name);
            $field_name =~ s/_/-- /g;
            $field_name =~ s/exucode/ex/;
            $field_name =~ s/exubit/b/;
            $field_name =~ s/bcucode/bcu/;
            $result .= " $width/$field_name,"
        }
    }
    $result =~ s/-- *,/--,/g;
    $result =~ s/,$//;
    return $result . " }\n\n";
}

1;

# vim: set ts=4 sw=4 et:
