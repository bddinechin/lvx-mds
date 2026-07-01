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
use PatternX;

&MDS::parse(*ARGV);

my %pattern;
foreach my $template (@Template::table) {
  my @dispersals = $template->access("dispersals");
  foreach my $dispersal (@dispersals) {
    my $nopValues = $dispersal->attribute("nopValues");
    if (defined $nopValues) {
      my $dispersalName = $dispersal->name();
      my $toFields = $dispersal->attribute("toFields");
      my $ID = &Pattern::ID("NOP.$dispersalName");
      print MDS::make("Pattern", {
        ID=>	$ID,
        fields=>	$toFields,
        values=>	$nopValues,
      })->emit() unless $pattern{$ID}++;
    }
  }
}

foreach my $synthetic (@Synthetic::table) {
  my @formats = $synthetic->access("formats");
  foreach my $format (@formats) {
    map { print $_->emit(); } &get_synthetic_patterns($synthetic, $format);
  }
}
