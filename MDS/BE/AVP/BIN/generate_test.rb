#!/usr/bin/ruby

#
#  Frederic BRAULT
#
#  Uses lisp interpreter for behavior to generate AVP tests.
#

require 'Behavior'
require 'rexml/document'
require 'digest/md5'
require 'matrix'


# Make Matrix Mutable objects
class Matrix
    def []=(i,j,x)
          @rows[i][j]=x
    end
end

include REXML

PROLOG      = ".text\n.globl _start\n_start:\nmake $r0 = 4\n;;\nwfxl $ps , $r0\n;;\n"
EPILOG      = "make $r0 = 0\n;;\nscall 4095\n;;\nfailure:\nmake $r0 = 1\n;;\nscall 4095\n;;\n"
MAX_AVP_IN_FILE = ENV.fetch("MAX_AVP_IN_FILE", 3000)

# Overload load store to generate processor specific tests.
MY_FORMS = {
  :LOAD => lambda{|env, forms, sign, cycle,loc|
                  p = Storage.new(:load, nil)
                  s = sign.nil? ? Sign.new(nil, nil, p) : Sign.new(sign.type, sign.width, p)
                  l, discard = loc.lispeval(env, forms, s)
                  raise "Load needs a location" unless l.kind_of? Location
                  # TODO : deal with mem access
                  if l.storage.name == :GPR or l.storage.name == :CS or l.storage.name == :PGR
                    new_sym = (l.storage.name.to_s + "_" + l.addr.to_s).to_sym # Convention : prefix reg values with name _ and put in env
                    new_sym.lispeval(env, forms, s)
                  end},
        :STORE => lambda{|env, forms, sign, cycle, loc, value|
                   p = Storage.new(:store, nil)
                   s = sign.nil? ? Sign.new(nil, nil, p) : Sign.new(sign.type, sign.width, p)
                   l, discard = loc.lispeval(env, forms, s)
                   v, discard = value.lispeval(env, forms, nil)
                   raise "Store needs a location" unless l.kind_of? Location
                   raise "Store needs number" unless v.kind_of? Numeric
                   # TODO : deal with mem access
                   if(l.storage.name == :GPR and l.size == 1)
         # Not so happy about global var. Processor specific, comp and cb need to be checked first.
                     if defined? $asm and (not $asm.nil?)
                       $asm += "make $r62 = 0x#{v.to_s(16)}\n;;\n"
                       $asm += "compd.eq $r63 = $r#{l.addr}, $r62\n;;\n"
                       $asm += "cb.deqz $r63? failure\n;;\n"
                     end
                   end
                   if(l.storage.name == :PGR and l.size == 1)
                     if defined? $asm and (not $asm.nil?)
                       # Check low, then check high
                       $asm += "make $r62 = 0x#{(v & 0xFFFFFFFFFFFFFFFF).to_s(16)}\n;;\n"
                       $asm += "compd.eq $r63 = $r#{l.addr}, $r62\n;;\n"
                       $asm += "cb.deqz $r63? failure\n;;\n"
                       $asm += "make $r62 = 0x#{((v >> 64) & 0xFFFFFFFFFFFFFFFF).to_s(16)}\n;;\n"
                       $asm += "compd.eq $r63 = $r#{l.addr + 1}, $r62\n;;\n"
                       $asm += "cb.deqz $r63? failure\n;;\n"
                     end
                   end
                   if(l.storage.name == :CS)
                     if defined? $asm and (not $asm.nil?)
                       mask = 0xFFFFFFFFFFFFFFFF
                       l.addr.upto(l.addr + l.size - 1) {|i| mask = mask ^ (1 << i)}
                       mask = (( ~ mask) & 0xFFFFFFFFFFFFFFFF)
                       $asm += "get $r63 = $cs\n;;\n"
                       $asm += "andd $r63 = $r63, 0x#{mask.to_s(16)}\n;;\n"
                       $asm += "compd.eq $r63 = $r63, 0x#{(v << l.addr).to_s(16)}\n;;\n"
                       $asm += "cb.deqz $r63? failure\n;;\n"
                     end
                   end
                   return :nil},
}

# When the only goal is to get type info, just propagate info up and down, and use in leaf.
FORMS_GET_TYPES = {
  :READ => lambda {|env, forms, sign, sym, section=nil|
                   # part of a hack here with global var.
                   # "get type mode" : return phony 0 value
                   if(not section.nil?) then
                     tmp = sym
                     sym = section
                     section = tmp
                   end
                   if defined? $get_types and (not $get_types.nil?)
                      $get_types[sym] = sign
                      return 1
                  end},
  :METHOD => lambda{|env, forms, sign, sym|
                   if defined? $get_types and (not $get_types.nil?)
                      # Get around operand with read/write registers
                      if $get_types.has_key? sym and is_load?($get_types[sym].loc)
                          # do nothing, no need to override a load with a store !
                      else
                        $get_types[sym] = sign
                      end
                      return 1
                   end},
  :LOAD => lambda{|env, forms, sign, cycle,loc|
            p = Storage.new(:load, nil)
            s = sign.nil? ? Sign.new(nil, nil, p) : Sign.new(sign.type, sign.width, p)
            l, discard= loc.lispeval(env, forms, s)
            raise "Load needs a location" unless l.kind_of? Location
            if defined? $get_types and (not $get_types.nil?) and (l.storage.name == :CS)
              s.loc = Storage.new(:load, :CS)
              s.width = l.size
              s.type = :unsigned
              sym = ("CS_" + l.addr.to_s).to_sym
              $get_types[sym] = s
            end
            return 1
            }
}

def matrixify(a)
  m = Matrix.zero(8)
  0.upto(7) do |i|
    0.upto(7) do |j|
      bit = (a & (1 << (i * 8 + j))) != 0 ? 1 : 0
      m[i,j] = bit
    end
  end
  return m
end

def unmatrixify(m)
  a = 0
  0.upto(7) do |i|
    0.upto(7) do |j|
      bit = m[i,j] << (i * 8 + j)
      a |= bit
    end
  end
  return a
end

def int2arr(int, size)
 a = []
 0.upto(size-1) {|shift| a.push((int >> shift) & 0x1)}
 return a
end

def bslu(table, a, b, c, d, size)
  table_t, a_t, b_t, c_t, d_t = int2arr(table, size), int2arr(a, size), int2arr(b, size), int2arr(c, size), int2arr(d, size)
  c = 0
  0.upto(size-1) do |i|
    index = a_t[i] + b_t[i] * 2 + c_t[i] * 4 + d_t[i] * 8
    c |= table_t[index] << i
  end
  return c
end

def condition(cond, x, size)
  s = Sign.new(:signed, size)
  x = s.convert(x)
  a = case cond
      when 0 then x != 0 #NEZ
      when 1 then x == 0 #EQZ
      when 2 then x < 0  #LTZ
      when 3 then x >= 0 #GEZ
      when 4 then x <= 0 #LEZ
      when 5 then x > 0  #GTZ
      when 6 then (x % 2 == 1) #ODD
      when 7 then (x % 2 == 0) #EVEN
      else raise "Unknown condition"
      end
  return a ? 1 : 0
end

def comparison(cond, x, y, size)

  s = Sign.new(:signed, size)
  sx, sy = s.convert(x), s.convert(y)
  s = Sign.new(:unsigned, size)
  ux, uy = s.convert(x), s.convert(y)

  a = case cond
      when 0 then sx != sy #NE
      when 1 then sx == sy #EQ
      when 2 then sx < sy  #LT
      when 3 then sx >= sy #GE
      when 4 then sx <= sy #LE
      when 5 then sx > sy  #GT
      when 6 then ux < uy  #LTU
      when 7 then ux >= uy #GEU
      when 8 then ux <= uy #LEU
      when 9 then ux > uy  #GTU
      when 10 then (ux & uy == uy) #ALL
      when 11 then (ux & uy != uy) #NALL
      when 12 then (ux & uy != 0)  #ANY
      when 13 then (ux & uy == 0)  #NONE
      when 14                      # TP
        r = (sx - sy) & s.getmask(size)
        r & (1 << (size - 1)) == 0 # size bit unset
      when 15                      # TN
        r = (sx - sy) & s.getmask(size)
        r & (1 << (size - 1)) != 0 # size bit set
      else raise "Unknown condition"
      end
  return a ? 1 : 0
end
# Processor specific "Applies" in MDS
APPLY = {
  :APPLY__BMT_8 => lambda {|a| unmatrixify(matrixify(a).transpose)},
  :APPLY__BMM_8 => lambda {|a, b|
                           m = matrixify(a)
                           n = matrixify(b)
                           r = Matrix.zero(8)
                           0.upto(7) do |i|
                              0.upto(7) do |j|
                                s = 0
                                0.upto(7) do |k|
                                    r[i,j] = r[i,j] ^ (m[i,k] & n[k,j])
                                end
                              end
                           end
                           unmatrixify(r)
                      },
  :APPLY_bwlu_16 => lambda {|t, a, b, c, d|  bslu(t, a, b, c, d, 16)},
  :APPLY_bwlu_32 => lambda {|t, a, b, c, d|  bslu(t, a, b, c, d, 32)},
  :TEST_condition_64 => lambda {|cond, x| condition(cond, x, 64) },
  :TEST_condition_32 => lambda {|cond, x| condition(cond, x, 32) },
  :TEST_condition_16 => lambda {|cond, x| condition(cond, x, 16) },
  :TEST_comparison_64 => lambda {|cond, x, y| comparison(cond, x, y, 64)},
  :TEST_comparison_32 => lambda {|cond, x, y| comparison(cond, x, y, 32)},
  :TEST_comparison_16 => lambda {|cond, x, y| comparison(cond, x, y, 16)},
}

