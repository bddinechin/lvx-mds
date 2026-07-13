#!/usr/bin/ruby
# -*- coding: utf-8 -*-

dir = File.dirname $0
load dir + "/Registers.rb"

def generate_bitfield_def (reg)
  puts "\ttype = tdesc_create_struct (feature, \"#{reg.name}_type\");"
  puts "\ttdesc_set_struct_size (type, #{reg.addrs.size * $storages[reg.storage].width/8});"
  reg.bits.each do |field|
    puts "\ttdesc_add_bitfield (type, \"#{field.name}\", #{field.addresses.min}, #{field.addresses.max});"
  end
  puts "\ttdesc_create_reg (feature, \"#{reg.name}\", #{reg.dwarf_id}, 1, \"general\", #{reg.addresses.size * $storages[reg.storage].width}, \"#{reg.name}_type\");"
end

puts "/* Generated target-description for #{$family} */"
puts get_copyrights("/* "," */")

$max_multi = 0
$max_dwarf = 0

$registers.values.each do |reg|
  next if reg.regfile and /RV_/.match($regfiles[reg.regfile].name)
  $max_dwarf = [ $max_dwarf, reg.dwarf_id ].max if reg.dwarf_id
  next if reg.width == 0
  next if not reg.regfile
  next if reg.addresses.size == 1 || reg.addresses.size == $storages[reg.storage].count
  next if $storages[reg.storage].kind >= Storage::MEMORY
  $max_multi = [$max_multi, reg.addresses.size].max
end

puts <<EOS
#include \"defs.h\"

#include <string.h>

#include \"gdbarch.h\"
#include \"gdbtypes.h\"
#include \"regcache.h\"
#include \"reggroups.h\"
#include \"user-regs.h\"
#include \"target-descriptions.h\"
#include \"lvx-common-tdep.h\"

