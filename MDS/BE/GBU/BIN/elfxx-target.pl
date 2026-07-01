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

# Create include/opcodes/$Family.h file for binutils.


use strict;
use warnings "FATAL" => "all";
use bignum;

use Carp;

use MDS;
use GBUTarget;

my $Family = $ENV{FAMILY};
my $FAMILY = uc $Family;
my @Cores = split ' ', $ENV{CORES};

my %relocs;

## HACK: the kvx asm/linker handles relocation
## syllabe by syllabe, which are always 32bits.
## Generating "64bits"-aware HOWTO contradicts asm/linker handling
## Easiest solution is to still handle relocation 32bits-word by 32bits-word.
my $elf_size = 32;

sub get_reloc_size {
    my ($reloc) = @_;
    my @fields = $reloc->access("fields");
    my $size = 0;
    my $mask = 0;
    foreach my $field (@fields) {
        my $fmask = ((1 << $field->attribute("width")) - 1) << ($field->attribute("offset") % $elf_size);
        $mask |= $fmask;
    }
    my $tvalue = 1;
    while($tvalue < $mask) {
        $size++;
        $tvalue <<= 1;
    }
    return $size;
}

sub get_elf_reloc {
    my ($reloc,$elf_id) = @_;
    my @elfIds = split(' ',$reloc->attribute("elfIds"));
    my $i = 0;
    my $elfid_idx;
    map { $elfid_idx = $i if($elf_id == $_); $i++; } @elfIds;
    croak "elf id $elf_id not found" if(not defined $elfid_idx);
    my @linker_names = split(' ',$reloc->attribute("linker"));
    my $linker_name = $linker_names[$elfid_idx];
    my @fields = $reloc->access("fields");
    my $scaling = $reloc->attribute("scaling");
    my $underflow;
    my $overflow;
    my $bf_offset;
    my $bf_width;
    for(my $i=scalar(@fields)-1; $i>=0; $i--) {
        my $bf = $fields[$elfid_idx];
        if($elfIds[$i] == $elf_id) {
            if($i == 0) {
                $overflow = $reloc->attribute("overflow");
            }
            if($i == scalar(@fields) - 1) {
                $underflow = $reloc->attribute("underflow");
            }
            $i = 0;
            $bf_offset = $bf->attribute("offset") % $elf_size;
            $bf_width = $bf->attribute("width");
        }
        else {
            my $field = $fields[$i] || croak $reloc->name().": Undefined field at $i";
            $scaling += $field->attribute("width");
        }
    }

    croak "Bit field width not defined for elf id $elf_id" if(not defined $bf_width);
    croak "Bit field offset not defined for elf id $elf_id" if(not defined $bf_offset);
    return ( linker=>$linker_name,
             field_offset=>$bf_offset,
             field_width=>$bf_width,
             overflow=>$overflow,
             underflow=>$underflow,
             scaling=>$scaling,
             type=>$reloc->attribute("type"),
             relative=>$reloc->attribute("relative"),
        );
}

sub elf_reloc_diff {
    my ($elf1,$elf2) = @_;

    if(scalar(keys %$elf1) != scalar(keys %$elf2)) {
        print STDERR "Not the same number of entries";
        return 1;
    }

    foreach my $entry (keys %$elf1) {
        if(defined $$elf1{$entry} and not defined $$elf2{$entry}) {
            print STDERR "Entry $entry not found\n";
            return 1;
        }
        if(defined $$elf1{$entry} and $$elf1{$entry} ne $$elf2{$entry}) {
            print STDERR "Mismatch on $entry ($$elf1{$entry} <-> $$elf2{$entry})\n";
            return 1;
        }
    }

    return 0;
}

sub init {
    my $processors_key = join '_', @Cores; #BD3
    foreach my $reloc (@Relocation::table) {
        my @elfIds = split(' ',$reloc->attribute("elfIds"));
        my @processors = $reloc->access("processors");
        #BD3 my $processors_key = join '_', map{$_->core()} @processors;
        foreach my $elf_id (@elfIds) {
            if(defined $relocs{$processors_key}{$elf_id}) {
                my $reloc2 = $relocs{$processors_key}{$elf_id};
                my %elf1 = get_elf_reloc($reloc,$elf_id);
                my %elf2 = get_elf_reloc($reloc2,$elf_id);
                croak "Elf relocation $elf_id not consistant (".$reloc->name()." <-> ".$reloc2->name().")" if(elf_reloc_diff(\%elf1,\%elf2));
            }
            else {
                $relocs{$processors_key}{$elf_id} = $reloc;
            }
        }
    }
}