$file = nil
$file_count = 0

def is_arg?(n)
  n.to_s =~ /^arg_/
end

def get_arg(n)
  n.to_s.gsub(/arg_(\d)/, '\1').to_i
end

def is_load?(loc)
  return false if loc.nil?
  loc.direction == :load
end

def is_store?(loc)
  return false if loc.nil?
  loc.direction == :store
end

# Conbinatorial sweep across all operands values.
def sweep(cons, args, syntax, mnemonic, id, lisp_code)

        # [JV] Reserve regiters $r62 and $r63
        available_regs = 62
        paired_regs = available_regs - (available_regs % 2)
        allocated_regs = Array.new(available_regs) # $r63 reserved
        free_registers = available_regs

  if cons.nil? # end of recursion
    my_args = {0 => mnemonic}
    my_env = {}
                $asm = ""
    args.each do |t|
      symbol = t[0]
      n = get_arg(symbol)
      v = t[1]
      value = t[2]

      if not v.loc.nil?
        if v.loc.name == :GPR
          regnum = rand(available_regs - 1) # [JV] r63 is reserved.
          raise "Unable to allocate register" if free_registers < 1
          while free_registers > 0 and allocated_regs[regnum] do
            regnum = rand(available_regs - 1)
          end
          free_registers--
            allocated_regs[regnum] = 1
        elsif not v.loc.nil? and v.loc.name == :PGR
          regnum = rand(paired_regs - 2) # [JV] r63 is reserved.
          regnum = regnum % 2 == 0 ? regnum : regnum - 1 # take the pair index
          raise "Unable to allocate register" if free_registers < 2
          while (free_registers > 1) and (allocated_regs[regnum] or allocated_regs[regnum+1]) do
            regnum = rand(paired_regs - 2)
            regnum = regnum % 2 == 0 ? regnum : regnum - 1 # take the pair index
          end
          free_registers--
            allocated_regs[regnum] = 1
          free_registers--
            allocated_regs[regnum+1] = 1
        end
      end

      if is_load?(v.loc) and (v.loc.name == :GPR) # REG value
        $asm += "make $r#{regnum} = 0x#{value.to_s(16)}\n;;\n"
        my_env[symbol] = regnum
        my_env[("GPR_" + regnum.to_s).to_sym] = value
        my_args[n] = "$r" + regnum.to_s
      end
      if is_load?(v.loc) and (v.loc.name == :PGR) # Paired REG value
                                regnum = (regnum % paired_regs) # disallow pair 62, since r63 is reserved
                                regnum = regnum % 2 == 0 ? regnum : regnum - 1 # take the pair index
        $asm += "make $r#{regnum} = #{value & 0xFFFFFFFFFFFFFFFF}\n;;\n"
        $asm += "make $r#{regnum + 1} = #{(value >> 64) & 0xFFFFFFFFFFFFFFFF}\n;;\n"
        my_env[symbol] = regnum
        my_env[("PGR_" + regnum.to_s).to_sym] = value
        my_args[n] = "$r" + regnum.to_s + "r" + (regnum + 1).to_s
      end
      if is_load?(v.loc) and (v.loc.name == :XVR) # Paired REG value
        $asm += "make $r#{regnum} = #{value & 0xFFFFFFFFFFFFFFFF}\n;;\n"
        $asm += "make $r#{regnum + 1} = #{(value >> 64) & 0xFFFFFFFFFFFFFFFF}\n;;\n"
        my_env[symbol] = regnum
        my_env[("PGR_" + regnum.to_s).to_sym] = value
        my_args[n] = "$r" + regnum.to_s + "r" + (regnum + 1).to_s
      end
      if is_load?(v.loc) and (v.loc.name == :CS) # CS value
                                cs_n = symbol.to_s.gsub(/CS_(\d)/, '\1').to_i
                                mask = 0xFFFFFFFFFFFFFFFF
                                cs_n.upto(cs_n + v.width - 1) {|i| mask = mask ^ (1 << i)}
                                $asm += "get $r63 = $cs\n;;\n"
                                $asm += "andd $r63 = $r63, 0x#{mask.to_s(16)}\n;;\n"
                                $asm += "iord $r63 = $r63, 0x#{(value << cs_n).to_s(16)} # val = 0x#{value.to_s(16)}\n;;\n"
                                $asm += "set $cs = $r63\n;;\n"
        my_env[symbol] = value
      end
      if v.loc.nil? # Immediate value
        my_env[symbol] = value
        my_args[n] = value.to_s
      end
      if is_store?(v.loc) and (v.loc.name  == :GPR)
        my_env[symbol] = regnum
        my_args[n] = "$r" + regnum.to_s
      end
      if is_store?(v.loc) and (v.loc.name  == :PGR)
                                regnum = (regnum % 62) # disallow pair 62, since r63 is reserved
                                regnum = regnum % 2 == 0 ? regnum : regnum - 1 # take the pair index
        my_env[symbol] = regnum
        my_args[n] = "$r" + regnum.to_s + "r" + (regnum + 1).to_s
      end
      if is_store?(v.loc) and (v.loc.name  == :XVR)
        my_env[symbol] = regnum
        my_args[n] = "$a" + regnum.to_s + "a" + (regnum + 1).to_s
      end
      if not v.loc.nil? and v.loc.name == :MOD # modifier
            my_env[symbol] = value[1].to_i
            my_args[n] = value[0].to_s.downcase
      end
    end
    # generate assembly line from syntax
    $asm += syntax.gsub(/%(\d)/) do |i|
      my_args[$1.to_i]
    end
    $asm += "\n;;\n"

    # this will indirectly fill $asm with checkup code
    p = Interpreter.new(DEFAULT_ENV.merge(APPLY).merge(my_env), DEFAULT_FORMS.merge(MY_FORMS))
    p.eval(lisp_code)

                $count += 1

                if $count > MAX_AVP_IN_FILE
                  $count = 0
                  $file_count += 1
                  $file.write(EPILOG)
                  $file.close
                  $file = File.new($file_name + $file_count.to_s + ".s", "w")
                  $file.write(PROLOG)
                end
    $file.write($asm)

  else # recursive part
    a = cons.car
    symbol = a[0]
    v = a[1]
    fuzz = a[2]
    fuzz.each do |val|
      new_args = args + [[symbol, v, val]]
      sweep(cons.cdr, new_args, syntax, mnemonic, id, lisp_code)
    end
  end
end

def xmltable_loop(name)
  path = ARGV[0] + "/" + name + ".table"
  xmlfile = "<?xml version='1.0' encoding='UTF-8'?><MDS>" + File.read(path) + "</MDS>"
  root = Document.new(xmlfile).root
  root.each_element("//" + name) do |instance|
    yield instance
  end
end

def getmodifier(modifier)
  tab = []
  xmltable_loop("Modifier") do |instance|
    if instance.attributes['ID'].to_s == modifier
      a = instance.attributes['members'].to_s.split
      b = instance.attributes['values'].to_s.split
      0.upto(a.length - 1) do |i|
        tab.push([a[i], b[i]])
      end
      return tab
    end
  end
  return tab
end

def generate_tests(instances)
  instances.each do |instance|
    id = instance.attributes['ID'].to_s

    mnemonic = instance.attributes['mnemonic'].to_s
    STDERR.puts "Assembling #{mnemonic} (#{id})"
    syntax = instance.attributes['syntax'].to_s
    behavior = instance.elements['Behavior']

    if behavior.nil?
      puts  "Skip empty behavior #{mnemonic}"
      next
    end

    methods = behavior.attributes['methods'].to_s
    proxies = behavior.attributes['proxies'].to_s

    index = 0
    modifiers = []
    methods.split.each do |m|
      if m =~ /Modifier/
        proxies.split[index].gsub(/%(\d)/) do |i|
          modifiers.push([$1.to_i, m])
        end
      end
      index += 1
    end
    lisp_code = behavior[0].to_s

    if lisp_code =~ /AGGL\.NRF/
      puts "Skip remote register for #{mnemonic}"
      next
    end

    if lisp_code =~ /AGGL\.PC/
      puts "Skip remote register for #{mnemonic}"
      next
    end

    if lisp_code =~ /AGGL\.XVR/
      puts "Skip XVR corprocessor register for #{mnemonic}. Have to allocate these registers"
      next
    end

    if lisp_code =~ /AGGL\.XCR/
      puts "Skip XCR corprocessor register for #{mnemonic}. Have to allocate these registers"
      next
    end

    if lisp_code =~ /(APPLY\.[^\s]*)/
      unknown_apply = $1.gsub(/APPLY\./, "APPLY_")
      if not APPLY.has_key? unknown_apply.to_sym
        puts  "Skip unknown #{unknown_apply} for #{mnemonic}"
        next
      end
    end

    if id =~ /OPXD/
      puts "Skip OPXD"
      next
    end

    if mnemonic =~ /_$/
      puts "Skip #{mnemonic}"
      next
    end

    if (mnemonic =~ /cmove/ or mnemonic =~ /cdmove/)
      puts "Skip #{mnemonic}"
      next
    end

    if instance.to_s =~ /float/
      puts "Skip float"
      next
    end

    if id =~ /MOVETQ/
      puts "Skip TCA instructions : MOVETQ"
      next
    end

    $get_types = {}
    # Interpreter that just gets types
    p = Interpreter.new(DEFAULT_ENV.merge(APPLY), DEFAULT_FORMS.merge(FORMS_GET_TYPES))
    p.eval(lisp_code)

    $fuzz = nil
    n_random = ENV.fetch("AVP_RAND", 4).to_i
    n_simd   = ENV.fetch("AVP_SIMD", 0).to_i


    if id =~ /INSF/
      n_random = 1
      n_simd = 0
      puts "WARNING : INSF instruction, AVP_RAND=1, AVP_SIMD=0 to limit combinations"
    end
    simd_parts = [0x7FFF, 0x8000, 0xFFFF, 0] # potential 16bit problematic values for SIMD
    $get_types.each do |k,v|
      if is_arg?(k)
        if is_store?(v.loc) and (v.loc.name == :GPR or v.loc.name == :PGR or v.loc.name == :XVR)
          $fuzz = Cons.new([k, v, [0]], $fuzz)
        elsif !(mod = (modifiers.select{ |m| k.to_s == "arg_" + m[0].to_s } )[0]).nil?
          v.loc = Storage.new(nil, :MOD)
          $fuzz = Cons.new([k, v, getmodifier(mod[1])], $fuzz)
        else
          simd_values = []
          if(v.width.nil?) then
            if(is_store?(v.loc)) then
              STDERR.puts "Testing width for #{v.loc.name}"
            end
            raise "Nil width value for: #{v}"
          end
          if v.width > 16
            n_simd.times do
              val = 0
              (v.width / 16).times do |i|
                val |= (simd_parts[rand(3)] << (16*i))
              end
              simd_values.push(val)
            end
          end
          $fuzz = Cons.new([k, v, v.fuzz(n_random).concat(simd_values)], $fuzz)
        end
      end
      if k.to_s =~ /CS/
        $fuzz = Cons.new([k, v, v.fuzz(n_random)], $fuzz)
      end
    end

    prefix = ENV["AVP_DIR"].nil? ? "./" : (ENV["AVP_DIR"] + "/")

    unless ENV["AVP_CACHE"].nil?
      prefix += Digest::MD5.hexdigest(instance.to_s) + "_" + id.to_s
      if File.exists? prefix
        puts "Skipping #{mnemonic}, already in cache"
        next
      end
    end

    $count = 0
    $file_count = 0
    Dir.mkdir(prefix) unless File.exists?(prefix)

    $file_name = prefix + "/" + id.to_s + "_"

    $file = File.new($file_name + $file_count.to_s + ".s", "w")
    $file.write(PROLOG)

    sweep($fuzz, [], syntax, mnemonic, id, lisp_code)

    $file.write(EPILOG) if($count != 0)
    $file.close
  end
end

def generate_all_tests
  # We want REPRODUCIBLE randomness
  srand(0)

  instances = []

  xmltable_loop("Opcode") do |instance|
    if instance.attributes['format'].to_s =~ /ALU|MAU/
      instances.push instance
    end
  end

  # Parallel generation of AVP
  n_proc = ENV.fetch("AVP_FORK", 1).to_i
  if(n_proc > 1)
    index = 0
    size = instances.length / n_proc

    # Divide workload evenly between processes
    1.upto(n_proc - 1) do |n|
      p_instances = []
      index.upto(index + size - 1) do |i|
        p_instances.push instances[i]
        index += 1
      end
      fork{generate_tests(p_instances)}
    end
    # last process gets "the rest"
    p_instances = []
    index.upto(instances.length - 1) do |i|
      p_instances.push instances[i]
    end
    fork{generate_tests(p_instances)}

    Process.waitall
  else
    generate_tests(instances)  # Not parallel
  end
end

generate_all_tests
