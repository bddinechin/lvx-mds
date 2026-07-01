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

use MDS;
use GBUTarget;
# use GBU;
use GBUFamilyRegFiles;
use Carp;

my $Family = $ENV{FAMILY};
my $FAMILY = uc $Family;
my @Cores = split ' ', $ENV{CORES};
my $wordWidth = 32;

# my $max_subcores = 0;
# my $nsubcores = 0;
# foreach my $core (@Cores) {
#     my @core_names = &GBUTarget::CoreNames(${core});
#     my @core_elfs = &GBUTarget::elfCoreInfo(${core});
#     if(scalar(@core_names) != scalar(@core_elfs)) {
#         croak "Number of names not equal equal to number of elf ids (" . scalar(@core_names) . " <-> " . scalar(@core_elfs) . ")";
#     }
#     $max_subcores = scalar(@core_names) + 1 if(scalar(@core_names) > $max_subcores);
#     $nsubcores += scalar(@core_elfs);
# }

sub printHeader {
    my $file = shift;

    #    my $copyrights = &MDS::get_copyrights("*** ","\n");

    print $file <<"EOT";
/* KVX assembler/disassembler support.

   Copyright (C) 2009-2024 Free Software Foundation, Inc.
   Contributed by Kalray SA.

   This file is part of GNU Binutils.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 3 of the license, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; see the file COPYING3. If not,
   see <http://www.gnu.org/licenses/>.  */


EOT

  print $file "#ifndef OPCODE_${FAMILY}_H\n";
  print $file "#define OPCODE_${FAMILY}_H\n\n";
}

sub printFamilyRegisters {
  my @regfiles_family = get_family_regfilenames($FAMILY);

  my $regfile_idx = 0;
  foreach my $regfile_name (@regfiles_family) {
      print "#define ${FAMILY}_REGFILE_FIRST_${regfile_name} $regfile_idx\n";
      $regfile_idx++;
      print "#define ${FAMILY}_REGFILE_LAST_${regfile_name} $regfile_idx\n";
      $regfile_idx++;
      print "#define ${FAMILY}_REGFILE_DEC_${regfile_name} $regfile_idx\n";
      $regfile_idx++;
  }
  print "\n\n";
}

sub printRegisters {
    my $file = shift;
    my $core = shift;
    my $core_uc = uc($core);

    my %regfiles_family = map { $_ => 1 } get_family_regfilenames($FAMILY);

    my $regfile_idx = 0;
    foreach my $regfile_name (get_sorted_regfilenames($FAMILY, \@RegFile::table)) {
        if (exists($regfiles_family{$regfile_name})) {
            print "#define ${core_uc}_REGFILE_FIRST_${regfile_name} ${FAMILY}_REGFILE_FIRST_${regfile_name}\n";
            print "#define ${core_uc}_REGFILE_LAST_${regfile_name} ${FAMILY}_REGFILE_LAST_${regfile_name}\n";
            print "#define ${core_uc}_REGFILE_DEC_${regfile_name} ${FAMILY}_REGFILE_DEC_${regfile_name}\n";
            $regfile_idx += 3;
        } else {
            print "#define ${core_uc}_REGFILE_FIRST_${regfile_name} $regfile_idx\n";
            $regfile_idx++;
            print "#define ${core_uc}_REGFILE_LAST_${regfile_name} $regfile_idx\n";
            $regfile_idx++;
            print "#define ${core_uc}_REGFILE_DEC_${regfile_name} $regfile_idx\n";
            $regfile_idx++;
        }
    }
    print "#define ${core_uc}_REGFILE_REGISTERS $regfile_idx\n";
    $regfile_idx++;
    print "#define ${core_uc}_REGFILE_DEC_REGISTERS $regfile_idx\n";
    print "\n\n";

    print $file "extern int ${core}_regfiles[];\n";
    print $file "extern const char **${core}_modifiers[];\n";
    print $file "extern struct ${Family}_register ${core}_registers[];\n\n";
    print $file "extern int ${core}_dec_registers[];\n\n";
}

sub printTrailer {
  my $file = shift;

  print $file "\n#endif /* OPCODE_${FAMILY}_H */\n";
}

