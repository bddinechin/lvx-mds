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

my %template;
foreach my $template (@Template::table) {
  my $templateID = $template->attribute("ID");
  my @dispersalIDs = split ' ', ($template->attribute("dispersals") || ' ');
  map { $template{$_}{$templateID} = 1 } @dispersalIDs;
}

my %wordWidth;
foreach my $dispersal (@Dispersal::table) {
  my $dispersalID = $dispersal->attribute("ID");
  foreach $templateID (sort keys %{$template{$dispersalID}}) {
    my $template = &MDS::fetch($templateID);
    my $wordWidth = $template->attribute("wordWidth");
    if (defined $wordWidth{$dispersalID}) {
      die "inconsistent Template\@wordWidth for $dispersalID"
          unless $wordWidth{$dispersalID} == $wordWidth;
    } else {
      $wordWidth{$dispersalID} = $wordWidth;
    }
  }
  unless (defined $wordWidth{$dispersalID}) {
    warn "no Template for $dispersalID";
    $wordWidth{$dispersalID} = 32; # FIXME! Should be 0.
  }
}

my %encode;
my %decode;
my %wordType;
foreach my $dispersal (@Dispersal::table) {
  my $dispersalID = $dispersal->attribute("ID");
  my @fromFields = $dispersal->access("fromFields");
  my @toFields = $dispersal->access("toFields");
  my $wordWidth = $wordWidth{$dispersalID};
  next unless $wordWidth;
  my $wordType = "uint${wordWidth}_t";
  my (@encode, @decode);
  while (@fromFields && @toFields) {
    my $fromField = pop @fromFields;
    my $toField = pop @toFields;
    my $fromWidth = $fromField->attribute("width");
    my $fromOffset = $fromField->attribute("offset");
    my $fromIndex = $fromOffset/$wordWidth;
    my $fromShift = $fromOffset%$wordWidth;
    my $toWidth = $toField->attribute("width");
    my $toOffset = $toField->attribute("offset");
    my $toIndex = $toOffset/$wordWidth;
    my $toShift = $toOffset%$wordWidth;
    my $width = $toWidth;
    my $mask = $width >= $wordWidth?
               "(($wordType)0-1)":
               "((($wordType)1<<$width)-1)";
    push @encode,
        "__value = (__words\[$fromIndex\]>>$fromShift)&$mask",
        "__code\[$toIndex\] &= ~($mask<<$toShift)",
        "__code\[$toIndex\] |= (__value&$mask)<<$toShift";
  }
  die "extra fromFields in $dispersalID" if @fromFields;
  die "extra toFields in $dispersalID" if @toFields;
  $encode{$dispersalID} = [ @encode ];
  $decode{$dispersalID} = [ @decode ];
  $wordType{$dispersalID} = $wordType;
}

my $copyrights = &MDS::get_copyrights(" *  ","");

print<<"EOT";
/*
 * $FAMILY/Template.tuple
${copyrights}
 * Automatically generated from the Machine Description System (MDS).
 */

#ifndef Template
#define Template(ID, ALIGNMENT, INCREMENT, DISTANCES, ENCODE, DECODE)
#else /*Template*/
EOT

my $Template_INCREMENT_MAX = 0;
my $Template_DISPERSALS_MAX = 0;
foreach my $template (@Template::table) {
  my $templateID = $template->attribute("ID");
  my $ID = $template->fullName('_');
  my @dispersals = $template->access("dispersals");
  my $alignBias = $template->attribute("alignBias");
  my $alignBase = $template->attribute("alignBase");
  my $ALIGNMENT = "ALIGNMENT(BIAS($alignBias),BASE($alignBase))";
  my $increment = $template->attribute("increment");
  $Template_INCREMENT_MAX = $increment if $Template_INCREMENT_MAX < $increment;
  my $INCREMENT = "INCREMENT($increment)";
  my @distances = map {$_->attribute("distance")} @dispersals;
  my @distanceList = map{"DISTANCE($_)"} @distances;
  my $distanceList = @distanceList? (join ' ', @distanceList): "/**/";
  my $DISTANCES = "DISTANCES(". @distanceList. ", $distanceList)";
  my @patterns = grep {$_->name()} $template->access("patterns");
  my @fields = map {$_->access("fields")} @patterns;
  my @values = map {split ' ', $_->attribute("values")} @patterns;
  my $wordWidth = 32; # FIXME!
  my $wordType = "uint${wordWidth}_t";
  my (@encode, @decode);
  push @encode,
      "$wordType *restrict __code = buffer";
  my $dispersalIndex = 0;
  foreach my $dispersal (@dispersals) {
    push @encode,
        "const void *restrict __codeWords_$dispersalIndex = codeWords\[$dispersalIndex\]";
    $dispersalIndex++;
  }
  my ($wordBytes, $wordIndex) = ($wordWidth/8, 0);
  for (my $address = 0; $address < $increment; $address += $wordBytes) {
    push @encode,
        "__code\[$wordIndex\] = ($wordType)0";
    $wordIndex++;
  }
  $dispersalIndex = 0;
  foreach my $dispersal (@dispersals) {
    my $dispersalID = $dispersal->attribute("ID");
    push @encode,
        "{ const $wordType *restrict __words = __codeWords_$dispersalIndex",
        "$wordType __value", grep {!/\&\=/} @{$encode{$dispersalID}}, " }";
    $dispersalIndex++;
  }
  while (@fields && @values) {
    my $field = pop @fields;
    my $value = pop @values;
    $value = oct($value) if $value =~ /^0/;
    my $width = $field->attribute("width");
    my $offset = $field->attribute("offset");
    my $index = $offset/$wordWidth;
    my $shift = $offset%$wordWidth;
    die "$templateID:\twidth+shift = $width+$shift > $wordWidth"
        if $width+$shift > $wordWidth;
    if ($width >= $wordWidth && $shift == 0) {
      push @encode, "__code\[$index\] = ($wordType)$value";
    } else {
      my $mask = $width >= $wordWidth? "(($wordType)0-1)": "((($wordType)1<<$width)-1)";
      push @encode,
          "__code\[$index\] &= ~($mask<<$shift)",
          "__code\[$index\] |= (($wordType)$value&$mask)<<$shift";
    }
  }
  die "extra fields in $templateID" if @fields;
  die "extra values in $templateID" if @values;
  my $ENCODE = "ENCODE(". (@encode? (join '; ', @encode): "/**/"). ")";
  my $DECODE = "DECODE(". (@decode? (join '; ', @decode): "/**/"). ")";
  print <<"EOT";
Template($ID, $ALIGNMENT, $INCREMENT, $DISTANCES,
         $ENCODE,
         $DECODE)
EOT
  if ($Template_DISPERSALS_MAX < @dispersals) {
    $Template_DISPERSALS_MAX = @dispersals;
  }
}

print<<"EOT";
#endif/*Template*/
#undef Template\n
EOT

print<<"EOT";
#ifndef Template_DISPERSALS_MAX
#define Template_DISPERSALS_MAX $Template_DISPERSALS_MAX
#endif/*Template_DISPERSALS_MAX*/\n
EOT

print<<"EOT";
#ifndef Template_INCREMENT_MAX
#define Template_INCREMENT_MAX $Template_INCREMENT_MAX
#endif/*Template_INCREMENT_MAX*/\n
EOT

