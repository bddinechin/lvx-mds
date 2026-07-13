
$copyrights = [ "(c) Copyright 2010-2018 Kalray SA." ]

def get_copyrights(prefix, suffix)
  formated_copyrights = $copyrights.map { |copyright| 
    "#{prefix}#{copyright}#{suffix}" }

  return formated_copyrights.join("\n")
end

module Mds
  class MdsOrderedHash < Hash
#    def each(&blk)
#      sort do |a,b|
#        a[0] <=> b[0]
#      end.each &blk
#    end
  end


  class MdsDescription
    attr_accessor :instructions, :formats, :operands, :methods, :immediates
    attr_accessor :opcodes, :regclasses, :regfiles, :regmasks, :registers
    attr_accessor :regfields, :modifiers, :storages, :builtins, :nativetypes
    attr_accessor :processors, :platforms, :conventions, :bitfields
    attr_accessor :synthetics, :schedulings, :resources, :reservations


    def initialize(mds_root)
      @methods = MdsOrderedHash.new
      @builtins = MdsOrderedHash.new

      @platforms = Platform.extract(self, mds_root)
      @processors = Processor.extract(self, mds_root)
      @resources = Resource.extract(self, mds_root)
      @reservations = Reservation.extract(self, mds_root)
      @regfiles = RegFile.extract(self, mds_root)
      @regclasses = RegClass.extract(self, mds_root)
      @regmasks = RegMask.extract(self, mds_root)
      @storages = Storage.extract(self, mds_root)
      @registers = Register.extract(self, mds_root)
      @regfields = RegField.extract(self, mds_root)
      @conventions = Convention.extract(self, mds_root)
      @modifiers = Modifier.extract(self, mds_root)
      @immediates = Immediate.extract(self, mds_root)
      @bitfields = BitField.extract(self, mds_root)
      @operands = Operand.extract(self, mds_root)
      @formats = Format.extract(self, mds_root)
      @schedulings = Scheduling.extract(self, mds_root)
      @instructions = Instruction.extract(self, mds_root)
      @opcodes = Opcode.extract(self, mds_root)
      @nativetypes = NativeType.extract(self, mds_root)
      @synthetics = Synthetic.extract(self, mds_root)
      @builtins = Builtin.extract(self, mds_root)
    end

    def debug_insns!(*insns)
      @instructions.select! do |k, _|
        insns.include?(k)
      end
    end

    def debug_opcodes!(*opcodes)
      @opcodes.select! do |k, _|
        opcodes.include?(k)
      end
    end
  end

  #
  # Objects definitions
  #
  class Mds
    attr_reader :description
    attr_reader :id, :what, :name, :cores, :processors, :mdstype

    def initialize(description,id,what,processors)
      @description = description
      @id = id
      @what = what
      @name = id.split('-')[2]
      @cores = []
      @processors = []
      if(processors == nil) then
        @cores.push id.split('-')[1]
      else
        processors.split().each do |processor|
          @cores.push processor.split('-')[1]
          @processors.push description.processors[processor] if(description.processors[processor])
        end
      end
      @mdstype = id.split('-')[0]
    end

    def self.ID(type, name)
      [type, ENV.fetch("CORE","unknown"), name].join('-')
    end

    @@specialization = {};
    @@specialization_init = {};

    def self.create(*args, &block)
      res = new(*args, &block)
      res.extend @@specialization[self] if @@specialization[self]
      @@specialization_init[self].bind(res).call() if @@specialization_init[self]
      res
    end

    def self.specialize(mod)
      @@specialization[self] = mod
      begin
        @@specialization_init[self] = mod.instance_method("initialize")
      rescue
        @@specialization_init[self] = nil
      end
    end

    def to_s
      @id
    end
  end

  def getFormatKey(format)
    format_key = []
    format.operands.each do |operand|
      method = operand.method
      case method.mdstype
      when "Immediate" then
        format_key.push "I"
      when "Register" then
        format_key.push method.id
      when "RegClass" then
        format_key.push method.id
      when "Modifier" then
        format_key.push method.id
      else raise "Not managed type #{method.mdstype}"
      end
    end
    return format.name != nil ? format_key.join("_") : "nil"
  end

  class Opcode < Mds
    attr_reader :format, :behavior, :properties, :operands, :encoded, :instruction

    def initialize (description, id, what, processors, format, behavior, properties, operands, encoded, instruction)
      @behavior = behavior
      @properties = properties
      @format = format
      @operands = operands.split.map { |op| description.operands[op] }
      @encoded = encoded
      @instruction = instruction
      super(description,id,what,processors)
    end

    def self.extract (description, document)
      opcodes = MdsOrderedHash.new
      document.elements.each("Opcode") do |element|
        id = element.attributes["ID"]
        what = element.attributes["what"]
        processors = element.attributes["processors"]
        properties_str = element.attributes["properties"] || ""
        operands = element.attributes["operands"] || ""
        encoded = element.attributes["encoded"]

        belt = element.elements["Behavior"]
        behavior = (belt != nil) ? belt.text : nil

        # Replace '.' with space to parse them as standard argument separator
        behavior = behavior.gsub(/\./, " ") if behavior

        next if id == nil || id[-1..-1] == "-"

        properties = {}

        #properties_str.split(',').each do |p|
          #proxy = 'arg_' + p.gsub(/%([0-9]+): ?(.*)/, '\1')
          #props = p.gsub(/%([0-9]+): ?(.*)/, '\2').split(';')

          #properties[proxy] = Hash[props do |p|
            #a = p.split('=')

            #a += [nil] if a.length == 1
            #a = [ a[0] ] + [ a[1..-1].join('=') ] if a.length > 2

            #a
          #end]
        #end

        format = element.attributes["format"]
        raise "#{id}: Unknown format: #{format}" if(description.formats[format] == nil)
        format = description.formats[format]

        instruction = element.attributes["instruction"]
        instruction = description.instructions[instruction]

        opcodes[id] = Opcode.create(description,id,what,processors,format,behavior,properties,operands,encoded,instruction)
      end

      return opcodes
    end
  end

  class Instruction < Mds
    attr_reader :behavior, :execution, :formats, :properties, :mnemonic, :syntax, :synthetic, :schedulings

    def initialize (description, id, what, mnemonic, formats, schedulings, patterns, syntax, synthetic, properties, processors, behavior, execution)
      super(description,id,what,processors)
      @mnemonic = mnemonic
      @formats = []
      formats.each do |format|
        @formats.push format
      end
      @schedulings = schedulings
      @patterns = patterns #maybe a loop
      @syntax = syntax
      @synthetic = synthetic
      @properties = properties

      @behavior = behavior
      @execution = execution
    end

    def self.extract (description, document)
      instructions = MdsOrderedHash.new
      document.elements.each("Instruction") do |element|
        id             = element.attributes["ID"]
        what           = element.attributes["what"]
        mnemonic       = element.attributes["mnemonic"] || ""
        patterns       = element.attributes["patterns"] || ""
        syntax         = element.attributes["syntax"] || ""
        synthetic      = element.attributes["synthetic"] || ""
        properties_str = element.attributes["properties"] || ""
        processors     = element.attributes["processors"]
        schedulings    = element.attributes["schedulings"] || ""
        schedulings    = schedulings.split(' ')

        belt = element.elements["Behavior"]
        behavior = (belt != nil) ? belt.text : nil
        # MDS lisp is not "clean" : clean it (ie make it look really like lisp).
        behavior = behavior.gsub(/%/,"arg_").gsub(/\./, " ") if behavior

        eelt = element.elements["Execution"]
        execution = (eelt != nil) ? eelt.text : nil

        next if id == nil || id[-1..-1] == "-"

        properties = {}
        properties_str.split(',').each do |p|
          proxy = 'arg_' + p.gsub(/%([0-9]+): ?(.*)/, '\1')
          props = p.gsub(/%([0-9]+): ?(.*)/, '\2').split(';')

          properties[proxy] = Hash[props.map do |p|
            a = p.split('=')

            a += [nil] if a.length == 1
            a = [ a[0] ] + [ a[1..-1].join('=') ] if a.length > 2

            a
          end]
        end

        raise "Instruction #{id} has no format" if element.attributes['formats'].nil?

        formats = []
        element.attributes["formats"].split().each do |format|
          raise "Unknown format: #{format}" if(description.formats[format] == nil)
          #format_key = getFormatKey(description.formats[format])
          #formats[format_key] = [] if(formats[format_key] == nil)
          #formats[format_key].push description.formats[format]
          formats.push description.formats[format]
        end
        #formats.each do |format_key,format|
        #id = format_key + "_" + id if format_key != ""
        #description.instructions[id] = Instruction.create(id,what,processors,format,behavior)
        #end

        schedulings = schedulings.map { |scheduling_id| description.schedulings[scheduling_id] }

        instructions[id] = Instruction.create(description, id, what, mnemonic, formats, schedulings, patterns, syntax, synthetic, properties, processors, behavior, execution)
      end

      return instructions
    end
  end

  class Processor < Mds
    attr_reader :interlocks, :min_taken

    def initialize (description, id, what, min_taken, interlocks, pipeline, stages)
      @min_taken = min_taken.to_i if min_taken
      @interlocks = interlocks.to_i if interlocks
      @pipeline = pipeline
      @stages = stages
      super(description,id,what,nil)
    end

    def self.extract (description, document)
      processors = MdsOrderedHash.new
      document.elements.each("Processor") do |element|
        id         = element.attributes["ID"]
        what       = element.attributes["what"]
        min_taken  = element.attributes["minTaken"]
        interlocks = element.attributes["interlocks"]
        pipeline   = element.attributes["pipeline"].split(' ')
        stages     = element.attributes["stages"].split(' ')

        next if id == nil || id[-1..-1] == "-"

        processors[id] = Processor.create(description,id,what,min_taken,interlocks,pipeline,stages)
      end

      return processors
    end
  end

  class Platform < Mds
    attr_reader :addrWidth, :charWidth
    attr_reader :alignData, :alignHeap, :alignStack, :alignText
    attr_reader :nativeFloat, :nativeInt, :nativePtr, :nativeUInt


    def initialize (description, id, what, addrWidth, charWidth,
                    alignData, alignHeap, alignStack, alignText,
                    nativeFloat, nativeInt, nativePtr, nativeUInt)
      @addrWidth = addrWidth.to_i if addrWidth
      @charWidth = charWidth.to_i if charWidth
      @alignData = alignData.to_i if alignData
      @alignHeap = alignHeap.to_i if alignHeap
      @alignStack = alignStack.to_i if alignStack
      @alignText = alignText.to_i if alignText
      @nativeFloat = nativeFloat
      @nativeInt = nativeInt
      @nativePtr = nativePtr
      @nativeUInt = nativeUInt

      super(description, id, what, nil)
    end

    def self.extract (description, document)
      platforms = MdsOrderedHash.new
      document.elements.each("Platform") do |element|
        id = element.attributes["ID"]
        what = element.attributes["what"]
        addrWidth = element.attributes["addrWidth"]
        charWidth = element.attributes["charWidth"]
        alignData = element.attributes["alignData"]
        alignHeap = element.attributes["alignHeap"]
        alignStack = element.attributes["alignStack"]
        alignText = element.attributes["alignText"]
        nativeFloat = element.attributes["nativeFloat"]
        nativeInt = element.attributes["nativeInt"]
        nativePtr = element.attributes["nativePtr"]
        nativeUInt = element.attributes["nativeUInt"]

        next if id == nil || id[-1..-1] == "-"

        platforms[id] = Platform.create(description, id, what, addrWidth, charWidth,
                                        alignData, alignHeap, alignStack,
                                        alignText, nativeFloat, nativeInt,
                                        nativePtr, nativeUInt)
      end

      return platforms
    end
  end

  class Format < Mds
    attr_reader :operands, :behavior, :syntax

    def initialize(description, id, what, processors, operands, behavior, syntax)
      @behavior = behavior
      @operands = []
      @syntax = syntax
      operands.split().each do |operand|
        raise "Unknown operand: #{operand}" if(description.operands[operand] == nil)
        @operands.push description.operands[operand]
      end
      super(description,id,what,processors)
    end

    def self.extract(description, document)
      formats = MdsOrderedHash.new
      document.elements.each("Format") do |element|
        id = element.attributes["ID"]
        what = element.attributes["what"]
        processors = element.attributes["processors"]
        operands = element.attributes["operands"]
        syntax = element.attributes["syntax"]

        belt = element.elements["Behavior"]
        behavior = (belt != nil) ? belt.text : nil

        # MDS lisp is not "clean" : clean it (ie make it look really like lisp).
        behavior = behavior.gsub(/%/,"arg_").gsub(/\./, " ") if behavior

        next if id == nil || id[-1..-1] == "-"

        formats[id] = Format.create(description,id,what,processors,
                                    operands == nil ? "" : operands, behavior, syntax)
      end

      return formats
    end
  end

  class Reservation < Mds
    attr_reader :resources, :requirements

    def initialize(description, id, what, resources, requirements)
      @resources = resources
      @requirements = requirements
      super(description,id,what,nil)
    end

    def self.ID(name)
      Mds.ID("Reservation",name)
    end

    def self.extract(description, document)
      reservations = MdsOrderedHash.new
      document.elements.each("Reservation") do |element|
        id           = element.attributes["ID"]
        what         = element.attributes["what"] || ""
        resources    = element.attributes["resources"] || ""
        requirements = element.attributes["requirements"] || ""

        next if id == nil || id[-1..-1] == "-"

        resources = resources.split(' ')
        for resource_id in resources do
          raise "#{id}: Unknown resource: #{resource_id}" if(description.resources[resource_id] == nil)
        end
        requirements = requirements.split(' ').map{ |r| r.to_i }
        raise "#{id}: Should have as many requirements as resources" if(resources.length != requirements.length)

        requirements = Hash[resources.zip(requirements)]
        resources = resources.map{ |resource_id| description.resources[resource_id] }

        reservations[id] = Reservation.create(description,id,what,resources,requirements)
      end

      return reservations
    end

  end

  class Resource < Mds
    attr_reader :availability

    def initialize(description, id, what, availability)
      @availability = availability
      super(description,id,what,nil)
    end

    def self.ID(name)
      Mds.ID("Resource",name)
    end

    def self.extract(description, document)
      resources = MdsOrderedHash.new
      document.elements.each("Resource") do |element|
        id           = element.attributes["ID"]
        what         = element.attributes["what"] || ""
        availability = element.attributes["availability"].to_i

        next if id == nil || id[-1..-1] == "-"

        resources[id] = Resource.create(description,id,what,availability)
      end

      return resources
    end

  end

  class Scheduling < Mds
    attr_reader :reservation, :bundling

    def initialize(description, id, processors, reservation, bundling)
      @reservation = reservation
      @bundling = bundling
      super(description,id,what,processors)
    end

    def self.ID(name)
      Mds.ID("Scheduling",name)
    end

    def self.extract(description, document)
      scheduling_classes = MdsOrderedHash.new
      document.elements.each("Scheduling") do |element|
        id          = element.attributes["ID"]
        processors  = element.attributes["processors"]
        bundling    = element.attributes["bundling"]

        next if id == nil || id[-1..-1] == "-"

        reservation = element.attributes["reservation"]
        raise "#{id}: Unknown reservation: #{reservation}" if(description.reservations[reservation] == nil)
        reservation = description.reservations[reservation]

        scheduling_classes[id] = Scheduling.create(description,id,processors, reservation, bundling)
      end

      return scheduling_classes
    end
  end

  class BitField < Mds
    attr_reader :offset, :width

    def initialize (description, id, offset, width)
      @offset = offset
      @width = width

      super(description, id, nil, nil)
    end

    def self.extract (description, document)
      operands = MdsOrderedHash.new
      document.elements.each("BitField") do |element|
        id = element.attributes["ID"]
        offset = element.attributes["offset"].to_i
        width = element.attributes["width"].to_i

        next if id == nil || id[-1..-1] == "-"

        operands[id] = BitField.create(description, id, offset, width)
      end

      return operands
    end

  end

  class Operand < Mds
    attr_reader :method, :fields, :shortName

    def initialize(description, id, what, processors, method, relocations, fields, shortName)
      raise "Unknown method: #{method}" if(description.methods[method] == nil)

      @fields = fields
      @method = description.methods[method]
      @relocations = relocations
      @shortName = shortName

      super(description,id,what,processors)
    end

    def self.extract(description, document)
      operands = MdsOrderedHash.new
      document.elements.each("Operand") do |element|
        id = element.attributes["ID"]

        next if id == nil || id[-1..-1] == "-"

        what = element.attributes["what"]
        processors = element.attributes["processors"]
        method = element.attributes["method"]
        fields = (element.attributes["fields"] || "").split(' ').map { |field| description.bitfields[field] }
        shortName = element.attributes["shortName"]
        relocations = element.attributes["relocation"]

        #next if /mainReg/.match(method)  # RV_ RegClass
        #next if /floatReg/.match(method) # RV_ RegClass

        operands[id] = Operand.create(description, id, what,
                                      processors, method, relocations, fields, shortName)
      end

      return operands
    end

  end

  class Immediate < Mds
    attr_reader :width, :shift

    def initialize (description, id, what, processors, width, shift)
      description.methods[id] = self
      # Size in bits
      @width = width.to_i
      @shift = shift.to_i