sub calcMaxOperands {
  my $maxoperands = 0;
  foreach my $opcode (@Opcode::table) {
    my $operands = $opcode->attribute("operands") || "";
    my @operands = (split ' ', $operands);
    my $ocnt = scalar @operands;
    my $syntax = $opcode->attribute("syntax") || "";
    $ocnt += &GBUTarget::additionalOperands($syntax);
    $maxoperands = $ocnt if $ocnt > $maxoperands;
  }
  return $maxoperands;
}

sub calcMaxSyllables {
  use integer;
  my $maxsyllables = 0;
  foreach my $encoding (@Encoding::table) {
    my $wordCount = $encoding->attribute("wordCount");
    $maxsyllables = $wordCount if $maxsyllables < $wordCount;
  }
  return $maxsyllables;
}

sub calcMaxBundleIssue {
  use integer;
  my $maxbundleissue = 0;
  foreach my $bundle (@Bundle::table) {
    my ($template) = $bundle->access("template");
    next if defined $template->attribute("nopified");
    my @bundlings = split ' ', $bundle->attribute("contents");
    my $count = scalar @bundlings;
    $maxbundleissue = $count if $count > $maxbundleissue;
  }
  return $maxbundleissue;
}

sub calcMaxBundleWords {
  use integer;
  my $maxbundlewords = 0;
  foreach my $bundle (@Bundle::table) {
    my ($template) = $bundle->access("template");
    next if defined $template->attribute("nopified");
    my $increment = $template->attribute("increment");
    my $wordWidth = $template->attribute("wordWidth");
    my $count = ($increment*8)/$wordWidth;
    $maxbundlewords = $count if $count > $maxbundlewords;
  }
  return $maxbundlewords;
}

sub printMacros {
  my $file = shift;
  my $numcores = (scalar @Cores);
  print $file "#define ${FAMILY}_NUMCORES $numcores\n";
  my $maxsyllables = 3; #FIXME: &calcMaxSyllables;
  print $file "#define ${FAMILY}_MAXSYLLABLES $maxsyllables\n";
  my $maxoperands = 7; #FIXME: &calcMaxOperands;
  print $file "#define ${FAMILY}_MAXOPERANDS $maxoperands\n";
  my $maxbundleissue = 10; #FIXME: &calcMaxBundleIssue;
  print $file "#define ${FAMILY}_MAXBUNDLEISSUE $maxbundleissue\n";
  my $maxbundlewords = 18; #FIXME: &calcMaxBundleWords;
  print $file "#define ${FAMILY}_MAXBUNDLEWORDS $maxbundlewords\n";
  print $file "\n";

  print $file <<'EOT';

/*
 * The following macros are provided for compatibility with old
 * code.  They should not be used in new code.
 */

EOT

  &GBUTarget::addMacros($file);
}

sub printMethodEnum {
  my $file = shift;
  my $core = shift;

  my @method_names;
  foreach my $method (@Modifier::table, @Immediate::table,
                      @RegClass::table, @RegMask::table) {
    next unless defined $method->name();
    my $name = $method->attribute("ID");
    $name =~ s/\W/_/g;
    next if ($name =~ /_\d+$/); # Skip multi-RegClass
    push @method_names, $name;
  }
  @method_names = sort @method_names;

  my %insn_names;
  foreach my $insn (@Instruction::table) {
    my $insn_name = $insn->attribute("ID");
    #print STDERR $insn_name, "\t";
    $insn_name =~ s/[^-:]+\://;
    #print STDERR $insn_name, "\n";
    $insn_name =~ s/([^-]*)-([^-]*)-([^-]*)/$1_$2_\L$3/;
    $insn_name =~ s/\W/_/g;
    $insn_names{$insn_name}++;
  }
  my @insn_names = sort keys %insn_names;
  push @method_names, @insn_names;

  push @method_names, "Separator_${core}_comma";
  push @method_names, "Separator_${core}_equal";
  push @method_names, "Separator_${core}_qmark";
  #push @method_names, "Separator_${core}_rbracket";
  #push @method_names, "Separator_${core}_lbracket";
  push @method_names, "Separator_${core}_rsbracket";
  push @method_names, "Separator_${core}_lsbracket";

  my $iter = 1;
  foreach my $method (@method_names) {
    $method .= " = $iter";
    $iter += 1;
  }

  #unshift @method_names, "_${Family}_ERROR";
  #print $file "enum Method_${Family}_enum {\n  ", (join ",\n  ", map { "Method".$_ } @method_names), "\n};\n";
  # unshift @method_names, "Method_${core}_ERROR";
  print $file "enum Method_${core}_enum {\n  ", (join ",\n  ", @method_names), "\n};\n";
}

