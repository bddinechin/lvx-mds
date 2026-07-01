#!/usr/bin/perl -w

my %opcode = ();

while (<>) {
    if (/^[ ]+([A-Z][A-Z0-9_.]*)[ ]*\|/) {
        my $mnemonic = $1;
        if (/\t([A-Z].*)/) {
            my $scheduling = $1;
            push @{$opcode{$mnemonic}}, $scheduling if $scheduling;
        }
    }
}

foreach my $mnemonic (sort keys %opcode) {
    my %seen = ();
    my @schedulings = grep {not $seen{$_}++} @{$opcode{$mnemonic}};
    #print "$mnemonic\t@schedulings\n";
    print "$mnemonic\n";
}

