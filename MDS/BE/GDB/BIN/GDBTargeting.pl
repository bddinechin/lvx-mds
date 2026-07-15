#!/usr/bin/perl -w
# Machine Description System (MDS)
#
# Generate the GDB target-description tdep (<FAMILY>-mds-tdep.c) from the MDS tables.
#
# Perl port of the Ruby GDBTargeting.rb (+ its Registers.rb helper), using the shared
# MDS.pm object model instead of a second one in Ruby.  Verified byte-identical against
# the reference the Ruby produced (refs/BE/GDB/lvx/lvx-mds-tdep.c).
#
# The register/regfile/storage/processor/convention model, and the two derived facts the
# Ruby computed in Registers.rb -- a storage's address->register map (GDBStorage) and a
# register's owning regfile when it does not name one (GDBRegister) -- are reproduced here.

use strict;
use Carp;
use MDS;

my $family = $ENV{FAMILY};
my $tdesc_namespace = $ENV{TDESC_NAMESPACE} || 'eu.kalray';

&MDS::parse(*ARGV);

# Storage kind enum, in the order the Ruby MDS gives it (the GCC backend relies on it).
my %KIND = (Register => 0, Constant => 1, Control => 2, Special => 3, Memory => 4, Neighbor => 5);
my $MEMORY = 4;

################################################################################
# Model helpers -- one per Ruby accessor the generator uses.

# A register's display names, with a leading '$' stripped (GDBRegister#names).
sub reg_names {
    my ($reg) = @_;
    return map { substr($_, 0, 1) eq '$' ? substr($_, 1) : $_ } split ' ', $reg->attribute("names");
}
# A register's storage addresses, as integers (Register#addresses).
sub reg_addresses { return map { $_ + 0 } split ' ', $_[0]->attribute("addresses"); }
sub reg_width     { return ($_[0]->attribute("width")  || 0) + 0; }
sub reg_dwarf     { my $d = $_[0]->attribute("dwarfId"); return defined $d ? $d + 0 : undef; }
sub reg_core      { return (split /-/, $_[0]->attribute("ID"))[1]; }   # base Mds cores[0]

sub sto_width { return ($_[0]->attribute("width") || 0) + 0; }
sub sto_count { return ($_[0]->attribute("count") || 0) + 0; }
sub sto_kind  { return $KIND{$_[0]->attribute("kind")}; }

# Is $proc among $obj's processors? (Ruby: obj.processors.index(processor))
sub has_processor {
    my ($obj, $proc_id) = @_;
    return grep { $_->attribute("ID") eq $proc_id } $obj->access("processors");
}

# A register's owning regfile ID: the regFile it names, or -- GDBRegister#initialize -- the
# first non-empty regfile whose register list contains it.
my %RegFileOf;
sub reg_regfile {
    my ($reg) = @_;
    my $id = $reg->attribute("ID");
    return $RegFileOf{$id} if exists $RegFileOf{$id};
    my $rf = $reg->attribute("regFile");
    if (!defined $rf || $rf eq '') {
        $rf = undef;
        foreach my $regfile (&MDS::regFiles()) {
            next if sto_regfile_width($regfile) == 0;
            if (grep { $_->attribute("ID") eq $id } $regfile->access("registers")) {
                $rf = $regfile->attribute("ID");
                last;
            }
        }
    }
    return $RegFileOf{$id} = $rf;
}
sub sto_regfile_width { return ($_[0]->attribute("width") || 0) + 0; }

# The storage address -> register map (GDBStorage#add_register), keyed by storage ID.
# add_register: skip a 1-bit storage's whole-storage register, and a multi-cell register
# that belongs to a regfile; then first register to claim an address keeps it.
my %StorageRegs;
sub build_storage_regs {
    foreach my $reg (@Register::table) {
        my $sto = $reg->attribute("storage");
        my $storage = &MDS::fetch($sto);
        my @addrs = reg_addresses($reg);
        my $w = sto_width($storage);
        next if $w == 1 && scalar(@addrs) == sto_count($storage);
        next if $w != 1 && defined($reg->attribute("regFile")) && $reg->attribute("regFile") ne '' && scalar(@addrs) != 1;
        foreach my $addr (@addrs) {
            $StorageRegs{$sto}{$addr} = $reg unless exists $StorageRegs{$sto}{$addr};
        }
    }
}
# The register at storage cell $addr, or undef (Ruby: storage.registers[sub]).
sub storage_reg_at { my ($sto, $addr) = @_; return $StorageRegs{$sto}{$addr}; }

