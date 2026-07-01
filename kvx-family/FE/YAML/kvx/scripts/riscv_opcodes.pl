#!/usr/bin/perl -w

my %opcodes;

while (<>) {
  if (/^  (\w+).*\| ([01]   [01]   [01]   [01]   [01]   [01]   [01]) \|\t/) {
    my $name = $1;
    my $bits = $2;
    my $binary = join '', (split / /, $bits);
    my $value = oct "0b". $binary;
    my $hexa = sprintf("0x%X", $value);
    push @{$opcodes{$value}}, $name;
  }
}

foreach my $value (sort { $a <=> $b } keys %opcodes) {
  my $hexa = sprintf("0x%X", $value);
  my $list = join ',', @{$opcodes{$value}};
  print "$hexa\t$list\n";
}