sub print_reloc_type {
    my ($file) = @_;

#   my $copyrights = &MDS::get_copyrights("/* "," */\n");
#   print $file $copyrights;

    print $file <<EOT;
/* KVX-specific relocations table.
   Copyright (C) 2009-2024 Free Software Foundation, Inc.
   Contributed by Kalray SA.

   This file is part of BFD, the Binary File Descriptor library.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; see the file COPYING3. If not,
   see <http://www.gnu.org/licenses/>.  */

EOT

    foreach my $processors_key (sort keys %relocs) {
	my $reloc_define = $FAMILY."_".uc($processors_key);

        print $file "#ifdef ".$reloc_define."\n";
        print $file "static reloc_howto_type elf_${Family}_howto_table[] =\n{\n";
        print $file "  HOWTO (R_${FAMILY}_NONE,\t\t\t/* type */\n";
        print $file "\t 0,\t\t\t\t/* rightshift */\n";
        print $file "\t 0,\t\t\t\t/* size (0 = byte, 1 = short, 2 = long, 3 = invalid, 4 = 64bits, 8 = 128bits) */\n";
        print $file "\t $elf_size,\t\t\t\t/* bitsize */\n";
        print $file "\t false,\t\t\t\t/* pc_relative */\n";
        print $file "\t 0,\t\t\t\t/* bitpos (bit field offset) */\n";
        print $file "\t complain_overflow_bitfield,\t/* complain_on_overflow */\n";
        print $file "\t bfd_elf_generic_reloc,\t\t/* special_function */\n";
        print $file "\t \"R_${FAMILY}_NONE\",\t\t\t/* name */\n";
        print $file "\t false,\t\t\t\t/* partial_inplace */\n";
        print $file "\t 0,\t\t\t\t/* src_mask */\n";
        print $file "\t 0,\t\t\t\t/* dst_mask */\n";
        print $file "\t false),\t\t\t/* pcrel_offset */\n";
        my $elfIds = $relocs{$processors_key};
        foreach my $elf_id (sort { $a <=> $b } keys %$elfIds) {
            my $reloc = $relocs{$processors_key}{$elf_id};
            croak "Relocation not defined for elf id $elf_id" if(not defined $reloc);
            my $reloc_size = get_reloc_size($reloc);
            my %reloc = get_elf_reloc($reloc,$elf_id);
            if(defined $reloc->attribute("what")) {
                print $file "  /* ".$reloc->attribute("what")." */\n\n";
            }
            my $scaling = $reloc{scaling}||"0";
            my $name = $reloc{linker} || croak "Linker reloc name not defined for elf id $elf_id";
            my $bf_size = $reloc{field_width};
            my $bf_offset = $reloc{field_offset};
            my $dst_mask = sprintf("0x%x",((1 << $bf_size) - 1) << $bf_offset);
            my $size = int($reloc_size / 8);
            $size += 1 if($reloc_size > $size * 8);
            my $pcrel = (defined $reloc{relative} and $reloc{relative} eq "PC") ? "true" : "false";
            my $overflow = "complain_overflow_dont";
            $overflow = "complain_overflow_".lc($reloc{overflow}) if(defined $reloc{overflow});
            print $file "  HOWTO ($name,\t\t\t/* type */\n";
            print $file "\t $scaling,\t\t\t\t/* rightshift */\n";
            print $file "\t $size,\t\t\t\t/* size (0 = byte, 1 = short, 2 = long, 3 = invalid, 4 = 64bits, 8 = 128bits) */\n";
            print $file "\t $bf_size,\t\t\t\t/* bitsize */\n";
            print $file "\t $pcrel,\t\t\t\t/* pc_relative */\n";
            print $file "\t $bf_offset,\t\t\t\t/* bitpos (bit field offset) */\n";
            print $file "\t $overflow,\t/* complain_on_overflow */\n";
            print $file "\t bfd_elf_generic_reloc,\t\t/* special_function */\n";
            print $file "\t \"$name\",\t\t\t/* name */\n";
            print $file "\t false,\t\t\t\t/* partial_inplace */\n";
            print $file "\t 0x0,\t\t\t\t/* src_mask */\n";
            print $file "\t $dst_mask,\t\t\t/* dst_mask */\n";
            print $file "\t $pcrel),\t\t\t/* pc_offset */\n";
        }
        print $file "};\n\n";
        print $file "#endif /* ".$reloc_define." */\n";
    }
}

&MDS::parse(*ARGV);

init();

print_reloc_type(*STDOUT);

