/* LVX assembler/disassembler support.

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


#ifndef OPCODE_LVX_H
#define OPCODE_LVX_H

#define LVX_NUMCORES 1
#define LVX_MAXSYLLABLES 3
#define LVX_MAXOPERANDS 7
#define LVX_MAXBUNDLEISSUE 10
#define LVX_MAXBUNDLEWORDS 18


/*
 * The following macros are provided for compatibility with old
 * code.  They should not be used in new code.
 */

#define LVX_ACTIVATE_OFFSET	6
#define LVX_ACTIVATE_WIDTH	8
#define LVX_ACTIVATE_MASK	\
  (((1 << LVX_ACTIVATE_WIDTH) - 1) << LVX_ACTIVATE_OFFSET)
#define LVX_BCU_GUARD_OPCODE	0x0f800000
#define LVX_BCU_GUARD_MASK	0x7ffc0000
#define LVX_BCU_BLEND_OPCODE	0x0f840000
#define LVX_BCU_BLEND_MASK	0x7ffc0000

/***********************************************/
/*       DATA TYPES                            */
/***********************************************/

/*  Operand definition -- used in building     */
/*  format table                               */

enum lvx_rel {
  /* Absolute relocation. */
  LVX_REL_ABS,
  /* PC relative relocation. */
  LVX_REL_PC,
  /* GP relative relocation. */
  LVX_REL_GP,
  /* TP relative relocation. */
  LVX_REL_TP,
  /* GOT relative relocation. */
  LVX_REL_GOT,
  /* BASE load address relative relocation. */
  LVX_REL_BASE,
};

struct lvx_reloc {
  /* Size in bits. */
  int bitsize;
  /* Type of relative relocation. */
  enum lvx_rel relative;
  /* Number of BFD relocations. */
  int reloc_nb;
  /* List of BFD relocations. */
  unsigned int relocs[];
};

struct lvx_bitfield {
  /* Number of bits.  */
  int size;
  /* Offset in abstract value.  */
  int from_offset;
  /* Offset in encoded value.  */
  int to_offset;
};

struct lvx_operand {
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
  struct lvx_reloc **relocs;
  /* Number of given bitfields.  */
  int bitfields;
  /* Bitfields in most to least significant order.  */
  struct lvx_bitfield bfield[];
};

struct lvx_pseudo_relocs
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
     Enum values should match the lvx_arch_size var set by -m32
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
  struct lvx_reloc *kreloc;
};

typedef struct symbol symbolS;

struct pseudo_func
{
  const char *name;

  symbolS *sym;
  struct lvx_pseudo_relocs pseudo_relocs;
};

/* Flags for lvx_operand  */
#define LVX_OPERAND_SIGNED    1
#define LVX_OPERAND_CANEXTEND 2
#define LVX_OPERAND_BITMASK   4
#define LVX_OPERAND_WRAPPED   8

#define LVX_OPCODE_FLAG_UNDEF 0
#define LVX_OPCODE_FLAG_IMMX 1
#define LVX_OPCODE_FLAG_COND 2
#define LVX_OPCODE_FLAG_CALL 4
#define LVX_OPCODE_FLAG_LOAD 8
#define LVX_OPCODE_FLAG_STORE 16
#define LVX_OPCODE_FLAG_MODE32 32
#define LVX_OPCODE_FLAG_MODE64 64
#define LVX_OPCODE_FLAG_RISCV 128

/* Opcode definition.  */

struct lvx_codeword {
  /* The opcode.  */
  unsigned opcode;
  /* Disassembly mask.  */
  unsigned mask;
  /* Target dependent flags.  */
  unsigned flags;
};

struct lvx_opc {
  /* asm name */
  const char *as_op;
  /* 32 bits code words. */
  struct lvx_codeword codewords[LVX_MAXSYLLABLES];
  /* Number of words in codewords[].  */
  int wordcount;
  /* Bundling class.  */
  short bundling;
  /* Reservation class.  */
  short reservation;
  /* 0 terminated.  */
  struct lvx_operand *format[LVX_MAXOPERANDS + 1];
  /* Formating string.  */
  const char *fmtstring;
};

