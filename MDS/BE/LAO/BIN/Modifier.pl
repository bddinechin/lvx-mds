#!/usr/bin/perl -w
# Machine Description System (MDS)
#
# Copyright (C) 2005 STMicroelectronics
#
# Stefan Freudenberger (Stefan.Freudenberger@st.com).
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

my $copyrights = &MDS::get_copyrights(" *  ","");

print<<"EOT";
/*
 * $FAMILY/Modifier.enum
${copyrights}
 * Automatically generated from the Machine Description System (MDS).
 */

#ifndef Modifier
#define Modifier(ID, MEMBERS, ENCODE, DECODE)
#else /*Modifier*/
EOT

my $adjust = 1;	# Adjust for ModifierMember_.
my @tuples;
foreach my $modifier (@Modifier::table) {
    my $ID = $modifier->fullName('_');
    my @members = split ' ', $modifier->attribute("members");
    my @values = split ' ', $modifier->attribute("values");
    my $index = 0;
    my @MEMBERS = ();
    foreach my $member (@members) {
        my $name = $member;
        $name =~ s/^\.$//;
        my $lcname = lc($name);
        my $id_name = $member;
        $id_name =~ s/\W/_/g;
        $id_name =~ s/^_//;
        my $id = "${ID}_$id_name";
        my $value = $values[$index];
        $value = $index unless defined $value;
        $value = oct($value) if $value =~ /^0/;
        push @MEMBERS, "MEMBER($id, NAME($name), LCNAME($lcname), VALUE($value))";
        push @tuples, [ $ID, $id_name, $value ];
        $index++;
    }
    my $MEMBERS = "MEMBERS(" . @MEMBERS . ",". (join "\n                 ", '', @MEMBERS) . ")";
    my (@encode, @decode);
    push @encode, "VALUE -= $adjust" if $adjust;
    my $ENCODE = "ENCODE(". (@encode? (join '; ', @encode): "/**/"). ")";
    push @decode, "VALUE += $adjust" if $adjust;
    my $DECODE = "DECODE(". (@decode? (join '; ', @decode): "/**/"). ")";
    print <<"EOT";
Modifier($ID,
         $MEMBERS,
         $ENCODE,
         $DECODE)
EOT
    $adjust += @members;
}

print<<"EOT";
#endif/*Modifier*/
#undef Modifier\n

#ifndef ModifierMemberValue
EOT

foreach my $tuple (@tuples) {
    my ($ID, $name, $value) = @$tuple;
    print "#define ModifierMemberValue_${ID}_${name}\t$value\n";
}

print<<"EOT";
#endif/*ModifierMemberValue*/\n
EOT

# vim: set ts=4 sw=4 et:
