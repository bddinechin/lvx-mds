
require 'MDS'
include Mds
require 'rexml/document'
include REXML

$family = ENV['FAMILY']

module GDBStorage
  attr_reader :registers

  def initialize
    @registers = {}
  end

  def add_register(addrs, reg)
    return if width == 1 and reg.addresses.size == count
    return if width != 1 and reg.regfile and reg.addresses.size != 1
    addrs.each { |addr| @registers[addr] = reg if not @registers[addr] }
  end
end

module GDBRegister
  def initialize
    @description.storages[storage].add_register(addresses, self)
    return if regfile
    @description.regfiles.each do |regfile_id, regfile|
        next if regfile.width == 0
        if not regfile.registers.index(id).nil? then
            @regfile = regfile_id
            return
        end
    end
  end

  def names
    @names.map { |name| name[0] == '$' ? name[1..-1] : name }
  end
end

Storage.specialize GDBStorage
Register.specialize GDBRegister

$desc = MdsDescription.new(Document.new(File.read(ARGV[0])).root)
$storages = $desc.storages
$regfiles = $desc.regfiles
$registers = $desc.registers
$regclasses = $desc.regclasses
$regfields = $desc.regfields
$processors = $desc.processors
$conventions = $desc.conventions

# $root.elements.each("Register") do |element|
#   id = element.attributes['ID']
#   mnemonic = element.attributes['names'].split(' ')[0] 
#   dwarfid = -1
#   dwarfid = element.attributes['dwarfId'].to_i if not element.attributes['dwarfId'].nil?
#   storage = element.attributes['storage']
#   what = element.attributes['what']
#   addrs = element.attributes['addresses']

#   if mnemonic[0,1] == "$"
#     mnemonic = mnemonic[1, mnemonic.length-1]
#   end

#   if not $all_regs.has_key? id
#     reg = Register.new(id)
#     $ignored_regs.push reg
#   else
#     reg = $all_regs[id]
#     $storages[storage].add_reg reg
#   end
  
#   reg.mnemonic = mnemonic
#   reg.dwarfid = dwarfid
#   reg.storage = $storages[storage]
#   reg.what = what
#   reg.addrs = addrs.split ' '
# end

# $max_multi = 0
# $root.elements.each("RegClass[@multi]") do |element|
#   element.attributes['registers'].split(' ').each do |reg_id| 
#     reg = $all_regs[reg_id]
#     addrs = reg.addrs
#     $max_multi = [$max_multi, addrs.length].max
    
#     addrs.each do |addr|
#       sub = nil;
#       reg.storage.regs.each do |storage_reg|
#         if storage_reg.addrs.length == 1 and storage_reg.addrs[0] == addr
#           sub = storage_reg
#           break
#         end
#       end
#       exit(1) if sub.nil?
#       reg.pseudo.push sub
#     end 

#     #components.each { |comp| reg.pseudo.push $all_regs[comp[idx]] }
#   end
# end

# tmp_regs = $ignored_regs.clone
# tmp_regs.each do |reg|
  
#   reg.storage.regs.each do |parent_reg|
#     next if $ignored_regs.member? parent_reg
#     parent_reg.bits.push reg
#     $ignored_regs.delete reg
#     break
#   end

# end

# $root.elements.each("Convention") do |element|
#   next if(element.attributes["ID"] =~ /-$/)
#   if not $stack.nil? 
#     if (element.attributes["stack"] != $stack) then
#       $stderr.puts "Convention: stack attribute is not defined"
#       exit 1 
#     end
#   else
#     $stack = element.attributes["stack"]
#   end
#   if not $pc.nil? 
#     if (element.attributes["program"] != $pc) then
#       $stderr.puts "Convention: program attribute is not defined"
#       exit 1
#     end
#   else
#     $pc = element.attributes["program"]
#     reg = $all_regs[$pc]
#     $ignored_regs.delete reg
#   end
#   if not $ra.nil? 
#     if (element.attributes["return"] != $ra) then
#       $stderr.puts "Convention: return attribute is not defined"
#       exit 1 
#     end
#   else
#     $ra = element.attributes["return"]
#   end
# end

# return if ($pc.nil? or $stack.nil?)

# $ignored_regs.each { |reg| STDERR.puts "Ignoring #{reg.id}" }

# if ($ignored_regs.size != 1) then
#   $stderr.puts "More than one ignored regs: #{ignored_regs.join(" ")}"
#   exit(1) 
# end
