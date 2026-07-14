dnl Process this file with autoconf to produce a configure script.
dnl Author Benoit Dupont de Dinechin (Benoit.Dupont-de-Dinechin@st.com).

AC_INIT
AC_CONFIG_SRCDIR([configure.ac])

AC_PROG_INSTALL

AC_PATH_PROG(OSX,osx)
if test -z "$OSX"; then
  AC_MSG_ERROR([osx (OpenSP) is needed for make check!])
fi

AC_PATH_PROG(PERL,perl)
if test -z "$PERL"; then
  AC_MSG_ERROR([perl is required!])
fi

AC_PATH_PROG(BISON,bison)
if test -z "$BISON"; then
  AC_MSG_ERROR([bison is required!])
fi

AC_PATH_PROG(RUBY,ruby)
if test -z "$RUBY"; then
  AC_MSG_ERROR([ruby is required!])
fi

MDSDIR=`(cd $srcdir; pwd )`

AC_ARG_WITH([iss_path],
	[AS_HELP_STRING([--with-iss-path],[Set ISS path.])],
	[ISSDIR="$with_iss_path"],
	[])
AC_SUBST(ISSDIR)


echo -e "TOPDIR=\t$TOPDIR"
echo -e "FAMDIR=\t$FAMDIR"
echo -e "ARCHDIR=\t$ARCHDIR"
echo -e "REFDIR=\t$REFDIR"
echo -e "MDSDIR=\t$MDSDIR"
echo -e "FAMILY=\t$FAMILY"
echo -e "CORES=\t$CORES"
echo -e "TOOLS=\t$TOOLS"
echo -e "FEDIR=\t$FEDIR"
echo -e "TDESC_NAMESPACE=\t$TDESC_NAMESPACE"
echo -e "MPPADLDIR=\t$MPPADLDIR"
echo -e "AVPDIR=\t$AVPDIR"
echo -e "GDBDIR=\t$GDBDIR"
echo -e "BINUTILSDIR=\t$BINUTILSDIR"
echo -e "GCCDIR=\t$GCCDIR"
echo -e "NEWLIBDIR=\t$NEWLIBDIR"
echo -e "LLVMDIR=\t$LLVMDIR"
echo -e "ISSDIR=\t$ISSDIR"
echo -e "LAODIR=\t$LAODIR"
echo -e "GEM5DIR=\t$GEM5DIR"
echo -e "TEXDIR=\t$TEXDIR"
echo -e "MDF_ENABLED=\t$MDF_ENABLED"

AC_SUBST(TOPDIR)
AC_SUBST(FAMDIR)
AC_SUBST(ARCHDIR)
AC_SUBST(REFDIR)
AC_SUBST(MDSDIR)
AC_SUBST(FAMILY)
AC_SUBST(CORES)
AC_SUBST(TOOLS)
AC_SUBST(FEDIR)
AC_SUBST(TDESC_NAMESPACE)
AC_SUBST(MPPADLDIR)
AC_SUBST(AVPDIR)
AC_SUBST(GDBDIR)
AC_SUBST(BINUTILSDIR)
AC_SUBST(GCCDIR)
AC_SUBST(NEWLIBDIR)
AC_SUBST(LLVMDIR)
AC_SUBST(LAODIR)
AC_SUBST(GEM5DIR)
AC_SUBST(TEXDIR)
AC_SUBST(HWTESTDIR)
AC_SUBST(MDF_ENABLED)

dnl Machine Description Database tables.
dnl (Need to list in topological order of dependencies.)
MDD_names=" \
  Platform.table \
  NativeType.table \
  Storage.table \
  Helper.table \
  RegField.table \
  Register.table \
  BitField.table \
  Operand.table \
  Modifier.table \
  Relocation.table \
  Immediate.table \
  RegClass.table \
  RegMask.table \
  Format.table \
  Pattern.table \
  Encoding.table \
  Instruction.table \
  Builtin.table \
  Synthetic.table \
  Simulated.table \
  Generic.table \
  Template.table \
  Dispersal.table \
  Bundling.table \
  Resource.table \
  Scheduling.table \
  Reservation.table \
  Processor.table \
  Convention.table \
"
AC_SUBST(MDD_names)

dnl Machine Description Expanded tables.
dnl (Need to list in topological order of dependencies.)
MDE_names=" \
  Synthetic.X.table \
  Instruction.X.table \
  Access.table \
  Pattern.X.table \
  Opcode.table \
  Decoding.table \
  Template.X.table \
  Bundle.table \
  Operator.table \
  Opcode.X.table \
  Register.X.table \
"
AC_SUBST(MDE_names)

dnl Machine Description Target-level tables (merged between cores).
dnl (Need to list in topological order of dependencies.)
MDT_names=" \
  Processor.table \
  Platform.table \
  NativeType.table \
  Storage.table \
  BitField.table \
  Modifier.table \
  Immediate.table \
  Relocation.table \
  RegField.table \
  Register.table \
  RegClass.table \
  Register.X.table \
  RegMask.table \
  Convention.table \
  Pattern.table \
  Pattern.X.table \
  Template.table \
  Template.X.table \
  Dispersal.table \
  Bundling.table \
  Resource.table \
  Reservation.table \
  Scheduling.table \
  Access.table \
  Bundle.table \
  Encoding.table \
  Operand.table \
  Format.table \
  Instruction.table \
  Synthetic.table \
  Instruction.X.table \
  Synthetic.X.table \
  Opcode.table \
  Decoding.table \
  Opcode.X.table \
  Generic.table \
  Operator.table \
  Builtin.table \
"
AC_SUBST(MDT_names)

AC_CONFIG_FILES([Makefile Makerules FE/Makerules MDD/Makerules BE/Makerules \
  DOC/Makefile FE/YAML/Makefile MDD/MDE/Makefile MDD/MDF/Makefile \
  BE/GBU/Makefile BE/GDB/Makefile BE/GCC/Makefile BE/MPPADL/Makefile \
  BE/LAO/Makefile BE/TEX/Makefile BE/LIBC/Makefile BE/AVP/Makefile BE/GEM5/Makefile
])
AC_OUTPUT

