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


my $debug = $ENV{DEBUG} || 0;
my $FAMILY = $ENV{FAMILY};

my $MDS_SPLIT_MODE = 0;
if ($ARGV[0] eq "--split") {
  $MDS_SPLIT_MODE = 1;
  shift @ARGV;
}

use MDS;
use Behavior;
use integer;
&MDS::parse(*ARGV);

my $copyrights = &MDS::get_copyrights(" * ","");

print<<"EOT";
/*
 * $FAMILY/Bundle.tuple
 * Automatically generated from the Machine Description System (MDS).
${copyrights}
 */

#ifndef Bundle
#define Bundle(ID, ALIGNMENT, CONTENTS, INVERSE, TEMPLATE)
#else /*Bundle*/
EOT

# Create %order for BundlingIDs.
my %order;
my $order = 0;
foreach my $bundling (@Bundling::table) {
  my $bundlingID = $bundling->attribute("ID");
  $order{$bundlingID} = $order++;
}

my $Bundle_INSTRUCTIONS_MAX = 0;
foreach my $bundle (@Bundle::table) {
  my $ID = $bundle->fullName('_');
  my $alignBias = $bundle->attribute("alignBias");
  my $alignBase = $bundle->attribute("alignBase");
  my $ALIGNMENT = "ALIGNMENT(BIAS($alignBias),BASE($alignBase))";
  my @contents = $bundle->access("contents");
  my @contentsList = map {"BUNDLING(" .$_->fullName('_'). ")"} @contents;
  my $contentsList = @contentsList? (join ' ', @contentsList): "/**/";
  my $CONTENTS = "CONTENTS(". @contentsList. ", $contentsList)";
  my $inverse = $bundle->attribute("inverse");
  my @inverse = split ' ', (defined $inverse? $inverse: '');
  my @inverseList = map {"INDEX($_)"} @inverse;
  my $inverseList = @inverseList? (join ' ', @inverseList): "/**/";
  my $INVERSE = "INVERSE($inverseList)";
  my ($template) = $bundle->access("template");
  my $templateName = $template->fullName('_');
  my $TEMPLATE = "TEMPLATE($templateName)";
  print <<"EOT";
Bundle($ID, $ALIGNMENT, $CONTENTS, $INVERSE, $TEMPLATE)
EOT
  $Bundle_INSTRUCTIONS_MAX = @contents if $Bundle_INSTRUCTIONS_MAX < @contents;
}

print<<"EOT";
#endif/*Bundle*/
#undef Bundle\n
EOT

print<<"EOT";
#ifndef Bundle_INSTRUCTIONS_MAX
#define Bundle_INSTRUCTIONS_MAX $Bundle_INSTRUCTIONS_MAX
#endif/*Bundle_INSTRUCTIONS_MAX*/\n
EOT

my %mapping;
foreach my $bundle (@Bundle::table) {
  my @canonic = $bundle->access("canonic");
  my @canonicNames = map {$_->fullName('_')} @canonic;
  my $canonic = join ' ', map {"BUNDLING($_)"} @canonicNames;
  my $mappingKey = $bundle->attribute("canonic") || '';
  my $hash = -1;
  map {
    ++$hash;
    $hash *= $order;
    $hash += $_;
  } map {$order{$_}} split ' ', $mappingKey;
  ++$hash;
  my $mapping = $mapping{$mappingKey};
  unless (defined $mapping) {
    $mapping = { CANONIC=>$canonic, HASH=>$hash, BUNDLES=>[], };
  }
  push @{$mapping->{BUNDLES}}, $bundle;
  die "Mismatch $canonic" unless $mapping->{CANONIC} eq $canonic;
  $mapping{$mappingKey} = $mapping;
}

print<<"EOT";
#ifndef BundleMatch
#define BundleMatch(HASH, CANONIC, BUNDLES)
#else /*BundleMatch*/
EOT

my $BundleMatch_HASH_MAX = 0;
my $BundleMatch_MAXCOUNT = 0;
foreach my $mapping (sort {$a->{HASH}<=>$b->{HASH}} values %mapping) {
  my $hash = $mapping->{HASH};
  my $HASH = "HASH($hash)";
  my $canonic = $mapping->{CANONIC};
  my @canonic = split ' ', $canonic;
  my $CANONIC = "CANONIC(". @canonic. ", $canonic)";
  my @bundles = @{$mapping->{BUNDLES}};
  my $bundleNames = join ' ', map {"BUNDLE(". $_->fullName('_'). ")"} @bundles;
  my $BUNDLES = "BUNDLES(". @bundles. ", $bundleNames)";
  print << "EOT";
BundleMatch($HASH, $CANONIC, $BUNDLES)
EOT
  $BundleMatch_HASH_MAX = $hash if $BundleMatch_HASH_MAX < $hash;
  $BundleMatch_MAXCOUNT = @bundles if $BundleMatch_MAXCOUNT < @bundles;
}

print<<"EOT";
#endif/*BundleMatch*/
#undef BundleMatch\n
EOT

print<<"EOT";
#ifndef BundleMatch_HASH_MAX
#define BundleMatch_HASH_MAX $BundleMatch_HASH_MAX
#endif/*BundleMatch_HASH_MAX*/\n
EOT

print<<"EOT";
#ifndef BundleMatch_MAXCOUNT
#define BundleMatch_MAXCOUNT $BundleMatch_MAXCOUNT
#endif/*BundleMatch_MAXCOUNT*/\n
EOT

