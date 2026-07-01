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
use Behavior;

&MDS::parse(*ARGV);

foreach my $template (@Template::table) {
  my $nopified = "";
  my @name = ($template->name(), "NOP");
  my @patterns = $template->access("patterns");
  my @dispersals = $template->access("dispersals");
  &template($template, $nopified, \@name, \@patterns, \@dispersals);
}

sub template {
  my ($template, $nopified, $name, $patterns, $dispersals) = @_;
  my $nopAllow = $template->attribute("nopAllow") || 0;
  my @nopified = split ' ', $nopified;
  return if @nopified >= $nopAllow;
  my @dispersals = @{$dispersals};
  my @patterns = @{$patterns};
  my @name = @{$name};
  my $wordWidth = $template->attribute("wordWidth");
  my $alignBase = $template->attribute("alignBase");
  my $alignBias = $template->attribute("alignBias");
  my $increment = $template->attribute("increment");
  my $templateID = $template->attribute("ID");
  foreach my $dispersal (@dispersals) {
    if (defined $dispersal->attribute("nopValues")) {
      my $dispersalName = $dispersal->name();
      push @name, $dispersalName;
      my $name = join '.', @name;
      my $ID = &Template::ID($name);
      my $dispersalID = $dispersal->attribute("ID");
      my @dispersalIDs = grep {$_ ne $dispersalID} map {$_->attribute("ID")} @dispersals;
      my $dispersalIDs = @dispersalIDs? (join ' ', @dispersalIDs): undef;
      my $patternID = &Pattern::ID("NOP.$dispersalName");
      my @patternIDs = ($patternID, map {$_->attribute("ID")} @patterns);
      my $patternIDs = join ' ', @patternIDs;
      my $nopified = join ' ', (@nopified, $dispersalID);
      print MDS::make("Template", {
        ID=>	$ID,
        wordWidth=>	$wordWidth,
        alignBase=>	$alignBase,
        alignBias=>	$alignBias,
        dispersals=>	$dispersalIDs,
        patterns=>	$patternIDs,
        increment=>	$increment,
        nopified=>	$nopified,
        original=>	$templateID,
      })->emit();
      my @patterns = map {&MDS::fetch($_)} @patternIDs;
      my @dispersals = map {&MDS::fetch($_)} @dispersalIDs;
      &template($template, $nopified, \@name, \@patterns, \@dispersals);
      pop @name;
    }
  }
}