sub printModifierEnum {
  my $file = shift;
  my $core = shift;

  foreach my $modifier (@Modifier::table) {
    next unless defined $modifier->name();
    my $name = $modifier->attribute("ID");
    next unless $name =~ /exunum/;
    $name =~ s/\W/_/g;
    print $file "\ntypedef enum {\n";
    my @names = map {s/\W/_/g;s/^_//;$_} split ' ', $modifier->attribute("members");
    my @values = split(' ',$modifier->attribute("values"));
    for(my $i=0; $i<@names; $i++) {
        print $file "  ${name}_$names[$i]=$values[$i],\n";
    }
    print $file "} ${name}_values;\n\n";
  }

  foreach my $modifier (@Modifier::table) {
    next unless defined $modifier->name();
    my $name = $modifier->attribute("ID");
    $name =~ s/\W/_/g;
    $name =~ s/Modifier/mod/;
    print $file "\nextern const char *${name}[];";
  }
  print $file "\n\n";
}

sub printBundlingEnum {
    my $file = shift;
    my $core = shift;

    my %bundlings;
    my $ordering = 1;
    foreach my $bundling (@Bundling::table) {
        my $bundlingID = $bundling->attribute("ID");
        $bundlings{$bundlingID} = $ordering++;
    }
    print $file "typedef enum {\n";
    foreach my $bundlingID (sort {$bundlings{$a} <=> $bundlings{$b}} keys %bundlings) {
        (my $bundling_name = $bundlingID) =~ s/\W/_/g;
        print $file "  $bundling_name,\n";
    }
    print $file "} Bundling_${core};\n\n";

    if (0) {
        print $file "static const char *bundling_${core}_names(Bundling_${core} bundling) __attribute__((unused));\n";
        print $file "static const char *bundling_${core}_names(Bundling_${core} bundling) {\n";
        print $file "  switch(bundling) {\n";
        foreach my $bundlingID (sort {$bundlings{$a} <=> $bundlings{$b}} keys %bundlings) {
            $bundlingID =~ s/\W/_/g;
            print $file "  case $bundlingID: return \"$bundlingID\";\n";
        }
        print $file "  };\n";
        print $file "  return \"unknown bundling\";\n";
        print $file "};\n\n";
    }

    print $file "static int ATTRIBUTE_UNUSED\n${core}_base_bundling(int bundling) {\n";
    print $file "  static int base_bundlings[] = {\n";
    foreach my $bundlingID (sort {$bundlings{$a} <=> $bundlings{$b}} keys %bundlings) {
        (my $base_bundlingID = $bundlingID) =~ s/\.[A-Z]+//;
        $bundlingID =~ s/\W/_/g;
        $base_bundlingID =~ s/\W/_/g;
        print $file "    $base_bundlingID,\t// $bundlingID\n";
    }
    print $file "  };\n";
    print $file "  return base_bundlings[bundling];\n";
    print $file "};\n\n";
}

sub printResourceEnum {
    my $file = shift;
    my $core = shift;

    my $resource_count = 0;
    print $file "typedef enum {\n";
    foreach my $resource (@Resource::table) {
        my $resourceID = $resource->attribute("ID");
        (my $resource_name = $resourceID) =~ s/\W/_/g;
        print $file "  $resource_name,\n";
        $resource_count++;
    }
    print $file "} Resource_${core};\n";
    print $file "#define ${core}_RESOURCE_COUNT $resource_count\n\n";
}

sub printReservationEnum {
    my $file = shift;
    my $core = shift;

    print $file "typedef enum {\n";
    foreach my $reservation (@Reservation::table) {
        my $reservationID = $reservation->attribute("ID");
        (my $reservation_name = $reservationID) =~ s/\W/_/g;
        print $file "  $reservation_name,\n";
    }
    print $file "} Reservation_${core};\n\n";
}

sub printTypes {
  my $file = shift;

  my $maxentries;

  my %canonical;
  foreach my $bundle (@Bundle::table) {
      my ($template) = $bundle->access("template");
      next if defined $template->attribute("nopified");
      $canonical{$bundle->attribute("canonic")}++;
  }
  $maxentries = (sort { $b <=> $a } values %canonical)[0];

  print $file <<'EOT';

/***********************************************/
/*       DATA TYPES                            */
/***********************************************/

/*  Operand definition -- used in building     */
/*  format table                               */

EOT

  print $file <<"EOT";
enum ${Family}_rel {
  /* Absolute relocation. */
  ${FAMILY}_REL_ABS,
  /* PC relative relocation. */
  ${FAMILY}_REL_PC,
  /* GP relative relocation. */
  ${FAMILY}_REL_GP,
  /* TP relative relocation. */
  ${FAMILY}_REL_TP,
  /* GOT relative relocation. */
  ${FAMILY}_REL_GOT,
  /* BASE load address relative relocation. */
  ${FAMILY}_REL_BASE,
};

struct ${Family}_reloc {
  /* Size in bits. */
  int bitsize;
  /* Type of relative relocation. */
  enum ${Family}_rel relative;
  /* Number of BFD relocations. */
  int reloc_nb;
  /* List of BFD relocations. */
  unsigned int relocs[];
};

struct ${Family}_bitfield {
  /* Number of bits.  */
  int size;
  /* Offset in abstract value.  */
  int from_offset;
  /* Offset in encoded value.  */
  int to_offset;
};

struct ${Family}_operand {
  /* Operand type name.  */
  const char *tname;
  /* Type of operand.  */
  int type;
  /* Width of the operand. */
  int width;
  /* Encoded value shift. */
  int shift;
  /* Encoded value bias.  */
  int bias;
  /* Can be SIGNED|CANEXTEND|BITMASK|WRAPPED.  */
  int flags;
  /* Number of registers.  */
  int reg_nb;
  /* Valid registers for this operand (if no register get null pointer).  */
  int *regs;
  /* Number of relocations.  */
  int reloc_nb;
  /* List of relocations that can be applied to this operand.  */
  struct ${Family}_reloc **relocs;
  /* Number of given bitfields.  */
  int bitfields;
  /* Bitfields in most to least significant order.  */
  struct ${Family}_bitfield bfield[];
};

struct kvx_pseudo_relocs
{
  enum
  {
    S32_LO5_UP27,
    S37_LO10_UP27,
    S43_LO10_UP27_EX6,
    S64_LO10_UP27_EX27,
    S16,
    S32,
    S64,
  } reloc_type;

  int bitsize;

  /* Used when pseudo func should expand to different relocations
     based on the 32/64 bits mode.
     Enum values should match the kvx_arch_size var set by -m32
   */
  enum
  {
    PSEUDO_ALL = 0,
    PSEUDO_32_ONLY = 32,
    PSEUDO_64_ONLY = 64,
  } avail_modes;

  /* set to 1 when pseudo func does not take an argument */
  int has_no_arg;

  bfd_reloc_code_real_type reloc_lo5, reloc_lo10, reloc_up27, reloc_ex;
  bfd_reloc_code_real_type single;
  struct kvx_reloc *kreloc;
};

typedef struct symbol symbolS;

struct pseudo_func
{
  const char *name;

  symbolS *sym;
  struct kvx_pseudo_relocs pseudo_relocs;
};

/* Flags for ${Family}_operand  */
#define ${FAMILY}_OPERAND_SIGNED    1
#define ${FAMILY}_OPERAND_CANEXTEND 2
#define ${FAMILY}_OPERAND_BITMASK   4
#define ${FAMILY}_OPERAND_WRAPPED   8

#define ${FAMILY}_OPCODE_FLAG_UNDEF 0
EOT

  my $other_flags = &GBUTarget::getOpcodeFlagsList();
  foreach my $flag (sort { $$other_flags{$a} <=> $$other_flags{$b} } keys %$other_flags) {
      print $file "#define $flag $$other_flags{$flag}\n";
  }

  print $file <<"EOT";

/* Opcode definition.  */

struct ${Family}_codeword {
  /* The opcode.  */
  unsigned opcode;
  /* Disassembly mask.  */
  unsigned mask;
  /* Target dependent flags.  */
  unsigned flags;
};

struct ${Family}_opc {
  /* asm name */
  const char *as_op;
  /* 32 bits code words. */
  struct ${Family}_codeword codewords[${FAMILY}_MAXSYLLABLES];
  /* Number of words in codewords[].  */
  int wordcount;
  /* Bundling class.  */
  short bundling;
  /* Reservation class.  */
  short reservation;
  /* 0 terminated.  */
  struct ${Family}_operand *format[${FAMILY}_MAXOPERANDS + 1];
  /* Formating string.  */
  const char *fmtstring;
};

struct ${Family}_core_info {
  struct ${Family}_opc *optab;
  const char *name;
  const int *resources;
  int elf_core;
  struct pseudo_func *pseudo_funcs;
  int nb_pseudo_funcs;
  int **reservation_tables;
  int reservation_table_cycles;
  int resource_count;
  char **resource_names;
};

struct ${Family}_register {
  int id;
  const char *name;
};

EOT
}

sub printDeclarations {
  my $file = shift;

  foreach my $core (@Cores) {
    print $file "extern const int ${core}_reservation_table_cycles;\n";
    print $file "extern const int *${core}_reservation_tables[];\n";
    print $file "extern const char *${core}_resource_names[];\n\n";

    print $file "extern const int ${core}_resources[];\n";
    print $file "extern struct ${Family}_opc ${core}_optab[];\n";
    print $file "extern const struct ",${Family},"_core_info ${core}_core_info;\n";
    &GBUTarget::addCoreInfo($file);
  }
    print $file "extern const struct ",${Family},"_core_info *${Family}_core_info_table[];\n";
    print $file "extern const char ***${Family}_modifiers_table[];\n";
    print $file "extern const struct ",${Family},"_register *${Family}_registers_table[];\n";
    print $file "extern const int *${Family}_regfiles_table[];\n";
    print $file "extern const int ${Family}_regfiles_size_table[];\n\n";
}

sub printRelocations {
  my $file = shift;

  foreach my  $reloc (@Relocation::table) {
      my $reloc_name = $reloc->core()."_".$reloc->name()."_reloc";
      print $file "extern struct ${Family}_reloc $reloc_name;\n";
  }
  print $file "\n";
}

sub clearMDSTables {
  @Bundle::table = ();
  @Bundling::table = ();
  @Decoding::table = ();
  @Encoding::table = ();
  @Immediate::table = ();
  @Instruction::table = ();
  @Modifier::table = ();
  @Opcode::table = ();
  @Operand::table = ();
  @Processor::table = ();
  @RegClass::table = ();
  @RegFile::table = ();
  @Register::table = ();
  @RegMask::table = ();
  @Relocation::table = ();
  @Reservation::table = ();
  @Resource::table = ();
}

sub main {
  printHeader(*STDOUT);
  printMacros(*STDOUT);
  printTypes(*STDOUT);
  printDeclarations(*STDOUT);

  printFamilyRegisters(*STDOUT);

  for my $i (0 .. (scalar @Cores)-1) {
    my $core = $Cores[$i];
    open (mds_file, '<', $ARGV[$i]);
    clearMDSTables();
    &MDS::parse(*mds_file);

    printRegisters(*STDOUT, $core);
    printMethodEnum(*STDOUT, $core);
    printModifierEnum(*STDOUT, $core);
    printBundlingEnum(*STDOUT, $core);
    printResourceEnum(*STDOUT, $core);
    printReservationEnum(*STDOUT, $core);
    printRelocations(*STDOUT);
  }

  printTrailer(*STDOUT);
}

main();
