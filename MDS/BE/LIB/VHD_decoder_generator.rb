require 'VHD'

module Generator


  class Instruction
    attr_reader :opcode, :metadata, :comment
    def initialize(opcode, metadata, comment)
      @opcode = opcode
      @metadata = metadata
      @comment = comment
    end

    def to_s
      "#{@name}: #{@opcode.to_s}"
    end
  end


  class OpcodeOrderer

    class Element
      attr_accessor :key, :value, :precedence, :used
      def initialize(key, value)
        @key = key
        @value = value
        @precedence = []
        @used = false
      end
    end


    attr_reader :missing_opcode, :missing_ucode
    def initialize
      @list = Array.new
      @missing_opcode = Array.new
      @missing_ucode = Array.new
    end

    def add_missing_opcode(name)
      @missing_opcode.append(name)
    end

    def add_missing_ucode(name)
      @missing_ucode.append(name)
    end

    def add_opcode(key, value)
      @list.append(Element.new(key, value))
    end

    def prepare_precedence
      @list.each do |element1|
        @list.each do |element2|
          next if element1 == element2
          if element1.key == element2.key
            raise "Error: Element have same keys"
          end
          common_bits = element1.key.get_shared_bits(element2.key)
          if common_bits.match(element1.key)
            element2.precedence.append(element1)
          end
        end
      end
    end

    def follow_precedence(element, ordered)
      return if element.used
      element.used = true
      element.precedence.each do |sub_element|
        follow_precedence(sub_element, ordered)
      end
      ordered.append(element.value)
    end

    def get_sorted
      prepare_precedence
      ordered = []
      @list.each do |element|
        follow_precedence(element, ordered)
      end
      return ordered.reverse
    end
  end


  class DecoderGenerator
    def initialize
      @to_generate = Array.new
    end

    def add_generation(type, param)
      @to_generate.append({
        type: type,
        param: param,
      })
    end

    def generate
      @to_generate.each do |to_gen|
        type = to_gen[:type]
        param = to_gen[:param]
        if type == "vhd_decoder"
          Generator::generate_decoder_file(**param)
        elsif type == "vhd_decoder_pkg"
          Generator::generate_package_file(**param)
        end
      end
    end
  end


  def self.get_from_path(hash, path)
    path = [] if path.nil?
    return hash if path.empty?
    id = path[0]
    return Generator::get_from_path(hash[id], path.drop(1))
  end

  def self.generate_opcode_list(mds_opcodes, ucode_map)
    opcode_list = Generator::OpcodeOrderer.new
    found_opcodes = Set.new

    mds_opcodes.each do |mds_opcode_id, mds_opcode|
      mds_instruction = mds_opcode.instruction
      opcode_id = mds_opcode.id

      opcode_name_regex = /Opcode-[^-]+-(.+)/
      opcode_name = opcode_name_regex.match(opcode_id)[1]
      found_opcodes.add(opcode_name)

      next unless ucode_map.has_key?(opcode_name)
      next if ucode_map[opcode_name].nil?

      ucode = ucode_map[opcode_name]
      encoding = BitVector.new(mds_opcode.encoded)
      comment = ["#{opcode_name}"]

      instruction = Generator::Instruction.new(encoding, ucode, comment)
      opcode_list.add_opcode(encoding, instruction)
    end

    defined_opcodes = Set.new(ucode_map.keys)

    missing_opcode = defined_opcodes - found_opcodes
    missing_opcode.to_a.each do |name|
      opcode_list.add_missing_opcode(name)
    end

    missing_ucode = found_opcodes - defined_opcodes
    missing_ucode.to_a.each do |name|
      opcode_list.add_missing_ucode(name)
    end

    unless opcode_list.missing_opcode.empty?
      puts '[WARNING] The following instruction(s) have no encoding:'
      opcode_list.missing_opcode.each do |instruction_name|
        puts "  #{instruction_name}"
      end
    end

    unless opcode_list.missing_ucode.empty?
      puts '[WARNING] The following instruction(s) have no ucode:'
      opcode_list.missing_ucode.each do |instruction_name|
        puts "  #{instruction_name}"
      end
    end

    return opcode_list
  end

  def self.generate_decoder_file(
      module_name:,
      filename:,
      decoder_description:,
      opcode_list:,
      extra_vhd_libraries: []
    )

    # Sort opcodes to prevent wrong ordering
    opcode_list_sorted = opcode_list.get_sorted

    # Generate a VHDL file
    decoder_module = VHD::Module.new(module_name)
    extra_vhd_libraries.each do |vhd_library|
      decoder_module.add_library(vhd_library)
    end
    decoder_module.add_port_in( 'opcode_i', "std_logic_vector(31 downto 0)")
    decoder_description.each do |decoder|
      port_name = decoder[:port_name]
      ucode_builder = decoder[:ucode_builder]
      decoder_module.add_port_out(port_name, "std_logic_vector(#{ucode_builder.vhd_range})")
    end
    decoder_module.add_port_out('match_o', "std_logic")

    # Add comment for ucode description
    decoder_description.each do |decoder|
      name = decoder[:name]
      port_name = decoder[:port_name]
      desc = decoder[:ucode_builder].get_formated_description

      decoder_module.append(VHD::Inline.new([""])) # Empty line
      decoder_module.append(VHD::Comment.new(["#{name} ucode (#{port_name}) description:"]))
      decoder_module.append(VHD::Comment.new(desc))
    end

    decoder_module.append(VHD::Inline.new([""])) # Empty line

    process = VHD::Process.new("p_decode")
    process.add_to_sensitivity('opcode_i')

    process.append(VHD::Comment.new(["Default values"]))
    process.append(VHD::Inline.new(
      decoder_description.map { |p| "#{p[:port_name]} <= (others => '0');" } + [
        "match_o <= '0';",
        "",
      ]
    ))

    # Build if chain
    previous_if = nil
    first_if = nil

    opcode_list_sorted.each do |instruction|

      instr_metadata = instruction.metadata

      code = Array.new
      if instr_metadata == false
        code.append("match_o <= '0';")
      else
        decoder_description.each do |decoder|
          ucode_to_build = Generator::get_from_path(instr_metadata, decoder[:path])
          port_name = decoder[:port_name]
          ucode_builder = decoder[:ucode_builder]
          ucode_vhd = ucode_builder.build_write(ucode_to_build)
          code.append("#{port_name} <= #{ucode_vhd};")
        end
        code.append("match_o <= '1';")
      end

      if_statement_condition = "std_match(opcode_i, \"#{instruction.opcode}\")"
      if_statement = VHD::If.new(if_statement_condition, inline: true)
      if_statement.add_comment(VHD::Comment.new(instruction.comment))
      if_statement.append(VHD::Inline.new(code))

      # Put "if-statement" in order
      first_if = if_statement unless first_if
      previous_if.add_else(if_statement) if previous_if
      previous_if = if_statement
    end

    process.append(first_if) # TODO: Error if no first_if (no opcode)

    unless opcode_list.missing_opcode.empty?
      decoder_module.append(VHD::Comment.new(
        ['Instructions without an encoding:'] +
        opcode_list.missing_opcode
      ))
      decoder_module.append(VHD::Inline.new([''])) # Empty line
    end

    unless opcode_list.missing_ucode.empty?
      decoder_module.append(VHD::Comment.new(
        ['Instructions without ucode:'] +
        opcode_list.missing_ucode
      ))
      decoder_module.append(VHD::Inline.new([''])) # Empty line
    end

    decoder_module.append(process)

    # Write the decoder module to a file
    vhd_file = VHD::File.new
    vhd_file.append(VHD::Comment.new([
      "/!\\ Generated file /!\\",
      "Do not modify this file manually",
    ]))
    vhd_file.append(VHD::Inline.new([""])) # Empty line
    vhd_file.append(decoder_module)

    vhd_writer = VHD::Writer.new
    vhd_writer.set_file(filename)
    vhd_file.write(vhd_writer)
  end

  def self.info_to_vhd(info, vhd_pkg, prefix=[])
    prefix = prefix.clone
    prefix.append(info[:name])

    length = info[:high] - info[:low] + 1
    name = prefix.join('_').upcase
    name_length = "#{name}_LENGTH"

    if info.key?(:content)
      vhd_len = VHD::Constant.new(name_length, 'natural', length)
      vhd_pkg.append(vhd_len)
      info[:content].each do |sub_info|
        info_to_vhd(sub_info, vhd_pkg, prefix)
      end
    else
      if length == 1
        vhd = VHD::Constant.new(name, "natural", info[:low])
        vhd_len = VHD::Constant.new(name_length, "natural", length)
      else
        vhd = VHD::RangeType.new(name, 'natural', info[:low], info[:high])
        vhd_len = VHD::Constant.new(name_length, "natural", length)
      end
      vhd_pkg.append(vhd)
      vhd_pkg.append(vhd_len)
    end
  end

  def self.generate_package_file(package_name:, filename:, name_prefix:, decoder_description:)
    decoder_pkg = VHD::Package.new(package_name)

    decoder_description.each do |ucode_desc|
      name = ucode_desc[:name]
      description = ["#{name} ucode constants:"]
      decoder_pkg.append(VHD::Inline.new([""])) # Empty line
      decoder_pkg.append(VHD::Comment.new(description))
      infos = ucode_desc[:ucode_builder].get_info()
      info_to_vhd(infos, decoder_pkg, name_prefix)
    end

    decoder_pkg.append(VHD::Inline.new([""])) # Empty line

    pkg_file = VHD::File.new
    pkg_file.append(VHD::Comment.new([
      "/!\\ Generated file /!\\",
      "Do not modify this file manually",
    ]))
    pkg_file.append(VHD::Inline.new([""])) # Empty line
    pkg_file.append(decoder_pkg)

    vhd_writer = VHD::Writer.new
    vhd_writer.set_file(filename)
    pkg_file.write(vhd_writer)
  end

end