################################################################################

build_storage_regs();

# $regs{name}{proc_id} = register  -- the per-name, per-processor register variant.
my %Regs;

# max multi-register span and max dwarf id, over the eligible registers.
my $max_multi = 0;
my $max_dwarf = 0;
foreach my $reg (@Register::table) {
    my $rf = reg_regfile($reg);
    next if defined $rf && &MDS::fetch($rf)->regFileName() =~ /RV_/;
    my $d = reg_dwarf($reg);
    $max_dwarf = $d if defined $d && $d > $max_dwarf;
    next if reg_width($reg) == 0;
    next if !defined $rf;
    my $storage = &MDS::fetch($reg->attribute("storage"));
    my @addrs = reg_addresses($reg);
    next if scalar(@addrs) == 1 || scalar(@addrs) == sto_count($storage);
    next if sto_kind($storage) >= $MEMORY;
    $max_multi = scalar(@addrs) if scalar(@addrs) > $max_multi;
}

print "/* Generated target-description for $family */\n";
print &MDS::get_copyrights("/* ", " */"), "\n";

print <<"EOS";
#include "defs.h"

#include <string.h>

#include "gdbarch.h"
#include "gdbtypes.h"
#include "regcache.h"
#include "reggroups.h"
#include "user-regs.h"
#include "target-descriptions.h"
#include "lvx-common-tdep.h"

struct pseudo_desc {
\tconst char *name;
\tstruct type *type;
\tint size;
\tint nb_components;
\tint components[$max_multi];
\tconst char *components_names[$max_multi];
};

struct dwarf2gdb_desc {
\tint gdb_regno;
\tconst char *name;
};

static struct dwarf2gdb_desc dwarf2gdb[@{[$max_dwarf+1]}];
EOS

my $default_arch;
foreach my $proc (@Processor::table) {
    my $gdb_core = reg_core_of($proc);
    $default_arch = $gdb_core unless defined $default_arch;
}

sub reg_core_of { (my $c = (split /-/, $_[0]->attribute("ID"))[1]) =~ s/_v/-/; return $c; }
sub proc_core   { return (split /-/, $_[0]->attribute("ID"))[1]; }

foreach my $processor (@Processor::table) {
    my $proc_id = $processor->attribute("ID");
    my $core = proc_core($processor);
    my $num_pseudo = 0;

    my ($pc, $stack);
    foreach my $convention (@Convention::table) {
        next unless has_processor($convention, $proc_id);
        my ($prog) = $convention->access("program");
        my ($stk)  = $convention->access("stack");
        ($pc)    = reg_names($prog);
        ($stack) = reg_names($stk);
    }

    print "\nstatic struct pseudo_desc ${core}_pseudo_regs[] = {\n";

    foreach my $reg (@Register::table) {
        my $rf = reg_regfile($reg);
        next if defined $rf && &MDS::fetch($rf)->regFileName() =~ /RV_/;
        next if reg_width($reg) == 0;
        my $name = $reg->name();
        $Regs{$name} = {} unless exists $Regs{$name};
        foreach my $proc ($reg->access("processors")) {
            $Regs{$name}{$proc->attribute("ID")} = $reg;
        }
        next unless has_processor($reg, $proc_id);
        next if !defined $rf;
        my $storage = &MDS::fetch($reg->attribute("storage"));
        my @addrs = reg_addresses($reg);
        next if scalar(@addrs) == 1 || scalar(@addrs) == sto_count($storage);
        next if sto_kind($storage) >= $MEMORY;
        next if sto_count($storage) >= 256;              # eliminate coprocessor registers
        next if defined reg_dwarf($reg);

        $num_pseudo++;
        my ($nm) = reg_names($reg);
        printf "\t{ \"%s\", NULL, %d, %d, {", $nm, scalar(@addrs) * sto_width($storage), scalar(@addrs);
        printf " -1," for @addrs;
        printf " }, { ";
        print join(", ", map {
            my $sub = storage_reg_at($reg->attribute("storage"), $_);
            '"' . ($sub ? (reg_names($sub))[0] : "_$_") . '"';
        } @addrs);
        print "}},\n";
    }

    print "};\n";
    print "\nstatic const int ${core}_num_pseudo_regs = $num_pseudo;\n";
    print "\nstatic const char *_${core}_sp_name = \"$stack\";\n";
    print "static const char *_${core}_pc_name = \"$pc\";\n";

    print "\nstatic int init_${core}_dwarf2gdb(struct gdbarch *gdbarch)\n";
    print "{\n";
    print "\tint i;\n";
    print "\tmemset (dwarf2gdb, -1, sizeof(dwarf2gdb));\n";

    my $gdb_regno = 0;
    foreach my $reg_file (&MDS::regFiles()) {
        next if $reg_file->regFileName() =~ /RV_/;
        next if sto_regfile_width($reg_file) == 0;
        next unless has_processor($reg_file, $proc_id);
        foreach my $reg ($reg_file->access("registers")) {
            unless (has_processor($reg, $proc_id)) {
                my $nm = $reg->name();
                unless (exists $Regs{$nm} && exists $Regs{$nm}{$proc_id}) {
                    die "Register " . $reg->attribute("ID") . " not defined for processor $proc_id\n";
                }
                $reg = $Regs{$nm}{$proc_id};
            }
            my $d = reg_dwarf($reg);
            next unless defined $d;
            my $storage = &MDS::fetch($reg->attribute("storage"));
            next if sto_kind($storage) >= $MEMORY;
            if ($d != -1) {
                my ($nm) = reg_names($reg);
                print "\tdwarf2gdb[$d].name = \"$nm\";\n";
                print "\tdwarf2gdb[$d].gdb_regno = $gdb_regno;\n";
            }
            $gdb_regno++;
        }
    }

    print "\n\tfor (i = 0; i < sizeof(dwarf2gdb)/sizeof(struct dwarf2gdb_desc); ++i) {\n";
    print "\t\tif (dwarf2gdb[i].name == (void *) -1)\n";
    print "\t\t\tcontinue;\n";
    print "\t\tdwarf2gdb[i].gdb_regno = user_reg_map_name_to_regnum (gdbarch, dwarf2gdb[i].name, -1);\n";
    print "\t}\n";
    print "\treturn 1;\n";
    print "}\n";
}

print <<"EOS";
static const char*
find_tdesc_arch (struct gdbarch *gdbarch)
{
\tconst struct target_desc *tdesc;

\tif (gdbarch == NULL) return "$default_arch";
tdesc = gdbarch_target_desc (gdbarch);

\tif (tdesc == NULL) return "$default_arch";
EOS
foreach my $processor (@Processor::table) {
    my $gdb_core = reg_core_of($processor);
    print <<"EOS";
\tif (tdesc_find_feature (tdesc, "$tdesc_namespace.core.$gdb_core"))
\t\treturn "$gdb_core";
EOS
}

print <<"EOS";
\treturn "$family";
}

EOS

foreach my $reg ('pc', 'sp') {
    print <<"EOS";
const char* ${family}_${reg}_name (struct gdbarch *gdbarch);
const char*
${family}_${reg}_name (struct gdbarch *gdbarch)
{
\tconst char *archname = find_tdesc_arch (gdbarch);
EOS
    foreach my $processor (@Processor::table) {
        my $gdb_core = reg_core_of($processor);
        my $core = proc_core($processor);
        print <<"EOS";
\tif (strcmp ("$gdb_core", archname) == 0) {
\t\treturn _${core}_${reg}_name;
\t}
EOS
    }
    print <<"EOS";
\terror ("No @{[uc $reg]} for architecture %s", archname);
}
EOS
}

print <<"EOS";
void init_dwarf2gdb (struct gdbarch *gdbarch);
void
init_dwarf2gdb (struct gdbarch *gdbarch)
{
\tconst char *archname = find_tdesc_arch (gdbarch);
EOS

foreach my $processor (@Processor::table) {
    my $gdb_core = reg_core_of($processor);
    my $core = proc_core($processor);
    print <<"EOS";
\tif (strcmp ("$gdb_core", archname) == 0) {
\t\tinit_${core}_dwarf2gdb (gdbarch);
\t\treturn;
\t}
EOS
}

print <<"EOS";
\terror ("Unable to find the dwarf2gdb table for processor %s", archname);
}

EOS

print <<"EOS";
int ${family}_num_pseudos (struct gdbarch *gdbarch);
int
${family}_num_pseudos (struct gdbarch *gdbarch)
{
\tconst char *archname = find_tdesc_arch (gdbarch);
EOS

foreach my $processor (@Processor::table) {
    my $gdb_core = reg_core_of($processor);
    my $core = proc_core($processor);
    print <<"EOS";
\tif (strcmp ("$gdb_core", archname) == 0)
\t\treturn ${core}_num_pseudo_regs;
EOS
}

print <<"EOS";
\terror ("Unable to find the num_pseudo_regs table for processor %s", archname);
}