struct lvx_core_info {
  struct lvx_opc *optab;
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

struct lvx_register {
  int id;
  const char *name;
};

extern const int lvx_v1_reservation_table_cycles;
extern const int *lvx_v1_reservation_tables[];
extern const char *lvx_v1_resource_names[];

extern const int lvx_v1_resources[];
extern struct lvx_opc lvx_v1_optab[];
extern const struct lvx_core_info lvx_v1_core_info;
extern const struct lvx_core_info *lvx_core_info_table[];
extern const char ***lvx_modifiers_table[];
extern const struct lvx_register *lvx_registers_table[];
extern const int *lvx_regfiles_table[];
extern const int lvx_regfiles_size_table[];

#define LVX_REGFILE_FIRST_SFR 0
#define LVX_REGFILE_LAST_SFR 1
#define LVX_REGFILE_DEC_SFR 2
#define LVX_REGFILE_FIRST_GPR 3
#define LVX_REGFILE_LAST_GPR 4
#define LVX_REGFILE_DEC_GPR 5


#define LVX_V1_REGFILE_FIRST_SFR LVX_REGFILE_FIRST_SFR
#define LVX_V1_REGFILE_LAST_SFR LVX_REGFILE_LAST_SFR
#define LVX_V1_REGFILE_DEC_SFR LVX_REGFILE_DEC_SFR
#define LVX_V1_REGFILE_FIRST_GPR LVX_REGFILE_FIRST_GPR
#define LVX_V1_REGFILE_LAST_GPR LVX_REGFILE_LAST_GPR
#define LVX_V1_REGFILE_DEC_GPR LVX_REGFILE_DEC_GPR
#define LVX_V1_REGFILE_FIRST_CSR 6
#define LVX_V1_REGFILE_LAST_CSR 7
#define LVX_V1_REGFILE_DEC_CSR 8
#define LVX_V1_REGFILE_FIRST_PGR 9
#define LVX_V1_REGFILE_LAST_PGR 10
#define LVX_V1_REGFILE_DEC_PGR 11
#define LVX_V1_REGFILE_FIRST_QGR 12
#define LVX_V1_REGFILE_LAST_QGR 13
#define LVX_V1_REGFILE_DEC_QGR 14
#define LVX_V1_REGFILE_FIRST_RV_BIR 15
#define LVX_V1_REGFILE_LAST_RV_BIR 16
#define LVX_V1_REGFILE_DEC_RV_BIR 17
#define LVX_V1_REGFILE_FIRST_RV_BIRP 18
#define LVX_V1_REGFILE_LAST_RV_BIRP 19
#define LVX_V1_REGFILE_DEC_RV_BIRP 20
#define LVX_V1_REGFILE_FIRST_RV_FPR 21
#define LVX_V1_REGFILE_LAST_RV_FPR 22
#define LVX_V1_REGFILE_DEC_RV_FPR 23
#define LVX_V1_REGFILE_FIRST_X16R 24
#define LVX_V1_REGFILE_LAST_X16R 25
#define LVX_V1_REGFILE_DEC_X16R 26
#define LVX_V1_REGFILE_FIRST_X2R 27
#define LVX_V1_REGFILE_LAST_X2R 28
#define LVX_V1_REGFILE_DEC_X2R 29
#define LVX_V1_REGFILE_FIRST_X32R 30
#define LVX_V1_REGFILE_LAST_X32R 31
#define LVX_V1_REGFILE_DEC_X32R 32
#define LVX_V1_REGFILE_FIRST_X4R 33
#define LVX_V1_REGFILE_LAST_X4R 34
#define LVX_V1_REGFILE_DEC_X4R 35
#define LVX_V1_REGFILE_FIRST_X64R 36
#define LVX_V1_REGFILE_LAST_X64R 37
#define LVX_V1_REGFILE_DEC_X64R 38
#define LVX_V1_REGFILE_FIRST_X8R 39
#define LVX_V1_REGFILE_LAST_X8R 40
#define LVX_V1_REGFILE_DEC_X8R 41
#define LVX_V1_REGFILE_FIRST_XBR 42
#define LVX_V1_REGFILE_LAST_XBR 43
#define LVX_V1_REGFILE_DEC_XBR 44
#define LVX_V1_REGFILE_FIRST_XCR 45
#define LVX_V1_REGFILE_LAST_XCR 46
#define LVX_V1_REGFILE_DEC_XCR 47
#define LVX_V1_REGFILE_FIRST_XMR 48
#define LVX_V1_REGFILE_LAST_XMR 49
#define LVX_V1_REGFILE_DEC_XMR 50
#define LVX_V1_REGFILE_FIRST_XTR 51
#define LVX_V1_REGFILE_LAST_XTR 52
#define LVX_V1_REGFILE_DEC_XTR 53
#define LVX_V1_REGFILE_FIRST_XVR 54
#define LVX_V1_REGFILE_LAST_XVR 55
#define LVX_V1_REGFILE_DEC_XVR 56
#define LVX_V1_REGFILE_REGISTERS 57
#define LVX_V1_REGFILE_DEC_REGISTERS 58


extern int lvx_v1_regfiles[];
extern const char **lvx_v1_modifiers[];
extern struct lvx_register lvx_v1_registers[];

extern int lvx_v1_dec_registers[];

enum Method_lvx_v1_enum {
  Immediate_lvx_v1_brknumber = 1,
  Immediate_lvx_v1_pcrel11s2 = 2,
  Immediate_lvx_v1_pcrel12s1 = 3,
  Immediate_lvx_v1_pcrel17s2 = 4,
  Immediate_lvx_v1_pcrel20s1 = 5,
  Immediate_lvx_v1_pcrel27s2 = 6,
  Immediate_lvx_v1_pcrel38s2 = 7,
  Immediate_lvx_v1_pcrel44s2 = 8,
  Immediate_lvx_v1_pcrel54s2 = 9,
  Immediate_lvx_v1_signed10 = 10,
  Immediate_lvx_v1_signed12 = 11,
  Immediate_lvx_v1_signed16 = 12,
  Immediate_lvx_v1_signed20 = 13,
  Immediate_lvx_v1_signed27 = 14,
  Immediate_lvx_v1_signed37 = 15,
  Immediate_lvx_v1_signed43 = 16,
  Immediate_lvx_v1_signed54 = 17,
  Immediate_lvx_v1_signed6 = 18,
  Immediate_lvx_v1_sysnumber = 19,
  Immediate_lvx_v1_unsigned5 = 20,
  Immediate_lvx_v1_unsigned6 = 21,
  Immediate_lvx_v1_wrapped32 = 22,
  Immediate_lvx_v1_wrapped64 = 23,
  Immediate_lvx_v1_wrapped8 = 24,
  Modifier_lvx_v1_accesses = 25,
  Modifier_lvx_v1_acqrel = 26,
  Modifier_lvx_v1_bcucond = 27,
  Modifier_lvx_v1_boolcas = 28,
  Modifier_lvx_v1_cachelev = 29,
  Modifier_lvx_v1_ccbcomp = 30,
  Modifier_lvx_v1_channel = 31,
  Modifier_lvx_v1_coherency = 32,
  Modifier_lvx_v1_conjugate = 33,
  Modifier_lvx_v1_doscale = 34,
  Modifier_lvx_v1_exunum = 35,
  Modifier_lvx_v1_floatcomp = 36,
  Modifier_lvx_v1_floatmode = 37,
  Modifier_lvx_v1_fnegate = 38,
  Modifier_lvx_v1_froundmode = 39,
  Modifier_lvx_v1_highmult = 40,
  Modifier_lvx_v1_hindex = 41,
  Modifier_lvx_v1_imultiply = 42,
  Modifier_lvx_v1_intcomp = 43,
  Modifier_lvx_v1_lanecond = 44,
  Modifier_lvx_v1_lanesize = 45,
  Modifier_lvx_v1_lanetodo = 46,
  Modifier_lvx_v1_mostsig = 47,
  Modifier_lvx_v1_oddlanes = 48,
  Modifier_lvx_v1_ordering = 49,
  Modifier_lvx_v1_qindex = 50,
  Modifier_lvx_v1_realimag = 51,
  Modifier_lvx_v1_shuffleV = 52,
  Modifier_lvx_v1_shuffleX = 53,
  Modifier_lvx_v1_signextw = 54,
  Modifier_lvx_v1_speculate = 55,
  Modifier_lvx_v1_splat32 = 56,
  Modifier_lvx_v1_variant = 57,
  Modifier_lvx_v1_widemult = 58,
  Modifier_lvx_v1_ziplanes = 59,
  RegClass_lvx_v1_aloneReg = 60,
  RegClass_lvx_v1_buffer16Reg = 61,
  RegClass_lvx_v1_buffer2Reg = 62,
  RegClass_lvx_v1_buffer32Reg = 63,
  RegClass_lvx_v1_buffer4Reg = 64,
  RegClass_lvx_v1_buffer64Reg = 65,
  RegClass_lvx_v1_buffer8Reg = 66,
  RegClass_lvx_v1_csReg = 67,
  RegClass_lvx_v1_floatReg = 68,
  RegClass_lvx_v1_mainReg = 69,
  RegClass_lvx_v1_mainRegPair = 70,
  RegClass_lvx_v1_onlyfxReg = 71,
  RegClass_lvx_v1_onlygetReg = 72,
  RegClass_lvx_v1_onlyraReg = 73,
  RegClass_lvx_v1_onlysetReg = 74,
  RegClass_lvx_v1_onlyswapReg = 75,
  RegClass_lvx_v1_pairedReg = 76,
  RegClass_lvx_v1_quadReg = 77,
  RegClass_lvx_v1_singleReg = 78,
  RegClass_lvx_v1_systemReg = 79,
  RegClass_lvx_v1_worddRegE = 80,
  RegClass_lvx_v1_worddRegO = 81,
  RegClass_lvx_v1_xworddReg = 82,
  RegClass_lvx_v1_xworddReg0M4 = 83,
  RegClass_lvx_v1_xworddReg1M4 = 84,
  RegClass_lvx_v1_xworddReg2M4 = 85,
  RegClass_lvx_v1_xworddReg3M4 = 86,
  RegClass_lvx_v1_xwordoReg = 87,
  RegClass_lvx_v1_xwordqReg = 88,
  RegClass_lvx_v1_xwordqRegE = 89,
  RegClass_lvx_v1_xwordqRegO = 90,
  RegClass_lvx_v1_xwordvReg = 91,
  RegClass_lvx_v1_xwordxReg = 92,
  Instruction_lvx_v1_abdbo = 93,
  Instruction_lvx_v1_abdd = 94,
  Instruction_lvx_v1_abdhq = 95,
  Instruction_lvx_v1_abdsbo = 96,
  Instruction_lvx_v1_abdsd = 97,
  Instruction_lvx_v1_abdshq = 98,
  Instruction_lvx_v1_abdsw = 99,
  Instruction_lvx_v1_abdswp = 100,
  Instruction_lvx_v1_abdubo = 101,
  Instruction_lvx_v1_abdud = 102,
  Instruction_lvx_v1_abduhq = 103,
  Instruction_lvx_v1_abduw = 104,
  Instruction_lvx_v1_abduwp = 105,
  Instruction_lvx_v1_abdw = 106,
  Instruction_lvx_v1_abdwp = 107,
  Instruction_lvx_v1_absbo = 108,
  Instruction_lvx_v1_absd = 109,
  Instruction_lvx_v1_abshq = 110,
  Instruction_lvx_v1_abssbo = 111,
  Instruction_lvx_v1_abssd = 112,
  Instruction_lvx_v1_absshq = 113,
  Instruction_lvx_v1_abssw = 114,
  Instruction_lvx_v1_absswp = 115,
  Instruction_lvx_v1_absw = 116,
  Instruction_lvx_v1_abswp = 117,
  Instruction_lvx_v1_acswapb = 118,
  Instruction_lvx_v1_acswapd = 119,
  Instruction_lvx_v1_acswaph = 120,
  Instruction_lvx_v1_acswapq = 121,
  Instruction_lvx_v1_acswapw = 122,
  Instruction_lvx_v1_add = 123,
  Instruction_lvx_v1_add_uw = 124,
  Instruction_lvx_v1_addbo = 125,
  Instruction_lvx_v1_addd = 126,
  Instruction_lvx_v1_addhq = 127,
  Instruction_lvx_v1_addi = 128,
  Instruction_lvx_v1_addiw = 129,
  Instruction_lvx_v1_addq = 130,
  Instruction_lvx_v1_addsbo = 131,
  Instruction_lvx_v1_addsd = 132,
  Instruction_lvx_v1_addshq = 133,
  Instruction_lvx_v1_addsw = 134,
  Instruction_lvx_v1_addswp = 135,
  Instruction_lvx_v1_addusbo = 136,
  Instruction_lvx_v1_addusd = 137,
  Instruction_lvx_v1_addushq = 138,
  Instruction_lvx_v1_addusw = 139,
  Instruction_lvx_v1_adduswp = 140,
  Instruction_lvx_v1_addw = 141,
  Instruction_lvx_v1_addwp = 142,
  Instruction_lvx_v1_addx16bo = 143,
  Instruction_lvx_v1_addx16d = 144,
  Instruction_lvx_v1_addx16hq = 145,
  Instruction_lvx_v1_addx16w = 146,
  Instruction_lvx_v1_addx16wp = 147,
  Instruction_lvx_v1_addx2bo = 148,
  Instruction_lvx_v1_addx2d = 149,
  Instruction_lvx_v1_addx2hq = 150,
  Instruction_lvx_v1_addx2w = 151,
  Instruction_lvx_v1_addx2wp = 152,
  Instruction_lvx_v1_addx32d = 153,
  Instruction_lvx_v1_addx32w = 154,
  Instruction_lvx_v1_addx4bo = 155,
  Instruction_lvx_v1_addx4d = 156,
  Instruction_lvx_v1_addx4hq = 157,
  Instruction_lvx_v1_addx4w = 158,
  Instruction_lvx_v1_addx4wp = 159,
  Instruction_lvx_v1_addx64d = 160,
  Instruction_lvx_v1_addx64w = 161,
  Instruction_lvx_v1_addx8bo = 162,
  Instruction_lvx_v1_addx8d = 163,
  Instruction_lvx_v1_addx8hq = 164,
  Instruction_lvx_v1_addx8w = 165,
  Instruction_lvx_v1_addx8wp = 166,
  Instruction_lvx_v1_aladdb = 167,
  Instruction_lvx_v1_aladdd = 168,
  Instruction_lvx_v1_aladdh = 169,
  Instruction_lvx_v1_aladdw = 170,
  Instruction_lvx_v1_alandb = 171,
  Instruction_lvx_v1_alandd = 172,
  Instruction_lvx_v1_alandh = 173,
  Instruction_lvx_v1_alandw = 174,
  Instruction_lvx_v1_alb = 175,
  Instruction_lvx_v1_alclrb = 176,
  Instruction_lvx_v1_alclrd = 177,
  Instruction_lvx_v1_alclrh = 178,
  Instruction_lvx_v1_alclrw = 179,
  Instruction_lvx_v1_ald = 180,
  Instruction_lvx_v1_aldusb = 181,
  Instruction_lvx_v1_aldusd = 182,
  Instruction_lvx_v1_aldush = 183,
  Instruction_lvx_v1_aldusw = 184,
  Instruction_lvx_v1_aleorb = 185,
  Instruction_lvx_v1_aleord = 186,
  Instruction_lvx_v1_aleorh = 187,
  Instruction_lvx_v1_aleorw = 188,
  Instruction_lvx_v1_alh = 189,
  Instruction_lvx_v1_aliorb = 190,
  Instruction_lvx_v1_aliord = 191,
  Instruction_lvx_v1_aliorh = 192,
  Instruction_lvx_v1_aliorw = 193,
  Instruction_lvx_v1_almaxb = 194,
  Instruction_lvx_v1_almaxd = 195,
  Instruction_lvx_v1_almaxh = 196,
  Instruction_lvx_v1_almaxub = 197,
  Instruction_lvx_v1_almaxud = 198,
  Instruction_lvx_v1_almaxuh = 199,
  Instruction_lvx_v1_almaxuw = 200,
  Instruction_lvx_v1_almaxw = 201,
  Instruction_lvx_v1_alminb = 202,
  Instruction_lvx_v1_almind = 203,
  Instruction_lvx_v1_alminh = 204,
  Instruction_lvx_v1_alminub = 205,
  Instruction_lvx_v1_alminud = 206,
  Instruction_lvx_v1_alminuh = 207,
  Instruction_lvx_v1_alminuw = 208,
  Instruction_lvx_v1_alminw = 209,
  Instruction_lvx_v1_alw = 210,
  Instruction_lvx_v1_amoadd_b = 211,
  Instruction_lvx_v1_amoadd_d = 212,
  Instruction_lvx_v1_amoadd_h = 213,
  Instruction_lvx_v1_amoadd_w = 214,
  Instruction_lvx_v1_amoand_b = 215,
  Instruction_lvx_v1_amoand_d = 216,
  Instruction_lvx_v1_amoand_h = 217,
  Instruction_lvx_v1_amoand_w = 218,
  Instruction_lvx_v1_amocas_b = 219,
  Instruction_lvx_v1_amocas_d = 220,
  Instruction_lvx_v1_amocas_h = 221,
  Instruction_lvx_v1_amocas_q = 222,
  Instruction_lvx_v1_amocas_w = 223,
  Instruction_lvx_v1_amomax_b = 224,
  Instruction_lvx_v1_amomax_d = 225,
  Instruction_lvx_v1_amomax_h = 226,
  Instruction_lvx_v1_amomax_w = 227,
  Instruction_lvx_v1_amomaxu_b = 228,
  Instruction_lvx_v1_amomaxu_d = 229,
  Instruction_lvx_v1_amomaxu_h = 230,
  Instruction_lvx_v1_amomaxu_w = 231,
  Instruction_lvx_v1_amomin_b = 232,
  Instruction_lvx_v1_amomin_d = 233,
  Instruction_lvx_v1_amomin_h = 234,
  Instruction_lvx_v1_amomin_w = 235,
  Instruction_lvx_v1_amominu_b = 236,
  Instruction_lvx_v1_amominu_d = 237,
  Instruction_lvx_v1_amominu_h = 238,
  Instruction_lvx_v1_amominu_w = 239,
  Instruction_lvx_v1_amoor_b = 240,
  Instruction_lvx_v1_amoor_d = 241,
  Instruction_lvx_v1_amoor_h = 242,
  Instruction_lvx_v1_amoor_w = 243,
  Instruction_lvx_v1_amoswap_b = 244,
  Instruction_lvx_v1_amoswap_d = 245,
  Instruction_lvx_v1_amoswap_h = 246,
  Instruction_lvx_v1_amoswap_w = 247,
  Instruction_lvx_v1_amoxor_b = 248,
  Instruction_lvx_v1_amoxor_d = 249,
  Instruction_lvx_v1_amoxor_h = 250,
  Instruction_lvx_v1_amoxor_w = 251,
  Instruction_lvx_v1_and = 252,
  Instruction_lvx_v1_andd = 253,
  Instruction_lvx_v1_andi = 254,
  Instruction_lvx_v1_andn = 255,
  Instruction_lvx_v1_andnd = 256,
  Instruction_lvx_v1_andnq = 257,
  Instruction_lvx_v1_andnw = 258,
  Instruction_lvx_v1_andq = 259,
  Instruction_lvx_v1_andw = 260,
  Instruction_lvx_v1_asaddb = 261,
  Instruction_lvx_v1_asaddd = 262,
  Instruction_lvx_v1_asaddh = 263,
  Instruction_lvx_v1_asaddw = 264,
  Instruction_lvx_v1_asandb = 265,
  Instruction_lvx_v1_asandd = 266,
  Instruction_lvx_v1_asandh = 267,
  Instruction_lvx_v1_asandw = 268,
  Instruction_lvx_v1_asb = 269,
  Instruction_lvx_v1_asd = 270,
  Instruction_lvx_v1_asdusb = 271,
  Instruction_lvx_v1_asdusd = 272,
  Instruction_lvx_v1_asdush = 273,
  Instruction_lvx_v1_asdusw = 274,
  Instruction_lvx_v1_aseorb = 275,
  Instruction_lvx_v1_aseord = 276,
  Instruction_lvx_v1_aseorh = 277,
  Instruction_lvx_v1_aseorw = 278,
  Instruction_lvx_v1_ash = 279,
  Instruction_lvx_v1_asiorb = 280,
  Instruction_lvx_v1_asiord = 281,
  Instruction_lvx_v1_asiorh = 282,
  Instruction_lvx_v1_asiorw = 283,
  Instruction_lvx_v1_asmaxb = 284,
  Instruction_lvx_v1_asmaxd = 285,
  Instruction_lvx_v1_asmaxh = 286,
  Instruction_lvx_v1_asmaxub = 287,
  Instruction_lvx_v1_asmaxud = 288,
  Instruction_lvx_v1_asmaxuh = 289,
  Instruction_lvx_v1_asmaxuw = 290,
  Instruction_lvx_v1_asmaxw = 291,
  Instruction_lvx_v1_asminb = 292,
  Instruction_lvx_v1_asmind = 293,
  Instruction_lvx_v1_asminh = 294,
  Instruction_lvx_v1_asminub = 295,
  Instruction_lvx_v1_asminud = 296,
  Instruction_lvx_v1_asminuh = 297,
  Instruction_lvx_v1_asminuw = 298,
  Instruction_lvx_v1_asminw = 299,
  Instruction_lvx_v1_asw = 300,
  Instruction_lvx_v1_aswapb = 301,
  Instruction_lvx_v1_aswapd = 302,
  Instruction_lvx_v1_aswaph = 303,
  Instruction_lvx_v1_aswapw = 304,
  Instruction_lvx_v1_auipc = 305,
  Instruction_lvx_v1_avgbo = 306,
  Instruction_lvx_v1_avghq = 307,
  Instruction_lvx_v1_avgrbo = 308,
  Instruction_lvx_v1_avgrhq = 309,
  Instruction_lvx_v1_avgrubo = 310,
  Instruction_lvx_v1_avgruhq = 311,
  Instruction_lvx_v1_avgruw = 312,
  Instruction_lvx_v1_avgruwp = 313,
  Instruction_lvx_v1_avgrw = 314,
  Instruction_lvx_v1_avgrwp = 315,
  Instruction_lvx_v1_avgubo = 316,
  Instruction_lvx_v1_avguhq = 317,
  Instruction_lvx_v1_avguw = 318,
  Instruction_lvx_v1_avguwp = 319,
  Instruction_lvx_v1_avgw = 320,
  Instruction_lvx_v1_avgwp = 321,
  Instruction_lvx_v1_await = 322,
  Instruction_lvx_v1_barrier = 323,
  Instruction_lvx_v1_bclr = 324,
  Instruction_lvx_v1_bclri = 325,
  Instruction_lvx_v1_beq = 326,
  Instruction_lvx_v1_beqz = 327,
  Instruction_lvx_v1_bext = 328,
  Instruction_lvx_v1_bexti = 329,
  Instruction_lvx_v1_bge = 330,
  Instruction_lvx_v1_bgeu = 331,
  Instruction_lvx_v1_bgez = 332,
  Instruction_lvx_v1_bgtz = 333,
  Instruction_lvx_v1_binv = 334,
  Instruction_lvx_v1_binvi = 335,
  Instruction_lvx_v1_blend = 336,
  Instruction_lvx_v1_blez = 337,
  Instruction_lvx_v1_blt = 338,
  Instruction_lvx_v1_bltu = 339,
  Instruction_lvx_v1_bltz = 340,
  Instruction_lvx_v1_bne = 341,
  Instruction_lvx_v1_bnez = 342,
  Instruction_lvx_v1_break = 343,
  Instruction_lvx_v1_bset = 344,
  Instruction_lvx_v1_bseti = 345,
  Instruction_lvx_v1_call = 346,
  Instruction_lvx_v1_callx = 347,
  Instruction_lvx_v1_catdq = 348,
  Instruction_lvx_v1_cb = 349,
  Instruction_lvx_v1_cbo_clean = 350,
  Instruction_lvx_v1_cbo_flush = 351,
  Instruction_lvx_v1_cbo_inval = 352,
  Instruction_lvx_v1_cbo_zero = 353,
  Instruction_lvx_v1_cbsd = 354,
  Instruction_lvx_v1_cbshq = 355,
  Instruction_lvx_v1_cbsw = 356,
  Instruction_lvx_v1_cbswp = 357,
  Instruction_lvx_v1_cbx = 358,
  Instruction_lvx_v1_ccb = 359,
  Instruction_lvx_v1_ccbx = 360,
  Instruction_lvx_v1_clmul = 361,
  Instruction_lvx_v1_clmulh = 362,
  Instruction_lvx_v1_clmulr = 363,
  Instruction_lvx_v1_clsd = 364,
  Instruction_lvx_v1_clshq = 365,
  Instruction_lvx_v1_clsw = 366,
  Instruction_lvx_v1_clswp = 367,
  Instruction_lvx_v1_clz = 368,
  Instruction_lvx_v1_clzd = 369,
  Instruction_lvx_v1_clzhq = 370,
  Instruction_lvx_v1_clzw = 371,
  Instruction_lvx_v1_clzwp = 372,
  Instruction_lvx_v1_cmovebo = 373,
  Instruction_lvx_v1_cmoved = 374,
  Instruction_lvx_v1_cmovehq = 375,
  Instruction_lvx_v1_cmoveq = 376,
  Instruction_lvx_v1_cmovewp = 377,
  Instruction_lvx_v1_compbo = 378,
  Instruction_lvx_v1_compd = 379,
  Instruction_lvx_v1_comphq = 380,
  Instruction_lvx_v1_compnbo = 381,
  Instruction_lvx_v1_compnd = 382,
  Instruction_lvx_v1_compnhq = 383,
  Instruction_lvx_v1_compnwp = 384,
  Instruction_lvx_v1_compq = 385,
  Instruction_lvx_v1_compw = 386,
  Instruction_lvx_v1_compwp = 387,
  Instruction_lvx_v1_copyd = 388,
  Instruction_lvx_v1_copyo = 389,
  Instruction_lvx_v1_copyq = 390,
  Instruction_lvx_v1_copyw = 391,
  Instruction_lvx_v1_cpop = 392,
  Instruction_lvx_v1_cpopw = 393,
  Instruction_lvx_v1_crcbellw = 394,
  Instruction_lvx_v1_crcbelmw = 395,
  Instruction_lvx_v1_crclellw = 396,
  Instruction_lvx_v1_crclelmw = 397,
  Instruction_lvx_v1_csrr = 398,
  Instruction_lvx_v1_csrrc = 399,
  Instruction_lvx_v1_csrrci = 400,
  Instruction_lvx_v1_csrrs = 401,
  Instruction_lvx_v1_csrrsi = 402,
  Instruction_lvx_v1_csrrw = 403,
  Instruction_lvx_v1_csrrwi = 404,
  Instruction_lvx_v1_csrw = 405,
  Instruction_lvx_v1_ctz = 406,
  Instruction_lvx_v1_ctzd = 407,
  Instruction_lvx_v1_ctzhq = 408,
  Instruction_lvx_v1_ctzw = 409,
  Instruction_lvx_v1_ctzwp = 410,
  Instruction_lvx_v1_czero_eqz = 411,
  Instruction_lvx_v1_czero_nez = 412,
  Instruction_lvx_v1_d1inval = 413,
  Instruction_lvx_v1_dflushl = 414,
  Instruction_lvx_v1_dflushsw = 415,
  Instruction_lvx_v1_dinvall = 416,
  Instruction_lvx_v1_dinvalsw = 417,
  Instruction_lvx_v1_div = 418,
  Instruction_lvx_v1_divmodd = 419,
  Instruction_lvx_v1_divmodud = 420,
  Instruction_lvx_v1_divmoduw = 421,
  Instruction_lvx_v1_divmodw = 422,
  Instruction_lvx_v1_divu = 423,
  Instruction_lvx_v1_divuw = 424,
  Instruction_lvx_v1_divw = 425,
  Instruction_lvx_v1_dpurgel = 426,
  Instruction_lvx_v1_dpurgesw = 427,
  Instruction_lvx_v1_dtouchl = 428,
  Instruction_lvx_v1_ebreak = 429,
  Instruction_lvx_v1_ecall = 430,
  Instruction_lvx_v1_eord = 431,
  Instruction_lvx_v1_eorq = 432,
  Instruction_lvx_v1_eorw = 433,
  Instruction_lvx_v1_errop = 434,
  Instruction_lvx_v1_extfs = 435,
  Instruction_lvx_v1_extfz = 436,
  Instruction_lvx_v1_extlqbho = 437,
  Instruction_lvx_v1_extlqhwq = 438,
  Instruction_lvx_v1_extlqnbx = 439,
  Instruction_lvx_v1_extlqwdp = 440,
  Instruction_lvx_v1_extlsbho = 441,
  Instruction_lvx_v1_extlshwq = 442,
  Instruction_lvx_v1_extlsnbx = 443,
  Instruction_lvx_v1_extlswdp = 444,
  Instruction_lvx_v1_extlzbho = 445,
  Instruction_lvx_v1_extlzhwq = 446,
  Instruction_lvx_v1_extlznbx = 447,
  Instruction_lvx_v1_extlzwdp = 448,
  Instruction_lvx_v1_fabsd = 449,
  Instruction_lvx_v1_fabsh = 450,
  Instruction_lvx_v1_fabshq = 451,
  Instruction_lvx_v1_fabsw = 452,
  Instruction_lvx_v1_fabswp = 453,
  Instruction_lvx_v1_fadd_d = 454,
  Instruction_lvx_v1_fadd_s = 455,
  Instruction_lvx_v1_faddd = 456,
  Instruction_lvx_v1_faddh = 457,
  Instruction_lvx_v1_faddhq = 458,
  Instruction_lvx_v1_faddw = 459,
  Instruction_lvx_v1_faddwc = 460,
  Instruction_lvx_v1_faddwp = 461,
  Instruction_lvx_v1_fclass_d = 462,
  Instruction_lvx_v1_fclass_s = 463,
  Instruction_lvx_v1_fclassd = 464,
  Instruction_lvx_v1_fclassh = 465,
  Instruction_lvx_v1_fclasshq = 466,
  Instruction_lvx_v1_fclassw = 467,
  Instruction_lvx_v1_fclasswp = 468,
  Instruction_lvx_v1_fcompd = 469,
  Instruction_lvx_v1_fcomph = 470,
  Instruction_lvx_v1_fcomphq = 471,
  Instruction_lvx_v1_fcompnd = 472,
  Instruction_lvx_v1_fcompnhq = 473,
  Instruction_lvx_v1_fcompnwp = 474,
  Instruction_lvx_v1_fcompw = 475,
  Instruction_lvx_v1_fcompwp = 476,
  Instruction_lvx_v1_fcvt_d_l = 477,
  Instruction_lvx_v1_fcvt_d_lu = 478,
  Instruction_lvx_v1_fcvt_d_s = 479,
  Instruction_lvx_v1_fcvt_d_w = 480,
  Instruction_lvx_v1_fcvt_d_wu = 481,
  Instruction_lvx_v1_fcvt_l_d = 482,
  Instruction_lvx_v1_fcvt_l_s = 483,
  Instruction_lvx_v1_fcvt_lu_d = 484,
  Instruction_lvx_v1_fcvt_lu_s = 485,
  Instruction_lvx_v1_fcvt_s_d = 486,
  Instruction_lvx_v1_fcvt_s_l = 487,
  Instruction_lvx_v1_fcvt_s_lu = 488,
  Instruction_lvx_v1_fcvt_s_w = 489,
  Instruction_lvx_v1_fcvt_s_wu = 490,
  Instruction_lvx_v1_fcvt_w_d = 491,
  Instruction_lvx_v1_fcvt_w_s = 492,
  Instruction_lvx_v1_fcvt_wu_d = 493,
  Instruction_lvx_v1_fcvt_wu_s = 494,
  Instruction_lvx_v1_fdiv_d = 495,
  Instruction_lvx_v1_fdiv_s = 496,
  Instruction_lvx_v1_fdivd = 497,
  Instruction_lvx_v1_fdivh = 498,
  Instruction_lvx_v1_fdivw = 499,
  Instruction_lvx_v1_fence = 500,
  Instruction_lvx_v1_fence_i = 501,
  Instruction_lvx_v1_fence_mem = 502,
  Instruction_lvx_v1_feq_d = 503,
  Instruction_lvx_v1_feq_s = 504,
  Instruction_lvx_v1_fextlhwq = 505,
  Instruction_lvx_v1_ffmad = 506,
  Instruction_lvx_v1_ffmah = 507,
  Instruction_lvx_v1_ffmahq = 508,
  Instruction_lvx_v1_ffmaw = 509,
  Instruction_lvx_v1_ffmawc = 510,
  Instruction_lvx_v1_ffmawp = 511,
  Instruction_lvx_v1_ffmsd = 512,
  Instruction_lvx_v1_ffmsh = 513,
  Instruction_lvx_v1_ffmshq = 514,
  Instruction_lvx_v1_ffmsw = 515,
  Instruction_lvx_v1_ffmswp = 516,
  Instruction_lvx_v1_fixedd = 517,
  Instruction_lvx_v1_fixeddw = 518,
  Instruction_lvx_v1_fixedhq = 519,
  Instruction_lvx_v1_fixedud = 520,
  Instruction_lvx_v1_fixedudw = 521,
  Instruction_lvx_v1_fixeduhq = 522,
  Instruction_lvx_v1_fixeduw = 523,
  Instruction_lvx_v1_fixeduwd = 524,
  Instruction_lvx_v1_fixeduwp = 525,
  Instruction_lvx_v1_fixedw = 526,
  Instruction_lvx_v1_fixedwd = 527,
  Instruction_lvx_v1_fixedwp = 528,
  Instruction_lvx_v1_fld = 529,
  Instruction_lvx_v1_fle_d = 530,
  Instruction_lvx_v1_fle_s = 531,
  Instruction_lvx_v1_floatd = 532,
  Instruction_lvx_v1_floatdw = 533,
  Instruction_lvx_v1_floathq = 534,
  Instruction_lvx_v1_floatud = 535,
  Instruction_lvx_v1_floatudw = 536,
  Instruction_lvx_v1_floatuhq = 537,
  Instruction_lvx_v1_floatuw = 538,
  Instruction_lvx_v1_floatuwd = 539,
  Instruction_lvx_v1_floatuwp = 540,
  Instruction_lvx_v1_floatw = 541,
  Instruction_lvx_v1_floatwd = 542,
  Instruction_lvx_v1_floatwp = 543,
  Instruction_lvx_v1_flt_d = 544,
  Instruction_lvx_v1_flt_s = 545,
  Instruction_lvx_v1_flw = 546,
  Instruction_lvx_v1_fmadd_d = 547,
  Instruction_lvx_v1_fmadd_s = 548,
  Instruction_lvx_v1_fmax_d = 549,
  Instruction_lvx_v1_fmax_s = 550,
  Instruction_lvx_v1_fmaxd = 551,
  Instruction_lvx_v1_fmaxh = 552,
  Instruction_lvx_v1_fmaxhq = 553,
  Instruction_lvx_v1_fmaxnd = 554,
  Instruction_lvx_v1_fmaxnh = 555,
  Instruction_lvx_v1_fmaxnhq = 556,
  Instruction_lvx_v1_fmaxnw = 557,
  Instruction_lvx_v1_fmaxnwp = 558,
  Instruction_lvx_v1_fmaxw = 559,
  Instruction_lvx_v1_fmaxwp = 560,
  Instruction_lvx_v1_fmin_d = 561,
  Instruction_lvx_v1_fmin_s = 562,
  Instruction_lvx_v1_fmind = 563,
  Instruction_lvx_v1_fminh = 564,
  Instruction_lvx_v1_fminhq = 565,
  Instruction_lvx_v1_fminnd = 566,
  Instruction_lvx_v1_fminnh = 567,
  Instruction_lvx_v1_fminnhq = 568,
  Instruction_lvx_v1_fminnw = 569,
  Instruction_lvx_v1_fminnwp = 570,
  Instruction_lvx_v1_fminw = 571,
  Instruction_lvx_v1_fminwp = 572,
  Instruction_lvx_v1_fmsub_d = 573,
  Instruction_lvx_v1_fmsub_s = 574,
  Instruction_lvx_v1_fmul_d = 575,
  Instruction_lvx_v1_fmul_s = 576,
  Instruction_lvx_v1_fmuld = 577,
  Instruction_lvx_v1_fmulh = 578,
  Instruction_lvx_v1_fmulhq = 579,
  Instruction_lvx_v1_fmulw = 580,
  Instruction_lvx_v1_fmulwc = 581,
  Instruction_lvx_v1_fmulwp = 582,
  Instruction_lvx_v1_fmv_d_x = 583,
  Instruction_lvx_v1_fmv_w_x = 584,
  Instruction_lvx_v1_fmv_x_d = 585,
  Instruction_lvx_v1_fmv_x_w = 586,
  Instruction_lvx_v1_fnarrowdw = 587,
  Instruction_lvx_v1_fnarrowdwp = 588,
  Instruction_lvx_v1_fnarrowwh = 589,
  Instruction_lvx_v1_fnarrowwhq = 590,
  Instruction_lvx_v1_fnegd = 591,
  Instruction_lvx_v1_fnegh = 592,
  Instruction_lvx_v1_fneghq = 593,
  Instruction_lvx_v1_fnegw = 594,
  Instruction_lvx_v1_fnegwp = 595,
  Instruction_lvx_v1_fnmadd_d = 596,
  Instruction_lvx_v1_fnmadd_s = 597,
  Instruction_lvx_v1_fnmsub_d = 598,
  Instruction_lvx_v1_fnmsub_s = 599,
  Instruction_lvx_v1_fractdwp = 600,
  Instruction_lvx_v1_fracthbo = 601,
  Instruction_lvx_v1_fractwhq = 602,
  Instruction_lvx_v1_frintd = 603,
  Instruction_lvx_v1_frinth = 604,
  Instruction_lvx_v1_frintw = 605,
  Instruction_lvx_v1_fsbfd = 606,
  Instruction_lvx_v1_fsbfh = 607,
  Instruction_lvx_v1_fsbfhq = 608,
  Instruction_lvx_v1_fsbfw = 609,
  Instruction_lvx_v1_fsbfwc = 610,
  Instruction_lvx_v1_fsbfwp = 611,
  Instruction_lvx_v1_fsd = 612,
  Instruction_lvx_v1_fsgnj_d = 613,
  Instruction_lvx_v1_fsgnj_s = 614,
  Instruction_lvx_v1_fsgnjn_d = 615,
  Instruction_lvx_v1_fsgnjn_s = 616,
  Instruction_lvx_v1_fsgnjx_d = 617,
  Instruction_lvx_v1_fsgnjx_s = 618,
  Instruction_lvx_v1_fsignd = 619,
  Instruction_lvx_v1_fsignh = 620,
  Instruction_lvx_v1_fsignhq = 621,
  Instruction_lvx_v1_fsignmd = 622,
  Instruction_lvx_v1_fsignmh = 623,
  Instruction_lvx_v1_fsignmhq = 624,
  Instruction_lvx_v1_fsignmw = 625,
  Instruction_lvx_v1_fsignmwp = 626,
  Instruction_lvx_v1_fsignnd = 627,
  Instruction_lvx_v1_fsignnh = 628,
  Instruction_lvx_v1_fsignnhq = 629,
  Instruction_lvx_v1_fsignnw = 630,
  Instruction_lvx_v1_fsignnwp = 631,
  Instruction_lvx_v1_fsignw = 632,
  Instruction_lvx_v1_fsignwp = 633,
  Instruction_lvx_v1_fsqrt_d = 634,
  Instruction_lvx_v1_fsqrt_s = 635,
  Instruction_lvx_v1_fsqrtd = 636,
  Instruction_lvx_v1_fsqrth = 637,
  Instruction_lvx_v1_fsqrtw = 638,
  Instruction_lvx_v1_fsrecd = 639,
  Instruction_lvx_v1_fsrecw = 640,
  Instruction_lvx_v1_fsrecwp = 641,
  Instruction_lvx_v1_fsrsrd = 642,
  Instruction_lvx_v1_fsrsrw = 643,
  Instruction_lvx_v1_fsrsrwp = 644,
  Instruction_lvx_v1_fsub_d = 645,
  Instruction_lvx_v1_fsub_s = 646,
  Instruction_lvx_v1_fsw = 647,
  Instruction_lvx_v1_fwidenhw = 648,
  Instruction_lvx_v1_fwidenhwq = 649,
  Instruction_lvx_v1_fwidenwd = 650,
  Instruction_lvx_v1_get = 651,
  Instruction_lvx_v1_goto = 652,
  Instruction_lvx_v1_gotox = 653,
  Instruction_lvx_v1_guard = 654,
  Instruction_lvx_v1_i1inval = 655,
  Instruction_lvx_v1_i1invals = 656,
  Instruction_lvx_v1_icall = 657,
  Instruction_lvx_v1_iget = 658,
  Instruction_lvx_v1_igoto = 659,
  Instruction_lvx_v1_insf = 660,
  Instruction_lvx_v1_iord = 661,
  Instruction_lvx_v1_iornd = 662,
  Instruction_lvx_v1_iornq = 663,
  Instruction_lvx_v1_iornw = 664,
  Instruction_lvx_v1_iorq = 665,
  Instruction_lvx_v1_iorw = 666,
  Instruction_lvx_v1_j = 667,
  Instruction_lvx_v1_jal = 668,
  Instruction_lvx_v1_jalr = 669,
  Instruction_lvx_v1_jr = 670,
  Instruction_lvx_v1_kv_lq = 671,
  Instruction_lvx_v1_kv_sq = 672,
  Instruction_lvx_v1_landd = 673,
  Instruction_lvx_v1_landw = 674,
  Instruction_lvx_v1_lb = 675,
  Instruction_lvx_v1_lbs = 676,
  Instruction_lvx_v1_lbu = 677,
  Instruction_lvx_v1_lbz = 678,
  Instruction_lvx_v1_ld = 679,
  Instruction_lvx_v1_lh = 680,
  Instruction_lvx_v1_lhs = 681,
  Instruction_lvx_v1_lhu = 682,
  Instruction_lvx_v1_lhz = 683,
  Instruction_lvx_v1_li = 684,
  Instruction_lvx_v1_liord = 685,
  Instruction_lvx_v1_liorw = 686,
  Instruction_lvx_v1_lnandd = 687,
  Instruction_lvx_v1_lnandw = 688,
  Instruction_lvx_v1_lniord = 689,
  Instruction_lvx_v1_lniorw = 690,
  Instruction_lvx_v1_lo = 691,
  Instruction_lvx_v1_loopdo = 692,
  Instruction_lvx_v1_lq = 693,
  Instruction_lvx_v1_lr_d = 694,
  Instruction_lvx_v1_lr_w = 695,
  Instruction_lvx_v1_lui = 696,
  Instruction_lvx_v1_lw = 697,
  Instruction_lvx_v1_lws = 698,
  Instruction_lvx_v1_lwu = 699,
  Instruction_lvx_v1_lwz = 700,
  Instruction_lvx_v1_maddbho = 701,
  Instruction_lvx_v1_maddd = 702,
  Instruction_lvx_v1_madddq = 703,
  Instruction_lvx_v1_madddt = 704,
  Instruction_lvx_v1_maddhq = 705,
  Instruction_lvx_v1_maddhwq = 706,
  Instruction_lvx_v1_maddsudt = 707,
  Instruction_lvx_v1_maddsuwd = 708,
  Instruction_lvx_v1_maddudt = 709,
  Instruction_lvx_v1_madduwd = 710,
  Instruction_lvx_v1_maddw = 711,
  Instruction_lvx_v1_maddwd = 712,
  Instruction_lvx_v1_maddwdp = 713,
  Instruction_lvx_v1_maddwp = 714,
  Instruction_lvx_v1_maddxbho = 715,
  Instruction_lvx_v1_maddxhwq = 716,
  Instruction_lvx_v1_maddxwdp = 717,
  Instruction_lvx_v1_make = 718,
  Instruction_lvx_v1_max = 719,
  Instruction_lvx_v1_maxbo = 720,
  Instruction_lvx_v1_maxd = 721,
  Instruction_lvx_v1_maxhq = 722,
  Instruction_lvx_v1_maxu = 723,
  Instruction_lvx_v1_maxubo = 724,
  Instruction_lvx_v1_maxud = 725,
  Instruction_lvx_v1_maxuhq = 726,
  Instruction_lvx_v1_maxuw = 727,
  Instruction_lvx_v1_maxuwp = 728,
  Instruction_lvx_v1_maxw = 729,
  Instruction_lvx_v1_maxwp = 730,
  Instruction_lvx_v1_min = 731,
  Instruction_lvx_v1_minbo = 732,
  Instruction_lvx_v1_mind = 733,
  Instruction_lvx_v1_minhq = 734,
  Instruction_lvx_v1_minu = 735,
  Instruction_lvx_v1_minubo = 736,
  Instruction_lvx_v1_minud = 737,
  Instruction_lvx_v1_minuhq = 738,
  Instruction_lvx_v1_minuw = 739,
  Instruction_lvx_v1_minuwp = 740,
  Instruction_lvx_v1_minw = 741,
  Instruction_lvx_v1_minwp = 742,
  Instruction_lvx_v1_msbfbho = 743,
  Instruction_lvx_v1_msbfd = 744,
  Instruction_lvx_v1_msbfdq = 745,
  Instruction_lvx_v1_msbfdt = 746,
  Instruction_lvx_v1_msbfhq = 747,
  Instruction_lvx_v1_msbfhwq = 748,
  Instruction_lvx_v1_msbfsudt = 749,
  Instruction_lvx_v1_msbfsuwd = 750,
  Instruction_lvx_v1_msbfudt = 751,
  Instruction_lvx_v1_msbfuwd = 752,
  Instruction_lvx_v1_msbfw = 753,
  Instruction_lvx_v1_msbfwd = 754,
  Instruction_lvx_v1_msbfwdp = 755,
  Instruction_lvx_v1_msbfwp = 756,
  Instruction_lvx_v1_msbfxbho = 757,
  Instruction_lvx_v1_msbfxhwq = 758,
  Instruction_lvx_v1_msbfxwdp = 759,
  Instruction_lvx_v1_mul = 760,
  Instruction_lvx_v1_mulbho = 761,
  Instruction_lvx_v1_muld = 762,
  Instruction_lvx_v1_muldq = 763,
  Instruction_lvx_v1_muldt = 764,
  Instruction_lvx_v1_mulh = 765,
  Instruction_lvx_v1_mulhq = 766,
  Instruction_lvx_v1_mulhsu = 767,
  Instruction_lvx_v1_mulhu = 768,
  Instruction_lvx_v1_mulhwq = 769,
  Instruction_lvx_v1_mulnbho = 770,
  Instruction_lvx_v1_mulnd = 771,
  Instruction_lvx_v1_mulndq = 772,
  Instruction_lvx_v1_mulnhq = 773,
  Instruction_lvx_v1_mulnhwq = 774,
  Instruction_lvx_v1_mulnw = 775,
  Instruction_lvx_v1_mulnwd = 776,
  Instruction_lvx_v1_mulnwdp = 777,
  Instruction_lvx_v1_mulnwp = 778,
  Instruction_lvx_v1_mulnxbho = 779,
  Instruction_lvx_v1_mulnxhwq = 780,
  Instruction_lvx_v1_mulnxwdp = 781,
  Instruction_lvx_v1_mulsudt = 782,
  Instruction_lvx_v1_mulsuwd = 783,
  Instruction_lvx_v1_muludt = 784,
  Instruction_lvx_v1_muluwd = 785,
  Instruction_lvx_v1_mulw = 786,
  Instruction_lvx_v1_mulwd = 787,
  Instruction_lvx_v1_mulwdp = 788,
  Instruction_lvx_v1_mulwp = 789,
  Instruction_lvx_v1_mulxbho = 790,
  Instruction_lvx_v1_mulxhwq = 791,
  Instruction_lvx_v1_mulxwdp = 792,
  Instruction_lvx_v1_mv = 793,
  Instruction_lvx_v1_nandd = 794,
  Instruction_lvx_v1_nandq = 795,
  Instruction_lvx_v1_nandw = 796,
  Instruction_lvx_v1_neg = 797,
  Instruction_lvx_v1_negbo = 798,
  Instruction_lvx_v1_negd = 799,
  Instruction_lvx_v1_neghq = 800,
  Instruction_lvx_v1_negq = 801,
  Instruction_lvx_v1_negsbo = 802,
  Instruction_lvx_v1_negsd = 803,
  Instruction_lvx_v1_negshq = 804,
  Instruction_lvx_v1_negsw = 805,
  Instruction_lvx_v1_negswp = 806,
  Instruction_lvx_v1_negw = 807,
  Instruction_lvx_v1_negwp = 808,
  Instruction_lvx_v1_neord = 809,
  Instruction_lvx_v1_neorq = 810,
  Instruction_lvx_v1_neorw = 811,
  Instruction_lvx_v1_niord = 812,
  Instruction_lvx_v1_niorq = 813,
  Instruction_lvx_v1_niorw = 814,
  Instruction_lvx_v1_nop = 815,
  Instruction_lvx_v1_not = 816,
  Instruction_lvx_v1_notd = 817,
  Instruction_lvx_v1_notq = 818,
  Instruction_lvx_v1_notw = 819,
  Instruction_lvx_v1_or = 820,
  Instruction_lvx_v1_orc_b = 821,
  Instruction_lvx_v1_ori = 822,
  Instruction_lvx_v1_orn = 823,
  Instruction_lvx_v1_pcrel = 824,
  Instruction_lvx_v1_prefetch_i = 825,
  Instruction_lvx_v1_prefetch_r = 826,
  Instruction_lvx_v1_prefetch_w = 827,
  Instruction_lvx_v1_rem = 828,
  Instruction_lvx_v1_remu = 829,
  Instruction_lvx_v1_remuw = 830,
  Instruction_lvx_v1_remw = 831,
  Instruction_lvx_v1_ret = 832,
  Instruction_lvx_v1_rev8 = 833,
  Instruction_lvx_v1_rfe = 834,
  Instruction_lvx_v1_rol = 835,
  Instruction_lvx_v1_rold = 836,
  Instruction_lvx_v1_rolw = 837,
  Instruction_lvx_v1_rolwp = 838,
  Instruction_lvx_v1_ror = 839,
  Instruction_lvx_v1_rord = 840,
  Instruction_lvx_v1_rori = 841,
  Instruction_lvx_v1_roriw = 842,
  Instruction_lvx_v1_rorw = 843,
  Instruction_lvx_v1_rorwp = 844,
  Instruction_lvx_v1_rswap = 845,
  Instruction_lvx_v1_sb = 846,
  Instruction_lvx_v1_sbfbo = 847,
  Instruction_lvx_v1_sbfd = 848,
  Instruction_lvx_v1_sbfhq = 849,
  Instruction_lvx_v1_sbfq = 850,
  Instruction_lvx_v1_sbfsbo = 851,
  Instruction_lvx_v1_sbfsd = 852,
  Instruction_lvx_v1_sbfshq = 853,
  Instruction_lvx_v1_sbfsw = 854,
  Instruction_lvx_v1_sbfswp = 855,
  Instruction_lvx_v1_sbfusbo = 856,
  Instruction_lvx_v1_sbfusd = 857,
  Instruction_lvx_v1_sbfushq = 858,
  Instruction_lvx_v1_sbfusw = 859,
  Instruction_lvx_v1_sbfuswp = 860,
  Instruction_lvx_v1_sbfw = 861,
  Instruction_lvx_v1_sbfwp = 862,
  Instruction_lvx_v1_sbmm8 = 863,
  Instruction_lvx_v1_sbmm8d = 864,
  Instruction_lvx_v1_sbmm8eord = 865,
  Instruction_lvx_v1_sbmmt8 = 866,
  Instruction_lvx_v1_sbmmt8d = 867,
  Instruction_lvx_v1_sbmmt8eord = 868,
  Instruction_lvx_v1_sc_d = 869,
  Instruction_lvx_v1_sc_w = 870,
  Instruction_lvx_v1_scall = 871,
  Instruction_lvx_v1_sd = 872,
  Instruction_lvx_v1_seqz = 873,
  Instruction_lvx_v1_set = 874,
  Instruction_lvx_v1_sext_b = 875,
  Instruction_lvx_v1_sext_h = 876,
  Instruction_lvx_v1_sext_w = 877,
  Instruction_lvx_v1_sgtz = 878,
  Instruction_lvx_v1_sh = 879,
  Instruction_lvx_v1_sh1add = 880,
  Instruction_lvx_v1_sh1add_uw = 881,
  Instruction_lvx_v1_sh2add = 882,
  Instruction_lvx_v1_sh2add_uw = 883,
  Instruction_lvx_v1_sh3add = 884,
  Instruction_lvx_v1_sh3add_uw = 885,
  Instruction_lvx_v1_signbo = 886,
  Instruction_lvx_v1_signd = 887,
  Instruction_lvx_v1_signhq = 888,
  Instruction_lvx_v1_signsbo = 889,
  Instruction_lvx_v1_signsd = 890,
  Instruction_lvx_v1_signshq = 891,
  Instruction_lvx_v1_signsw = 892,
  Instruction_lvx_v1_signswp = 893,
  Instruction_lvx_v1_signw = 894,
  Instruction_lvx_v1_signwp = 895,
  Instruction_lvx_v1_sleep = 896,
  Instruction_lvx_v1_sll = 897,
  Instruction_lvx_v1_sllbo = 898,
  Instruction_lvx_v1_slld = 899,
  Instruction_lvx_v1_sllhq = 900,
  Instruction_lvx_v1_slli = 901,
  Instruction_lvx_v1_slli_uw = 902,
  Instruction_lvx_v1_slliw = 903,
  Instruction_lvx_v1_sllw = 904,
  Instruction_lvx_v1_sllwp = 905,
  Instruction_lvx_v1_slsbo = 906,
  Instruction_lvx_v1_slsd = 907,
  Instruction_lvx_v1_slshq = 908,
  Instruction_lvx_v1_slsw = 909,
  Instruction_lvx_v1_slswp = 910,
  Instruction_lvx_v1_slt = 911,
  Instruction_lvx_v1_slti = 912,
  Instruction_lvx_v1_sltiu = 913,
  Instruction_lvx_v1_sltu = 914,
  Instruction_lvx_v1_sltz = 915,
  Instruction_lvx_v1_slusbo = 916,
  Instruction_lvx_v1_slusd = 917,
  Instruction_lvx_v1_slushq = 918,
  Instruction_lvx_v1_slusw = 919,
  Instruction_lvx_v1_sluswp = 920,
  Instruction_lvx_v1_snez = 921,
  Instruction_lvx_v1_so = 922,
  Instruction_lvx_v1_sq = 923,
  Instruction_lvx_v1_sra = 924,
  Instruction_lvx_v1_srabo = 925,
  Instruction_lvx_v1_srad = 926,
  Instruction_lvx_v1_srahq = 927,
  Instruction_lvx_v1_srai = 928,
  Instruction_lvx_v1_sraiw = 929,
  Instruction_lvx_v1_sraw = 930,
  Instruction_lvx_v1_srawp = 931,
  Instruction_lvx_v1_srl = 932,
  Instruction_lvx_v1_srlbo = 933,
  Instruction_lvx_v1_srld = 934,
  Instruction_lvx_v1_srlhq = 935,
  Instruction_lvx_v1_srli = 936,
  Instruction_lvx_v1_srliw = 937,
  Instruction_lvx_v1_srlw = 938,
  Instruction_lvx_v1_srlwp = 939,
  Instruction_lvx_v1_srsbo = 940,
  Instruction_lvx_v1_srsd = 941,
  Instruction_lvx_v1_srshq = 942,
  Instruction_lvx_v1_srsw = 943,
  Instruction_lvx_v1_srswp = 944,
  Instruction_lvx_v1_stop = 945,
  Instruction_lvx_v1_stsud = 946,
  Instruction_lvx_v1_stsuhq = 947,
  Instruction_lvx_v1_stsuw = 948,
  Instruction_lvx_v1_stsuwp = 949,
  Instruction_lvx_v1_sub = 950,
  Instruction_lvx_v1_subw = 951,
  Instruction_lvx_v1_sw = 952,
  Instruction_lvx_v1_sxbd = 953,
  Instruction_lvx_v1_sxhd = 954,
  Instruction_lvx_v1_sxwd = 955,
  Instruction_lvx_v1_syncgroup = 956,
  Instruction_lvx_v1_tlbdinval = 957,
  Instruction_lvx_v1_tlbiinval = 958,
  Instruction_lvx_v1_tlbprobe = 959,
  Instruction_lvx_v1_tlbread = 960,
  Instruction_lvx_v1_tlbwrite = 961,
  Instruction_lvx_v1_truncdwp = 962,
  Instruction_lvx_v1_trunchbo = 963,
  Instruction_lvx_v1_truncwhq = 964,
  Instruction_lvx_v1_waitit = 965,
  Instruction_lvx_v1_wfxl = 966,
  Instruction_lvx_v1_wfxm = 967,
  Instruction_lvx_v1_widenqbho = 968,
  Instruction_lvx_v1_widenqhwq = 969,
  Instruction_lvx_v1_widenqwdp = 970,
  Instruction_lvx_v1_widensbho = 971,
  Instruction_lvx_v1_widenshwq = 972,
  Instruction_lvx_v1_widenswdp = 973,
  Instruction_lvx_v1_widenzbho = 974,
  Instruction_lvx_v1_widenzhwq = 975,
  Instruction_lvx_v1_widenzwdp = 976,
  Instruction_lvx_v1_xaccesso = 977,
  Instruction_lvx_v1_xaligno = 978,
  Instruction_lvx_v1_xcopyo = 979,
  Instruction_lvx_v1_xlo = 980,
  Instruction_lvx_v1_xmovefd = 981,
  Instruction_lvx_v1_xmovefo = 982,
  Instruction_lvx_v1_xmovefq = 983,
  Instruction_lvx_v1_xmovetd = 984,
  Instruction_lvx_v1_xmoveto = 985,
  Instruction_lvx_v1_xmovetq = 986,
  Instruction_lvx_v1_xnor = 987,
  Instruction_lvx_v1_xor = 988,
  Instruction_lvx_v1_xori = 989,
  Instruction_lvx_v1_xplb = 990,
  Instruction_lvx_v1_xpld = 991,
  Instruction_lvx_v1_xplh = 992,
  Instruction_lvx_v1_xplo = 993,
  Instruction_lvx_v1_xplq = 994,
  Instruction_lvx_v1_xplw = 995,
  Instruction_lvx_v1_xso = 996,
  Instruction_lvx_v1_zext_h = 997,
  Instruction_lvx_v1_zxbd = 998,
  Instruction_lvx_v1_zxhd = 999,
  Instruction_lvx_v1_zxwd = 1000,
  Separator_lvx_v1_comma = 1001,
  Separator_lvx_v1_equal = 1002,
  Separator_lvx_v1_qmark = 1003,
  Separator_lvx_v1_rsbracket = 1004,
  Separator_lvx_v1_lsbracket = 1005
};

typedef enum {
  Modifier_lvx_v1_exunum_ALU0=0,
  Modifier_lvx_v1_exunum_ALU1=1,
  Modifier_lvx_v1_exunum_LSU0=2,
  Modifier_lvx_v1_exunum_LSU1=3,
} Modifier_lvx_v1_exunum_values;


extern const char *mod_lvx_v1_exunum[];
extern const char *mod_lvx_v1_ccbcomp[];
extern const char *mod_lvx_v1_bcucond[];
extern const char *mod_lvx_v1_intcomp[];
extern const char *mod_lvx_v1_lanecond[];
extern const char *mod_lvx_v1_lanetodo[];
extern const char *mod_lvx_v1_lanesize[];
extern const char *mod_lvx_v1_floatcomp[];
extern const char *mod_lvx_v1_floatmode[];
extern const char *mod_lvx_v1_signextw[];
extern const char *mod_lvx_v1_highmult[];
extern const char *mod_lvx_v1_widemult[];
extern const char *mod_lvx_v1_mostsig[];
extern const char *mod_lvx_v1_oddlanes[];
extern const char *mod_lvx_v1_ziplanes[];
extern const char *mod_lvx_v1_fnegate[];
extern const char *mod_lvx_v1_variant[];
extern const char *mod_lvx_v1_speculate[];
extern const char *mod_lvx_v1_doscale[];
extern const char *mod_lvx_v1_qindex[];
extern const char *mod_lvx_v1_hindex[];
extern const char *mod_lvx_v1_cachelev[];
extern const char *mod_lvx_v1_coherency[];
extern const char *mod_lvx_v1_boolcas[];
extern const char *mod_lvx_v1_accesses[];
extern const char *mod_lvx_v1_channel[];
extern const char *mod_lvx_v1_conjugate[];
extern const char *mod_lvx_v1_imultiply[];
extern const char *mod_lvx_v1_realimag[];
extern const char *mod_lvx_v1_shuffleV[];
extern const char *mod_lvx_v1_shuffleX[];
extern const char *mod_lvx_v1_splat32[];
extern const char *mod_lvx_v1_ordering[];
extern const char *mod_lvx_v1_acqrel[];
extern const char *mod_lvx_v1_froundmode[];

typedef enum {
  Bundling_lvx_v1_ALL,
  Bundling_lvx_v1_BCU2,
  Bundling_lvx_v1_BCU2_X,
  Bundling_lvx_v1_BCU0,
  Bundling_lvx_v1_BCU,
  Bundling_lvx_v1_FULL,
  Bundling_lvx_v1_FULL_X,
  Bundling_lvx_v1_FULL_Y,
  Bundling_lvx_v1_LITE,
  Bundling_lvx_v1_LITE_X,
  Bundling_lvx_v1_LITE_Y,
  Bundling_lvx_v1_LSU0,
  Bundling_lvx_v1_LSU0_X,
  Bundling_lvx_v1_LSU0_Y,
  Bundling_lvx_v1_LSU,
  Bundling_lvx_v1_LSU_X,
  Bundling_lvx_v1_LSU_Y,
  Bundling_lvx_v1_TINY,
  Bundling_lvx_v1_TINY_X,
  Bundling_lvx_v1_TINY_Y,
  Bundling_lvx_v1_EXT,
  Bundling_lvx_v1_NOP,
} Bundling_lvx_v1;

static int ATTRIBUTE_UNUSED
lvx_v1_base_bundling(int bundling) {
  static int base_bundlings[] = {
    Bundling_lvx_v1_ALL,	// Bundling_lvx_v1_ALL
    Bundling_lvx_v1_BCU2,	// Bundling_lvx_v1_BCU2
    Bundling_lvx_v1_BCU2,	// Bundling_lvx_v1_BCU2_X
    Bundling_lvx_v1_BCU0,	// Bundling_lvx_v1_BCU0
    Bundling_lvx_v1_BCU,	// Bundling_lvx_v1_BCU
    Bundling_lvx_v1_FULL,	// Bundling_lvx_v1_FULL
    Bundling_lvx_v1_FULL,	// Bundling_lvx_v1_FULL_X
    Bundling_lvx_v1_FULL,	// Bundling_lvx_v1_FULL_Y
    Bundling_lvx_v1_LITE,	// Bundling_lvx_v1_LITE
    Bundling_lvx_v1_LITE,	// Bundling_lvx_v1_LITE_X
    Bundling_lvx_v1_LITE,	// Bundling_lvx_v1_LITE_Y
    Bundling_lvx_v1_LSU0,	// Bundling_lvx_v1_LSU0
    Bundling_lvx_v1_LSU0,	// Bundling_lvx_v1_LSU0_X
    Bundling_lvx_v1_LSU0,	// Bundling_lvx_v1_LSU0_Y
    Bundling_lvx_v1_LSU,	// Bundling_lvx_v1_LSU
    Bundling_lvx_v1_LSU,	// Bundling_lvx_v1_LSU_X
    Bundling_lvx_v1_LSU,	// Bundling_lvx_v1_LSU_Y
    Bundling_lvx_v1_TINY,	// Bundling_lvx_v1_TINY
    Bundling_lvx_v1_TINY,	// Bundling_lvx_v1_TINY_X
    Bundling_lvx_v1_TINY,	// Bundling_lvx_v1_TINY_Y
    Bundling_lvx_v1_EXT,	// Bundling_lvx_v1_EXT
    Bundling_lvx_v1_NOP,	// Bundling_lvx_v1_NOP
  };
  return base_bundlings[bundling];
};

typedef enum {
  Resource_lvx_v1_ISSUE,
  Resource_lvx_v1_TINY,
  Resource_lvx_v1_LITE,
  Resource_lvx_v1_FULL,
  Resource_lvx_v1_LSU,
  Resource_lvx_v1_MAU,
  Resource_lvx_v1_BCU,
  Resource_lvx_v1_EXT,
  Resource_lvx_v1_AUXR,
  Resource_lvx_v1_AUXW,
  Resource_lvx_v1_XFER,
  Resource_lvx_v1_MEMW,
  Resource_lvx_v1_SR12,
  Resource_lvx_v1_SR13,
  Resource_lvx_v1_SR14,
  Resource_lvx_v1_SR15,
} Resource_lvx_v1;
#define lvx_v1_RESOURCE_COUNT 16

typedef enum {
  Reservation_lvx_v1_ALL,
  Reservation_lvx_v1_ALU_TINY,
  Reservation_lvx_v1_ALU_TINY_X,
  Reservation_lvx_v1_ALU_TINY_Y,
  Reservation_lvx_v1_ALU_TINY_AUXR,
  Reservation_lvx_v1_ALU_LITE,
  Reservation_lvx_v1_ALU_LITE_X,
  Reservation_lvx_v1_ALU_LITE_Y,
  Reservation_lvx_v1_ALU_LITE_MISC,
  Reservation_lvx_v1_ALU_FULL,
  Reservation_lvx_v1_ALU_FULL_X,
  Reservation_lvx_v1_ALU_FULL_Y,
  Reservation_lvx_v1_BCU,
  Reservation_lvx_v1_BCU_BRRP,
  Reservation_lvx_v1_BCU_BRRP2,
  Reservation_lvx_v1_BCU2,
  Reservation_lvx_v1_BCU2_X,
  Reservation_lvx_v1_BCU_XFER,
  Reservation_lvx_v1_BCU_XFER_BRRP,
  Reservation_lvx_v1_BCU2_TINY_LSU,
  Reservation_lvx_v1_LSU,
  Reservation_lvx_v1_LSU_X,
  Reservation_lvx_v1_LSU_Y,
  Reservation_lvx_v1_LSU_MEMW_ACCR,
  Reservation_lvx_v1_LSU_MEMW_ACCR_X,
  Reservation_lvx_v1_LSU_MEMW_ACCR_Y,
  Reservation_lvx_v1_LSU2_MEMW,
  Reservation_lvx_v1_LSU2_MEMW_X,
  Reservation_lvx_v1_LSU2_MEMW_Y,
  Reservation_lvx_v1_LSU_AUXR,
  Reservation_lvx_v1_LSU_AUXR_X,
  Reservation_lvx_v1_LSU_AUXR_Y,
  Reservation_lvx_v1_LSU_MEMW_AUXR,
  Reservation_lvx_v1_LSU_MEMW_AUXR_X,
  Reservation_lvx_v1_LSU_MEMW_AUXR_Y,
  Reservation_lvx_v1_LSU2_MEMW_AUXR,
  Reservation_lvx_v1_LSU2_MEMW_AUXR_X,
  Reservation_lvx_v1_LSU2_MEMW_AUXR_Y,
  Reservation_lvx_v1_LSU_MEMW_AUXW,
  Reservation_lvx_v1_LSU_MEMW_AUXW_X,
  Reservation_lvx_v1_LSU_MEMW_AUXW_Y,
  Reservation_lvx_v1_LSU2_MEMW_AUXW,
  Reservation_lvx_v1_LSU2_MEMW_AUXW_X,
  Reservation_lvx_v1_LSU2_MEMW_AUXW_Y,
  Reservation_lvx_v1_LSU_AUXW,
  Reservation_lvx_v1_LSU_AUXW_X,
  Reservation_lvx_v1_LSU_AUXW_Y,
  Reservation_lvx_v1_LSU_AUXR_AUXW,
  Reservation_lvx_v1_LSU_AUXR_AUXW_X,
  Reservation_lvx_v1_LSU_AUXR_AUXW_Y,
  Reservation_lvx_v1_LSU2_MEMW_AUXR_AUXW,
  Reservation_lvx_v1_LSU2_MEMW_AUXR_AUXW_X,
  Reservation_lvx_v1_LSU2_MEMW_AUXR_AUXW_Y,
  Reservation_lvx_v1_MAU,
  Reservation_lvx_v1_EXT,
  Reservation_lvx_v1_EXT_COMP,
  Reservation_lvx_v1_EXT_MISC,
  Reservation_lvx_v1_EXT_MISC_AUXW,
} Reservation_lvx_v1;

extern struct lvx_reloc lvx_v1_rel16_reloc;
extern struct lvx_reloc lvx_v1_rel32_reloc;
extern struct lvx_reloc lvx_v1_rel64_reloc;
extern struct lvx_reloc lvx_v1_pcrel_signed16_reloc;
extern struct lvx_reloc lvx_v1_pcrel32_reloc;
extern struct lvx_reloc lvx_v1_pcrel_signed37_reloc;
extern struct lvx_reloc lvx_v1_pcrel_signed43_reloc;
extern struct lvx_reloc lvx_v1_pcrel_signed64_reloc;
extern struct lvx_reloc lvx_v1_pcrel64_reloc;
extern struct lvx_reloc lvx_v1_signed16_reloc;
extern struct lvx_reloc lvx_v1_signed32_reloc;
extern struct lvx_reloc lvx_v1_signed37_reloc;
extern struct lvx_reloc lvx_v1_gotoff_signed37_reloc;
extern struct lvx_reloc lvx_v1_gotoff_signed43_reloc;
extern struct lvx_reloc lvx_v1_gotoff_32_reloc;
extern struct lvx_reloc lvx_v1_gotoff_64_reloc;
extern struct lvx_reloc lvx_v1_got_32_reloc;
extern struct lvx_reloc lvx_v1_got_signed37_reloc;
extern struct lvx_reloc lvx_v1_got_signed43_reloc;
extern struct lvx_reloc lvx_v1_got_64_reloc;
extern struct lvx_reloc lvx_v1_glob_dat_reloc;
extern struct lvx_reloc lvx_v1_copy_reloc;
extern struct lvx_reloc lvx_v1_jump_slot_reloc;
extern struct lvx_reloc lvx_v1_relative_reloc;
extern struct lvx_reloc lvx_v1_signed43_reloc;
extern struct lvx_reloc lvx_v1_signed64_reloc;
extern struct lvx_reloc lvx_v1_gotaddr_signed37_reloc;
extern struct lvx_reloc lvx_v1_gotaddr_signed43_reloc;
extern struct lvx_reloc lvx_v1_gotaddr_signed64_reloc;
extern struct lvx_reloc lvx_v1_dtpmod64_reloc;
extern struct lvx_reloc lvx_v1_dtpoff64_reloc;
extern struct lvx_reloc lvx_v1_dtpoff_signed37_reloc;
extern struct lvx_reloc lvx_v1_dtpoff_signed43_reloc;
extern struct lvx_reloc lvx_v1_tlsgd_signed37_reloc;
extern struct lvx_reloc lvx_v1_tlsgd_signed43_reloc;
extern struct lvx_reloc lvx_v1_tlsld_signed37_reloc;
extern struct lvx_reloc lvx_v1_tlsld_signed43_reloc;
extern struct lvx_reloc lvx_v1_tpoff64_reloc;
extern struct lvx_reloc lvx_v1_tlsie_signed37_reloc;
extern struct lvx_reloc lvx_v1_tlsie_signed43_reloc;
extern struct lvx_reloc lvx_v1_tlsle_signed37_reloc;
extern struct lvx_reloc lvx_v1_tlsle_signed43_reloc;
extern struct lvx_reloc lvx_v1_rel8_reloc;
extern struct lvx_reloc lvx_v1_pcrel11s2_reloc;
extern struct lvx_reloc lvx_v1_pcrel17s2_reloc;
extern struct lvx_reloc lvx_v1_pcrel27s2_reloc;
extern struct lvx_reloc lvx_v1_pcrel38s2_reloc;
extern struct lvx_reloc lvx_v1_pcrel44s2_reloc;
extern struct lvx_reloc lvx_v1_pcrel54s2_reloc;


#endif /* OPCODE_LVX_H */
