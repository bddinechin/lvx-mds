#!/usr/bin/perl -w
# Machine Description System (MDS)
#
# Copyright (C) 2005 STMicroelectronics
#
# Benoit Dupont de Dinechin (Benoit.Dupont-de-Dinechin@st.com).
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

use MDS;

my $FAMILY = $ENV{FAMILY};

&MDS::parse(*ARGV);

my $ordering = 0;
my %ordering;		# $bundlingID to ordering.
my %bundlingIDs;	# $dispersalID to ordered @bundlingIDs
my %dispersalIDs;	# $bundlingID to sorted $dispersalIDs
foreach my $bundling (@Bundling::table) {
  my $bundlingID = $bundling->attribute("ID");
  # Bundling classes in order of appearance.
  $ordering{$bundlingID} = $ordering++;
  my %dispersalID;
  my @dispersalIDs = grep {!$dispersalID{$_}++}
                     sort split ' ', $bundling->attribute("dispersals");
  foreach my $dispersalID (@dispersalIDs) {
    push @{$bundlingIDs{$dispersalID}}, $bundlingID;
  }
  $dispersalIDs{$bundlingID} = join ' ', @dispersalIDs;
}

# Sort the values of the %bundlingIDs table.
foreach my $dispersalID (sort keys %bundlingIDs) {
  my @bundlingIDs = sort {
    $ordering{$a} <=> $ordering{$b}
  } @{$bundlingIDs{$dispersalID}};
  $bundlingIDs{$dispersalID} = \@bundlingIDs;
}

# Check that Bundling(s) are not redundant, that is, have a different Dispersal set.
my %canonic;
foreach my $bundling (@Bundling::table) {
  my $bundlingID = $bundling->attribute("ID");
  my $dispersalIDs = $dispersalIDs{$bundlingID};
  if (defined $canonic{$dispersalIDs}) {
    print STDERR "Same Dispersal(s) for $canonic{$dispersalIDs} and $bundlingID:";
    print STDERR "\t$dispersalIDs\n";
  }
  $canonic{$dispersalIDs} = 1;
}

# Main loop on Template(s) to enumerate the Bundle(s).
my %bundle = ();
foreach my $template (@Template::table) {
  my $templateID = $template->attribute("ID");
  my $alignBias = $template->attribute("alignBias");
  my $alignBase = $template->attribute("alignBase");
  my $increment = $template->attribute("increment");
  my $dispersals = $template->attribute("dispersals");
  my @dispersals = $template->access("dispersals");
  my $bundle = {
    ALIGNBASE=>	$alignBase,
    ALIGNBIAS=>	$alignBias,
    INCREMENT=>	$increment,
    TEMPLATE=>	$templateID,
    CONTENTS=>	[ ],
  };
  &bundle($bundle, @dispersals);
}

my @recordKeys;
my %recordTable;
sub bundle {
  my ($bundle, @dispersals) = @_;
  if (@dispersals) {
    my $dispersal = shift @dispersals;
    my $dispersalID = $dispersal->attribute("ID");
    my @bundlingIDs = @{$bundlingIDs{$dispersalID}};
    my @bundlings = map {MDS::fetch($_)} @bundlingIDs;
    foreach my $bundling (@bundlings) {
      my $bundlingID = $bundling->attribute("ID");
      push @{$$bundle{CONTENTS}}, $bundlingID;
      &bundle($bundle, @dispersals);
      pop @{$$bundle{CONTENTS}};
    }
  } else {
    my $index = 0;
    my @contents = @{$$bundle{CONTENTS}};
    my @canonic = sort {$ordering{$a} <=> $ordering{$b}} @contents;
    my @unsorted = map {{ORDERING=>$ordering{$_}, INDEX=>$index++}} @contents;
    my @permute = map {$_->{INDEX}} sort {$a->{ORDERING} <=> $b->{ORDERING}} @unsorted;
    my %inverse; $index = 0; map {$inverse{$_} = $index++} @permute;
    my @inverse = map {$inverse{$_}} sort {$a<=>$b} keys %inverse;
    my $recordKey = join ' ', map {MDS::fetch($_)->name()} @canonic;
    my $record = {
      ALIGNBASE=>	$$bundle{ALIGNBASE},
      ALIGNBIAS=>	$$bundle{ALIGNBIAS},
      INCREMENT=>	$$bundle{INCREMENT},
      TEMPLATE=>	$$bundle{TEMPLATE},
      CONTENTS=>	[ @contents ],
      CANONIC=>		[ @canonic ],
      INVERSE=>		[ @inverse ],
    };
    push @recordKeys, $recordKey unless $recordTable{$recordKey};
    push @{$recordTable{$recordKey}}, $record;
  }
}

