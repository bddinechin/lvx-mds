module VHD


  class Writer
    def initialize(indent_level=0, indent_text="  ")
      @indent_level = indent_level
      @indent_text = indent_text
      @file = nil
    end

    def write_line(line)
      text = @indent_text * @indent_level + line
      text = text.rstrip # Remove trailing whitespaces
      if @file
        @file.puts text
      else
        puts text
      end
    end

    def write_lines(lines)
      lines.each do |line|
        write_line(line)
      end
    end

    def change_indent(diff)
      @indent_level += diff
    end

    def set_file(file_name)
      @file = ::File.open(file_name, "w")
    end
  end


  class File
    def initialize
      @content = []
    end

    def append(element)
      @content.append(element)
    end

    def write(writer)
      @content.each do |statement|
        statement.write(writer)
      end
    end
  end


  class LineWriter
    def initialize()
      @lines = []
    end

    def write_line(line)
      @lines.append(line)
    end

    def write_lines(lines)
      lines.each do |line|
        write_line(line)
      end
    end

    def write(writer)
      writer.write_line(@lines.join(" "))
    end

    def change_indent(diff)
    end
  end


  class Inline
    def initialize(lines)
      @lines = lines
    end

    def write(writer)
      @lines.each do |line|
        writer.write_line(line)
      end
    end
  end


  class Comment < Inline
    def initialize(comment_lines)
      lines = comment_lines.map { |comment_line| "-- " + comment_line }
      super(lines)
    end
  end


  class Subtype
    attr_reader :name, :base_type
    def initialize(name, base_type)
      @name = name
      @base_type = base_type
    end

    def definition
      raise 'Subtype have no definition'
    end

    def write(writer)
      writer.write_line "subtype #{@name} is #{definition};"
    end
  end


  class Constant
    def initialize(name, type, value)
      @name = name
      @type = type
      @value = value
    end

    def write(writer)
      writer.write_line "constant #{@name} : #{@type} := #{@value};"
    end
  end


  class RangeType < Subtype
    def initialize(name, base_type, low, high)
      super(name, base_type)
      @boundary_low = low
      @boundary_high = high
    end

    def definition
      "#{self.base_type} range #{@boundary_high} downto #{@boundary_low}"
    end
  end


  class Block
    def initialize
      @content = []
    end

    def append(element)
      @content.append(element)
    end

    def write_content(writer)
      writer.change_indent(+1)
      @content.each do |statement|
        statement.write(writer)
      end
      writer.change_indent(-1)
    end
  end


  class Package < Block
    def initialize(name)
      super()
      @name = name
    end

    def add_list(list)
      list.each do |element|
        name = element[:name]
        if element[:low] == element[:high]
          vhd = VHD::Constant.new(name, "natural", element[:low])
        else
          vhd = VHD::RangeType.new(name, 'natural', element[:low], element[:high])
        end
        vhd_pkg.append(vhd)
      end
    end

    def write_libraries(writer)
      get_libraries().each do |lib_name, used|
        writer.write_line "library #{lib_name};"
        used.each do |use|
          writer.write_line "use     #{lib_name}.#{use}.all;"
        end
        writer.write_line ""
      end
    end

    def write(writer)
      write_libraries(writer)

      writer.write_line "package #{@name} is"
      write_content(writer)
      writer.write_line "end package;"
    end

    def get_libraries()
      libs = []
      libs_list = Hash.new
      libs.each do |lib|
        if libs_list.key?(lib[0])
          libs_list[lib[0]].add(lib[1])
        else
          libs_list[lib[0]] = Set[lib[1]]
        end
      end
      return libs_list
    end
  end


  class Module < Block
    def initialize(name)
      super()
      @name = name
      @architecture_name = "rtl"
      @port_in = []
      @port_out = []
      @libraries = [
        # TODO: Replace default libraries with a library lookup
        # Default libraries
        ["ieee", "std_logic_1164", "all"],
        ["ieee", "std_logic_misc", "all"],
        ["ieee", "numeric_std", "all"],
      ]
    end

    def add_port_in(name, type)
      @port_in.append([name, type])
    end

    def add_port_out(name, type)
      @port_out.append([name, type])
    end

    def write_libraries(writer)
      get_libraries().each do |lib_name, used|
        writer.write_line "library #{lib_name};"
        used.each do |use|
          writer.write_line "use     #{lib_name}.#{use}.all;"
        end
        writer.write_line ""
      end
    end

    def add_library(library)
      @libraries.append(library)
    end

    def get_libraries()
      libs_list = Hash.new
      @libraries.each do |lib|
        if libs_list.key?(lib[0])
          libs_list[lib[0]].add(lib[1])
        else
          libs_list[lib[0]] = Set[lib[1]]
        end
      end
      return libs_list
    end

    def write_instance_ports(writer, connection)
      len = (@port_in + @port_out).map { |port| port[0].length }.max
      last_port = (@port_in + @port_out).last
      @port_in.each do |port|
        port_name = port[0]
        is_last = port == last_port
        signal = connection[port_name]
        raise "Missing connection for #{port_name}" if signal.nil?
        writer.write_line "#{port_name.ljust(len)} => #{signal}#{is_last ? '' : ','}"
      end
      @port_out.each do |port|
        port_name = port[0]
        is_last = port == last_port
        signal = connection[port_name]
        signal = "open" if signal.nil?
        writer.write_line "#{port_name.ljust(len)} => #{signal}#{is_last ? '' : ','}"
      end
    end

    def write_instance(writer, label, connection)
      writer.write_line "#{label}: #{@name}"
      writer.change_indent(+1)
      writer.write_line 'port map ('
      writer.change_indent(+1)
      write_instance_ports(writer, connection)
      writer.change_indent(-1)
      writer.write_line ");"
      writer.change_indent(-1)
      writer.write_line("")
    end

    def write_entity_ports(writer)
      len = (@port_in + @port_out).map { |port| port[0].length }.max
      last_port = (@port_in + @port_out).last
      @port_in.each do |port|
        is_last = port == last_port
        writer.write_line "#{port[0].ljust(len)} : in  #{port[1]}#{is_last ? '' : ';'}"
      end
      @port_out.each do |port|
        is_last = port == last_port
        writer.write_line "#{port[0].ljust(len)} : out #{port[1]}#{is_last ? '' : ';'}"
      end
    end

    def write_entity(writer, component = false)
      object_type = component ? 'component' : 'entity'

      writer.write_line "#{object_type} #{@name} is"
      writer.change_indent(+1)
      writer.write_line 'port ('
      writer.change_indent(+1)
      write_entity_ports(writer)
      writer.change_indent(-1)
      writer.write_line ");"
      writer.change_indent(-1)
      writer.write_line "end #{object_type};"
      writer.write_line("")
    end

    def write_architecture(writer)
      writer.write_line "architecture #{@architecture_name} of #{@name} is"
      writer.change_indent(+1)
      writer.change_indent(-1)
      writer.write_line "begin"
      write_content(writer)
      writer.write_line "end architecture;"
    end

    def write(writer)
      write_libraries(writer)
      write_entity(writer)
      write_architecture(writer)
    end
  end


  class ModuleInstance
    def initialize(label, mod)
      @label = label
      @module = mod
      @connection = Hash.new
    end

    def connect_port(port, signal)
      @connection[port] = signal
    end

    def write_component(writer)
      @module.write_entity(writer, true)
    end

    def write(writer)
      @module.write_instance(writer, @label, @connection)
    end
  end


  class Process < Block
    def initialize(label)
      super()
      @label = label
      @sensitivity_list = []
    end

    def add_to_sensitivity(signal)
      @sensitivity_list.append(signal)
    end

    def write(writer)
      sensitivity_list = @sensitivity_list.join(', ')
      writer.write_line("#{@label}:")
      writer.write_line("process(#{sensitivity_list})")
      writer.write_line("begin")
      write_content(writer)
      writer.write_line("end process;")
      writer.write_line("")
    end
  end


  class If < Block
    def initialize(condition, inline: false)
      super()
      @condition = condition
      @next = nil
      @inline = inline
      @comment = nil
    end

    def add_else(element)
      @next = element
    end

    def write(writer, first_if: true)
      @comment.write(writer) if @comment

      current_writer = @inline ? LineWriter.new : writer

      current_writer.write_line "#{first_if ? 'if':'elsif'} #{@condition} then"
      write_content(current_writer)

      current_writer.write(writer) if @inline

      if @next.instance_of?(If)
        @next.write(writer, first_if: false)
      elsif @next
        writer.write_line "else"
        @next.write(writer)
      end
      writer.write_line "end if;" if first_if
    end

    def add_comment(comment)
      @comment = comment
    end
  end


  class Type
    attr_reader :name, :library

    def initialize(name, library)
      @name = name
      @library = library
    end
  end


end

