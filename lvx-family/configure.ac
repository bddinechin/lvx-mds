dnl Process this file with autoconf to produce a configure script.
dnl Author Benoit Dupont de Dinechin (Benoit.Dupont-de-Dinechin@st.com).

AC_INIT
AC_CONFIG_SRCDIR([configure.ac])

TOPDIR=`(cd .; pwd )`
FAMDIR=`(cd $srcdir; pwd )`
ABSPATH=`echo "$(cd "$(dirname "$FAMDIR")"; pwd)/$(basename "$FAMDIR")"`

AC_ARG_WITH([mds],
  [AS_HELP_STRING([--with-mds],[Set MDS path (to <mds repo>/MDS).])],
  [],
  [with_mds="$srcdir/../MDS"])

function mds_error {
  echo "ERROR: You have to set a valid MDS path using --with-mds option (see --help). Current is '$with_mds'"
  exit -1
}

$with_mds/configure --help > /dev/null 2>&1 || mds_error

# Set default target to lvx (if not set)
if test -z "$target_alias"; then
  target_alias=lvx
fi

case $target_alias in
  lvx )
    family="lvx"
    target="^target^"
    with_cores="lvx_v1 lvx_v2"
    enable_tools="TEX GBU GDB GCC LAO LIBC"
    ;;
  *)
    AC_MSG_ERROR([target $target_alias unknown!])
    ;;
esac
if test -z "$enable_tools"; then
  enable_tools=""
fi
if test "$enable_tools" == "yes"; then
  enable_tools="TEX GBU GDB GCC LAO LIBC"
fi

AC_ARG_ENABLE([avp],
  [AS_HELP_STRING([--enable-avp],[Build auto-tests using AVP backend.])],
  [],
  [])

if test "$enable_avp" = "yes"; then
   enable_tools+=" AVP"
fi

AC_ARG_ENABLE([mdf],
  [AS_HELP_STRING([--enable-mdf],[Enable MDF merged mds.])],
  [],
  [enable_mdf=yes])

if test "$enable_mdf" = "yes"; then
  MDF_ENABLED=yes
else
  MDF_ENABLED=
fi

FAMILY=`echo $family | tr 'A-Z' 'a-z'`
CORES=`echo $with_cores | tr 'A-Z' 'a-z'`
TOOLS=`echo $enable_tools | tr 'a-z' 'A-Z'`
FEDIR=FE/YAML

AC_ARG_WITH([arch_path],
  [AS_HELP_STRING([--with-arch-path],[Set Architecture description path])],
  [ARCHDIR="$with_arch_path"],
  [ARCHDIR="$ABSPATH"])
AC_SUBST(ARCHDIR)

AC_ARG_WITH([lao_path],
  [AS_HELP_STRING([--with-lao-path],[Set LAO path.])],
  [LAODIR="$with_lao_path"],
  [LAODIR="$ABSPATH/BE"])
AC_SUBST(LAODIR)

AC_ARG_WITH([iss_path],
  [AS_HELP_STRING([--with-iss-path],[Set ISS path.])],
  [ISSDIR="$with_iss_path"],
  [ISSDIR="$ABSPATH/BE"])
AC_SUBST(ISSDIR)

AC_ARG_WITH([binutils_prefix],
  [AS_HELP_STRING([--with-binutils-prefix],[Set BINUTILS prefix for install])],
  [BINUTILSDIR="$with_binutils_prefix"],
  [BINUTILSDIR="$ABSPATH/BE"])
AC_SUBST(BINUTILSDIR)

AC_ARG_WITH([gdb_prefix],
  [AS_HELP_STRING([--with-gdb-prefix],[Set GDB prefix for install])],
  [GDBDIR="$with_gdb_prefix"],
  [GDBDIR="$ABSPATH/BE"])
AC_SUBST(GDBDIR)

AC_ARG_WITH([mppadl_prefix],
  [AS_HELP_STRING([--with-mppadl-prefix],[Set MPPADL prefix for install])],
  [MPPADLDIR="$with_mppadl_prefix"],
  [MPPADLDIR="$ABSPATH/BE"])
AC_SUBST(MPPADLDIR)

AC_ARG_WITH([o64_prefix],
  [AS_HELP_STRING([--with-o64-prefix],[Set O64 prefix for install])],
  [O64DIR="$with_o64_prefix"],
  [O64DIR="$ABSPATH/BE"])
AC_SUBST(O64DIR)

AC_ARG_WITH([gcc_prefix],
  [AS_HELP_STRING([--with-gcc-prefix],[Set GCC prefix for install])],
  [GCCDIR="$with_gcc_prefix"],
  [GCCDIR="$ABSPATH/BE"])
AC_SUBST(GCCDIR)

AC_ARG_WITH([newlib_prefix],
  [AS_HELP_STRING([--with-newlib-prefix],[Set NEWLIB prefix for install])],
  [NEWLIBDIR="$with_newlib_prefix"],
  [NEWLIBDIR="$ABSPATH/BE"])
AC_SUBST(NEWLIBDIR)

AC_ARG_WITH([llvm_prefix],
  [AS_HELP_STRING([--with-llvm-prefix],[Set LLVM prefix for install])],
  [LLVMDIR="$with_llvm_prefix"],
  [LLVMDIR="$ABSPATH/BE"])
AC_SUBST(LLVMDIR)

AC_ARG_WITH([avp_prefix],
  [AS_HELP_STRING([--with-avp-prefix],[Set AVP prefix for install])],
  [AVPDIR="$with_avp_prefix"],
  [AVPDIR="$ABSPATH/BE"])
AC_SUBST(AVPDIR)

AC_ARG_WITH([tex_valid_prefix],
  [AS_HELP_STRING([--with-tex-valid-prefix],[Set TEX valid prefix for install])],
  [TEXDIR="$with_tex_valid_prefix"],
  [TEXDIR="$ABSPATH/BE"])
AC_SUBST(TEXDIR)

AC_ARG_WITH([hwtest_valid_prefix],
  [AS_HELP_STRING([--with-hwtest-valid-prefix],[Set HW_TEST valid prefix for install])],
  [HWTESTDIR="$with_tex_valid_prefix"],
  [HWTESTDIR="$ABSPATH/BE"])
AC_SUBST(HWTESTDIR)

AC_SUBST(FAMDIR)
AC_SUBST(TOPDIR)
AC_SUBST(FAMILY)
AC_SUBST(CORES)

AC_CONFIG_FILES([FE/YAML/lvx/Makefile
])
AC_OUTPUT


function run_with_config()
{
  "$@" TOPDIR="$TOPDIR" ARCHDIR="$ARCHDIR" \
    FAMDIR="$FAMDIR" FAMILY="$FAMILY" CORES="$CORES" MDF_ENABLED="$MDF_ENABLED"\
    TOOLS="$TOOLS" FEDIR="$FEDIR" \
    GDBDIR="$GDBDIR" BINUTILSDIR="$BINUTILSDIR" MPPADLDIR="$MPPADLDIR" \
    GCCDIR="$GCCDIR" NEWLIBDIR="$NEWLIBDIR" ISSDIR="$ISSDIR" LLVMDIR="$LLVMDIR" LAODIR="$LAODIR" \
    TEXDIR="$TEXDIR" HWTESTDIR="$HWTESTDIR"
}
run_with_config echo $with_mds/configure
HWTESTADIR="$HWTESTADIR"
run_with_config $with_mds/configure


