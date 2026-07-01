#!/usr/bin/perl -w

use Getopt::Std;
my %option;
getopts('t:', \%option);
my $target = $option{t};

# Sample code to use the CHESS.pm

use CHESS;
my $records = &CHESS::parse(*ARGV);
foreach my $record (@{$records}) {
    my $key = $$record{KEY};
    my $comment = $$record{COMMENT};
    if (defined $comment) {
        local $, = "\n";
        print @{$comment}, "";
    }
    if (defined $key) {
        my @fields = @{$$record{FIELDS}};
        my $fields = join ' ', @fields;
        print "KEY\t$key\n";
        print "FIELDS\t$fields\n";
        foreach my $field (@fields) {
            my $value = $$record{$field};
            print "$field\t$value\n";
        }
    }
}

# vim: set ts=4 sw=4 et:
