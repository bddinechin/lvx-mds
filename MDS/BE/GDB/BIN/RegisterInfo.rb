#!/usr/bin/ruby
# -*- coding: utf-8 -*-

dir = File.dirname $0
load dir + "/Registers.rb"

require 'GDBTarget'
include GDBTarget

def generate_bitfield_def (reg, fields_size, regs_field, regs_size)
  reg_name = reg.names[0]
  field_name = "#{reg_name}_type"
  fields_size[field_name] = regs_size[reg_name]
  regs_field[reg_name] = field_name
  puts "\"\n\t\"<struct id=\\\"#{reg.names[0]}_type\\\" size=\\\"#{(fields_size[field_name] + 7)/8}\\\">\\n\""
  $storages[reg.storage].registers.values.uniq.sort { |a,b| a.addresses[0] <=> b.addresses[0]}.each do |field|
    addrs = field.addresses
    break unless addrs.min < 32
    register_name = field.names[0].gsub(/^#{$storages[reg.storage].name.downcase}_/,"")
    puts "\t\"\t<field name=\\\"#{register_name}\\\" start=\\\"#{addrs.min}\\\" end=\\\"#{addrs.max}\\\" />\\n\""
  end
  puts "\t\"</struct>\\n\""
  printf "\t\"<reg name=\\\"#{reg.names[0]}\\\" regnum=\\\"%%d\\\" bitsize=\\\"#{fields_size[field_name]}\\\" type=\\\"#{reg.names[0]}_type\\\" />"
end

puts get_copyrights("/* "," */")

puts <<-EOS
struct reg_desc {
char *name;
char *desc;
};
EOS

def sort_regfiles(a,b)
  order = GDBTarget.ordered_regfiles()
  a_index = order.index(a)
  raise "Unknown order for regfile #{a}" if(a_index.nil?)
  b_index = order.index(b)
  raise "Unknown order for regfile #{b}" if(b_index.nil?)

  if(a_index < b_index) then
    return -1
  elsif(a_index > b_index) then
    return +1
  else
    return 0
  end
end

# Sort regfiles depending on GDBTarget.ordered_regfiles order
$sorted_regfiles = $regfiles.keys.sort { |a,b|
  regfile_a = $regfiles[a]
  regfile_b = $regfiles[b]
  sort_regfiles(regfile_a.name,regfile_b.name)
}

def regfiles_each()
  $sorted_regfiles.each do |regfile_id|
    yield(regfile_id,$regfiles[regfile_id])
  end
end


$regfiles.each do |regfile_id, reg_file|
  STDERR.puts "Regfile: #{regfile_id}"
end

$processors.each do |processor_id, processor|
  
  puts "struct reg_desc #{processor.cores[0]}_mds_registers_description[] = {"
  ssize = "int #{processor.cores[0]}_mds_registers_size[] = {\n\t"
  idx_reg = 0

  pc = nil
  ra = nil
  stack = nil

  $conventions.each do |convention_id, convention|
    STDERR.puts "[0] -> #{convention_id}"
    next if convention.processors.index(processor).nil?
    STDERR.puts "[1] -> #{convention_id}"

    pc = convention.program[0]
    ra = convention.return[0]
    stack = convention.stack[0]

    raise "Incoherent PC descriptions" if (pc != convention.program[0])
    raise "Incoherent RA descriptions" if (ra != convention.return[0])
    raise "Incoherent SP descriptions" if (stack != convention.stack[0])
  end

  fields_size = {}
  regs_size = {}
  regs_field = {}

  regfiles_each do |regfile_id, reg_file|
    
    next if reg_file.width == 0
    STDERR.puts "[0] -> #{regfile_id}"
    next if reg_file.processors.index(processor).nil?
    STDERR.puts "[1] -> #{regfile_id}"

    reg_file.registers.each do |reg_id|
      reg = $registers[reg_id]
      next if $storages[reg.storage].kind >= Storage::MEMORY
      next if $regclasses[$regfiles[reg.regfile].regclass].multi

      reg_name = reg.names[0]
      regs_size[reg_name] = [reg.addresses.size * $storages[reg.storage].width,32].max

      idx_reg = idx_reg + 1
      ssize += "#{regs_size[reg_name]} \/\*#{reg_name}\*\/,"
      ssize += "\n\t" if ((idx_reg % 10) == 0)

      printf  "{ \"#{reg_name}\", \""
      type = "int"
      if not $storages[reg.storage].registers.empty? and not $storages[reg.storage].registers.values[0].regfile then
        generate_bitfield_def(reg, fields_size, regs_field, regs_size)
        puts "\" },"
        next
      elsif reg.id == pc || reg.id == ra
        type = "int"
      elsif reg.id == stack
        type = "int"
      elsif $target =~ /^lvx/ && (reg_name == "sps" || reg_name == "ssps" || reg_name == "sssps")
        type = "ps_type"
      elsif $target =~ /^lvx/ && (reg_name == "spc" || reg_name == "sspc" || reg_name == "ssspc")
        type = "int"
      end

      regs_field[reg_name] = type
      
      puts "<reg name=\\\"#{reg_name}\\\" regnum=\\\"%d\\\" bitsize=\\\"#{regs_size[reg_name]}\\\" type=\\\"#{type}\\\" />\" },"

    end
  end

  puts "{ 0 },\n};"
  ssize += "\n0};\n\n"
  puts ssize

#BD3  # Check coherency between struct types and register size
#BD3  regs_field.each do |reg_name, field_name|
#BD3    if(field_name != "int" and
#BD3       field_name != "data_ptr" and
#BD3       field_name != "code_ptr") then
#BD3      raise "No register size for #{reg_name}" unless regs_size.has_key?(reg_name)
#BD3      reg_size = regs_size[reg_name]
#BD3      raise "No field size for #{field_name}" unless fields_size.has_key?(field_name)
#BD3      field_size = fields_size[field_name]
#BD3      
#BD3      if(reg_size != field_size) then
#BD3        raise "#{field_name}: Field size #{field_size} != Register size #{reg_size}"
#BD3      end
#BD3    end
#BD3  end
end

puts <<EOS

static inline struct reg_desc*
get_register_descriptions (const char *arch)
{
EOS

$processors.each do |processor_id, processor|
  gdb_core = "#{processor.cores[0].gsub(/_v/,"-")}"
  puts <<EOS
\tif (strcmp (arch, \"#{gdb_core}\") == 0)
\t\treturn #{processor.cores[0]}_mds_registers_description;
EOS
end

puts "\treturn NULL;\n}\n\n"

puts <<EOS
static inline int*
get_register_sizes (const char *arch)
{
EOS

$processors.each do |processor_id, processor|
  gdb_core = "#{$target}-#{processor.cores[0].gsub(/_v/,"-")}"  
  puts <<EOS
\tif (strcmp (arch, \"#{gdb_core}\") == 0)
\t\treturn #{processor.cores[0]}_mds_registers_size;
EOS
end

puts "\treturn NULL;\n}\n\n"