static struct pseudo_desc *
pseudo_registers (struct gdbarch *gdbarch, int *pseudo_num)
{
\tconst char *archname = find_tdesc_arch (gdbarch);
EOS

foreach my $processor (@Processor::table) {
    my $gdb_core = reg_core_of($processor);
    my $core = proc_core($processor);
    print <<"EOS";
\tif (strcmp ("$gdb_core", archname) == 0) {
\t\t*pseudo_num = ${core}_num_pseudo_regs;
\t\treturn ${core}_pseudo_regs;
\t}
EOS
}

print <<"EOS";
\terror ("Unable to find the pseudo_regs table for processor %s", archname);
}

EOS

print "\n
int ${family}_dwarf2_reg_to_regnum (struct gdbarch *gdbarch, int reg);
int ${family}_dwarf2_reg_to_regnum (struct gdbarch *gdbarch, int reg)
{
\t/* Test bith .name and .gdb_regno. The ordering of events might have
\t   us passing here while the registers aren't yet available through
\t   the user-reg interface.  To be totally honest, what I did is too
\t   complicated.  We should have decided on a GDB register order and
\t   stuck statically with it in the debugger/simulator/jtag-runner...\x20
\t   Would have been more painful when MDS is in flux, but much
\t   simpler for everyday maintainance. */
\tif (dwarf2gdb[0].name == 0 || dwarf2gdb[0].gdb_regno == -1) init_dwarf2gdb (gdbarch);

\tif (reg < ARRAY_SIZE(dwarf2gdb)) return dwarf2gdb[reg].gdb_regno;

\treturn -1;
}\n";


print "
const char *${family}_pseudo_register_name (struct gdbarch *gdbarch, int regnr);
const char *${family}_pseudo_register_name (struct gdbarch *gdbarch, int regnr)
{
\tint pseudo_num = regnr - gdbarch_num_regs (gdbarch);
\tint num_pseudo;
\tstruct pseudo_desc *pseudo_regs = pseudo_registers (gdbarch, &num_pseudo);
\tif (pseudo_num<0 || pseudo_num>=num_pseudo)
\t\treturn NULL;

\treturn pseudo_regs[pseudo_num].name;
}\n";


print "
struct type *${family}_pseudo_register_type (struct gdbarch *gdbarch,\x20
                                      int regnr);
