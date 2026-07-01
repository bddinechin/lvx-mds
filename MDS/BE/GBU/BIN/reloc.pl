#!/usr/bin/perl -w
# Machine Description System (MDS)
#
# Copyright (C) 2005 STMicroelectronics.
#
# Stephen Clarke (Stephen.Clarke@st.com).
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

# Create opcodes/$target-opc.c file for binutils.

use strict;
use warnings "FATAL" => "all";

use MDS;
use BitString;
use AsmTestLib;
use GBUTarget;
use GBU;
use Carp;

my $Family = $ENV{FAMILY};
my $FAMILY = uc $Family;
my $wordWidth = &GBUTarget::wordWidth();

&MDS::parse(*ARGV);

my @cores = map { $_->core(); } @Processor::table;

sub printRelocations {
    my $file = shift;

    my %bfd_relocs;
    foreach my  $reloc (@Relocation::table) {
	my @linker_reloc = split(/\s+/,$reloc->attribute("linker"));
	my @linker_elf_ids = split(/\s+/,$reloc->attribute("elfIds"));
	croak "Bad arrays: @linker_elf_ids <-> @linker_reloc" if(@linker_reloc != @linker_elf_ids);
	for my $i (0 .. $#linker_reloc) {
	    $linker_reloc[$i] =~ s/^R_/BFD_RELOC_/;
	    croak "Already defined relocation with elf ID: $linker_elf_ids[$i] ($linker_reloc[$i])" if(defined $bfd_relocs{$linker_elf_ids[$i]});
	    $bfd_relocs{$linker_elf_ids[$i]} = $linker_reloc[$i];
	}
    }
    my $elfID_check = 1;
    my $enum = "ENUM";
    my $start_relocs = <<"END";
ENUM
  BFD_RELOC_${FAMILY}_RELOC_START
ENUMDOC
  ${FAMILY} pseudo relocation code to mark the start of the ${FAMILY} relocation
  enumerators.  N.B. the order of the enumerators is important as
  several tables in the ${FAMILY} bfd backend are indexed by these
  enumerators; make sure they are all synced.
ENUM
  BFD_RELOC_${FAMILY}_NONE
ENUMDOC
  ${FAMILY} null relocation code.
END

    my $end_reloc = << "END";
ENUMDOC
  KVX Relocations.
ENUM
  BFD_RELOC_${FAMILY}_RELOC_END
ENUMDOC
  ${FAMILY} pseudo relocation code to mark the end of the ${FAMILY} relocation
  enumerators that have direct mapping to ELF reloc codes.  There are
  a few more enumerators after this one; those are mainly used by the
  ${FAMILY} assembler for the internal fixup or to select one of the above
  enumerators.
END
    print $file "$start_relocs";

    foreach my $elfID (sort { $a <=> $b } keys %bfd_relocs) {
	croak "Bad ElfID $elfID" if($elfID_check != $elfID);
	$elfID_check++;
	my $reloc = $bfd_relocs{$elfID};
	print $file "$enum\n";
	$enum = "ENUMX";
	print $file "$reloc\n";
    }

    print $file "$end_reloc";
}

printRelocations(*STDOUT);


