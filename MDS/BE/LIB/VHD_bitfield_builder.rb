class Field

  attr_reader :name, :width, :description

  def initialize(width, name, description)
    @name = name
    @width = width
    @description = description
  end

  def build(args, writer: nil, is_top: false)
    name_syn = @name.to_sym
    arg = args&.key?(name_syn) && args[name_syn]

    if @width == 1
      writer.add_bit(arg.instance_of?(TrueClass) || arg == 1 ? "1" : "0")
    else
      value = arg.instance_of?(Integer) ? arg : 0
      writer.add_bitfield(value.to_s(2), @width)
    end
  end

  def get_info(start_bit=0)
    return {low: start_bit, high: start_bit+@width-1, name: @name}
  end

end


class FieldLookup

  attr_reader :name, :width, :description

  def initialize(width, name, description, table = nil)
    @name = name
    @width = width
    @description = description
    @table = table
  end

  def build(args, writer: nil, is_top: false)
    name_syn = @name.to_sym
    arg = args&.key?(name_syn) && args[name_syn]

    if arg && @table.key?(arg.to_sym)
      writer.add_constant(@table[arg.to_sym])
      return
    end
    writer.add_bitfield("", @width)
  end

  def get_info(start_bit=0)
    return {low: start_bit, high: start_bit+@width-1, name: @name}
  end

end


class FieldReserved

  attr_reader :width

  def initialize(width)
    @width = width
  end

  def name
    ''
  end

  def description
    'reserved'
  end

  def build(args, writer: nil, is_top: false)
    writer.add_bitfield('', @width) # Pad with 0's by default
  end

  def get_info(start_bit = 0)
    { low: start_bit, high: start_bit + @width - 1, name: name }
  end

end


class FieldContainerGeneric

  attr_reader :subfields

  def initialize
    @subfields = []
  end

  def width
    raise 'FieldContainerGeneric have no defined width'
  end

  def group(name)
    group = FieldGroup.new(name)
    @subfields.append(group)
    return group
  end

  def field(width, name, description="")
    field = Field.new(width, name, description)
    @subfields.append(field)
    return self
  end

  def field_lookup(width, name, description, table)
    field = FieldLookup.new(width, name, description, table)
    @subfields.append(field)
    return self
  end

  def field_reserved(width)
    field = FieldReserved.new(width)
    @subfields.append(field)
    return self
  end

end


class FieldGroup < FieldContainerGeneric

  attr_reader :name

  def initialize(name)
    super()
    @name = name
  end

  def width
    @subfields.sum(&:width)
  end

  def get_info(start_bit=0)
    current_bit = start_bit
    content = []
    @subfields.each do |field|
      info = field.get_info(current_bit)
      content.append(info)
      current_bit = info[:high] + 1
    end
    return {
      name: @name,
      content: content,
      low:  start_bit,
      high: current_bit - 1,
    }
  end

  def build(args, writer: nil, is_top: true)
    @subfields.each do |field|
      sub_args = args
      if field.instance_of?(FieldGroup)
        grp_name = field.name.to_sym
        sub_args = args.key?(grp_name) ? args[grp_name] : {}
      end
      field.build(sub_args, writer: writer, is_top: false)
      writer.add_separator if is_top
    end
  end

  def build_write(args)
    bitfield_writer = BitFieldWriter.new
    build(args, writer: bitfield_writer)
    return bitfield_writer.get
  end

end


class BitFieldWriter

  def initialize
    @in_bitstring = false
    @content = ""
    @last_sep = ""
  end

  def add_separator
    @last_sep = "_" if @in_bitstring
  end

  def add_bitfield(value, width)
    value = value.rjust(width, '0')
    if @in_bitstring
      @content = "#{value}#{@last_sep}#{@content}"
    else
      @content = "#{value}\"#{@last_sep}#{@content}"
      @in_bitstring = true # Enter a bitstring
    end
    @last_sep = ""
  end

  def add_constant(value)
    if @in_bitstring
      @content = "#{value} & b\"#{@content}"
      @in_bitstring = false # Exit a bitstring
    else
      @content = "#{value}#{@last_sep}#{@content}"
    end
    @last_sep = " & "
  end

  def add_bit(value)
    add_bitfield(value, 1)
  end

  def get
    return "b\"#{@content}" if @in_bitstring
    return @content
  end

end


class UCodeBuilder < FieldGroup

  def initialize(name)
    super(name)
  end

  def vhd_range
    return "#{width - 1} downto 0"
  end

  def get_field_description(field, bit_idx=0)
    idx_start = bit_idx
    idx_end = bit_idx + field.width - 1
    field_description = {
      position: [idx_start, idx_end],
      name: field.name,
      field: field,
    }
    if field.kind_of?(FieldGroup)
      subfields_description = Array.new
      subfields = field.subfields
      subfields.each do |subfield|
        description = get_field_description(subfield, bit_idx)
        subfields_description.append(description)
        bit_idx += subfield.width
      end
      field_description[:fields] = subfields_description
    else
      field_description[:details] = field.description
    end
    return field_description
  end

  def get_formated_description()
    field_description = get_field_description(self)
    bits = extract_per_bit_description(field_description[:fields])
    description = format_per_bit_description(bits)
  end

  def extract_per_bit_description(fields, bits = Array.new)
    padding = fields.map { |field| field[:name].to_s.length + 1 }.max

    fields.each do |field|
      pos = field[:position]
      bit_range = pos[0]..pos[1]
      bit_range.each do |bit_idx|
        is_first = (bit_idx == bit_range.first)
        is_last  = (bit_idx == bit_range.last)
        bits[bit_idx] = Array.new if bits[bit_idx].nil?
        bits[bit_idx].append({
          field: field,
          padding: padding,
          is_first: is_first,
          is_last:  is_last,
        })
      end
      sub_fields = field[:fields]
      if sub_fields
        bits = extract_per_bit_description(sub_fields, bits)
      end
    end
    return bits
  end

  def format_per_bit_description(bits)
    formated_description = Array.new
    bit_padding = (bits.length - 1).to_s.length
    bits.each_index do |bit_idx|
      bit = bits[bit_idx]
      line = Array.new
      bit.each do |field|
        name = field[:field][:name]
        details = field[:field][:details]
        padding = field[:padding]

        last_field = (bit.last == field)
        is_first = field[:is_first]
        is_last = field[:is_last]

        # Generate prefix
        spaces = "".ljust(padding)
        if is_first && is_last
          prefix = "╶ #{name.ljust(padding)}"
        elsif is_first
          prefix = "┌ #{name.ljust(padding)}"
        elsif is_last
          prefix = "└ #{spaces}"
        else
          prefix = "│ #{spaces}"
        end
        prefix = "#{prefix} (#{details})" if last_field && is_first && !details.nil? && !details.empty?
        # Create line
        line.append("#{prefix}")
      end
      formated_description.append("b#{bit_idx.to_s.ljust(bit_padding)} " + line.join(""))
    end

    return formated_description
  end

end