struct type *${family}_pseudo_register_type (struct gdbarch *gdbarch,\x20
                                      int regnr)
{
\tint pseudo_num = regnr - gdbarch_num_regs (gdbarch);
\tint num_pseudo;
\tstruct pseudo_desc *pseudo_regs = pseudo_registers (gdbarch, &num_pseudo);

\tif (pseudo_num<0 || pseudo_num>=num_pseudo)
\t\treturn NULL;

\tif (pseudo_regs[pseudo_num].type != NULL)\x20
\t\treturn pseudo_regs[pseudo_num].type;

\tif (pseudo_regs[pseudo_num].size == gdbarch_long_bit (gdbarch))
\t\tpseudo_regs[pseudo_num].type = builtin_type (gdbarch)->builtin_long;
\telse if (pseudo_regs[pseudo_num].size == TARGET_CHAR_BIT)
\t\tpseudo_regs[pseudo_num].type = builtin_type (gdbarch)->builtin_char;
\telse if (pseudo_regs[pseudo_num].size == gdbarch_short_bit (gdbarch))
\t\tpseudo_regs[pseudo_num].type = builtin_type (gdbarch)->builtin_short;
\telse if (pseudo_regs[pseudo_num].size == gdbarch_int_bit (gdbarch))
\t\tpseudo_regs[pseudo_num].type = builtin_type (gdbarch)->builtin_int;
\telse if (pseudo_regs[pseudo_num].size == gdbarch_long_long_bit (gdbarch))
\t\tpseudo_regs[pseudo_num].type = builtin_type (gdbarch)->builtin_long_long;
\telse if (pseudo_regs[pseudo_num].size == gdbarch_ptr_bit (gdbarch))
\t/* A bit desperate by this point... */
\t\tpseudo_regs[pseudo_num].type = builtin_type (gdbarch)->builtin_data_ptr;
\telse if (pseudo_regs[pseudo_num].size == 128)
\t\tpseudo_regs[pseudo_num].type = builtin_type (gdbarch)->builtin_int128;
\telse if (pseudo_regs[pseudo_num].size == 256)
\t\tpseudo_regs[pseudo_num].type =
\t\t\tgdbarch_tdep<lvx_gdbarch_tdep> (gdbarch)->uint256;
\telse if (pseudo_regs[pseudo_num].size == 512)
\t\tpseudo_regs[pseudo_num].type =
\t\t\tgdbarch_tdep<lvx_gdbarch_tdep> (gdbarch)->uint512;
\telse if (pseudo_regs[pseudo_num].size == 1024)
\t\tpseudo_regs[pseudo_num].type =
\t\t\tgdbarch_tdep<lvx_gdbarch_tdep> (gdbarch)->uint1024;
\telse {
\t\twarning (_(\"Register \\\"%s\\\" has an unsupported size (%d bits)\"),
\t\tpseudo_regs[pseudo_num].name, pseudo_regs[pseudo_num].size);
\t\tpseudo_regs[pseudo_num].type = builtin_type (gdbarch)->builtin_long;
\t}
\treturn pseudo_regs[pseudo_num].type;
}
";

print "
int ${family}_pseudo_register_reggroup_p (struct gdbarch *gdbarch,\x20
				   int regnum,\x20
				   const struct reggroup *reggroup);
int ${family}_pseudo_register_reggroup_p (struct gdbarch *gdbarch,\x20
				   int regnum,\x20
				   const struct reggroup *reggroup)
{
\treturn reggroup == general_reggroup;
}\n";

print "
static void ${family}_init_pseudo_register (struct gdbarch *gdbarch,\x20
			            struct pseudo_desc *reg)
{
\tint i;

\tfor (i = 0; i < reg->nb_components; ++i) {
\t\treg->components[i] = user_reg_map_name_to_regnum (gdbarch, reg->components_names[i], -1);
\t\tif (reg->components[i] < 0) error (\"Can't find register '%s' for pseudo reg '%s'\\\n\", reg->components_names[i], reg->name);
\t}
}\n";

print "
enum register_status ${family}_pseudo_register_read (struct gdbarch *gdbarch,\x20
                              struct readable_regcache *regcache,
                              int regnum, gdb_byte *buf);
enum register_status ${family}_pseudo_register_read (struct gdbarch *gdbarch,\x20
                              struct readable_regcache *regcache,
                              int regnum, gdb_byte *buf)
{
\tint pseudo_num = regnum - gdbarch_num_regs (gdbarch);
\tint num_pseudo;
\tstruct pseudo_desc *pseudo_regs = pseudo_registers (gdbarch, &num_pseudo);
\tstruct pseudo_desc *reg = &pseudo_regs[pseudo_num];
\tint i;

\tif (pseudo_num<0 || pseudo_num>=num_pseudo)
\t\terror (\"Register %i is not a pseudo register!\", regnum);

\tif (reg->components[0] < 0) ${family}_init_pseudo_register (gdbarch, reg);

\tfor (i = 0; i < reg->nb_components; ++i) {
\t\tenum register_status status;
\t\tstatus = regcache->raw_read (reg->components[i], buf);
\t\tif (status != REG_VALID)
\t\t\treturn status;
\t\tbuf += register_size (gdbarch, reg->components[i]);
\t}
\treturn REG_VALID;
}\n";

print "
void ${family}_pseudo_register_write (struct gdbarch *gdbarch,\x20
                               struct regcache *regcache,
                               int regnum, const gdb_byte *buf)
{
\tint pseudo_num = regnum - gdbarch_num_regs (gdbarch);
\tint num_pseudo;
\tstruct pseudo_desc *pseudo_regs = pseudo_registers (gdbarch, &num_pseudo);
\tstruct pseudo_desc *reg = &pseudo_regs[pseudo_num];
\tint i;

\tif (pseudo_num<0 || pseudo_num>=num_pseudo)
\t\terror (\"Register %i is not a pseudo register!\", regnum);

\tif (reg->components[0] < 0) ${family}_init_pseudo_register (gdbarch, reg);

\tfor (i = 0; i < reg->nb_components; ++i) {
\t\tregcache->raw_write (reg->components[i], buf);
\t\tbuf += register_size (gdbarch, reg->components[i]);
\t}
}\n";

print "
void _initialize_${family}_mds_tdep ();
void
_initialize_${family}_mds_tdep ()
{
}\n";
