#!/usr/bin/perl -w
# Machine Description System (MDS)
#
# Copyright (C) 2005 STMicroelectronics.
# Copyright (C) 2018 Kalray

# Stephen Clarke (Stephen.Clarke@st.com).
# Marc Poulhiès (mpoulhies@kalray.eu).
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

use strict;
use warnings "FATAL" => "all";

use MDS;
use BitString;
use AsmTestLib;
use GBUTarget;
use GBU;
use Carp;

my $wordWidth = &GBUTarget::wordWidth();

&MDS::parse(*ARGV);

my @cores = map { $_->core(); } @Processor::table;
my $Family = $ENV{FAMILY};
my $FAMILY = uc $Family;

sub printRelocations {
    my $file = shift;

    my %bfd_relocs;
    $bfd_relocs{0} = "R_${FAMILY}_NONE";
    foreach my  $reloc (@Relocation::table) {
        my @linker_reloc = split(/\s+/,$reloc->attribute("linker"));
        my @linker_elf_ids = split(/\s+/,$reloc->attribute("elfIds"));
        croak "Bad arrays: @linker_elf_ids <-> @linker_reloc" if(@linker_reloc != @linker_elf_ids);
        for my $i (0 .. $#linker_reloc) {
            croak "Already defined relocation with elf ID: $linker_elf_ids[$i] ($linker_reloc[$i]) / $bfd_relocs{$linker_elf_ids[$i]}" if(defined $bfd_relocs{$linker_elf_ids[$i]});
            $bfd_relocs{$linker_elf_ids[$i]} = $linker_reloc[$i];
        }
    }

    print $file "/* DO NOT EDIT!  -*- buffer-read-only: t -*-  This file is automatically\n";
    print $file " * generated from MDS\n */\n\n";

    my $include_guard = "__${FAMILY}_MPPADL_RELOC_MDS_H__";

    print $file "#ifndef ${include_guard}\n";
    print $file "#define ${include_guard}\n\n\n";

    print $file "enum MPPA_DL_RELOCATIONS {\n";

    my $elfID_check = 0;
    foreach my $elfID (sort { $a <=> $b } keys %bfd_relocs) {
        croak "Bad ElfID $elfID" if($elfID_check != $elfID);
        $elfID_check++;
        my $reloc = $bfd_relocs{$elfID};
        format =
     @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< =@#,
     $reloc,                                      $elfID
.

        write $file;
    }

    print $file "};\n";

    print $file "#endif /* ${include_guard} */\n";
}

printRelocations(*STDOUT);
# vim: set ts=4 sw=4 et:
