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

use Carp;

&MDS::parse(*ARGV);

&Behavior::yyinit();

#
# Generate Access(es) for the Operand(s).
#
foreach my $operand (@Operand::table) {
    my $name = $operand->name();
    my $methodID = $operand->attribute("method");
    my $method = &MDS::fetch($methodID);
    my $ID = &Access::ID("Operand.$name");
    if (ref $method eq 'Modifier') {
        &processModifier($ID, $method, $methodID);
    } elsif (ref $method eq 'Immediate') {
        &processImmediate($ID, $method, $methodID);
    } elsif (ref $method eq 'RegClass') {
        &processRegClass($ID, $method, $methodID);
    } elsif (ref $method eq 'RegMask') {
        &processRegMask($ID, $method, $methodID);
    } else {
        die "unknown Operand method $methodID (", ref $method, ")";
    }
}

sub processModifier {
    my ($ID, $modifier, $methodID) = @_;
    my @read;
    my $width = $modifier->attribute("width");
    my $zx = &ZX($width, &METHOD("%0"));
    @read = &Pretty($zx, '');
    (my $read = join '', @read) =~ s/\s+//g;
    my $access = MDS::make("Access", {
            ID=>	$ID,
            read=>	$read,
            method=>	$methodID,
        });
    print $access->emit();
}

sub processImmediate {
    my ($ID, $immediate, $methodID) = @_;
    my $extend = $immediate->attribute("extend");
    my $width = $immediate->attribute("width");
    my $shift = $immediate->attribute("shift") || 0;
    my @read;
    if ($extend eq 'Signed' or $extend eq 'Wrap') {
        my $sx = &SX($width+$shift, &METHOD("%0"));
        #print STDERR "processImmediate A : $extend $width $shift $sx\n";
        @read = &Pretty($sx, '');
    } elsif ($extend eq 'Unsigned') {
        my $zx = &ZX($width+$shift, &METHOD("%0"));
        @read = &Pretty($zx, '');
    } else {
        die "unknown Immediate extension $extend";
    }
    (my $read = join '', @read) =~ s/\s+//g;
    #print STDERR "processImmediate B : $read \n";
    my $access = MDS::make("Access", {
            ID=>	$ID,
            read=>	$read,
            method=>	$methodID,
        });
    my $data = $access->emit();
    #print STDERR "processImmediate C : $data\n";
    print $access->emit();
}

sub processRegClass {
    my ($ID, $regClass, $methodID) = @_;
    my $regClassID = $regClass->attribute("ID");
    my ($regFile) = $regClass->access("regFile");
    my $width = $regFile->attribute("width");
    my $regFileName = $regFile->regFileName();
    my @registers = $regClass->access("registers");
    my $load = &LOAD('_', &AGGL($regFileName, &METHOD("%0"), &CONST(1)));
    my $f2i = &F2I($width, $load);
    my @read = &Pretty($f2i, '');
    (my $read = join '', @read) =~ s/\s+//g;
    my $i2f = &I2F($width, &UNDEF());
    my $store = &STORE('_', &AGGL($regFileName, &METHOD("%0"), &CONST(1)), $i2f);
    my @write = &Pretty($store, '');
    (my $write = join '', @write) =~ s/\s+//g;
    my $access = MDS::make("Access", {
            ID=>	$ID,
            read=>	$read,
            write=>	$write,
            method=>	$methodID,
        });
    print $access->emit();
}

sub processRegMask {
    my ($ID, $regMask, $methodID) = @_;
    my @read = &Pretty(&METHOD("%0"), '');
    (my $read = join '', @read) =~ s/\s+//g;
    my $access = MDS::make("Access", {
            ID=>	$ID,
            read=>	$read,
            method=>	$methodID,
        });
    print $access->emit();
}
# vim: set ts=4 sw=4 et:
