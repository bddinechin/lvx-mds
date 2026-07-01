#!/usr/bin/perl -w

use XML::DTDParser;

my $DTD = ParseDTDFile $ARGV[0];

#use Data::Dumper;
#print STDERR Dumper($DTD);

print << 'EOT';
package MDD;
$CORE = $ENV{CORE};
$FAMILY =  $ENV{FAMILY};
sub ID {
  my ($type, $name) = @_;
  return undef unless defined $name;
  join '-', ($type, $CORE, $name);
}
sub IDs {
  my ($type, $names) = @_;
  return undef unless defined $names;
  my @names = ref $names? @{$names}: (split ' ', $names);
  [ map { &ID($type, $_) } @names ];
}

EOT
foreach my $element (sort keys %{$DTD}) {
  my $attributes = $DTD->{$element}->{attributes};
  &process($element, $attributes);
}
print << 'EOT';

1;
EOT

sub process {
  my ($element, $attributes) = @_;
  print "package $element;\n";
  print '@ISA = ( "MDS" );', "\n";
  print << "EOT";
sub ID { &MDD::ID("$element", \$_[0]) }
sub IDs { &MDD::IDs("$element", \$_[0]) }
EOT
  print "%ATTLIST = (\n";
  foreach my $attribute (sort keys %{$attributes}) {
    my $type = $attributes->{$attribute}->[0];
    my $option = $attributes->{$attribute}->[1];
    my $default = $attributes->{$attribute}->[2] || 'undef';
#print STDERR "ATTRIBUTE $attribute:\t$type\t$option\n";
#print STDERR Dumper($$attributes{$attribute});
    print "  $attribute=>\t[ '$type', '$option', '$default' ],\n";
  }
  print ");\n";
  print << 'EOT';
sub attlist { return \%ATTLIST; }
@table = ();
@noname = ();
sub enter {
  my ($self) = @_;
  my $ID = $self->{ATTRIBUTES}->{ID};
  if (defined $ID) {
    my $name = (split '-', $ID)[2];
    if (defined $name) {
      push @table, $self
    } else {
      push @noname, $self
    }
  }
}

EOT
}