foreach my $recordKey (@recordKeys) {
  # Sort records of given recordKey with smaller alignment base first.
  # Same recordKey means same @canonic.
  my @records = sort {
    $$a{ALIGNBASE} <=> $$b{ALIGNBASE} ||
    $$a{ALIGNBIAS} <=> $$b{ALIGNBIAS} ||
    $$a{INCREMENT} <=> $$b{INCREMENT} ||
    $$b{TEMPLATE}  cmp $$a{TEMPLATE}; # to ensure sort is deterministic.
  } @{$recordTable{$recordKey}};
  # Prune records of same or less strict alignment and bias.
  my %alignment;
  @records = grep {
    my ($mybase, $mybias) = ( $$_{ALIGNBASE}, $$_{ALIGNBIAS} );
    my $seen = 0;
  base:
    foreach my $base (keys %alignment) {
        next base if &gcd ($mybase, $base) != $base;
        foreach my $bias (keys %{$alignment{$base}}) {
            $seen = 1 if (($mybias % $base) == $bias);
        }
    }
    $alignment{$mybase}{$mybias} = 1 if not $seen;
    not $seen;
  } @records;
  if (0 &&	# FIXME! Disabled Bundle factoring.
      @records > 1) {
    my $gcd = 0;
    # Compute the GCD of alignments.
    foreach my $record (@records) {
      my $alignBias = $$record{ALIGNBIAS};
      my $alignBase = $$record{ALIGNBASE};
      $gcd = &gcd($gcd, $alignBias);
      $gcd = &gcd($gcd, $alignBase);
    }
    # Collect and collapse the generators.
    my %generator;
    foreach my $record (@records) {
      my $alignBias = $$record{ALIGNBIAS};
      my $alignBase = $$record{ALIGNBASE};
      my $remainder = $alignBias/$gcd;
      my $factor = $alignBase/$gcd;
      $generator{$factor}{$remainder}++;
      my @remainders = keys %{$generator{$factor}};
      if ($factor > 1 && @remainders == $factor) {
#print STDERR "COLLAPSE($factor, ", (join ' ', @remainders), ")\n";
        delete $generator{$factor};
        $generator{1}{0}++;
      }
    }
    # Rewrite the @records;
    my $record = $records[0];
    @records = ();
    foreach my $factor (sort {$a <=> $b} keys %generator) {
      my $alignBase = $factor*$gcd;
      my @remainders = keys %{$generator{$factor}};
      foreach my $remainder (sort {$a <=> $b} @remainders) {
        my $alignBias = $remainder*$gcd;
        push @records, { %{$record}, ALIGNBIAS=>$alignBias, ALIGNBASE=>$alignBase };
      }
    }
  }
  foreach my $record (@records) {
    my $alignBias = $$record{ALIGNBIAS};
    my $alignBase = $$record{ALIGNBASE};
    my @contents = @{$$record{CONTENTS}};
    my @canonic = @{$$record{CANONIC}};
    my @inverse = @{$$record{INVERSE}};
    my @bundlingNames = map {MDS::fetch($_)->name()} @contents;
    my $name = join '_', (@bundlingNames, $alignBias, $alignBase);
    my $template = $$record{TEMPLATE};
    my $contents = @contents? (join ' ', @contents): undef;
    my $canonic = @canonic? (join ' ', @canonic): undef;
    my $inverse = @inverse? (join ' ', @inverse): undef;

    my $bundle = MDS::make("Bundle",
      {
        ID=>	&Bundle::ID($name),
        alignBias=>	$alignBias,
        alignBase=>	$alignBase,
        template=>	$template,
        contents=>	$contents,
        canonic=>	$canonic,
        inverse=>	$inverse,
      },
    );
    print $bundle->emit();
  }
}

sub gcd {
  my ($u, $v) = @_;
  return $u unless $v;
  return $v unless $u;
  my $g = 1;
  while (!($u & 0x1) && !($v & 0x1)) {
    $u >>= 1;
    $v >>= 1;
    $g <<= 1;
  }
  while ($u > 0) {
    if (!($u & 0x1)) { $u >>= 1; }
    elsif (!($v & 0x1)) { $v >>= 1; }
    else {
      if ($u < $v) {
        $v = ($v - $u) >> 1;
      } else {
        $u = ($u - $v) >> 1;
      }
    }
  }
  return $g*$v;
}

if (0) {
  my ($a, $b);
  ($a, $b) = (2, 6);
  print STDERR "gcd($a, $b)=", &gcd($a, $b), "\n";
  ($a, $b) = (2, 0);
  print STDERR "gcd($a, $b)=", &gcd($a, $b), "\n";
  ($a, $b) = (0, 3);
  print STDERR "gcd($a, $b)=", &gcd($a, $b), "\n";
  ($a, $b) = (128, 24);
  print STDERR "gcd($a, $b)=", &gcd($a, $b), "\n";
}

