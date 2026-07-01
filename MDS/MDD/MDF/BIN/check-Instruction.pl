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
use Data::Dumper;

&MDS::parse(*ARGV);

$Behavior::yycheck = 1;
&Behavior::yyinit();

my $error = 0;

foreach my $instruction (@Instruction::table) {
    my $instructionID = $instruction->attribute("ID");
    my ($behavior) = $instruction->children('Behavior');
    if (defined $behavior) {
        my $proxies = $behavior->attribute("proxies") || '';
        my %proxies; map { ++$proxies{$_} } (split ' ', $proxies);
        map {++$proxies{"%$_"}} 1..9;
        map {&Behavior::Symbol($_, { })} keys %proxies;
        my @input = @{$behavior->contents()};
        &Behavior::yyin(@input);
        if (&Behavior::yyparse) {
            print STDERR $instructionID, @input, "\n";
            die "syntax error:\t", &Behavior::yylval, "\n";
        }
        my $tree = &Behavior::yytree;
        &Behavior::Symbol();
        &Behavior::yyflush;
        my $input = join '', @input;
        my $output = join '', &Pretty($tree, "");
        $input =~ s/\s+//g;
        $input =~ s/\bCONST\.(0[Xx][0-9a-fA-F]+)/const($1)/ge;
        $output =~ s/\s+//g;
        $output =~ s/\bCONST\.(0[Xx][0-9a-fA-F]+)/const($1)/ge;
        $output =~ s/\b(ACCESS|COMMIT|LOAD|STORE|EFFECT|THROW|PROBE)\.([A-Za-z_]\w*)/stage($1, $2)/ge;
        if (0&& $input ne $output) {
            print STDERR $instructionID, "\n";
            print STDERR "\tInput: ", $input, "\n\tPretty: ", $output, "\n";
            print STDERR Dumper($tree);
            $error = 1;
        }
    }
}

sub const { 'CONST.'. oct($_[0]) }

sub stage { $_[0]. ".". $Behavior::pipeline{$_[1]} }

if($error) {
    exit(-1);
}
# vim: set ts=4 sw=4 et:
