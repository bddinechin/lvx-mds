/* LVX assembler/disassembler support.

   Copyright (C) 2009-2024 Free Software Foundation, Inc.
   Contributed by Liesme Tech.

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

#define LVX_NUMCORES 2
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
extern const int lvx_v2_reservation_table_cycles;
extern const int *lvx_v2_reservation_tables[];
extern const char *lvx_v2_resource_names[];

extern const int lvx_v2_resources[];
extern struct lvx_opc lvx_v2_optab[];
extern const struct lvx_core_info lvx_v2_core_info;
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
#define LVX_V1_REGFILE_FIRST_PGR 6
#define LVX_V1_REGFILE_LAST_PGR 7
#define LVX_V1_REGFILE_DEC_PGR 8
#define LVX_V1_REGFILE_FIRST_QGR 9
#define LVX_V1_REGFILE_LAST_QGR 10
#define LVX_V1_REGFILE_DEC_QGR 11
#define LVX_V1_REGFILE_FIRST_X16R 12
#define LVX_V1_REGFILE_LAST_X16R 13
#define LVX_V1_REGFILE_DEC_X16R 14
#define LVX_V1_REGFILE_FIRST_X2R 15
#define LVX_V1_REGFILE_LAST_X2R 16
#define LVX_V1_REGFILE_DEC_X2R 17
#define LVX_V1_REGFILE_FIRST_X32R 18
#define LVX_V1_REGFILE_LAST_X32R 19
#define LVX_V1_REGFILE_DEC_X32R 20
#define LVX_V1_REGFILE_FIRST_X4R 21
#define LVX_V1_REGFILE_LAST_X4R 22
#define LVX_V1_REGFILE_DEC_X4R 23
#define LVX_V1_REGFILE_FIRST_X64R 24
#define LVX_V1_REGFILE_LAST_X64R 25
#define LVX_V1_REGFILE_DEC_X64R 26
#define LVX_V1_REGFILE_FIRST_X8R 27
#define LVX_V1_REGFILE_LAST_X8R 28
#define LVX_V1_REGFILE_DEC_X8R 29
#define LVX_V1_REGFILE_FIRST_XBR 30
#define LVX_V1_REGFILE_LAST_XBR 31
#define LVX_V1_REGFILE_DEC_XBR 32
#define LVX_V1_REGFILE_FIRST_XCR 33
#define LVX_V1_REGFILE_LAST_XCR 34
#define LVX_V1_REGFILE_DEC_XCR 35
#define LVX_V1_REGFILE_FIRST_XMR 36
#define LVX_V1_REGFILE_LAST_XMR 37
#define LVX_V1_REGFILE_DEC_XMR 38
#define LVX_V1_REGFILE_FIRST_XTR 39
#define LVX_V1_REGFILE_LAST_XTR 40
#define LVX_V1_REGFILE_DEC_XTR 41
#define LVX_V1_REGFILE_FIRST_XVR 42
#define LVX_V1_REGFILE_LAST_XVR 43
#define LVX_V1_REGFILE_DEC_XVR 44
#define LVX_V1_REGFILE_REGISTERS 45
#define LVX_V1_REGFILE_DEC_REGISTERS 46


extern int lvx_v1_regfiles[];
extern const char **lvx_v1_modifiers[];
extern struct lvx_register lvx_v1_registers[];

extern int lvx_v1_dec_registers[];

enum Method_lvx_v1_enum {
  Immediate_lvx_v1_brknumber = 1,
  Immediate_lvx_v1_csrnumber = 2,
  Immediate_lvx_v1_pcrel11s2 = 3,
  Immediate_lvx_v1_pcrel17s2 = 4,
  Immediate_lvx_v1_pcrel27s2 = 5,
  Immediate_lvx_v1_pcrel38s2 = 6,
  Immediate_lvx_v1_pcrel44s2 = 7,
  Immediate_lvx_v1_pcrel54s2 = 8,
  Immediate_lvx_v1_signed10 = 9,
  Immediate_lvx_v1_signed16 = 10,
  Immediate_lvx_v1_signed27 = 11,
  Immediate_lvx_v1_signed37 = 12,
  Immediate_lvx_v1_signed43 = 13,
  Immediate_lvx_v1_signed54 = 14,
  Immediate_lvx_v1_sysnumber = 15,
  Immediate_lvx_v1_unsigned6 = 16,
  Immediate_lvx_v1_wrapped32 = 17,
  Immediate_lvx_v1_wrapped64 = 18,
  Immediate_lvx_v1_wrapped8 = 19,
  Modifier_lvx_v1_accesses = 20,
  Modifier_lvx_v1_bcucond = 21,
  Modifier_lvx_v1_boolcas = 22,
  Modifier_lvx_v1_cachelev = 23,
  Modifier_lvx_v1_ccbcomp = 24,
  Modifier_lvx_v1_channel = 25,
  Modifier_lvx_v1_coherency = 26,
  Modifier_lvx_v1_conjugate = 27,
  Modifier_lvx_v1_doscale = 28,
  Modifier_lvx_v1_exunum = 29,
  Modifier_lvx_v1_floatcomp = 30,
  Modifier_lvx_v1_floatmode = 31,
  Modifier_lvx_v1_fnegate = 32,
  Modifier_lvx_v1_highmult = 33,
  Modifier_lvx_v1_hindex = 34,
  Modifier_lvx_v1_imultiply = 35,
  Modifier_lvx_v1_intcomp = 36,
  Modifier_lvx_v1_lanecond = 37,
  Modifier_lvx_v1_lanesize = 38,
  Modifier_lvx_v1_lanetodo = 39,
  Modifier_lvx_v1_mostsig = 40,
  Modifier_lvx_v1_oddlanes = 41,
  Modifier_lvx_v1_qindex = 42,
  Modifier_lvx_v1_realimag = 43,
  Modifier_lvx_v1_shuffleV = 44,
  Modifier_lvx_v1_shuffleX = 45,
  Modifier_lvx_v1_signextw = 46,
  Modifier_lvx_v1_speculate = 47,
  Modifier_lvx_v1_splat32 = 48,
  Modifier_lvx_v1_variant = 49,
  Modifier_lvx_v1_widemult = 50,
  Modifier_lvx_v1_ziplanes = 51,
  RegClass_lvx_v1_aloneReg = 52,
  RegClass_lvx_v1_buffer16Reg = 53,
  RegClass_lvx_v1_buffer2Reg = 54,
  RegClass_lvx_v1_buffer32Reg = 55,
  RegClass_lvx_v1_buffer4Reg = 56,
  RegClass_lvx_v1_buffer64Reg = 57,
  RegClass_lvx_v1_buffer8Reg = 58,
  RegClass_lvx_v1_onlyfxReg = 59,
  RegClass_lvx_v1_onlygetReg = 60,
  RegClass_lvx_v1_onlyraReg = 61,
  RegClass_lvx_v1_onlysetReg = 62,
  RegClass_lvx_v1_onlyswapReg = 63,
  RegClass_lvx_v1_pairedReg = 64,
  RegClass_lvx_v1_quadReg = 65,
  RegClass_lvx_v1_singleReg = 66,
  RegClass_lvx_v1_systemReg = 67,
  RegClass_lvx_v1_worddRegE = 68,
  RegClass_lvx_v1_worddRegO = 69,
  RegClass_lvx_v1_xworddReg = 70,
  RegClass_lvx_v1_xworddReg0M4 = 71,
  RegClass_lvx_v1_xworddReg1M4 = 72,
  RegClass_lvx_v1_xworddReg2M4 = 73,
  RegClass_lvx_v1_xworddReg3M4 = 74,
  RegClass_lvx_v1_xwordoReg = 75,
  RegClass_lvx_v1_xwordqReg = 76,
  RegClass_lvx_v1_xwordqRegE = 77,
  RegClass_lvx_v1_xwordqRegO = 78,
  RegClass_lvx_v1_xwordvReg = 79,
  RegClass_lvx_v1_xwordxReg = 80,
  Instruction_lvx_v1_abdd = 81,
  Instruction_lvx_v1_abdsd = 82,
  Instruction_lvx_v1_abdsw = 83,
  Instruction_lvx_v1_abdud = 84,
  Instruction_lvx_v1_abduw = 85,
  Instruction_lvx_v1_abdw = 86,
  Instruction_lvx_v1_absd = 87,
  Instruction_lvx_v1_abssd = 88,
  Instruction_lvx_v1_abssw = 89,
  Instruction_lvx_v1_absw = 90,
  Instruction_lvx_v1_acswapb = 91,
  Instruction_lvx_v1_acswapd = 92,
  Instruction_lvx_v1_acswaph = 93,
  Instruction_lvx_v1_acswapq = 94,
  Instruction_lvx_v1_acswapw = 95,
  Instruction_lvx_v1_addd = 96,
  Instruction_lvx_v1_addq = 97,
  Instruction_lvx_v1_addsd = 98,
  Instruction_lvx_v1_addsw = 99,
  Instruction_lvx_v1_addusd = 100,
  Instruction_lvx_v1_addusw = 101,
  Instruction_lvx_v1_addw = 102,
  Instruction_lvx_v1_addx16d = 103,
  Instruction_lvx_v1_addx16w = 104,
  Instruction_lvx_v1_addx2d = 105,
  Instruction_lvx_v1_addx2w = 106,
  Instruction_lvx_v1_addx32d = 107,
  Instruction_lvx_v1_addx32w = 108,
  Instruction_lvx_v1_addx4d = 109,
  Instruction_lvx_v1_addx4w = 110,
  Instruction_lvx_v1_addx64d = 111,
  Instruction_lvx_v1_addx64w = 112,
  Instruction_lvx_v1_addx8d = 113,
  Instruction_lvx_v1_addx8w = 114,
  Instruction_lvx_v1_aladdb = 115,
  Instruction_lvx_v1_aladdd = 116,
  Instruction_lvx_v1_aladdh = 117,
  Instruction_lvx_v1_aladdw = 118,
  Instruction_lvx_v1_alandb = 119,
  Instruction_lvx_v1_alandd = 120,
  Instruction_lvx_v1_alandh = 121,
  Instruction_lvx_v1_alandw = 122,
  Instruction_lvx_v1_alb = 123,
  Instruction_lvx_v1_alclrb = 124,
  Instruction_lvx_v1_alclrd = 125,
  Instruction_lvx_v1_alclrh = 126,
  Instruction_lvx_v1_alclrw = 127,
  Instruction_lvx_v1_ald = 128,
  Instruction_lvx_v1_aldusb = 129,
  Instruction_lvx_v1_aldusd = 130,
  Instruction_lvx_v1_aldush = 131,
  Instruction_lvx_v1_aldusw = 132,
  Instruction_lvx_v1_aleorb = 133,
  Instruction_lvx_v1_aleord = 134,
  Instruction_lvx_v1_aleorh = 135,
  Instruction_lvx_v1_aleorw = 136,
  Instruction_lvx_v1_alh = 137,
  Instruction_lvx_v1_aliorb = 138,
  Instruction_lvx_v1_aliord = 139,
  Instruction_lvx_v1_aliorh = 140,
  Instruction_lvx_v1_aliorw = 141,
  Instruction_lvx_v1_almaxb = 142,
  Instruction_lvx_v1_almaxd = 143,
  Instruction_lvx_v1_almaxh = 144,
  Instruction_lvx_v1_almaxub = 145,
  Instruction_lvx_v1_almaxud = 146,
  Instruction_lvx_v1_almaxuh = 147,
  Instruction_lvx_v1_almaxuw = 148,
  Instruction_lvx_v1_almaxw = 149,
  Instruction_lvx_v1_alminb = 150,
  Instruction_lvx_v1_almind = 151,
  Instruction_lvx_v1_alminh = 152,
  Instruction_lvx_v1_alminub = 153,
  Instruction_lvx_v1_alminud = 154,
  Instruction_lvx_v1_alminuh = 155,
  Instruction_lvx_v1_alminuw = 156,
  Instruction_lvx_v1_alminw = 157,
  Instruction_lvx_v1_alw = 158,
  Instruction_lvx_v1_andd = 159,
  Instruction_lvx_v1_andnd = 160,
  Instruction_lvx_v1_andnq = 161,
  Instruction_lvx_v1_andnw = 162,
  Instruction_lvx_v1_andq = 163,
  Instruction_lvx_v1_andw = 164,
  Instruction_lvx_v1_asaddb = 165,
  Instruction_lvx_v1_asaddd = 166,
  Instruction_lvx_v1_asaddh = 167,
  Instruction_lvx_v1_asaddw = 168,
  Instruction_lvx_v1_asandb = 169,
  Instruction_lvx_v1_asandd = 170,
  Instruction_lvx_v1_asandh = 171,
  Instruction_lvx_v1_asandw = 172,
  Instruction_lvx_v1_asb = 173,
  Instruction_lvx_v1_asd = 174,
  Instruction_lvx_v1_asdusb = 175,
  Instruction_lvx_v1_asdusd = 176,
  Instruction_lvx_v1_asdush = 177,
  Instruction_lvx_v1_asdusw = 178,
  Instruction_lvx_v1_aseorb = 179,
  Instruction_lvx_v1_aseord = 180,
  Instruction_lvx_v1_aseorh = 181,
  Instruction_lvx_v1_aseorw = 182,
  Instruction_lvx_v1_ash = 183,
  Instruction_lvx_v1_asiorb = 184,
  Instruction_lvx_v1_asiord = 185,
  Instruction_lvx_v1_asiorh = 186,
  Instruction_lvx_v1_asiorw = 187,
  Instruction_lvx_v1_asmaxb = 188,
  Instruction_lvx_v1_asmaxd = 189,
  Instruction_lvx_v1_asmaxh = 190,
  Instruction_lvx_v1_asmaxub = 191,
  Instruction_lvx_v1_asmaxud = 192,
  Instruction_lvx_v1_asmaxuh = 193,
  Instruction_lvx_v1_asmaxuw = 194,
  Instruction_lvx_v1_asmaxw = 195,
  Instruction_lvx_v1_asminb = 196,
  Instruction_lvx_v1_asmind = 197,
  Instruction_lvx_v1_asminh = 198,
  Instruction_lvx_v1_asminub = 199,
  Instruction_lvx_v1_asminud = 200,
  Instruction_lvx_v1_asminuh = 201,
  Instruction_lvx_v1_asminuw = 202,
  Instruction_lvx_v1_asminw = 203,
  Instruction_lvx_v1_asw = 204,
  Instruction_lvx_v1_aswapb = 205,
  Instruction_lvx_v1_aswapd = 206,
  Instruction_lvx_v1_aswaph = 207,
  Instruction_lvx_v1_aswapw = 208,
  Instruction_lvx_v1_avgruw = 209,
  Instruction_lvx_v1_avgrw = 210,
  Instruction_lvx_v1_avguw = 211,
  Instruction_lvx_v1_avgw = 212,
  Instruction_lvx_v1_await = 213,
  Instruction_lvx_v1_barrier = 214,
  Instruction_lvx_v1_blend = 215,
  Instruction_lvx_v1_break = 216,
  Instruction_lvx_v1_call = 217,
  Instruction_lvx_v1_callx = 218,
  Instruction_lvx_v1_catdq = 219,
  Instruction_lvx_v1_cb = 220,
  Instruction_lvx_v1_cbsd = 221,
  Instruction_lvx_v1_cbsw = 222,
  Instruction_lvx_v1_cbx = 223,
  Instruction_lvx_v1_ccb = 224,
  Instruction_lvx_v1_ccbx = 225,
  Instruction_lvx_v1_clsd = 226,
  Instruction_lvx_v1_clsw = 227,
  Instruction_lvx_v1_clzd = 228,
  Instruction_lvx_v1_clzw = 229,
  Instruction_lvx_v1_cmoved = 230,
  Instruction_lvx_v1_cmoveq = 231,
  Instruction_lvx_v1_compd = 232,
  Instruction_lvx_v1_compq = 233,
  Instruction_lvx_v1_compw = 234,
  Instruction_lvx_v1_copyd = 235,
  Instruction_lvx_v1_copyo = 236,
  Instruction_lvx_v1_copyq = 237,
  Instruction_lvx_v1_copyw = 238,
  Instruction_lvx_v1_crcbellw = 239,
  Instruction_lvx_v1_crcbelmw = 240,
  Instruction_lvx_v1_crclellw = 241,
  Instruction_lvx_v1_crclelmw = 242,
  Instruction_lvx_v1_csrrc = 243,
  Instruction_lvx_v1_csrrs = 244,
  Instruction_lvx_v1_csrrw = 245,
  Instruction_lvx_v1_ctzd = 246,
  Instruction_lvx_v1_ctzw = 247,
  Instruction_lvx_v1_d1inval = 248,
  Instruction_lvx_v1_dflushl = 249,
  Instruction_lvx_v1_dflushsw = 250,
  Instruction_lvx_v1_dinvall = 251,
  Instruction_lvx_v1_dinvalsw = 252,
  Instruction_lvx_v1_divmodd = 253,
  Instruction_lvx_v1_divmodud = 254,
  Instruction_lvx_v1_divmoduw = 255,
  Instruction_lvx_v1_divmodw = 256,
  Instruction_lvx_v1_dpurgel = 257,
  Instruction_lvx_v1_dpurgesw = 258,
  Instruction_lvx_v1_dtouchl = 259,
  Instruction_lvx_v1_eord = 260,
  Instruction_lvx_v1_eorq = 261,
  Instruction_lvx_v1_eorw = 262,
  Instruction_lvx_v1_errop = 263,
  Instruction_lvx_v1_extfs = 264,
  Instruction_lvx_v1_extfz = 265,
  Instruction_lvx_v1_fabsd = 266,
  Instruction_lvx_v1_fabsh = 267,
  Instruction_lvx_v1_fabsw = 268,
  Instruction_lvx_v1_fabswp = 269,
  Instruction_lvx_v1_faddd = 270,
  Instruction_lvx_v1_faddh = 271,
  Instruction_lvx_v1_faddw = 272,
  Instruction_lvx_v1_faddwc = 273,
  Instruction_lvx_v1_fclassd = 274,
  Instruction_lvx_v1_fclassh = 275,
  Instruction_lvx_v1_fclassw = 276,
  Instruction_lvx_v1_fclasswp = 277,
  Instruction_lvx_v1_fcompd = 278,
  Instruction_lvx_v1_fcomph = 279,
  Instruction_lvx_v1_fcompw = 280,
  Instruction_lvx_v1_fdivd = 281,
  Instruction_lvx_v1_fdivh = 282,
  Instruction_lvx_v1_fdivw = 283,
  Instruction_lvx_v1_fence = 284,
  Instruction_lvx_v1_ffmad = 285,
  Instruction_lvx_v1_ffmah = 286,
  Instruction_lvx_v1_ffmaw = 287,
  Instruction_lvx_v1_ffmawc = 288,
  Instruction_lvx_v1_ffmsd = 289,
  Instruction_lvx_v1_ffmsh = 290,
  Instruction_lvx_v1_ffmsw = 291,
  Instruction_lvx_v1_fixedd = 292,
  Instruction_lvx_v1_fixeddw = 293,
  Instruction_lvx_v1_fixedud = 294,
  Instruction_lvx_v1_fixedudw = 295,
  Instruction_lvx_v1_fixeduw = 296,
  Instruction_lvx_v1_fixeduwd = 297,
  Instruction_lvx_v1_fixeduwp = 298,
  Instruction_lvx_v1_fixedw = 299,
  Instruction_lvx_v1_fixedwd = 300,
  Instruction_lvx_v1_fixedwp = 301,
  Instruction_lvx_v1_floatd = 302,
  Instruction_lvx_v1_floatdw = 303,
  Instruction_lvx_v1_floatud = 304,
  Instruction_lvx_v1_floatudw = 305,
  Instruction_lvx_v1_floatuw = 306,
  Instruction_lvx_v1_floatuwd = 307,
  Instruction_lvx_v1_floatuwp = 308,
  Instruction_lvx_v1_floatw = 309,
  Instruction_lvx_v1_floatwd = 310,
  Instruction_lvx_v1_floatwp = 311,
  Instruction_lvx_v1_fmaxd = 312,
  Instruction_lvx_v1_fmaxh = 313,
  Instruction_lvx_v1_fmaxnd = 314,
  Instruction_lvx_v1_fmaxnh = 315,
  Instruction_lvx_v1_fmaxnw = 316,
  Instruction_lvx_v1_fmaxw = 317,
  Instruction_lvx_v1_fmind = 318,
  Instruction_lvx_v1_fminh = 319,
  Instruction_lvx_v1_fminnd = 320,
  Instruction_lvx_v1_fminnh = 321,
  Instruction_lvx_v1_fminnw = 322,
  Instruction_lvx_v1_fminw = 323,
  Instruction_lvx_v1_fmuld = 324,
  Instruction_lvx_v1_fmulh = 325,
  Instruction_lvx_v1_fmulw = 326,
  Instruction_lvx_v1_fmulwc = 327,
  Instruction_lvx_v1_fnarrowdw = 328,
  Instruction_lvx_v1_fnarrowwh = 329,
  Instruction_lvx_v1_fnegd = 330,
  Instruction_lvx_v1_fnegh = 331,
  Instruction_lvx_v1_fnegw = 332,
  Instruction_lvx_v1_fnegwp = 333,
  Instruction_lvx_v1_frcsr = 334,
  Instruction_lvx_v1_frflags = 335,
  Instruction_lvx_v1_frintd = 336,
  Instruction_lvx_v1_frinth = 337,
  Instruction_lvx_v1_frintw = 338,
  Instruction_lvx_v1_frrm = 339,
  Instruction_lvx_v1_fsbfd = 340,
  Instruction_lvx_v1_fsbfh = 341,
  Instruction_lvx_v1_fsbfw = 342,
  Instruction_lvx_v1_fsbfwc = 343,
  Instruction_lvx_v1_fscsr = 344,
  Instruction_lvx_v1_fsflags = 345,
  Instruction_lvx_v1_fsignd = 346,
  Instruction_lvx_v1_fsignh = 347,
  Instruction_lvx_v1_fsignmd = 348,
  Instruction_lvx_v1_fsignmh = 349,
  Instruction_lvx_v1_fsignmw = 350,
  Instruction_lvx_v1_fsignnd = 351,
  Instruction_lvx_v1_fsignnh = 352,
  Instruction_lvx_v1_fsignnw = 353,
  Instruction_lvx_v1_fsignw = 354,
  Instruction_lvx_v1_fsqrtd = 355,
  Instruction_lvx_v1_fsqrth = 356,
  Instruction_lvx_v1_fsqrtw = 357,
  Instruction_lvx_v1_fsrecd = 358,
  Instruction_lvx_v1_fsrecw = 359,
  Instruction_lvx_v1_fsrecwp = 360,
  Instruction_lvx_v1_fsrm = 361,
  Instruction_lvx_v1_fsrsrd = 362,
  Instruction_lvx_v1_fsrsrw = 363,
  Instruction_lvx_v1_fsrsrwp = 364,
  Instruction_lvx_v1_fwidenhw = 365,
  Instruction_lvx_v1_fwidenwd = 366,
  Instruction_lvx_v1_get = 367,
  Instruction_lvx_v1_goto = 368,
  Instruction_lvx_v1_gotox = 369,
  Instruction_lvx_v1_guard = 370,
  Instruction_lvx_v1_i1inval = 371,
  Instruction_lvx_v1_i1invals = 372,
  Instruction_lvx_v1_icall = 373,
  Instruction_lvx_v1_iget = 374,
  Instruction_lvx_v1_igoto = 375,
  Instruction_lvx_v1_insf = 376,
  Instruction_lvx_v1_iord = 377,
  Instruction_lvx_v1_iornd = 378,
  Instruction_lvx_v1_iornq = 379,
  Instruction_lvx_v1_iornw = 380,
  Instruction_lvx_v1_iorq = 381,
  Instruction_lvx_v1_iorw = 382,
  Instruction_lvx_v1_landd = 383,
  Instruction_lvx_v1_landw = 384,
  Instruction_lvx_v1_lbs = 385,
  Instruction_lvx_v1_lbz = 386,
  Instruction_lvx_v1_ld = 387,
  Instruction_lvx_v1_lhs = 388,
  Instruction_lvx_v1_lhz = 389,
  Instruction_lvx_v1_liord = 390,
  Instruction_lvx_v1_liorw = 391,
  Instruction_lvx_v1_lnandd = 392,
  Instruction_lvx_v1_lnandw = 393,
  Instruction_lvx_v1_lniord = 394,
  Instruction_lvx_v1_lniorw = 395,
  Instruction_lvx_v1_lo = 396,
  Instruction_lvx_v1_loopdo = 397,
  Instruction_lvx_v1_lq = 398,
  Instruction_lvx_v1_lws = 399,
  Instruction_lvx_v1_lwz = 400,
  Instruction_lvx_v1_maddd = 401,
  Instruction_lvx_v1_madddq = 402,
  Instruction_lvx_v1_madddt = 403,
  Instruction_lvx_v1_maddsudt = 404,
  Instruction_lvx_v1_maddsuwd = 405,
  Instruction_lvx_v1_maddudt = 406,
  Instruction_lvx_v1_madduwd = 407,
  Instruction_lvx_v1_maddw = 408,
  Instruction_lvx_v1_maddwd = 409,
  Instruction_lvx_v1_make = 410,
  Instruction_lvx_v1_maxd = 411,
  Instruction_lvx_v1_maxud = 412,
  Instruction_lvx_v1_maxuw = 413,
  Instruction_lvx_v1_maxw = 414,
  Instruction_lvx_v1_mind = 415,
  Instruction_lvx_v1_minud = 416,
  Instruction_lvx_v1_minuw = 417,
  Instruction_lvx_v1_minw = 418,
  Instruction_lvx_v1_msbfd = 419,
  Instruction_lvx_v1_msbfdq = 420,
  Instruction_lvx_v1_msbfdt = 421,
  Instruction_lvx_v1_msbfsudt = 422,
  Instruction_lvx_v1_msbfsuwd = 423,
  Instruction_lvx_v1_msbfudt = 424,
  Instruction_lvx_v1_msbfuwd = 425,
  Instruction_lvx_v1_msbfw = 426,
  Instruction_lvx_v1_msbfwd = 427,
  Instruction_lvx_v1_muld = 428,
  Instruction_lvx_v1_muldq = 429,
  Instruction_lvx_v1_muldt = 430,
  Instruction_lvx_v1_mulnd = 431,
  Instruction_lvx_v1_mulndq = 432,
  Instruction_lvx_v1_mulnw = 433,
  Instruction_lvx_v1_mulnwd = 434,
  Instruction_lvx_v1_mulsudt = 435,
  Instruction_lvx_v1_mulsuwd = 436,
  Instruction_lvx_v1_muludt = 437,
  Instruction_lvx_v1_muluwd = 438,
  Instruction_lvx_v1_mulw = 439,
  Instruction_lvx_v1_mulwd = 440,
  Instruction_lvx_v1_nandd = 441,
  Instruction_lvx_v1_nandq = 442,
  Instruction_lvx_v1_nandw = 443,
  Instruction_lvx_v1_negd = 444,
  Instruction_lvx_v1_negq = 445,
  Instruction_lvx_v1_negsd = 446,
  Instruction_lvx_v1_negsw = 447,
  Instruction_lvx_v1_negw = 448,
  Instruction_lvx_v1_neord = 449,
  Instruction_lvx_v1_neorq = 450,
  Instruction_lvx_v1_neorw = 451,
  Instruction_lvx_v1_niord = 452,
  Instruction_lvx_v1_niorq = 453,
  Instruction_lvx_v1_niorw = 454,
  Instruction_lvx_v1_nop = 455,
  Instruction_lvx_v1_notd = 456,
  Instruction_lvx_v1_notq = 457,
  Instruction_lvx_v1_notw = 458,
  Instruction_lvx_v1_pcrel = 459,
  Instruction_lvx_v1_ret = 460,
  Instruction_lvx_v1_rfe = 461,
  Instruction_lvx_v1_rold = 462,
  Instruction_lvx_v1_rolw = 463,
  Instruction_lvx_v1_rord = 464,
  Instruction_lvx_v1_rorw = 465,
  Instruction_lvx_v1_rswap = 466,
  Instruction_lvx_v1_sb = 467,
  Instruction_lvx_v1_sbfd = 468,
  Instruction_lvx_v1_sbfq = 469,
  Instruction_lvx_v1_sbfsd = 470,
  Instruction_lvx_v1_sbfsw = 471,
  Instruction_lvx_v1_sbfusd = 472,
  Instruction_lvx_v1_sbfusw = 473,
  Instruction_lvx_v1_sbfw = 474,
  Instruction_lvx_v1_sbmm8 = 475,
  Instruction_lvx_v1_sbmm8d = 476,
  Instruction_lvx_v1_sbmm8eord = 477,
  Instruction_lvx_v1_sbmmt8 = 478,
  Instruction_lvx_v1_sbmmt8d = 479,
  Instruction_lvx_v1_sbmmt8eord = 480,
  Instruction_lvx_v1_scall = 481,
  Instruction_lvx_v1_sd = 482,
  Instruction_lvx_v1_set = 483,
  Instruction_lvx_v1_sh = 484,
  Instruction_lvx_v1_signd = 485,
  Instruction_lvx_v1_signsd = 486,
  Instruction_lvx_v1_signsw = 487,
  Instruction_lvx_v1_signw = 488,
  Instruction_lvx_v1_sleep = 489,
  Instruction_lvx_v1_slld = 490,
  Instruction_lvx_v1_sllw = 491,
  Instruction_lvx_v1_slsd = 492,
  Instruction_lvx_v1_slsw = 493,
  Instruction_lvx_v1_slusd = 494,
  Instruction_lvx_v1_slusw = 495,
  Instruction_lvx_v1_so = 496,
  Instruction_lvx_v1_sq = 497,
  Instruction_lvx_v1_srad = 498,
  Instruction_lvx_v1_sraw = 499,
  Instruction_lvx_v1_srld = 500,
  Instruction_lvx_v1_srlw = 501,
  Instruction_lvx_v1_srsd = 502,
  Instruction_lvx_v1_srsw = 503,
  Instruction_lvx_v1_stop = 504,
  Instruction_lvx_v1_stsud = 505,
  Instruction_lvx_v1_stsuw = 506,
  Instruction_lvx_v1_sw = 507,
  Instruction_lvx_v1_sxbd = 508,
  Instruction_lvx_v1_sxhd = 509,
  Instruction_lvx_v1_sxwd = 510,
  Instruction_lvx_v1_syncgroup = 511,
  Instruction_lvx_v1_tlbdinval = 512,
  Instruction_lvx_v1_tlbiinval = 513,
  Instruction_lvx_v1_tlbprobe = 514,
  Instruction_lvx_v1_tlbread = 515,
  Instruction_lvx_v1_tlbwrite = 516,
  Instruction_lvx_v1_waitit = 517,
  Instruction_lvx_v1_wfxl = 518,
  Instruction_lvx_v1_wfxm = 519,
  Instruction_lvx_v1_zxbd = 520,
  Instruction_lvx_v1_zxhd = 521,
  Instruction_lvx_v1_zxwd = 522,
  Separator_lvx_v1_comma = 523,
  Separator_lvx_v1_equal = 524,
  Separator_lvx_v1_qmark = 525,
  Separator_lvx_v1_rsbracket = 526,
  Separator_lvx_v1_lsbracket = 527
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

#define LVX_V2_REGFILE_FIRST_SFR LVX_REGFILE_FIRST_SFR
#define LVX_V2_REGFILE_LAST_SFR LVX_REGFILE_LAST_SFR
#define LVX_V2_REGFILE_DEC_SFR LVX_REGFILE_DEC_SFR
#define LVX_V2_REGFILE_FIRST_GPR LVX_REGFILE_FIRST_GPR
#define LVX_V2_REGFILE_LAST_GPR LVX_REGFILE_LAST_GPR
#define LVX_V2_REGFILE_DEC_GPR LVX_REGFILE_DEC_GPR
#define LVX_V2_REGFILE_FIRST_PGR 6
#define LVX_V2_REGFILE_LAST_PGR 7
#define LVX_V2_REGFILE_DEC_PGR 8
#define LVX_V2_REGFILE_FIRST_QGR 9
#define LVX_V2_REGFILE_LAST_QGR 10
#define LVX_V2_REGFILE_DEC_QGR 11
#define LVX_V2_REGFILE_FIRST_X16R 12
#define LVX_V2_REGFILE_LAST_X16R 13
#define LVX_V2_REGFILE_DEC_X16R 14
#define LVX_V2_REGFILE_FIRST_X2R 15
#define LVX_V2_REGFILE_LAST_X2R 16
#define LVX_V2_REGFILE_DEC_X2R 17
#define LVX_V2_REGFILE_FIRST_X32R 18
#define LVX_V2_REGFILE_LAST_X32R 19
#define LVX_V2_REGFILE_DEC_X32R 20
#define LVX_V2_REGFILE_FIRST_X4R 21
#define LVX_V2_REGFILE_LAST_X4R 22
#define LVX_V2_REGFILE_DEC_X4R 23
#define LVX_V2_REGFILE_FIRST_X64R 24
#define LVX_V2_REGFILE_LAST_X64R 25
#define LVX_V2_REGFILE_DEC_X64R 26
#define LVX_V2_REGFILE_FIRST_X8R 27
#define LVX_V2_REGFILE_LAST_X8R 28
#define LVX_V2_REGFILE_DEC_X8R 29
#define LVX_V2_REGFILE_FIRST_XBR 30
#define LVX_V2_REGFILE_LAST_XBR 31
#define LVX_V2_REGFILE_DEC_XBR 32
#define LVX_V2_REGFILE_FIRST_XCR 33
#define LVX_V2_REGFILE_LAST_XCR 34
#define LVX_V2_REGFILE_DEC_XCR 35
#define LVX_V2_REGFILE_FIRST_XMR 36
#define LVX_V2_REGFILE_LAST_XMR 37
#define LVX_V2_REGFILE_DEC_XMR 38
#define LVX_V2_REGFILE_FIRST_XTR 39
#define LVX_V2_REGFILE_LAST_XTR 40
#define LVX_V2_REGFILE_DEC_XTR 41
#define LVX_V2_REGFILE_FIRST_XVR 42
#define LVX_V2_REGFILE_LAST_XVR 43
#define LVX_V2_REGFILE_DEC_XVR 44
#define LVX_V2_REGFILE_REGISTERS 45
#define LVX_V2_REGFILE_DEC_REGISTERS 46


extern int lvx_v2_regfiles[];
extern const char **lvx_v2_modifiers[];
extern struct lvx_register lvx_v2_registers[];

extern int lvx_v2_dec_registers[];

enum Method_lvx_v2_enum {
  Immediate_lvx_v2_brknumber = 1,
  Immediate_lvx_v2_csrnumber = 2,
  Immediate_lvx_v2_pcrel11s2 = 3,
  Immediate_lvx_v2_pcrel17s2 = 4,
  Immediate_lvx_v2_pcrel27s2 = 5,
  Immediate_lvx_v2_pcrel38s2 = 6,
  Immediate_lvx_v2_pcrel44s2 = 7,
  Immediate_lvx_v2_pcrel54s2 = 8,
  Immediate_lvx_v2_signed10 = 9,
  Immediate_lvx_v2_signed16 = 10,
  Immediate_lvx_v2_signed27 = 11,
  Immediate_lvx_v2_signed37 = 12,
  Immediate_lvx_v2_signed43 = 13,
  Immediate_lvx_v2_signed54 = 14,
  Immediate_lvx_v2_sysnumber = 15,
  Immediate_lvx_v2_unsigned6 = 16,
  Immediate_lvx_v2_wrapped32 = 17,
  Immediate_lvx_v2_wrapped64 = 18,
  Immediate_lvx_v2_wrapped8 = 19,
  Modifier_lvx_v2_accesses = 20,
  Modifier_lvx_v2_bcucond = 21,
  Modifier_lvx_v2_boolcas = 22,
  Modifier_lvx_v2_cachelev = 23,
  Modifier_lvx_v2_ccbcomp = 24,
  Modifier_lvx_v2_channel = 25,
  Modifier_lvx_v2_coherency = 26,
  Modifier_lvx_v2_conjugate = 27,
  Modifier_lvx_v2_doscale = 28,
  Modifier_lvx_v2_exunum = 29,
  Modifier_lvx_v2_floatcomp = 30,
  Modifier_lvx_v2_floatmode = 31,
  Modifier_lvx_v2_fnegate = 32,
  Modifier_lvx_v2_highmult = 33,
  Modifier_lvx_v2_hindex = 34,
  Modifier_lvx_v2_imultiply = 35,
  Modifier_lvx_v2_intcomp = 36,
  Modifier_lvx_v2_lanecond = 37,
  Modifier_lvx_v2_lanesize = 38,
  Modifier_lvx_v2_lanetodo = 39,
  Modifier_lvx_v2_mostsig = 40,
  Modifier_lvx_v2_oddlanes = 41,
  Modifier_lvx_v2_qindex = 42,
  Modifier_lvx_v2_realimag = 43,
  Modifier_lvx_v2_shuffleV = 44,
  Modifier_lvx_v2_shuffleX = 45,
  Modifier_lvx_v2_signextw = 46,
  Modifier_lvx_v2_speculate = 47,
  Modifier_lvx_v2_splat32 = 48,
  Modifier_lvx_v2_variant = 49,
  Modifier_lvx_v2_widemult = 50,
  Modifier_lvx_v2_ziplanes = 51,
  RegClass_lvx_v2_aloneReg = 52,
  RegClass_lvx_v2_buffer16Reg = 53,
  RegClass_lvx_v2_buffer2Reg = 54,
  RegClass_lvx_v2_buffer32Reg = 55,
  RegClass_lvx_v2_buffer4Reg = 56,
  RegClass_lvx_v2_buffer64Reg = 57,
  RegClass_lvx_v2_buffer8Reg = 58,
  RegClass_lvx_v2_onlyfxReg = 59,
  RegClass_lvx_v2_onlygetReg = 60,
  RegClass_lvx_v2_onlyraReg = 61,
  RegClass_lvx_v2_onlysetReg = 62,
  RegClass_lvx_v2_onlyswapReg = 63,
  RegClass_lvx_v2_pairedReg = 64,
  RegClass_lvx_v2_quadReg = 65,
  RegClass_lvx_v2_singleReg = 66,
  RegClass_lvx_v2_systemReg = 67,
  RegClass_lvx_v2_worddRegE = 68,
  RegClass_lvx_v2_worddRegO = 69,
  RegClass_lvx_v2_xworddReg = 70,
  RegClass_lvx_v2_xworddReg0M4 = 71,
  RegClass_lvx_v2_xworddReg1M4 = 72,
  RegClass_lvx_v2_xworddReg2M4 = 73,
  RegClass_lvx_v2_xworddReg3M4 = 74,
  RegClass_lvx_v2_xwordoReg = 75,
  RegClass_lvx_v2_xwordqReg = 76,
  RegClass_lvx_v2_xwordqRegE = 77,
  RegClass_lvx_v2_xwordqRegO = 78,
  RegClass_lvx_v2_xwordvReg = 79,
  RegClass_lvx_v2_xwordxReg = 80,
  Instruction_lvx_v2_abdbx = 81,
  Instruction_lvx_v2_abdd = 82,
  Instruction_lvx_v2_abddp = 83,
  Instruction_lvx_v2_abdho = 84,
  Instruction_lvx_v2_abdsbx = 85,
  Instruction_lvx_v2_abdsd = 86,
  Instruction_lvx_v2_abdsdp = 87,
  Instruction_lvx_v2_abdsho = 88,
  Instruction_lvx_v2_abdsw = 89,
  Instruction_lvx_v2_abdswq = 90,
  Instruction_lvx_v2_abdubx = 91,
  Instruction_lvx_v2_abdud = 92,
  Instruction_lvx_v2_abdudp = 93,
  Instruction_lvx_v2_abduho = 94,
  Instruction_lvx_v2_abduw = 95,
  Instruction_lvx_v2_abduwq = 96,
  Instruction_lvx_v2_abdw = 97,
  Instruction_lvx_v2_abdwq = 98,
  Instruction_lvx_v2_absbx = 99,
  Instruction_lvx_v2_absd = 100,
  Instruction_lvx_v2_absdp = 101,
  Instruction_lvx_v2_absho = 102,
  Instruction_lvx_v2_abssbx = 103,
  Instruction_lvx_v2_abssd = 104,
  Instruction_lvx_v2_abssdp = 105,
  Instruction_lvx_v2_abssho = 106,
  Instruction_lvx_v2_abssw = 107,
  Instruction_lvx_v2_absswq = 108,
  Instruction_lvx_v2_absw = 109,
  Instruction_lvx_v2_abswq = 110,
  Instruction_lvx_v2_acswapb = 111,
  Instruction_lvx_v2_acswapd = 112,
  Instruction_lvx_v2_acswaph = 113,
  Instruction_lvx_v2_acswapq = 114,
  Instruction_lvx_v2_acswapw = 115,
  Instruction_lvx_v2_addbx = 116,
  Instruction_lvx_v2_addd = 117,
  Instruction_lvx_v2_adddp = 118,
  Instruction_lvx_v2_addho = 119,
  Instruction_lvx_v2_addq = 120,
  Instruction_lvx_v2_addsbx = 121,
  Instruction_lvx_v2_addsd = 122,
  Instruction_lvx_v2_addsdp = 123,
  Instruction_lvx_v2_addsho = 124,
  Instruction_lvx_v2_addsw = 125,
  Instruction_lvx_v2_addswq = 126,
  Instruction_lvx_v2_addusbx = 127,
  Instruction_lvx_v2_addusd = 128,
  Instruction_lvx_v2_addusdp = 129,
  Instruction_lvx_v2_addusho = 130,
  Instruction_lvx_v2_addusw = 131,
  Instruction_lvx_v2_adduswq = 132,
  Instruction_lvx_v2_addw = 133,
  Instruction_lvx_v2_addwq = 134,
  Instruction_lvx_v2_addx16bx = 135,
  Instruction_lvx_v2_addx16d = 136,
  Instruction_lvx_v2_addx16dp = 137,
  Instruction_lvx_v2_addx16ho = 138,
  Instruction_lvx_v2_addx16w = 139,
  Instruction_lvx_v2_addx16wq = 140,
  Instruction_lvx_v2_addx2bx = 141,
  Instruction_lvx_v2_addx2d = 142,
  Instruction_lvx_v2_addx2dp = 143,
  Instruction_lvx_v2_addx2ho = 144,
  Instruction_lvx_v2_addx2w = 145,
  Instruction_lvx_v2_addx2wq = 146,
  Instruction_lvx_v2_addx32d = 147,
  Instruction_lvx_v2_addx32w = 148,
  Instruction_lvx_v2_addx4bx = 149,
  Instruction_lvx_v2_addx4d = 150,
  Instruction_lvx_v2_addx4dp = 151,
  Instruction_lvx_v2_addx4ho = 152,
  Instruction_lvx_v2_addx4w = 153,
  Instruction_lvx_v2_addx4wq = 154,
  Instruction_lvx_v2_addx64d = 155,
  Instruction_lvx_v2_addx64w = 156,
  Instruction_lvx_v2_addx8bx = 157,
  Instruction_lvx_v2_addx8d = 158,
  Instruction_lvx_v2_addx8dp = 159,
  Instruction_lvx_v2_addx8ho = 160,
  Instruction_lvx_v2_addx8w = 161,
  Instruction_lvx_v2_addx8wq = 162,
  Instruction_lvx_v2_aladdb = 163,
  Instruction_lvx_v2_aladdd = 164,
  Instruction_lvx_v2_aladdh = 165,
  Instruction_lvx_v2_aladdw = 166,
  Instruction_lvx_v2_alandb = 167,
  Instruction_lvx_v2_alandd = 168,
  Instruction_lvx_v2_alandh = 169,
  Instruction_lvx_v2_alandw = 170,
  Instruction_lvx_v2_alb = 171,
  Instruction_lvx_v2_alclrb = 172,
  Instruction_lvx_v2_alclrd = 173,
  Instruction_lvx_v2_alclrh = 174,
  Instruction_lvx_v2_alclrw = 175,
  Instruction_lvx_v2_ald = 176,
  Instruction_lvx_v2_aldusb = 177,
  Instruction_lvx_v2_aldusd = 178,
  Instruction_lvx_v2_aldush = 179,
  Instruction_lvx_v2_aldusw = 180,
  Instruction_lvx_v2_aleorb = 181,
  Instruction_lvx_v2_aleord = 182,
  Instruction_lvx_v2_aleorh = 183,
  Instruction_lvx_v2_aleorw = 184,
  Instruction_lvx_v2_alh = 185,
  Instruction_lvx_v2_aliorb = 186,
  Instruction_lvx_v2_aliord = 187,
  Instruction_lvx_v2_aliorh = 188,
  Instruction_lvx_v2_aliorw = 189,
  Instruction_lvx_v2_almaxb = 190,
  Instruction_lvx_v2_almaxd = 191,
  Instruction_lvx_v2_almaxh = 192,
  Instruction_lvx_v2_almaxub = 193,
  Instruction_lvx_v2_almaxud = 194,
  Instruction_lvx_v2_almaxuh = 195,
  Instruction_lvx_v2_almaxuw = 196,
  Instruction_lvx_v2_almaxw = 197,
  Instruction_lvx_v2_alminb = 198,
  Instruction_lvx_v2_almind = 199,
  Instruction_lvx_v2_alminh = 200,
  Instruction_lvx_v2_alminub = 201,
  Instruction_lvx_v2_alminud = 202,
  Instruction_lvx_v2_alminuh = 203,
  Instruction_lvx_v2_alminuw = 204,
  Instruction_lvx_v2_alminw = 205,
  Instruction_lvx_v2_alw = 206,
  Instruction_lvx_v2_andd = 207,
  Instruction_lvx_v2_andnd = 208,
  Instruction_lvx_v2_andnq = 209,
  Instruction_lvx_v2_andnw = 210,
  Instruction_lvx_v2_andq = 211,
  Instruction_lvx_v2_andw = 212,
  Instruction_lvx_v2_asaddb = 213,
  Instruction_lvx_v2_asaddd = 214,
  Instruction_lvx_v2_asaddh = 215,
  Instruction_lvx_v2_asaddw = 216,
  Instruction_lvx_v2_asandb = 217,
  Instruction_lvx_v2_asandd = 218,
  Instruction_lvx_v2_asandh = 219,
  Instruction_lvx_v2_asandw = 220,
  Instruction_lvx_v2_asb = 221,
  Instruction_lvx_v2_asd = 222,
  Instruction_lvx_v2_asdusb = 223,
  Instruction_lvx_v2_asdusd = 224,
  Instruction_lvx_v2_asdush = 225,
  Instruction_lvx_v2_asdusw = 226,
  Instruction_lvx_v2_aseorb = 227,
  Instruction_lvx_v2_aseord = 228,
  Instruction_lvx_v2_aseorh = 229,
  Instruction_lvx_v2_aseorw = 230,
  Instruction_lvx_v2_ash = 231,
  Instruction_lvx_v2_asiorb = 232,
  Instruction_lvx_v2_asiord = 233,
  Instruction_lvx_v2_asiorh = 234,
  Instruction_lvx_v2_asiorw = 235,
  Instruction_lvx_v2_asmaxb = 236,
  Instruction_lvx_v2_asmaxd = 237,
  Instruction_lvx_v2_asmaxh = 238,
  Instruction_lvx_v2_asmaxub = 239,
  Instruction_lvx_v2_asmaxud = 240,
  Instruction_lvx_v2_asmaxuh = 241,
  Instruction_lvx_v2_asmaxuw = 242,
  Instruction_lvx_v2_asmaxw = 243,
  Instruction_lvx_v2_asminb = 244,
  Instruction_lvx_v2_asmind = 245,
  Instruction_lvx_v2_asminh = 246,
  Instruction_lvx_v2_asminub = 247,
  Instruction_lvx_v2_asminud = 248,
  Instruction_lvx_v2_asminuh = 249,
  Instruction_lvx_v2_asminuw = 250,
  Instruction_lvx_v2_asminw = 251,
  Instruction_lvx_v2_asw = 252,
  Instruction_lvx_v2_aswapb = 253,
  Instruction_lvx_v2_aswapd = 254,
  Instruction_lvx_v2_aswaph = 255,
  Instruction_lvx_v2_aswapw = 256,
  Instruction_lvx_v2_avgbx = 257,
  Instruction_lvx_v2_avgho = 258,
  Instruction_lvx_v2_avgrbx = 259,
  Instruction_lvx_v2_avgrho = 260,
  Instruction_lvx_v2_avgrubx = 261,
  Instruction_lvx_v2_avgruho = 262,
  Instruction_lvx_v2_avgruw = 263,
  Instruction_lvx_v2_avgruwq = 264,
  Instruction_lvx_v2_avgrw = 265,
  Instruction_lvx_v2_avgrwq = 266,
  Instruction_lvx_v2_avgubx = 267,
  Instruction_lvx_v2_avguho = 268,
  Instruction_lvx_v2_avguw = 269,
  Instruction_lvx_v2_avguwq = 270,
  Instruction_lvx_v2_avgw = 271,
  Instruction_lvx_v2_avgwq = 272,
  Instruction_lvx_v2_await = 273,
  Instruction_lvx_v2_barrier = 274,
  Instruction_lvx_v2_blend = 275,
  Instruction_lvx_v2_break = 276,
  Instruction_lvx_v2_call = 277,
  Instruction_lvx_v2_callx = 278,
  Instruction_lvx_v2_catdq = 279,
  Instruction_lvx_v2_cb = 280,
  Instruction_lvx_v2_cbsd = 281,
  Instruction_lvx_v2_cbsdp = 282,
  Instruction_lvx_v2_cbsho = 283,
  Instruction_lvx_v2_cbsw = 284,
  Instruction_lvx_v2_cbswq = 285,
  Instruction_lvx_v2_cbx = 286,
  Instruction_lvx_v2_ccb = 287,
  Instruction_lvx_v2_ccbx = 288,
  Instruction_lvx_v2_clsd = 289,
  Instruction_lvx_v2_clsdp = 290,
  Instruction_lvx_v2_clsho = 291,
  Instruction_lvx_v2_clsw = 292,
  Instruction_lvx_v2_clswq = 293,
  Instruction_lvx_v2_clzd = 294,
  Instruction_lvx_v2_clzdp = 295,
  Instruction_lvx_v2_clzho = 296,
  Instruction_lvx_v2_clzw = 297,
  Instruction_lvx_v2_clzwq = 298,
  Instruction_lvx_v2_cmovebx = 299,
  Instruction_lvx_v2_cmoved = 300,
  Instruction_lvx_v2_cmovedp = 301,
  Instruction_lvx_v2_cmoveho = 302,
  Instruction_lvx_v2_cmoveq = 303,
  Instruction_lvx_v2_cmovewq = 304,
  Instruction_lvx_v2_compbx = 305,
  Instruction_lvx_v2_compd = 306,
  Instruction_lvx_v2_compdp = 307,
  Instruction_lvx_v2_compho = 308,
  Instruction_lvx_v2_compnbx = 309,
  Instruction_lvx_v2_compndp = 310,
  Instruction_lvx_v2_compnho = 311,
  Instruction_lvx_v2_compnwq = 312,
  Instruction_lvx_v2_compq = 313,
  Instruction_lvx_v2_compw = 314,
  Instruction_lvx_v2_compwq = 315,
  Instruction_lvx_v2_copyd = 316,
  Instruction_lvx_v2_copyo = 317,
  Instruction_lvx_v2_copyq = 318,
  Instruction_lvx_v2_copyw = 319,
  Instruction_lvx_v2_crcbellw = 320,
  Instruction_lvx_v2_crcbelmw = 321,
  Instruction_lvx_v2_crclellw = 322,
  Instruction_lvx_v2_crclelmw = 323,
  Instruction_lvx_v2_csrrc = 324,
  Instruction_lvx_v2_csrrs = 325,
  Instruction_lvx_v2_csrrw = 326,
  Instruction_lvx_v2_ctzd = 327,
  Instruction_lvx_v2_ctzdp = 328,
  Instruction_lvx_v2_ctzho = 329,
  Instruction_lvx_v2_ctzw = 330,
  Instruction_lvx_v2_ctzwq = 331,
  Instruction_lvx_v2_d1inval = 332,
  Instruction_lvx_v2_dflushl = 333,
  Instruction_lvx_v2_dflushsw = 334,
  Instruction_lvx_v2_dinvall = 335,
  Instruction_lvx_v2_dinvalsw = 336,
  Instruction_lvx_v2_divmodd = 337,
  Instruction_lvx_v2_divmodud = 338,
  Instruction_lvx_v2_divmoduw = 339,
  Instruction_lvx_v2_divmodw = 340,
  Instruction_lvx_v2_dpurgel = 341,
  Instruction_lvx_v2_dpurgesw = 342,
  Instruction_lvx_v2_dtouchl = 343,
  Instruction_lvx_v2_eord = 344,
  Instruction_lvx_v2_eorq = 345,
  Instruction_lvx_v2_eorw = 346,
  Instruction_lvx_v2_errop = 347,
  Instruction_lvx_v2_extfs = 348,
  Instruction_lvx_v2_extfz = 349,
  Instruction_lvx_v2_extlqbho = 350,
  Instruction_lvx_v2_extlqhwq = 351,
  Instruction_lvx_v2_extlqnbx = 352,
  Instruction_lvx_v2_extlqwdp = 353,
  Instruction_lvx_v2_extlsbho = 354,
  Instruction_lvx_v2_extlshwq = 355,
  Instruction_lvx_v2_extlsnbx = 356,
  Instruction_lvx_v2_extlswdp = 357,
  Instruction_lvx_v2_extlzbho = 358,
  Instruction_lvx_v2_extlzhwq = 359,
  Instruction_lvx_v2_extlznbx = 360,
  Instruction_lvx_v2_extlzwdp = 361,
  Instruction_lvx_v2_fabsd = 362,
  Instruction_lvx_v2_fabsdp = 363,
  Instruction_lvx_v2_fabsh = 364,
  Instruction_lvx_v2_fabsho = 365,
  Instruction_lvx_v2_fabsw = 366,
  Instruction_lvx_v2_fabswp = 367,
  Instruction_lvx_v2_fabswq = 368,
  Instruction_lvx_v2_faddd = 369,
  Instruction_lvx_v2_fadddp = 370,
  Instruction_lvx_v2_faddh = 371,
  Instruction_lvx_v2_faddho = 372,
  Instruction_lvx_v2_faddw = 373,
  Instruction_lvx_v2_faddwc = 374,
  Instruction_lvx_v2_faddwq = 375,
  Instruction_lvx_v2_fclassd = 376,
  Instruction_lvx_v2_fclassh = 377,
  Instruction_lvx_v2_fclassw = 378,
  Instruction_lvx_v2_fclasswp = 379,
  Instruction_lvx_v2_fclasswq = 380,
  Instruction_lvx_v2_fcompd = 381,
  Instruction_lvx_v2_fcompdp = 382,
  Instruction_lvx_v2_fcomph = 383,
  Instruction_lvx_v2_fcompho = 384,
  Instruction_lvx_v2_fcompndp = 385,
  Instruction_lvx_v2_fcompnho = 386,
  Instruction_lvx_v2_fcompnwq = 387,
  Instruction_lvx_v2_fcompw = 388,
  Instruction_lvx_v2_fcompwq = 389,
  Instruction_lvx_v2_fdivd = 390,
  Instruction_lvx_v2_fdivh = 391,
  Instruction_lvx_v2_fdivw = 392,
  Instruction_lvx_v2_fence = 393,
  Instruction_lvx_v2_fextlhwq = 394,
  Instruction_lvx_v2_ffmad = 395,
  Instruction_lvx_v2_ffmadp = 396,
  Instruction_lvx_v2_ffmah = 397,
  Instruction_lvx_v2_ffmaho = 398,
  Instruction_lvx_v2_ffmaw = 399,
  Instruction_lvx_v2_ffmawc = 400,
  Instruction_lvx_v2_ffmawq = 401,
  Instruction_lvx_v2_ffmsd = 402,
  Instruction_lvx_v2_ffmsdp = 403,
  Instruction_lvx_v2_ffmsh = 404,
  Instruction_lvx_v2_ffmsho = 405,
  Instruction_lvx_v2_ffmsw = 406,
  Instruction_lvx_v2_ffmswq = 407,
  Instruction_lvx_v2_fixedd = 408,
  Instruction_lvx_v2_fixeddp = 409,
  Instruction_lvx_v2_fixeddw = 410,
  Instruction_lvx_v2_fixedho = 411,
  Instruction_lvx_v2_fixedud = 412,
  Instruction_lvx_v2_fixedudp = 413,
  Instruction_lvx_v2_fixedudw = 414,
  Instruction_lvx_v2_fixeduho = 415,
  Instruction_lvx_v2_fixeduw = 416,
  Instruction_lvx_v2_fixeduwd = 417,
  Instruction_lvx_v2_fixeduwp = 418,
  Instruction_lvx_v2_fixeduwq = 419,
  Instruction_lvx_v2_fixedw = 420,
  Instruction_lvx_v2_fixedwd = 421,
  Instruction_lvx_v2_fixedwp = 422,
  Instruction_lvx_v2_fixedwq = 423,
  Instruction_lvx_v2_floatd = 424,
  Instruction_lvx_v2_floatdp = 425,
  Instruction_lvx_v2_floatdw = 426,
  Instruction_lvx_v2_floatho = 427,
  Instruction_lvx_v2_floatud = 428,
  Instruction_lvx_v2_floatudp = 429,
  Instruction_lvx_v2_floatudw = 430,
  Instruction_lvx_v2_floatuho = 431,
  Instruction_lvx_v2_floatuw = 432,
  Instruction_lvx_v2_floatuwd = 433,
  Instruction_lvx_v2_floatuwp = 434,
  Instruction_lvx_v2_floatuwq = 435,
  Instruction_lvx_v2_floatw = 436,
  Instruction_lvx_v2_floatwd = 437,
  Instruction_lvx_v2_floatwp = 438,
  Instruction_lvx_v2_floatwq = 439,
  Instruction_lvx_v2_fmaxd = 440,
  Instruction_lvx_v2_fmaxdp = 441,
  Instruction_lvx_v2_fmaxh = 442,
  Instruction_lvx_v2_fmaxho = 443,
  Instruction_lvx_v2_fmaxnd = 444,
  Instruction_lvx_v2_fmaxndp = 445,
  Instruction_lvx_v2_fmaxnh = 446,
  Instruction_lvx_v2_fmaxnho = 447,
  Instruction_lvx_v2_fmaxnw = 448,
  Instruction_lvx_v2_fmaxnwq = 449,
  Instruction_lvx_v2_fmaxw = 450,
  Instruction_lvx_v2_fmaxwq = 451,
  Instruction_lvx_v2_fmind = 452,
  Instruction_lvx_v2_fmindp = 453,
  Instruction_lvx_v2_fminh = 454,
  Instruction_lvx_v2_fminho = 455,
  Instruction_lvx_v2_fminnd = 456,
  Instruction_lvx_v2_fminndp = 457,
  Instruction_lvx_v2_fminnh = 458,
  Instruction_lvx_v2_fminnho = 459,
  Instruction_lvx_v2_fminnw = 460,
  Instruction_lvx_v2_fminnwq = 461,
  Instruction_lvx_v2_fminw = 462,
  Instruction_lvx_v2_fminwq = 463,
  Instruction_lvx_v2_fmuld = 464,
  Instruction_lvx_v2_fmuldp = 465,
  Instruction_lvx_v2_fmulh = 466,
  Instruction_lvx_v2_fmulho = 467,
  Instruction_lvx_v2_fmulw = 468,
  Instruction_lvx_v2_fmulwc = 469,
  Instruction_lvx_v2_fmulwq = 470,
  Instruction_lvx_v2_fnarrowdw = 471,
  Instruction_lvx_v2_fnarrowdwq = 472,
  Instruction_lvx_v2_fnarrowwh = 473,
  Instruction_lvx_v2_fnarrowwhq = 474,
  Instruction_lvx_v2_fnegd = 475,
  Instruction_lvx_v2_fnegdp = 476,
  Instruction_lvx_v2_fnegh = 477,
  Instruction_lvx_v2_fnegho = 478,
  Instruction_lvx_v2_fnegw = 479,
  Instruction_lvx_v2_fnegwp = 480,
  Instruction_lvx_v2_fnegwq = 481,
  Instruction_lvx_v2_fractdwq = 482,
  Instruction_lvx_v2_fracthbx = 483,
  Instruction_lvx_v2_fractwho = 484,
  Instruction_lvx_v2_frcsr = 485,
  Instruction_lvx_v2_frflags = 486,
  Instruction_lvx_v2_frintd = 487,
  Instruction_lvx_v2_frinth = 488,
  Instruction_lvx_v2_frintw = 489,
  Instruction_lvx_v2_frrm = 490,
  Instruction_lvx_v2_fsbfd = 491,
  Instruction_lvx_v2_fsbfdp = 492,
  Instruction_lvx_v2_fsbfh = 493,
  Instruction_lvx_v2_fsbfho = 494,
  Instruction_lvx_v2_fsbfw = 495,
  Instruction_lvx_v2_fsbfwc = 496,
  Instruction_lvx_v2_fsbfwq = 497,
  Instruction_lvx_v2_fscsr = 498,
  Instruction_lvx_v2_fsflags = 499,
  Instruction_lvx_v2_fsignd = 500,
  Instruction_lvx_v2_fsigndp = 501,
  Instruction_lvx_v2_fsignh = 502,
  Instruction_lvx_v2_fsignho = 503,
  Instruction_lvx_v2_fsignmd = 504,
  Instruction_lvx_v2_fsignmdp = 505,
  Instruction_lvx_v2_fsignmh = 506,
  Instruction_lvx_v2_fsignmho = 507,
  Instruction_lvx_v2_fsignmw = 508,
  Instruction_lvx_v2_fsignmwq = 509,
  Instruction_lvx_v2_fsignnd = 510,
  Instruction_lvx_v2_fsignndp = 511,
  Instruction_lvx_v2_fsignnh = 512,
  Instruction_lvx_v2_fsignnho = 513,
  Instruction_lvx_v2_fsignnw = 514,
  Instruction_lvx_v2_fsignnwq = 515,
  Instruction_lvx_v2_fsignw = 516,
  Instruction_lvx_v2_fsignwq = 517,
  Instruction_lvx_v2_fsqrtd = 518,
  Instruction_lvx_v2_fsqrth = 519,
  Instruction_lvx_v2_fsqrtw = 520,
  Instruction_lvx_v2_fsrecd = 521,
  Instruction_lvx_v2_fsrecw = 522,
  Instruction_lvx_v2_fsrecwp = 523,
  Instruction_lvx_v2_fsrecwq = 524,
  Instruction_lvx_v2_fsrm = 525,
  Instruction_lvx_v2_fsrsrd = 526,
  Instruction_lvx_v2_fsrsrw = 527,
  Instruction_lvx_v2_fsrsrwp = 528,
  Instruction_lvx_v2_fsrsrwq = 529,
  Instruction_lvx_v2_fwidenhw = 530,
  Instruction_lvx_v2_fwidenhwq = 531,
  Instruction_lvx_v2_fwidenwd = 532,
  Instruction_lvx_v2_fwidenwdp = 533,
  Instruction_lvx_v2_get = 534,
  Instruction_lvx_v2_goto = 535,
  Instruction_lvx_v2_gotox = 536,
  Instruction_lvx_v2_guard = 537,
  Instruction_lvx_v2_i1inval = 538,
  Instruction_lvx_v2_i1invals = 539,
  Instruction_lvx_v2_icall = 540,
  Instruction_lvx_v2_iget = 541,
  Instruction_lvx_v2_igoto = 542,
  Instruction_lvx_v2_insf = 543,
  Instruction_lvx_v2_iord = 544,
  Instruction_lvx_v2_iornd = 545,
  Instruction_lvx_v2_iornq = 546,
  Instruction_lvx_v2_iornw = 547,
  Instruction_lvx_v2_iorq = 548,
  Instruction_lvx_v2_iorw = 549,
  Instruction_lvx_v2_landd = 550,
  Instruction_lvx_v2_landw = 551,
  Instruction_lvx_v2_lbs = 552,
  Instruction_lvx_v2_lbz = 553,
  Instruction_lvx_v2_ld = 554,
  Instruction_lvx_v2_lhs = 555,
  Instruction_lvx_v2_lhz = 556,
  Instruction_lvx_v2_liord = 557,
  Instruction_lvx_v2_liorw = 558,
  Instruction_lvx_v2_lnandd = 559,
  Instruction_lvx_v2_lnandw = 560,
  Instruction_lvx_v2_lniord = 561,
  Instruction_lvx_v2_lniorw = 562,
  Instruction_lvx_v2_lo = 563,
  Instruction_lvx_v2_loopdo = 564,
  Instruction_lvx_v2_lq = 565,
  Instruction_lvx_v2_lws = 566,
  Instruction_lvx_v2_lwz = 567,
  Instruction_lvx_v2_maddbho = 568,
  Instruction_lvx_v2_maddd = 569,
  Instruction_lvx_v2_madddp = 570,
  Instruction_lvx_v2_madddq = 571,
  Instruction_lvx_v2_madddt = 572,
  Instruction_lvx_v2_maddhwq = 573,
  Instruction_lvx_v2_maddsudt = 574,
  Instruction_lvx_v2_maddsuwd = 575,
  Instruction_lvx_v2_maddudt = 576,
  Instruction_lvx_v2_madduwd = 577,
  Instruction_lvx_v2_maddw = 578,
  Instruction_lvx_v2_maddwd = 579,
  Instruction_lvx_v2_maddwdp = 580,
  Instruction_lvx_v2_maddxbho = 581,
  Instruction_lvx_v2_maddxhwq = 582,
  Instruction_lvx_v2_maddxwdp = 583,
  Instruction_lvx_v2_make = 584,
  Instruction_lvx_v2_maxbx = 585,
  Instruction_lvx_v2_maxd = 586,
  Instruction_lvx_v2_maxdp = 587,
  Instruction_lvx_v2_maxho = 588,
  Instruction_lvx_v2_maxubx = 589,
  Instruction_lvx_v2_maxud = 590,
  Instruction_lvx_v2_maxudp = 591,
  Instruction_lvx_v2_maxuho = 592,
  Instruction_lvx_v2_maxuw = 593,
  Instruction_lvx_v2_maxuwq = 594,
  Instruction_lvx_v2_maxw = 595,
  Instruction_lvx_v2_maxwq = 596,
  Instruction_lvx_v2_minbx = 597,
  Instruction_lvx_v2_mind = 598,
  Instruction_lvx_v2_mindp = 599,
  Instruction_lvx_v2_minho = 600,
  Instruction_lvx_v2_minubx = 601,
  Instruction_lvx_v2_minud = 602,
  Instruction_lvx_v2_minudp = 603,
  Instruction_lvx_v2_minuho = 604,
  Instruction_lvx_v2_minuw = 605,
  Instruction_lvx_v2_minuwq = 606,
  Instruction_lvx_v2_minw = 607,
  Instruction_lvx_v2_minwq = 608,
  Instruction_lvx_v2_msbfbho = 609,
  Instruction_lvx_v2_msbfd = 610,
  Instruction_lvx_v2_msbfdp = 611,
  Instruction_lvx_v2_msbfdq = 612,
  Instruction_lvx_v2_msbfdt = 613,
  Instruction_lvx_v2_msbfhwq = 614,
  Instruction_lvx_v2_msbfsudt = 615,
  Instruction_lvx_v2_msbfsuwd = 616,
  Instruction_lvx_v2_msbfudt = 617,
  Instruction_lvx_v2_msbfuwd = 618,
  Instruction_lvx_v2_msbfw = 619,
  Instruction_lvx_v2_msbfwd = 620,
  Instruction_lvx_v2_msbfwdp = 621,
  Instruction_lvx_v2_msbfxbho = 622,
  Instruction_lvx_v2_msbfxhwq = 623,
  Instruction_lvx_v2_msbfxwdp = 624,
  Instruction_lvx_v2_mulbho = 625,
  Instruction_lvx_v2_muld = 626,
  Instruction_lvx_v2_muldp = 627,
  Instruction_lvx_v2_muldq = 628,
  Instruction_lvx_v2_muldt = 629,
  Instruction_lvx_v2_mulho = 630,
  Instruction_lvx_v2_mulhwq = 631,
  Instruction_lvx_v2_mulnbho = 632,
  Instruction_lvx_v2_mulnd = 633,
  Instruction_lvx_v2_mulndp = 634,
  Instruction_lvx_v2_mulndq = 635,
  Instruction_lvx_v2_mulnho = 636,
  Instruction_lvx_v2_mulnhwq = 637,
  Instruction_lvx_v2_mulnw = 638,
  Instruction_lvx_v2_mulnwd = 639,
  Instruction_lvx_v2_mulnwdp = 640,
  Instruction_lvx_v2_mulnwq = 641,
  Instruction_lvx_v2_mulnxbho = 642,
  Instruction_lvx_v2_mulnxhwq = 643,
  Instruction_lvx_v2_mulnxwdp = 644,
  Instruction_lvx_v2_mulsudt = 645,
  Instruction_lvx_v2_mulsuwd = 646,
  Instruction_lvx_v2_muludt = 647,
  Instruction_lvx_v2_muluwd = 648,
  Instruction_lvx_v2_mulw = 649,
  Instruction_lvx_v2_mulwd = 650,
  Instruction_lvx_v2_mulwdp = 651,
  Instruction_lvx_v2_mulwq = 652,
  Instruction_lvx_v2_mulxbho = 653,
  Instruction_lvx_v2_mulxhwq = 654,
  Instruction_lvx_v2_mulxwdp = 655,
  Instruction_lvx_v2_nandd = 656,
  Instruction_lvx_v2_nandq = 657,
  Instruction_lvx_v2_nandw = 658,
  Instruction_lvx_v2_negbx = 659,
  Instruction_lvx_v2_negd = 660,
  Instruction_lvx_v2_negdp = 661,
  Instruction_lvx_v2_negho = 662,
  Instruction_lvx_v2_negq = 663,
  Instruction_lvx_v2_negsbx = 664,
  Instruction_lvx_v2_negsd = 665,
  Instruction_lvx_v2_negsdp = 666,
  Instruction_lvx_v2_negsho = 667,
  Instruction_lvx_v2_negsw = 668,
  Instruction_lvx_v2_negswq = 669,
  Instruction_lvx_v2_negw = 670,
  Instruction_lvx_v2_negwq = 671,
  Instruction_lvx_v2_neord = 672,
  Instruction_lvx_v2_neorq = 673,
  Instruction_lvx_v2_neorw = 674,
  Instruction_lvx_v2_niord = 675,
  Instruction_lvx_v2_niorq = 676,
  Instruction_lvx_v2_niorw = 677,
  Instruction_lvx_v2_nop = 678,
  Instruction_lvx_v2_notd = 679,
  Instruction_lvx_v2_notq = 680,
  Instruction_lvx_v2_notw = 681,
  Instruction_lvx_v2_pcrel = 682,
  Instruction_lvx_v2_ret = 683,
  Instruction_lvx_v2_rfe = 684,
  Instruction_lvx_v2_rold = 685,
  Instruction_lvx_v2_rolw = 686,
  Instruction_lvx_v2_rolwq = 687,
  Instruction_lvx_v2_rord = 688,
  Instruction_lvx_v2_rorw = 689,
  Instruction_lvx_v2_rorwq = 690,
  Instruction_lvx_v2_rswap = 691,
  Instruction_lvx_v2_sb = 692,
  Instruction_lvx_v2_sbfbx = 693,
  Instruction_lvx_v2_sbfd = 694,
  Instruction_lvx_v2_sbfdp = 695,
  Instruction_lvx_v2_sbfho = 696,
  Instruction_lvx_v2_sbfq = 697,
  Instruction_lvx_v2_sbfsbx = 698,
  Instruction_lvx_v2_sbfsd = 699,
  Instruction_lvx_v2_sbfsdp = 700,
  Instruction_lvx_v2_sbfsho = 701,
  Instruction_lvx_v2_sbfsw = 702,
  Instruction_lvx_v2_sbfswq = 703,
  Instruction_lvx_v2_sbfusbx = 704,
  Instruction_lvx_v2_sbfusd = 705,
  Instruction_lvx_v2_sbfusdp = 706,
  Instruction_lvx_v2_sbfusho = 707,
  Instruction_lvx_v2_sbfusw = 708,
  Instruction_lvx_v2_sbfuswq = 709,
  Instruction_lvx_v2_sbfw = 710,
  Instruction_lvx_v2_sbfwq = 711,
  Instruction_lvx_v2_sbmm8 = 712,
  Instruction_lvx_v2_sbmm8d = 713,
  Instruction_lvx_v2_sbmm8dp = 714,
  Instruction_lvx_v2_sbmm8eord = 715,
  Instruction_lvx_v2_sbmm8eordp = 716,
  Instruction_lvx_v2_sbmmt8 = 717,
  Instruction_lvx_v2_sbmmt8d = 718,
  Instruction_lvx_v2_sbmmt8dp = 719,
  Instruction_lvx_v2_sbmmt8eord = 720,
  Instruction_lvx_v2_sbmmt8eordp = 721,
  Instruction_lvx_v2_scall = 722,
  Instruction_lvx_v2_sd = 723,
  Instruction_lvx_v2_set = 724,
  Instruction_lvx_v2_sh = 725,
  Instruction_lvx_v2_signbx = 726,
  Instruction_lvx_v2_signd = 727,
  Instruction_lvx_v2_signdp = 728,
  Instruction_lvx_v2_signho = 729,
  Instruction_lvx_v2_signsbx = 730,
  Instruction_lvx_v2_signsd = 731,
  Instruction_lvx_v2_signsdp = 732,
  Instruction_lvx_v2_signsho = 733,
  Instruction_lvx_v2_signsw = 734,
  Instruction_lvx_v2_signswq = 735,
  Instruction_lvx_v2_signw = 736,
  Instruction_lvx_v2_signwq = 737,
  Instruction_lvx_v2_sleep = 738,
  Instruction_lvx_v2_sllbx = 739,
  Instruction_lvx_v2_slld = 740,
  Instruction_lvx_v2_slldp = 741,
  Instruction_lvx_v2_sllho = 742,
  Instruction_lvx_v2_sllw = 743,
  Instruction_lvx_v2_sllwq = 744,
  Instruction_lvx_v2_slsbx = 745,
  Instruction_lvx_v2_slsd = 746,
  Instruction_lvx_v2_slsdp = 747,
  Instruction_lvx_v2_slsho = 748,
  Instruction_lvx_v2_slsw = 749,
  Instruction_lvx_v2_slswq = 750,
  Instruction_lvx_v2_slusbx = 751,
  Instruction_lvx_v2_slusd = 752,
  Instruction_lvx_v2_slusdp = 753,
  Instruction_lvx_v2_slusho = 754,
  Instruction_lvx_v2_slusw = 755,
  Instruction_lvx_v2_sluswq = 756,
  Instruction_lvx_v2_so = 757,
  Instruction_lvx_v2_sq = 758,
  Instruction_lvx_v2_srabx = 759,
  Instruction_lvx_v2_srad = 760,
  Instruction_lvx_v2_sradp = 761,
  Instruction_lvx_v2_sraho = 762,
  Instruction_lvx_v2_sraw = 763,
  Instruction_lvx_v2_srawq = 764,
  Instruction_lvx_v2_srlbx = 765,
  Instruction_lvx_v2_srld = 766,
  Instruction_lvx_v2_srldp = 767,
  Instruction_lvx_v2_srlho = 768,
  Instruction_lvx_v2_srlw = 769,
  Instruction_lvx_v2_srlwq = 770,
  Instruction_lvx_v2_srsbx = 771,
  Instruction_lvx_v2_srsd = 772,
  Instruction_lvx_v2_srsdp = 773,
  Instruction_lvx_v2_srsho = 774,
  Instruction_lvx_v2_srsw = 775,
  Instruction_lvx_v2_srswq = 776,
  Instruction_lvx_v2_stop = 777,
  Instruction_lvx_v2_stsud = 778,
  Instruction_lvx_v2_stsudp = 779,
  Instruction_lvx_v2_stsuho = 780,
  Instruction_lvx_v2_stsuw = 781,
  Instruction_lvx_v2_stsuwq = 782,
  Instruction_lvx_v2_sw = 783,
  Instruction_lvx_v2_sxbd = 784,
  Instruction_lvx_v2_sxhd = 785,
  Instruction_lvx_v2_sxwd = 786,
  Instruction_lvx_v2_syncgroup = 787,
  Instruction_lvx_v2_tlbdinval = 788,
  Instruction_lvx_v2_tlbiinval = 789,
  Instruction_lvx_v2_tlbprobe = 790,
  Instruction_lvx_v2_tlbread = 791,
  Instruction_lvx_v2_tlbwrite = 792,
  Instruction_lvx_v2_truncdwq = 793,
  Instruction_lvx_v2_trunchbx = 794,
  Instruction_lvx_v2_truncwho = 795,
  Instruction_lvx_v2_waitit = 796,
  Instruction_lvx_v2_wfxl = 797,
  Instruction_lvx_v2_wfxm = 798,
  Instruction_lvx_v2_widenqbho = 799,
  Instruction_lvx_v2_widenqhwq = 800,
  Instruction_lvx_v2_widenqwdp = 801,
  Instruction_lvx_v2_widensbho = 802,
  Instruction_lvx_v2_widenshwq = 803,
  Instruction_lvx_v2_widenswdp = 804,
  Instruction_lvx_v2_widenzbho = 805,
  Instruction_lvx_v2_widenzhwq = 806,
  Instruction_lvx_v2_widenzwdp = 807,
  Instruction_lvx_v2_xaccesso = 808,
  Instruction_lvx_v2_xaligno = 809,
  Instruction_lvx_v2_xcopyo = 810,
  Instruction_lvx_v2_xlo = 811,
  Instruction_lvx_v2_xmovefd = 812,
  Instruction_lvx_v2_xmovefo = 813,
  Instruction_lvx_v2_xmovefq = 814,
  Instruction_lvx_v2_xmovetd = 815,
  Instruction_lvx_v2_xmoveto = 816,
  Instruction_lvx_v2_xmovetq = 817,
  Instruction_lvx_v2_xplb = 818,
  Instruction_lvx_v2_xpld = 819,
  Instruction_lvx_v2_xplh = 820,
  Instruction_lvx_v2_xplo = 821,
  Instruction_lvx_v2_xplq = 822,
  Instruction_lvx_v2_xplw = 823,
  Instruction_lvx_v2_xso = 824,
  Instruction_lvx_v2_zxbd = 825,
  Instruction_lvx_v2_zxhd = 826,
  Instruction_lvx_v2_zxwd = 827,
  Separator_lvx_v2_comma = 828,
  Separator_lvx_v2_equal = 829,
  Separator_lvx_v2_qmark = 830,
  Separator_lvx_v2_rsbracket = 831,
  Separator_lvx_v2_lsbracket = 832
};

typedef enum {
  Modifier_lvx_v2_exunum_ALU0=0,
  Modifier_lvx_v2_exunum_ALU1=1,
  Modifier_lvx_v2_exunum_LSU0=2,
  Modifier_lvx_v2_exunum_LSU1=3,
} Modifier_lvx_v2_exunum_values;


extern const char *mod_lvx_v2_exunum[];
extern const char *mod_lvx_v2_ccbcomp[];
extern const char *mod_lvx_v2_bcucond[];
extern const char *mod_lvx_v2_intcomp[];
extern const char *mod_lvx_v2_lanecond[];
extern const char *mod_lvx_v2_lanetodo[];
extern const char *mod_lvx_v2_lanesize[];
extern const char *mod_lvx_v2_floatcomp[];
extern const char *mod_lvx_v2_floatmode[];
extern const char *mod_lvx_v2_signextw[];
extern const char *mod_lvx_v2_highmult[];
extern const char *mod_lvx_v2_widemult[];
extern const char *mod_lvx_v2_mostsig[];
extern const char *mod_lvx_v2_oddlanes[];
extern const char *mod_lvx_v2_ziplanes[];
extern const char *mod_lvx_v2_fnegate[];
extern const char *mod_lvx_v2_variant[];
extern const char *mod_lvx_v2_speculate[];
extern const char *mod_lvx_v2_doscale[];
extern const char *mod_lvx_v2_qindex[];
extern const char *mod_lvx_v2_hindex[];
extern const char *mod_lvx_v2_cachelev[];
extern const char *mod_lvx_v2_coherency[];
extern const char *mod_lvx_v2_boolcas[];
extern const char *mod_lvx_v2_accesses[];
extern const char *mod_lvx_v2_channel[];
extern const char *mod_lvx_v2_conjugate[];
extern const char *mod_lvx_v2_imultiply[];
extern const char *mod_lvx_v2_realimag[];
extern const char *mod_lvx_v2_shuffleV[];
extern const char *mod_lvx_v2_shuffleX[];
extern const char *mod_lvx_v2_splat32[];

typedef enum {
  Bundling_lvx_v2_ALL,
  Bundling_lvx_v2_BCU2,
  Bundling_lvx_v2_BCU2_X,
  Bundling_lvx_v2_BCU0,
  Bundling_lvx_v2_BCU,
  Bundling_lvx_v2_FULL,
  Bundling_lvx_v2_FULL_X,
  Bundling_lvx_v2_FULL_Y,
  Bundling_lvx_v2_LITE,
  Bundling_lvx_v2_LITE_X,
  Bundling_lvx_v2_LITE_Y,
  Bundling_lvx_v2_LSU0,
  Bundling_lvx_v2_LSU0_X,
  Bundling_lvx_v2_LSU0_Y,
  Bundling_lvx_v2_LSU,
  Bundling_lvx_v2_LSU_X,
  Bundling_lvx_v2_LSU_Y,
  Bundling_lvx_v2_TINY,
  Bundling_lvx_v2_TINY_X,
  Bundling_lvx_v2_TINY_Y,
  Bundling_lvx_v2_EXT,
  Bundling_lvx_v2_NOP,
} Bundling_lvx_v2;

static int ATTRIBUTE_UNUSED
lvx_v2_base_bundling(int bundling) {
  static int base_bundlings[] = {
    Bundling_lvx_v2_ALL,	// Bundling_lvx_v2_ALL
    Bundling_lvx_v2_BCU2,	// Bundling_lvx_v2_BCU2
    Bundling_lvx_v2_BCU2,	// Bundling_lvx_v2_BCU2_X
    Bundling_lvx_v2_BCU0,	// Bundling_lvx_v2_BCU0
    Bundling_lvx_v2_BCU,	// Bundling_lvx_v2_BCU
    Bundling_lvx_v2_FULL,	// Bundling_lvx_v2_FULL
    Bundling_lvx_v2_FULL,	// Bundling_lvx_v2_FULL_X
    Bundling_lvx_v2_FULL,	// Bundling_lvx_v2_FULL_Y
    Bundling_lvx_v2_LITE,	// Bundling_lvx_v2_LITE
    Bundling_lvx_v2_LITE,	// Bundling_lvx_v2_LITE_X
    Bundling_lvx_v2_LITE,	// Bundling_lvx_v2_LITE_Y
    Bundling_lvx_v2_LSU0,	// Bundling_lvx_v2_LSU0
    Bundling_lvx_v2_LSU0,	// Bundling_lvx_v2_LSU0_X
    Bundling_lvx_v2_LSU0,	// Bundling_lvx_v2_LSU0_Y
    Bundling_lvx_v2_LSU,	// Bundling_lvx_v2_LSU
    Bundling_lvx_v2_LSU,	// Bundling_lvx_v2_LSU_X
    Bundling_lvx_v2_LSU,	// Bundling_lvx_v2_LSU_Y
    Bundling_lvx_v2_TINY,	// Bundling_lvx_v2_TINY
    Bundling_lvx_v2_TINY,	// Bundling_lvx_v2_TINY_X
    Bundling_lvx_v2_TINY,	// Bundling_lvx_v2_TINY_Y
    Bundling_lvx_v2_EXT,	// Bundling_lvx_v2_EXT
    Bundling_lvx_v2_NOP,	// Bundling_lvx_v2_NOP
  };
  return base_bundlings[bundling];
};

typedef enum {
  Resource_lvx_v2_ISSUE,
  Resource_lvx_v2_TINY,
  Resource_lvx_v2_LITE,
  Resource_lvx_v2_FULL,
  Resource_lvx_v2_LSU,
  Resource_lvx_v2_MAU,
  Resource_lvx_v2_BCU,
  Resource_lvx_v2_EXT,
  Resource_lvx_v2_AUXR,
  Resource_lvx_v2_AUXW,
  Resource_lvx_v2_XFER,
  Resource_lvx_v2_MEMW,
  Resource_lvx_v2_SR12,
  Resource_lvx_v2_SR13,
  Resource_lvx_v2_SR14,
  Resource_lvx_v2_SR15,
} Resource_lvx_v2;
#define lvx_v2_RESOURCE_COUNT 16

typedef enum {
  Reservation_lvx_v2_ALL,
  Reservation_lvx_v2_ALU_TINY,
  Reservation_lvx_v2_ALU_TINY_X,
  Reservation_lvx_v2_ALU_TINY_Y,
  Reservation_lvx_v2_ALU_TINY_AUXR,
  Reservation_lvx_v2_ALU_LITE,
  Reservation_lvx_v2_ALU_LITE_X,
  Reservation_lvx_v2_ALU_LITE_Y,
  Reservation_lvx_v2_ALU_LITE_MISC,
  Reservation_lvx_v2_ALU_FULL,
  Reservation_lvx_v2_ALU_FULL_X,
  Reservation_lvx_v2_ALU_FULL_Y,
  Reservation_lvx_v2_BCU,
  Reservation_lvx_v2_BCU_BRRP,
  Reservation_lvx_v2_BCU_BRRP2,
  Reservation_lvx_v2_BCU2,
  Reservation_lvx_v2_BCU2_X,
  Reservation_lvx_v2_BCU_XFER,
  Reservation_lvx_v2_BCU_XFER_BRRP,
  Reservation_lvx_v2_BCU2_TINY_LSU,
  Reservation_lvx_v2_LSU,
  Reservation_lvx_v2_LSU_X,
  Reservation_lvx_v2_LSU_Y,
  Reservation_lvx_v2_LSU_MEMW_ACCR,
  Reservation_lvx_v2_LSU_MEMW_ACCR_X,
  Reservation_lvx_v2_LSU_MEMW_ACCR_Y,
  Reservation_lvx_v2_LSU2_MEMW,
  Reservation_lvx_v2_LSU2_MEMW_X,
  Reservation_lvx_v2_LSU2_MEMW_Y,
  Reservation_lvx_v2_LSU_AUXR,
  Reservation_lvx_v2_LSU_AUXR_X,
  Reservation_lvx_v2_LSU_AUXR_Y,
  Reservation_lvx_v2_LSU_MEMW_AUXR,
  Reservation_lvx_v2_LSU_MEMW_AUXR_X,
  Reservation_lvx_v2_LSU_MEMW_AUXR_Y,
  Reservation_lvx_v2_LSU2_MEMW_AUXR,
  Reservation_lvx_v2_LSU2_MEMW_AUXR_X,
  Reservation_lvx_v2_LSU2_MEMW_AUXR_Y,
  Reservation_lvx_v2_LSU_MEMW_AUXW,
  Reservation_lvx_v2_LSU_MEMW_AUXW_X,
  Reservation_lvx_v2_LSU_MEMW_AUXW_Y,
  Reservation_lvx_v2_LSU2_MEMW_AUXW,
  Reservation_lvx_v2_LSU2_MEMW_AUXW_X,
  Reservation_lvx_v2_LSU2_MEMW_AUXW_Y,
  Reservation_lvx_v2_LSU_AUXW,
  Reservation_lvx_v2_LSU_AUXW_X,
  Reservation_lvx_v2_LSU_AUXW_Y,
  Reservation_lvx_v2_LSU_AUXR_AUXW,
  Reservation_lvx_v2_LSU_AUXR_AUXW_X,
  Reservation_lvx_v2_LSU_AUXR_AUXW_Y,
  Reservation_lvx_v2_LSU2_MEMW_AUXR_AUXW,
  Reservation_lvx_v2_LSU2_MEMW_AUXR_AUXW_X,
  Reservation_lvx_v2_LSU2_MEMW_AUXR_AUXW_Y,
  Reservation_lvx_v2_MAU,
  Reservation_lvx_v2_EXT,
  Reservation_lvx_v2_EXT_COMP,
  Reservation_lvx_v2_EXT_MISC,
  Reservation_lvx_v2_EXT_MISC_AUXW,
} Reservation_lvx_v2;

extern struct lvx_reloc lvx_v2_rel16_reloc;
extern struct lvx_reloc lvx_v2_rel32_reloc;
extern struct lvx_reloc lvx_v2_rel64_reloc;
extern struct lvx_reloc lvx_v2_pcrel_signed16_reloc;
extern struct lvx_reloc lvx_v2_pcrel32_reloc;
extern struct lvx_reloc lvx_v2_pcrel_signed37_reloc;
extern struct lvx_reloc lvx_v2_pcrel_signed43_reloc;
extern struct lvx_reloc lvx_v2_pcrel_signed64_reloc;
extern struct lvx_reloc lvx_v2_pcrel64_reloc;
extern struct lvx_reloc lvx_v2_signed16_reloc;
extern struct lvx_reloc lvx_v2_signed32_reloc;
extern struct lvx_reloc lvx_v2_signed37_reloc;
extern struct lvx_reloc lvx_v2_gotoff_signed37_reloc;
extern struct lvx_reloc lvx_v2_gotoff_signed43_reloc;
extern struct lvx_reloc lvx_v2_gotoff_32_reloc;
extern struct lvx_reloc lvx_v2_gotoff_64_reloc;
extern struct lvx_reloc lvx_v2_got_32_reloc;
extern struct lvx_reloc lvx_v2_got_signed37_reloc;
extern struct lvx_reloc lvx_v2_got_signed43_reloc;
extern struct lvx_reloc lvx_v2_got_64_reloc;
extern struct lvx_reloc lvx_v2_glob_dat_reloc;
extern struct lvx_reloc lvx_v2_copy_reloc;
extern struct lvx_reloc lvx_v2_jump_slot_reloc;
extern struct lvx_reloc lvx_v2_relative_reloc;
extern struct lvx_reloc lvx_v2_signed43_reloc;
extern struct lvx_reloc lvx_v2_signed64_reloc;
extern struct lvx_reloc lvx_v2_gotaddr_signed37_reloc;
extern struct lvx_reloc lvx_v2_gotaddr_signed43_reloc;
extern struct lvx_reloc lvx_v2_gotaddr_signed64_reloc;
extern struct lvx_reloc lvx_v2_dtpmod64_reloc;
extern struct lvx_reloc lvx_v2_dtpoff64_reloc;
extern struct lvx_reloc lvx_v2_dtpoff_signed37_reloc;
extern struct lvx_reloc lvx_v2_dtpoff_signed43_reloc;
extern struct lvx_reloc lvx_v2_tlsgd_signed37_reloc;
extern struct lvx_reloc lvx_v2_tlsgd_signed43_reloc;
extern struct lvx_reloc lvx_v2_tlsld_signed37_reloc;
extern struct lvx_reloc lvx_v2_tlsld_signed43_reloc;
extern struct lvx_reloc lvx_v2_tpoff64_reloc;
extern struct lvx_reloc lvx_v2_tlsie_signed37_reloc;
extern struct lvx_reloc lvx_v2_tlsie_signed43_reloc;
extern struct lvx_reloc lvx_v2_tlsle_signed37_reloc;
extern struct lvx_reloc lvx_v2_tlsle_signed43_reloc;
extern struct lvx_reloc lvx_v2_rel8_reloc;
extern struct lvx_reloc lvx_v2_pcrel11s2_reloc;
extern struct lvx_reloc lvx_v2_pcrel17s2_reloc;
extern struct lvx_reloc lvx_v2_pcrel27s2_reloc;
extern struct lvx_reloc lvx_v2_pcrel38s2_reloc;
extern struct lvx_reloc lvx_v2_pcrel44s2_reloc;
extern struct lvx_reloc lvx_v2_pcrel54s2_reloc;


#endif /* OPCODE_LVX_H */
