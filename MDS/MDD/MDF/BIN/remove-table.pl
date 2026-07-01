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

# This script is used to remove a table from given file.

use strict "vars";
use strict "subs";

use MDS;
&MDS::parse(*ARGV);

my $TABLE = $ENV{TABLE};

my $elements = &MDS::getTable();
my %types;
foreach my $ID (keys %$elements) {
    my $type = $$elements{$ID}->type();
    if(not defined $types{$type}) {
	$types{$type} = 1;
	if($ID !~ /^$TABLE/) {
	    my $table = \@{"${type}::table"};
	    my $noname = \@{"${type}::noname"};
	    foreach my $element (@$noname, @$table) {
		print $element->emit();
	    }
	}
    }
} 
