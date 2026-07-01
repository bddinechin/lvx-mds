
$LOAD_PATH.push(`dirname #{$0}`.chomp)

require 'rexml/document'
require 'MDS'
include Mds
include REXML

#
# Global variables definitions
#
$doc = Document.new( File.new(ARGV[0]))
$root = $doc.root
$family = ENV['FAMILY']
$cores = ENV['CORES'].split()

#
# MDS specialization
#
module GCCBuiltin
  def initialize

  end

  def emit_enum(file)
    if(@name != nil and @cname != "") then
      file.puts "    #{$family.upcase}_BUILTIN_#{@name.upcase},"
    end
  end

  def emit_init(file)
    if(@name != nil and @cname != "") then
      if(@cores != $cores) then
        file.puts "    if(TARGET_#{@cores.join(' | TARGET_').upcase})"
      end
      
      file.puts "    ADD_GCC_BUILTIN (#{@name.upcase}, \"#{@cname.downcase}\", false, #{@gcc_types.join(", ")});"
    end
  end

  def emit_expand_routines(file)
    if(@name != nil and @cname != "") then
      ret_mode = @gcc_modes[0]
      attribute_unused = ret_mode == "VOIDmode" ? "ATTRIBUTE_UNUSED" : ""
      file.puts "static rtx"
      file.puts "#{$family.downcase}_expand_builtin_#{@name.downcase}( rtx target #{attribute_unused}, tree args)"
      file.puts "{"
      arg_idx = 0
      @gcc_modes.each do |gcc_mode|
        if(arg_idx != 0 and gcc_mode != "VOIDmode") then
          file.puts "  rtx arg#{arg_idx} = expand_normal (CALL_EXPR_ARG (args, #{arg_idx-1}));"
        end
        arg_idx += 1
      end

      #if (@formats[0] != nil) then
        #file.puts "@format[0].operands: #{@formats[0].operands}"
        #file.puts "  if (!verify_const_int_arg (arg1, 32, true)) {"
        #file.puts "      error (\"__builtin_#{@name.downcase} expects a 32 bits immediate first argument.\");"
        #file.puts "      return NULL_RTX;"
        #file.puts "  }
      #end

      if(ret_mode != "VOIDmode") then
        file.puts "  if(!target)"
        file.puts "    target = gen_reg_rtx(#{@gcc_modes[0]});"
        file.puts "  if (!REG_P(target) || GET_MODE (target) != #{@gcc_modes[0]}) {"
        file.puts "    target = force_reg (#{@gcc_modes[0]}, target);"
        file.puts "  }"
      end
      arg_idx = 0
      args = []
      @gcc_modes.each do |gcc_mode|
        if(gcc_mode != "VOIDmode") then
          if(arg_idx == 0) then
            file.puts "  target = force_reg(#{gcc_mode}, target);"
          else
            file.puts "  arg#{arg_idx} = force_reg(#{gcc_mode}, arg#{arg_idx});"
            args.push arg_idx
          end
        end
        arg_idx += 1
      end
      args_str = ""
      args_str = "arg#{ args.join(', arg')}" if(args.size > 0)
      if(ret_mode == "VOIDmode") then
        file.puts "  emit_insn(gen_#{@name.downcase} (#{args_str}));"
        file.puts "  return NULL_RTX;"
      else
        file.puts "  emit_insn(gen_#{@name.downcase} (target, #{args_str}));"
        file.puts "  return target;"
      end
      file.puts "}"
      file.puts ""
    end
  end

  def emit_expand(file)
    if(@name != nil and @cname != "") then
      file.puts "    case #{$family.upcase}_BUILTIN_#{@name.upcase}:"
      file.puts "        return #{$family.downcase}_expand_builtin_#{@name.downcase}(target, exp);"
    end
  end

end

Builtin.specialize GCCBuiltin

#
# Initialization phase
#
$desc = MdsDescription.new(Document.new(File.read(ARGV[0])).root)
$processors = $desc.processors
$immediates = $desc.immediates
$regclasses = $desc.regclasses
$modifiers = $desc.modifiers
$operands = $desc.operands
$schedulings = $desc.schedulings
$formats = $desc.formats
$instructions = $desc.instructions
$nativetypes = $desc.nativetypes
$builtins = $desc.builtins

#
# Generation phase
#
file = $stdout

copyrights = get_copyrights("*** ","")

copyright= <<"eos"
/**
#{copyrights}
***
*** This program is free software; you can redistribute it and/or
*** modify it under the terms of the GNU General Public License
*** as published by the Free Software Foundation; either version
*** 2 of the License, or (at your option) any later version.
***
*** This program is distributed in the hope that it will be useful,
*** but WITHOUT ANY WARRANTY; without even the implied warranty of
*** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
*** General Public License for more details.
***
*** You should have received a copy of the GNU General Public License
*** along with this program; if not, write to the Free Software
*** Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
***
**/

eos

file.puts copyright

# Emit builtins enumeration
file.puts "#ifdef GCC_BUILTIN_ENUM"
$builtins.sort.each do |id,builtin|
  builtin.emit_enum(file)
#  builtin.dump()
end
file.puts "#endif /* GCC_BUILTIN_ENUM */"
file.puts ""

# Emit initialization of builtins
file.puts "#ifdef GCC_BUILTIN_INIT"

file.puts <<EOT
#define ADD_GCC_BUILTIN(UC_NAME, LC_NAME, ...)                             \\
  builtin_fndecls[K1_BUILTIN_##UC_NAME] =                                  \\
  add_builtin_function ("__builtin_" LC_NAME,                              \\
                            build_function_type_list (__VA_ARGS__,         \\
						      NULL_TREE),          \\
			K1_BUILTIN_##UC_NAME,			           \\
			BUILT_IN_MD, NULL, NULL_TREE)

EOT

$builtins.sort.each do |id,builtin|
  builtin.emit_init(file)
end
file.puts "#endif /* GCC_BUILTIN_INIT */"
file.puts ""

# Emit expansion routines
file.puts "#ifdef GCC_BUILTIN_EXPAND_ROUTINES"
$builtins.sort.each do |id,builtin|
  builtin.emit_expand_routines(file)
end
file.puts "#endif /* GCC_BUILTIN_EXPAND_ROUTINES */"
file.puts ""

# Emit expansion of builtins
file.puts "#ifdef GCC_BUILTIN_EXPAND"
$builtins.sort.each do |id,builtin|
  builtin.emit_expand(file)
end
file.puts "#endif /* GCC_BUILTIN_EXPAND */"
file.puts ""

file.close