struct pseudo_desc {
\tconst char *name;
\tstruct type *type;
\tint size;
\tint nb_components;
\tint components[#{$max_multi}];
\tconst char *components_names[#{$max_multi}];
};

struct dwarf2gdb_desc {
\tint gdb_regno;
\tconst char *name;
};

static struct dwarf2gdb_desc dwarf2gdb[#{$max_dwarf+1}];
EOS

default_arch = nil

$processors.each { |proc_id, proc|
  gdb_core = "#{proc.cores[0].gsub(/_v/,"-")}"
  default_arch = gdb_core if default_arch.nil?
}

$processors.each do |processor_id, processor|
  num_pseudo = 0
  
  # FIXME!!
  pc = nil
  stack = nil
  
  $conventions.each do |convention_id, convention|
    next if not convention.processors.index(processor)
    pc = $registers[convention.program[0]].names[0]
    stack = $registers[convention.stack[0]].names[0]

    raise "Inconsistent PC descrition in convention (#{pc} != #{$registers[convention.program[0]].names[0]})" if pc != $registers[convention.program[0]].names[0]
    raise "Inconsistent Stack descrition in convention (#{stack} != #{$registers[convention.stack[0]].names[0]})" if stack != $registers[convention.stack[0]].names[0]
  end
  
  puts "\nstatic struct pseudo_desc #{processor.cores[0]}_pseudo_regs[] = {"

  $regs = {}
  
  $registers.each do |reg_id, reg|
    next if reg.regfile and /RV_/.match($regfiles[reg.regfile].name)
    next if reg.width == 0
    $regs[reg.name] = {} if(not $regs.has_key?(reg.name))
    reg.processors.each do |proc|
      $regs[reg.name][proc.id] = reg
    end
    next if not reg.processors.index(processor)
    next if not reg.regfile
    next if reg.addresses.size == 1 || reg.addresses.size == $storages[reg.storage].count
    next if $storages[reg.storage].kind >= Storage::MEMORY
    next if $storages[reg.storage].count >= 256 # Hack to eliminate coprocessor registers
    next if reg.dwarf_id != nil
    
    num_pseudo += 1
    name = reg.names[0]
    printf "\t{ \"#{name}\", NULL, #{reg.addresses.size*$storages[reg.storage].width}, #{reg.addresses.size}, {"
    reg.addresses.size.times { printf " -1," }
    printf " }, { "
    printf reg.addresses.collect { |sub| "\""  + ($storages[reg.storage].registers[sub]? $storages[reg.storage].registers[sub].names[0]: "_#{sub}") + "\"" }.join(", ")
    puts "}},"
  end
  
  puts "};"
  
  puts "\nstatic const int #{processor.cores[0]}_num_pseudo_regs = #{num_pseudo};"
  puts "\nstatic const char *_#{processor.cores[0]}_sp_name = \"#{stack}\";"
  puts "static const char *_#{processor.cores[0]}_pc_name = \"#{pc}\";"

  puts "\nstatic int init_#{processor.cores[0]}_dwarf2gdb(struct gdbarch *gdbarch)"
  puts "{"
  puts "\tint i;"
  puts "\tmemset (dwarf2gdb, -1, sizeof(dwarf2gdb));"
  
  gdb_regno = 0;
  $regfiles.values.each do |reg_file|
    next if /RV_/.match(reg_file.name())
    next if reg_file.width == 0
    next if not reg_file.processors.index(processor)
    reg_file.registers.each do |reg_id|
      reg = $registers[reg_id]
      if(not reg.processors.index(processor)) then
        if(not $regs.has_key?(reg.name) and not $regs[reg.name].has_key?(processor.id)) then
          raise "Register #{reg.id} not defined for processor #{processor.id}"
        end
        reg = $regs[reg.name][processor.id]
      end
      next if not reg.dwarf_id
      next if $storages[reg.storage].kind >= Storage::MEMORY
      puts "\tdwarf2gdb[#{reg.dwarf_id}].name = \"#{reg.names[0]}\";" if reg.dwarf_id != -1
      puts "\tdwarf2gdb[#{reg.dwarf_id}].gdb_regno = #{gdb_regno};" if reg.dwarf_id != -1
      gdb_regno = gdb_regno + 1
    end
  end

  puts "\n\tfor (i = 0; i < sizeof(dwarf2gdb)/sizeof(struct dwarf2gdb_desc); ++i) {"
  puts "\t\tif (dwarf2gdb[i].name == (void *) -1)"
  puts "\t\t\tcontinue;\n"
  puts "\t\tdwarf2gdb[i].gdb_regno = user_reg_map_name_to_regnum (gdbarch, dwarf2gdb[i].name, -1);"
  puts "\t}"
  puts "\treturn 1;"
  puts "}"

end

puts <<EOS
static const char*
find_tdesc_arch (struct gdbarch *gdbarch)
{
\tconst struct target_desc *tdesc;
\n\tif (gdbarch == NULL) return \"#{default_arch}\";
tdesc = gdbarch_target_desc (gdbarch);
\n\tif (tdesc == NULL) return \"#{default_arch}\";
EOS
$processors.each do |processor_id, processor|
  gdb_core = "#{processor.cores[0].gsub(/_v/,"-")}"
  puts <<EOS
\tif (tdesc_find_feature (tdesc, \"#{$tdesc_namespace}.core.#{gdb_core}\"))
\t\treturn \"#{gdb_core}\";
EOS
end

puts <<EOS
\treturn \"#{$family}\";
}

EOS

[ 'pc', 'sp' ].each do |reg|
  puts <<EOS
const char* #{$family}_#{reg}_name (struct gdbarch *gdbarch);
const char*
#{$family}_#{reg}_name (struct gdbarch *gdbarch)
{
\tconst char *archname = find_tdesc_arch (gdbarch);
EOS
  $processors.each do |processor_id, processor|
    gdb_core = "#{processor.cores[0].gsub(/_v/,"-")}"
    puts <<EOS
\tif (strcmp ("#{gdb_core}", archname) == 0) {
\t\treturn _#{processor.cores[0]}_#{reg}_name;
\t}
EOS
  end
  puts <<EOS
\terror ("No #{reg.upcase} for architecture %s", archname);
}
EOS
end

puts <<EOS
void init_dwarf2gdb (struct gdbarch *gdbarch);
void
init_dwarf2gdb (struct gdbarch *gdbarch)
{
\tconst char *archname = find_tdesc_arch (gdbarch);
EOS

$processors.each do |processor_id, processor|
  gdb_core = "#{processor.cores[0].gsub(/_v/,"-")}"
  puts <<EOS
\tif (strcmp ("#{gdb_core}", archname) == 0) {
\t\tinit_#{processor.cores[0]}_dwarf2gdb (gdbarch);
\t\treturn;
\t}
EOS
end

puts <<EOS
\terror ("Unable to find the dwarf2gdb table for processor %s", archname);
}

EOS


puts <<EOS
int #{$family}_num_pseudos (struct gdbarch *gdbarch);
int
#{$family}_num_pseudos (struct gdbarch *gdbarch)
{
\tconst char *archname = find_tdesc_arch (gdbarch);
EOS

$processors.each do |processor_id, processor|
  gdb_core = "#{processor.cores[0].gsub(/_v/,"-")}"
  puts <<EOS
\tif (strcmp ("#{gdb_core}", archname) == 0)
\t\treturn #{processor.cores[0]}_num_pseudo_regs;
EOS
end

puts <<EOS
\terror ("Unable to find the num_pseudo_regs table for processor %s", archname);
}

static struct pseudo_desc *
pseudo_registers (struct gdbarch *gdbarch, int *pseudo_num)
{
\tconst char *archname = find_tdesc_arch (gdbarch);
EOS

$processors.each do |processor_id, processor|
  gdb_core = "#{processor.cores[0].gsub(/_v/,"-")}"
  puts <<EOS
\tif (strcmp ("#{gdb_core}", archname) == 0) {
\t\t*pseudo_num = #{processor.cores[0]}_num_pseudo_regs;
\t\treturn #{processor.cores[0]}_pseudo_regs;
\t}
EOS
end

puts <<EOS
\terror ("Unable to find the pseudo_regs table for processor %s", archname);
}

EOS

puts "\n
int #{$family}_dwarf2_reg_to_regnum (struct gdbarch *gdbarch, int reg);
int #{$family}_dwarf2_reg_to_regnum (struct gdbarch *gdbarch, int reg)
{
\t/* Test bith .name and .gdb_regno. The ordering of events might have
\t   us passing here while the registers aren't yet available through
\t   the user-reg interface.  To be totally honest, what I did is too
\t   complicated.  We should have decided on a GDB register order and
\t   stuck statically with it in the debugger/simulator/jtag-runner... 
\t   Would have been more painful when MDS is in flux, but much
\t   simpler for everyday maintainance. */
\tif (dwarf2gdb[0].name == 0 || dwarf2gdb[0].gdb_regno == -1) init_dwarf2gdb (gdbarch);

\tif (reg < ARRAY_SIZE(dwarf2gdb)) return dwarf2gdb[reg].gdb_regno;

\treturn -1;
}"


puts "
const char *#{$family}_pseudo_register_name (struct gdbarch *gdbarch, int regnr);
const char *#{$family}_pseudo_register_name (struct gdbarch *gdbarch, int regnr)
{
\tint pseudo_num = regnr - gdbarch_num_regs (gdbarch);
\tint num_pseudo;
\tstruct pseudo_desc *pseudo_regs = pseudo_registers (gdbarch, &num_pseudo);
\tif (pseudo_num<0 || pseudo_num>=num_pseudo)
\t\treturn NULL;

\treturn pseudo_regs[pseudo_num].name;
}"


puts "
struct type *#{$family}_pseudo_register_type (struct gdbarch *gdbarch, 
                                      int regnr);
struct type *#{$family}_pseudo_register_type (struct gdbarch *gdbarch, 
                                      int regnr)
{
\tint pseudo_num = regnr - gdbarch_num_regs (gdbarch);
\tint num_pseudo;
\tstruct pseudo_desc *pseudo_regs = pseudo_registers (gdbarch, &num_pseudo);

\tif (pseudo_num<0 || pseudo_num>=num_pseudo)
\t\treturn NULL;

\tif (pseudo_regs[pseudo_num].type != NULL) 
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
"

puts "
int #{$family}_pseudo_register_reggroup_p (struct gdbarch *gdbarch, 
				   int regnum, 
				   const struct reggroup *reggroup);
int #{$family}_pseudo_register_reggroup_p (struct gdbarch *gdbarch, 
				   int regnum, 
				   const struct reggroup *reggroup)
{
\treturn reggroup == general_reggroup;
}"

puts "
static void #{$family}_init_pseudo_register (struct gdbarch *gdbarch, 
			            struct pseudo_desc *reg)
{
\tint i;

\tfor (i = 0; i < reg->nb_components; ++i) {
\t\treg->components[i] = user_reg_map_name_to_regnum (gdbarch, reg->components_names[i], -1);
\t\tif (reg->components[i] < 0) error (\"Can't find register '%s' for pseudo reg '%s'\\\n\", reg->components_names[i], reg->name);
\t}
}"

puts "
enum register_status #{$family}_pseudo_register_read (struct gdbarch *gdbarch, 
                              struct readable_regcache *regcache,
                              int regnum, gdb_byte *buf);
enum register_status #{$family}_pseudo_register_read (struct gdbarch *gdbarch, 
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

\tif (reg->components[0] < 0) #{$family}_init_pseudo_register (gdbarch, reg);

\tfor (i = 0; i < reg->nb_components; ++i) {
\t\tenum register_status status;
\t\tstatus = regcache->raw_read (reg->components[i], buf);
\t\tif (status != REG_VALID)
\t\t\treturn status;
\t\tbuf += register_size (gdbarch, reg->components[i]);
\t}
\treturn REG_VALID;
}"

puts "
void #{$family}_pseudo_register_write (struct gdbarch *gdbarch, 
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

\tif (reg->components[0] < 0) #{$family}_init_pseudo_register (gdbarch, reg);

\tfor (i = 0; i < reg->nb_components; ++i) {
\t\tregcache->raw_write (reg->components[i], buf);
\t\tbuf += register_size (gdbarch, reg->components[i]);
\t}
}"

puts "
void _initialize_#{$family}_mds_tdep ();
void
_initialize_#{$family}_mds_tdep ()
{
}"