#      @extend = extend

      super(description,id,what,processors)
    end

    def self.extract (description, document)
      immediates = MdsOrderedHash.new
      document.elements.each("Immediate") do |element|
        id         = element.attributes["ID"]
        what       = element.attributes["what"]
        processors = element.attributes["processors"]
        width      = element.attributes["width"]
        shift      = element.attributes["shift"]
#        extend     = element.attributes["extend"]

        next if id == nil || id[-1..-1] == "-"

        immediates[id] = Immediate.create(description,id,what,processors,width,shift)
      end

      return immediates
    end

  end

  class Storage < Mds
    attr_reader :kind, :width, :count, :registers

    # This order is used in the GCC backend. Everything below and including MEMORY
    # is considered not a register
    REGISTER = 0
    CONSTANT = 1
    CONTROL  = 2
    SPECIAL  = 3
    MEMORY   = 4
    NEIGHBOR = 5

    KIND_TO_GCC_CST = {
      :register => REGISTER, :constant => CONSTANT, :control => CONTROL,
      :special => SPECIAL, :memory => MEMORY, :neighbor => NEIGHBOR
    }

    def initialize (description, id, what, kind, width, count)
      @kind = case kind
              when "Memory" then MEMORY
              when "Control" then CONTROL
              when "Special" then SPECIAL
              when "Register" then REGISTER
              when "Neighbor" then NEIGHBOR
              when "Constant" then CONSTANT
              else raise "Unknown kind in Storage construction: #{kind} for #{id}"
              end
      @width = width.to_i
      @count = count.to_i
      super(description,id,what,nil)
    end

    def self.extract (description, document)
      storages = MdsOrderedHash.new
      document.elements.each("Storage") do |element|
        id = element.attributes["ID"]
        what = element.attributes["what"]
        kind = element.attributes["kind"]
        width = element.attributes["width"]
        count = element.attributes["count"]

        next if id == nil || id[-1..-1] == "-"

        storages[id] = Storage.create(description,id,what,kind,width,count)
      end

      return storages
    end

  end

  class RegClass < Mds
    attr_reader :regfile, :registers, :multi, :names, :processors

    def initialize (description, id, what, processors, regfile, registers, names, shift, bias)
      description.methods[id] = self
      # Size in number of registers
      @regfile = regfile
      @registers = registers
      @names = names
      @shift = shift
      @bias = bias
      super(description,id,what,processors)
    end

    def self.ID(name)
      Mds.ID("RegClass",name)
    end

    def self.extract (description, document)
      regclasses = MdsOrderedHash.new
      document.elements.each("RegClass") do |element|
        id         = element.attributes["ID"]
        what       = element.attributes["what"]
        regfile    = element.attributes["regFile"]
        registers  = element.attributes["registers"].split(' ')
        names      = element.attributes["names"]
        names      = names.split(' ') if names
        shift      = element.attributes["shift"]
        bias       = element.attributes["bias"]
        processors = element.attributes["processors"]

        next if id == nil || id[-1..-1] == "-"
        #next if /RV_/.match(regfile)

        regclasses[id] = RegClass.create(description,id,what,processors,regfile,registers,names,shift,bias)
      end

      return regclasses
    end

    def get_storages
      storages = []
      @registers.each do |reg_id|
        reg = @description.registers[reg_id]
        storages.push(reg.storage) unless storages.include?(reg.storage)
      end

      storages
    end
  end

  # A register file is a RegClass carrying a regFileName: that RegClass is the
  # one holding the width and the native types of the file, and it is its own
  # regclass. The name of the file is unrelated to the name of the RegClass, so
  # it replaces the name Mds derives from the ID.
  class RegFile < Mds
    attr_reader :width, :regclass, :registers, :native_types, :processors, :multi, :number

    def initialize(description, id, what, processors, width,
                   regclass, registers, native_types, multi, regfile_name, number)
      @width        = width.to_i
      @regclass     = regclass
      @registers    = registers
      @native_types = native_types
      @multi        = multi
      @number       = number.to_i
      super(description,id,what,processors)
      @name         = regfile_name
    end

    def self.ID(name)
      Mds.ID("RegClass",name)
    end
    def self.extract (description, document)
      regfiles = MdsOrderedHash.new
      elements = []
      document.elements.each("RegClass") do |element|
        next if element.attributes["regFileName"] == nil
        elements.push element
      end
      # Emit the register files in the order they are declared in.
      elements.sort_by { |e| e.attributes["regFileNumber"].to_i }.each do |element|
        id           = element.attributes["ID"]
        what         = element.attributes["what"]
        width        = element.attributes["width"]
        regfile_name = element.attributes["regFileName"]
        number       = element.attributes["regFileNumber"]
        registers    = element.attributes["registers"].split(' ')
        native_types = element.attributes["nativeTypes"].split(' ')
        processors   = element.attributes["processors"]
        multi        = element.attributes["multi"]
        multi        = multi.split(' ') if multi

        next if id == nil || id[-1..-1] == "-"

        regfiles[id] = RegFile.create(description, id, what, processors, width,
                                      id, registers, native_types, multi,
                                      regfile_name, number)
      end

      return regfiles
    end

  end

  class RegMask < Mds
    attr_reader :count, :first, :regfile

    def initialize (description, id, what, processors, count, first, regfile)
      raise "Unknown regfile: #{regfile}" if(description.regfiles[regfile] == nil)

      description.methods[id] = self

      @count = count
      @first = first
      @regfile = description.regfiles[regfile]

      super(description, id, what, processors)
    end

    def self.extract (description, document)
      regmasks = MdsOrderedHash.new
      document.elements.each("RegMask") do |element|
        id = element.attributes["ID"]
        what = element.attributes["what"]
        count = element.attributes["count"]
        first = element.attributes["first"]
        regfile = element.attributes["regFile"]
        processors = element.attributes["processors"]

        next if id == nil || id[-1..-1] == "-"

        regmasks[id] = RegMask.create(description, id, what, processors, count, first, regfile)
      end

      return regmasks
    end
  end

  class Register < Mds
    attr_reader :storage, :regfile, :addresses, :names, :dwarf_id, :reset, :processors, :width, :fields, :owners, :raccess, :waccess

    def initialize(description, id, what, processors, storage, regfile, addresses, fields, owners, names, raccess, waccess, width, reset, dwarf_id)
      description.methods[id] = self
      @storage = storage
      @regfile = regfile
      @addresses = addresses.map(&:to_i)
      @fields = fields
      @owners = owners
      @names = names
      @raccess = raccess
      @waccess = waccess
      @width = width.to_i
      @reset = reset
      @dwarf_id = dwarf_id.to_i if dwarf_id
      super(description,id,what,processors)
    end

    def self.ID(name)
      Mds.ID("Register",name)
    end

    def self.extract(description, document)
      registers = MdsOrderedHash.new
      document.elements.each("Register") do |element|
        id         = element.attributes["ID"]
        what       = element.attributes["what"]
        storage    = element.attributes["storage"]
        regfile    = element.attributes["regFile"]
        addresses  = element.attributes["addresses"].split(' ')
        fields     = (element.attributes["fields"] || "").split(' ')
        owners     = (element.attributes["owners"] || "").split(' ')
        names      = element.attributes["names"].split(' ')
        raccess    = element.attributes["raccess"]
        waccess    = element.attributes["waccess"]
        width      = element.attributes["width"]
        reset      = element.attributes["reset"]
        dwarf_id   = element.attributes["dwarfId"]
        processors = element.attributes["processors"]

        next if id == nil || id[-1..-1] == "-"
        #next if /RV_/.match(regfile)

        registers[id] = Register.create(description,id,what,processors,storage,regfile,addresses,fields,owners,names,raccess,waccess,width,reset,dwarf_id)
      end

      return registers
    end

  end

  class RegField < Mds
    attr_reader :register, :offset, :width, :owners, :reset, :rerrors, :werrors

    def initialize (description, id, what, register, offset, width, owners, reset, rerrors, werrors)
      description.methods[id] = self
      @register = register
      @offset = offset
      @width = width
      @owners = owners
      @reset = reset
      @rerrors = rerrors
      @werrors = werrors
      super(description,id,what,nil)
    end

    def self.ID(name)
      Mds.ID("RegField",name)
    end

    def self.extract(description, document)
      regfields = MdsOrderedHash.new
      document.elements.each("RegField") do |element|
        id = element.attributes["ID"]
        what = element.attributes["what"]
        register = element.attributes["register"]
        offset = element.attributes["offset"].to_i
        width = element.attributes["width"].to_i
        owners = element.attributes["owners"]
        if (owners) then owners = owners.split ' '
        else owners = [] end
        reset = element.attributes["reset"].to_i
        rerrors = element.attributes["rerrors"]
        if (rerrors) then rerrors = rerrors.split ' '
        else rerrors = [] end
        werrors = element.attributes["werrors"]
        if (werrors) then werrors = werrors.split ' '
        else werrors = [] end

        next if id == nil || id[-1..-1] == "-"

        regfields[id] = RegField.create(description, id, what, register, offset, width, owners, reset, rerrors, werrors)
      end
      return regfields
    end

  end

  class Modifier < Mds
    attr_reader :width, :values, :members, :what

    def initialize (description, id, what, processors, width, values, members)
      description.methods[id] = self
      # Size in bits
      @width = width.to_i
      @values = values
      @members = members
      super(description,id,what,processors)
    end

    def self.extract (description, document)
      modifiers = MdsOrderedHash.new
      document.elements.each("Modifier") do |element|
        id             = element.attributes["ID"]
        what           = element.attributes["what"]
        width          = element.attributes["width"]
        members        = (element.attributes["members"] || "").split(' ')
        values         = (element.attributes["values"] || "").split(' ')
        processors     = element.attributes["processors"]
        properties_str = element.attributes["properties"] || ""

        properties = {}
        properties_str.split(',').each do |p|
          proxy = 'arg_' + p.gsub(/%([0-9]+): ?(.*)/, '\1')
          props = p.gsub(/%([0-9]+): ?(.*)/, '\2').split(';')

          properties[proxy] = Hash[props.map do |p|
            a = p.split('=')

            a += [nil] if a.length == 1
            a = [ a[0] ] + [ a[1..-1].join('=') ] if a.length > 2

            a
          end]
        end

        next if id == nil || id[-1..-1] == "-"

        modifiers[id] = Modifier.create(description,id,what,processors,width,values, members)
      end

      return modifiers
    end

  end

  class NativeType < Mds
    attr_reader :width, :sizeof, :type

    def initialize (description, id, what, processors, width, sizeof, type = "Unsigned")
      super(description,id,what,processors)
      @width = width.to_i
      @sizeof = sizeof.to_i
      @type = type
    end

    def self.extract (description, document)
      nativetypes = MdsOrderedHash.new
      document.elements.each("NativeType") do |element|
        id = element.attributes["ID"]
        what = element.attributes["what"]
        width = element.attributes["width"].to_i
        sizeof = element.attributes["sizeof"].to_i
        type = element.attributes["type"]
        processors = element.attributes["processors"]

        next if id == nil || id[-1..-1] == "-"

        nativetype = NativeType.create(description,id,what,processors,width,sizeof,type)
        nativetypes[id] = nativetype
      end

      return nativetypes
    end

  end

  class OpndInfo
    def initialize (type,format,opnd1_idx,operand1,constant=nil,opnd2_idx = nil,operand2=nil,part=nil)
      @type = type
      @opnd_idx = []
      @opnd_idx.push opnd1_idx
      @opnd_idx.push opnd2_idx if(opnd2_idx)
      @format = format
      @operands = []
      @operands.push operand1
      @operands.push operand2 if(operand2)
      @constant = constant if(constant)
      @parts = []
      @parts.push part if(part)
    end
  end

  class Ctype2Opnd
    def initialize ()
      @UNKNOWN  = -1
      @CONSTANT = 0
      @MERGED   = 1
      @PAIRED   = 2
      @SINGLE   = 3

      @formats = {}
      @ctypes = {}

      @debug = false
    end

    def debug (str)
      if(@debug) then
        STDERR.puts str
      end
    end

    def add_constant(format,opnd_idx,operand,constant)
      opnd_info = OpndInfo.new(@CONSTANT,format,opnd_idx,operand,constant)
      @formats[format.id] = [] if(not @formats[format.id])
      @formats[format.id][opnd_idx] = opnd_info;
      debug "add_constant -> #{operand.id} #{constant}"
    end

    def add_merged(ctype,ctype_idx,format,opnd_idx,operand,part)
      raise "C type not defined for ctype_idx = #{ctype_idx}" if(ctype == nil)

      opnd_info = OpndInfo.new(@MERGED,format,opnd_idx,operand,nil,nil,nil,part)
      @formats[format.id] = [] if(not @formats[format.id])
      @formats[format.id][opnd_idx] = opnd_info;
      @ctypes[format.id] = [] if(not @ctypes[format.id])
      @ctypes[format.id][ctype_idx] = opnd_info;

      debug "add_merged -> #{ctype} #{ctype_idx}: #{operand.id} #{part}"
    end

    def add_paired(ctype,ctype_idx,format,opnd1_idx,operand1,opnd2_idx,operand2)
      raise "C type not defined for ctype_idx = #{ctype_idx}" if(ctype == nil)

      opnd_info = OpndInfo.new(@PAIRED,format,opnd1_idx,operand1,nil,opnd2_idx,operand2)
      @formats[format.id] = [] if(not @formats[format.id])
      @formats[format.id][opnd1_idx] = opnd_info;
      @formats[format.id][opnd2_idx] = opnd_info;
      @ctypes[format.id] = [] if(not @ctypes[format.id])
      @ctypes[format.id][ctype_idx] = opnd_info;

      debug "add_paired -> #{ctype} #{ctype_idx}: #{operand1.id}:#{operand2.id}"
    end

    def add_single(ctype,ctype_idx,format,opnd_idx,operand)
      raise "C type not defined for ctype_idx = #{ctype_idx}" if(ctype == nil)

      opnd_info = OpndInfo.new(@SINGLE,format,opnd_idx,operand)
      @formats[format.id] = [] if(not @formats[format.id])
      @formats[format.id][opnd_idx] = opnd_info;
      @ctypes[format.id] = [] if(not @ctypes[format.id])
      @ctypes[format.id][ctype_idx] = opnd_info;

      debug "add_single -> #{ctype} #{ctype_idx}: #{operand.id}"
    end
  end

  class Builtin < Mds

    attr_reader :prototype, :instructions, :formats, :operands, :gcc_types, :gcc_modes

    def initialize (description, id, what, processors, prototype, instruction, formats, arguments)
      super(description,id,what,processors)
      @prototype = prototype
      @instruction = instruction
      @formats = []
      @builtins = []
      @gcc_types = []
      @gcc_modes = []
      @operands = {}
      @cname = ""
      @ctype2opnd = Ctype2Opnd.new
      @debug = false

      operands_regexp = "("+arguments.split(/[ :]/).join("|").gsub(/\.w[01]{1}/,"")+")"

      argument_types = []
      if(@prototype != "") then
        proto = @prototype.split(/[\(\)]+/)
        retval = proto[0].split(/__builtin/)[0]
        @cname = "__builtin"+proto[0].split(/__builtin/)[1]
        tokens = proto[1].split(/,/)
        retval = retval.gsub(/\s+/,"")
        argument_types = [ retval ]
        tokens.each do |token|
          next if(token == @cname)
          token = token.gsub(/#{operands_regexp}/,"")
          argument_types.push token.gsub(/ /,"")
        end
      end

      formats.split().each do |format|
        add_format(format)
      end

      @gccinfo = {
        # C type   => [ gcc type, gcc mode ]
        "void"     => [ "VOID", "VOIDmode" ],
        "void*"    => [ "voidPTR", "DImode" ],
        "uint8_t"  => [ "uintBI", "BImode" ],
        "int8_t"   => [ "intBI",  "BImode" ],
        "uint16_t" => [ "uintHI", "HImode" ],
        "int16_t"  => [ "intHI",  "HImode" ],
        "uint32_t" => [ "uintSI", "SImode" ],
        "unsigned" => [ "uintSI", "SImode" ],
        "int32_t"  => [ "intSI",  "SImode" ],
        "uint64_t" => [ "uintDI", "DImode" ],
        "int64_t"  => [ "intDI",  "DImode" ],
        "float"    => [ "floatSF","SFmode" ],
        "double"   => [ "floatDF","DFmode" ],
      }

      debug "#{id}: proto => #{prototype} operands => #{arguments}"

      operand_idx = 0
      argument_idx = 0
      ctype_idx = 0
      arg_list = arguments.split()
      while(argument_idx < arg_list.length)
        ctype = argument_types[ctype_idx]
        argument = arg_list[argument_idx]
        raise "Unsupported merge arguments for builtin result" if(ctype_idx == 0 and argument =~ /:/)
        # Split case
        if(argument =~ /\.w([01]{1})/) then
          debug " ----> #{argument_idx}: first pair"
          opnd1_idx = operand_idx
          opnd1_idx += $1.to_i()
          argument_idx += 1
          argument = arg_list[argument_idx]
          if(argument =~ /\.w([01]{1})/) then
            debug " ----> #{argument_idx}: second pair"
            opnd2_idx = operand_idx
            opnd2_idx += $1.to_i()
            @formats.each do |format|
              operand1 = format.operands[opnd1_idx]
              operand2 = format.operands[opnd2_idx]
              @ctype2opnd.add_paired(ctype,ctype_idx,format,opnd1_idx,operand1,opnd2_idx,operand2)
            end
          elsif(argument =~ /^([x0-9A-Fa-f]+$)/) then
            debug " ----> #{argument_idx}: second constant"
            opnd2_idx = (operand_idx != opnd1_idx) ? operand_idx : operand_idx + 1
            @formats.each do |format|
              operand1 = format.operands[opnd1_idx]
              operand2 = format.operands[opnd2_idx]
              @ctype2opnd.add_single(ctype,ctype_idx,format,opnd1_idx,operand1)
              @ctype2opnd.add_constant(format,opnd2_idx,operand2,get_value($1))
            end
          end
          operand_idx += 1
        elsif(argument =~ /:/) then
          debug " ----> #{argument_idx}: merged"
          args = argument.split(/:/)
          args.each do |arg|
            arg =~ /_(w[0-9]+)$/
            @formats.each do |format|
              operand = format.operands[operand_idx]
              @ctype2opnd.add_merged(ctype,ctype_idx,format,operand_idx,operand,$1)
            end
            ctype_idx += 1
          end
        elsif(argument =~ /^([x0-9A-Fa-f]+)$/) then
          debug " ----> #{argument_idx}: constant"
          @formats.each do |format|
            operand = format.operands[operand_idx]
            @ctype2opnd.add_constant(format,operand_idx,operand,get_value($1))
          end
          ctype_idx -= 1 # Do not increment builtin argument index
        else
          debug " ----> #{argument_idx}: add single"
          @formats.each do |format|
            operand = format.operands[operand_idx]
            @ctype2opnd.add_single(ctype,ctype_idx,format,operand_idx,operand)
          end
        end
        ctype_idx += 1
        argument_idx += 1
        operand_idx += 1
      end

      argument_types.each do |ctype|
        raise "Unknown C type '#{ctype}' for #{@id}" if(not @gccinfo.has_key?(ctype))
        @gcc_types.push @gccinfo[ctype][0]
        @gcc_modes.push @gccinfo[ctype][1]

      end
    end

    def get_value (str)
      value = -1
      if(str =~ /^0x/) then
        value = str.to_i(16)
      else
        value = str.to_i(10)
      end
      return value
    end


    def add_format (format)
      raise "Format #{format} not known" if(description.formats[format] == nil)
      if(@formats[0] != nil) then
        operands0 = @formats.first.operands.length
        operands1 = description.formats[format].operands.length

        if(operands0 != nil and operands1 != nil and operands0 != operands1) then
          raise "Formats #{format0.name} and #{format1.name} mismatch on operands number."
        end
      end
      @formats.push description.formats[format]
    end

    def dump ()
      puts "#{@id}:"
      puts "  prototype = #{@prototype}"
      puts "  what = #{@what}"
      puts "  instruction = #{@instruction}"
      format_ids = []
      @formats.each do |format|
        format_ids.push format.id
      end
      puts "  formats = " + format_ids.join(" ")
    end

    def self.extract (description, document)
      builtins = MdsOrderedHash.new
      document.elements.each("Builtin") do |element|
        id = element.attributes["ID"]
        what = element.attributes["what"]
        processors = element.attributes["processors"]
        prototype = element.attributes["prototype"]
        prototype = "" if not prototype
        instruction = element.attributes["instruction"]
        instruction = "" if not instruction
        formats = element.attributes["formats"]
        formats = "" if not formats
        arguments = element.attributes["operands"]
        arguments = "" if not arguments

        next if id == nil || id[-1..-1] == "-"

        builtins[id] = Builtin.create(description,id,what,processors,prototype,instruction,formats,arguments)
      end

      return builtins
    end

    def debug(str)
      if(@debug) then
        STDERR.puts str
      end
    end
  end


  class Convention < Mds
    attr_reader :reserved, :argument, :result, :struct, :caller, :callee, :program, :handler, :veneer, :return, :stack, :static, :frame, :global, :local, :wired, :zero, :fzero, :one, :true_pred

    def initialize (description, id, what, processors, reserved, argument, result, struct, caller, callee, program, handler, veneer, returnaddr, stack, static, frame, global, local, wired, zero, fzero, one, true_pred)
      super(description, id,what,processors)
      @reserved = reserved
      @argument = argument
      @result = result
      @struct = struct
      @caller = caller
      @callee = callee
      @program = program
      @handler = handler
      @veneer = veneer
      @return = returnaddr
      @stack = stack
      @static = static
      @frame = frame
      @global = global
      @local = local
      @wired = wired
      @zero = zero
      @fzero = fzero
      @one = one
      @true_pred = true_pred
    end

    def self.extract (description, document)
      conventions = MdsOrderedHash.new
      document.elements.each("Convention") do |element|
        id = element.attributes["ID"]
        what = element.attributes["what"]
        processors = element.attributes["processors"]
        reserved = element.attributes["reserved"]
        reserved = reserved.split ' ' if reserved
        argument = element.attributes["argument"]
        argument = argument.split ' ' if argument
        result = element.attributes["result"]
        result = result.split ' ' if result
        struct = element.attributes["struct"]
        struct = struct.split ' ' if struct
        caller = element.attributes["caller"]
        caller = caller.split ' ' if caller
        callee = element.attributes["callee"]
        callee = callee.split ' ' if callee
        program = element.attributes["program"]
        program = program.split ' ' if program
        handler = element.attributes["handler"]
        handler = handler.split ' ' if handler
        veneer = element.attributes["veneer"]
        veneer = veneer.split ' ' if veneer
        returnaddr = element.attributes["return"]
        returnaddr = returnaddr.split ' ' if returnaddr
        stack = element.attributes["stack"]
        stack = stack.split ' ' if stack
        static = element.attributes["static"]
        static = static.split ' ' if static
        frame = element.attributes["frame"]
        frame = frame.split ' ' if frame
        global = element.attributes["global"]
        global = global.split ' ' if global
        local = element.attributes["local"]
        local = local.split ' ' if local
        wired = element.attributes["wired"]
        wired = wired.split ' ' if wired
        zero = element.attributes["zero"]
        zero = zero.split ' ' if zero
        fzero = element.attributes["fzero"]
        fzero = fzero.split ' ' if fzero
        one = element.attributes["one"]
        one = one.split ' ' if one
        true_pred = element.attributes["true"]
        true_pred = true_pred.split ' ' if true_pred

        next if id == nil || id[-1..-1] == "-"

        convention = Convention.create(description, id, what, processors, reserved, argument, result, struct, caller, callee, program, handler, veneer, returnaddr, stack, static, frame, global, local, wired, zero, fzero, one, true_pred)
        conventions[id] = convention
      end

      return conventions
    end
  end

  class Synthetic < Mds
    attr_reader :what, :mnemonic, :instruction, :formats
    attr_reader :syntax, :forced, :values, :processors

    def initialize (description, id, what, processors, mnemonic, instruction, formats, syntax, forced, values)
      super(description, id,what,processors)
      @mnemonic    = mnemonic
      @instruction = instruction
      @formats     = formats
      @syntax      = syntax
      @forced      = forced
      @values      = values
    end

    def self.extract (description, document)
      synthetics = MdsOrderedHash.new
      document.elements.each("Synthetic") do |element|
        attrs = element.attributes
        id = attrs["ID"]
        next if id == nil || id[-1..-1] == "-"
        what = attrs["what"]
        processors = attrs["processors"]
        mnemonic    = attrs["mnemonic"]
        instruction = attrs["instruction"]
        formats = []
        element.attributes["formats"].split().each do |format|
          raise "Unknown format: #{format}" if(description.formats[format] == nil)
          formats.push description.formats[format]
        end
        syntax      = attrs["syntax"]
        forced      = attrs["forced"].gsub(/%/, '').split(' ').map &:to_i unless attrs["forced"].nil?
        values      = attrs["values"].split(' ').map &:to_i unless attrs["values"].nil?


        synthetic = Synthetic.create(description, id, what, processors, mnemonic, instruction, formats, syntax, forced, values)
        synthetics[id] = synthetic
      end

      return synthetics
    end

  end
end
