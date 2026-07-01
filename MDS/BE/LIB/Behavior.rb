#!/usr/bin/ruby

#
#  Frederic BRAULT
#  
#  Lisp interpreter for MDS Behaviors.
#

require 'rubygems'
gem 'sexp'
require 'sexp'

class Cons
  attr_reader :car, :cdr
  
  def initialize(car, cdr)
    @car, @cdr = car, cdr
  end

  def lispeval(env, forms, sign)
    return forms.lookup(car).call(env, forms, sign, *cdr.arrayify) if forms.defined?(car)
    func, discard = car.lispeval(env, forms, sign)
    return func.call(*cdr.arrayify.map{|x| v, discard = x.lispeval(env, forms, sign); v})
  end

  def conslist?
    cdr.conslist?
  end

  def arrayify
    return self unless conslist?
    return [car] + cdr.arrayify
  end

  def to_sexp
    return "(cons #{car.to_sexp} #{cdr.to_sexp})" unless conslist?
    return "(#{arrayify.map{|x| x.to_sexp}.join(' ')})"
  end

end

class Env
  def initialize(parent=nil, defaults={})
    @parent = parent
    @defs = defaults
  end

  def define(symbol, value)
    @defs[symbol] = value
    return value
  end

  def defined?(symbol)
    return true if @defs.has_key?(symbol)
    return false if @parent.nil?
    return parent.defined?(symbol)
  end

  def lookup(symbol)
    return @defs[symbol] if @defs.has_key?(symbol)
    raise "Symbol #{symbol} has no binding" if @parent.nil?
    return @parent.lookup(symbol)
  end

  def set(symbol, value)
    if @defs.has_key?(symbol)
      @defs[symbol] = value
    elsif @parent.nil?
      raise "Symbol #{symbol} has no binding"
    else
      @parent.set(symbol, value)
    end
  end
end

class Object
  def lispeval(env, forms, sign)
    self
  end
  
  def consify
    self
  end

  def conslist?
    false
  end

  def arrayify
    self
  end

	# Overcome limitation of the parsing lib, that does not recognize negative numbers
	def numeric?
		true if Integer(self.to_s) rescue false
	end

end

class Array
  def consify
    map{|x| x.consify}.reverse.inject(:nil) {|cdr, car| Cons.new(car, cdr)}
  end
end

class Symbol
  def lispeval(env, forms, sign)
    env.lookup(self)
  end

  def conslist?
    self == :nil
  end

  def arrayify
    self == :nil ? [] : self
  end

end


class Interpreter
  attr_accessor :env, :forms
  def initialize(env=DEFAULT_ENV, forms=DEFAULT_FORMS)
    @env   = Env.new(nil, env)
    @forms = Env.new(nil, forms)
  end

  def eval_file(file)
    f = File.new(file, "r")
    self.eval(f.read)
  end

  def eval(s)
    # MDS lisp is not "clean" : clean it (ie make it look really like lisp).
    # Replacing sections: 32[0] -> (SECTION (CONST.32) (CONST.0))
    s = s.gsub(/([0-9]+)\[([0-9]+)\]/, '(SECTION (CONST.\1) (CONST.\2))')
    s = s.gsub(/APPLY\.([0-9]+)\./, 'APPLY_\1_').gsub(/TEST\./, "TEST_").gsub(/%/,"arg_").gsub(/\./, " ")
    s.parse_sexp.map do |exp|
      exp.consify.lispeval(@env, @forms, nil)
    end.last
  end
end

class Sign
  
  attr_accessor :type, :width, :loc
  
  def initialize(type, width, loc=nil)
    @type, @width, @loc = type, width, loc
  end

  def signed?
    (@type == :signed or @type == :sat)
  end

  def unsigned?
    (@type == :unsigned or @type == :bool)
  end

  def getmask(width)
    ((1 << width) - 1)
  end

  def getmax()
    case
    when unsigned? then
      (2 ** @width) - 1
    when signed? then
      (2 ** (@width - 1)) - 1
    end
  end

  def getmin()
    case
    when unsigned? then
      0
    when signed? then
      - (2 ** (@width - 1))
    end
  end

  def convert(i)
    raise "Only numeric can be converted" unless i.kind_of? Numeric
    i = i.to_i
    case @type
      when :unsigned then 
        i & getmask(@width)
      when :sat then
        if i > getmax
          getmax
        elsif i < getmin
          getmin
        else
          i
        end
      when :signed then
        i &= getmask(@width)
        if i & (1 << (@width - 1)) != 0 # sign bit set, i < 0
          i - (2 ** @width)
        else
          i
        end
      when :bool then
        if i != 0
          1
        else
          0
        end
      else
        raise "Unknown type #{@type}"
      end
  end

  def to_s
    "width(#{@width}), type(#{@type}), loc(#{@loc})"
  end

  def fuzz(n)
    a = [];
    a.push(getmin)
    a.push(getmax)
    if @width > 1
      a.push(getmin+1)
      a.push(getmax-1)
      a.push(0)
      a.push(-1) if signed?

      sign = 1
      n.times do |i|
        sign = rand > 0.5 ? 1 : -1 if signed?
        a.push(sign * rand(getmax))
      end
    end
    return a
  end
end

class Storage
  attr_accessor :direction, :name
  def initialize(direction, name)
    @direction, @name = direction, name
  end
  def to_s
    "direction(#{@direction}), name(#{@name})"
  end
end

class Location
  attr_accessor :storage, :addr, :size
  def initialize(storage, addr, size)
    @storage, @addr, @size = storage, addr, size
  end
end

class Section
  attr_accessor :width, :part
  def initialize(width, part)
    @width, @part = width, part
  end
end

def generate_type(env, forms, sign, width, value, type)
  loc = sign.nil? ? nil : sign.loc
  w, discard = width.lispeval(env, forms, sign)
  s = Sign.new(type, w, loc)
  v, discard = value.lispeval(env, forms, s)
  raise "#{value.to_sexp} Value is not numeric" unless v.kind_of?Numeric
  raise "Value is not numeric" unless w.kind_of?Numeric
  return s.convert(v) ,s  
end

DEFAULT_FORMS = {
  :SEQ => lambda{|env, forms, sign, *args| 
                 args.each do |a| 
                 a.lispeval(env, forms, sign)
                 end.last},
  :CONST => lambda{|env, forms, sign, val|
                 if val.numeric?
                   return Integer(val.to_s)
                 else
                   val.lispeval(env, forms, sign)
                 end
                },
  :SELECT => lambda {|env, forms, sign, cond, xthen, xelse|
             v, discard = cond.lispeval(env, forms, sign)
             if v != 0
                xthen.lispeval(env, forms, sign)
             else
                xelse.lispeval(env, forms, sign)
             end},
  :IF => lambda {|env, forms, sign, cond, xthen, xelse|
             v, discard = cond.lispeval(env, forms, sign)
             if v != 0
                xthen.lispeval(env, forms, sign)
             else
                xelse.lispeval(env, forms, sign)
             end},
  :WRITE => lambda {|env, forms, sign, sym, value|
                     v, discard = value.lispeval(env, forms, sign)
                     env.define(sym, v)},
  :READ => lambda {|env, forms, sign, sym, section=nil|
                     if(section.nil?) then
                       sym.lispeval(env, forms, sign)
                     else
                       tmp = section
                       section = sym
                       sym = tmp
                       s, discard = section.lispeval(env, forms, sign)
                       v, discard = sym.lispeval(env, forms, sign)
                       ((((1 << s.width) - 1) << (s.part * s.width)) & v) >> (s.part * s.width)
                     end
                   },
  :SECTION => lambda {|env, forms, sign, width, part|
                  w, discard = width.lispeval(env, forms, sign)
                  p, discard = part.lispeval(env, forms, sign)
                  Section.new(w, p)
                },
  :SX => lambda {|env, forms, sign, width, value|
                 generate_type(env, forms, sign, width, value, :signed)
                 },
  :ZX => lambda {|env, forms, sign, width, value|
                 generate_type(env, forms, sign, width, value, :unsigned)
                 },
  :SAT => lambda {|env, forms, sign, width, value|
                 generate_type(env, forms, sign, width, value, :sat)
                 },
  :I2F => lambda {|env, forms, sign, width, value|
                 generate_type(env, forms, sign, width, value, :unsigned)
                   },
  :F2I => lambda {|env, forms, sign, width, value|
                 generate_type(env, forms, sign, width, value, :unsigned)
                   },
  :I2B => lambda {|env, forms, sign, value|
                 generate_type(env, forms, sign, 1, value, :bool)
                   },
  :B2I => lambda {|env, forms, sign, value|
                 generate_type(env, forms, sign, 1, value, :unsigned)
                   },
  :METHOD => lambda{|env, forms, sign, sym|
                    sym.lispeval(env, forms, sign)},
  :AGGL => lambda{|env, forms, sign, store_name, addr, size|
                    p = Storage.new(sign.loc.direction, store_name)
                    s = sign.nil? ? Sign.new(nil, nil, p) : Sign.new(sign.type, sign.width, p)
                    my_addr, discard = addr.lispeval(env, forms, s)
                    my_size, discard = size.lispeval(env, forms, s)
                    Location.new(p, my_addr, my_size)
                    },
  :LOAD => lambda{|env, forms, sign, cycle, loc|
                  p = Storage.new(:load, nil)    
                  s = sign.nil? ? Sign.new(nil, nil, p) : Sign.new(sign.type, sign.width, p)
                  l, discard = loc.lispeval(env, forms, s)
                  raise "Load needs a location" unless l.kind_of? Location
                  # TODO: This part is probably processor dependent. See generate_test.rb. Return phony value.
									return 1},
  :STORE => lambda{|env, forms, sign, cycle, loc, value|                  
                  p = Storage.new(:store, nil)    
                  s = sign.nil? ? Sign.new(nil, nil, p) : Sign.new(sign.type, sign.width, p)
                  l, discard = loc.lispeval(env, forms, s)
                  v, discard = value.lispeval(env, forms, nil)
                  raise "Store needs a location" unless l.kind_of? Location
                  raise "Store needs number" unless v.kind_of? Numeric
                  # TODO : This part is probably processor dependent. See generate_test.rb.
                  return :nil},   
}

DEFAULT_ENV = {
  :nil => :nil,
  :t => :t,
  :PRINT => lambda {|*args| puts *args; :nil },
  :CANCEL => lambda {|*args| :nil},
  :SKIP => lambda {|*args| :nil},
  :ABS => lambda {|x| x < 0 ? -x : x },
  :ADD => lambda {|x, y| x + y },
  :SUB => lambda {|x, y| x - y },
  :AND => lambda {|x, y| x & y },
  :NOT => lambda {|x| ~ x },
  :NEG => lambda {|x| -x },
  :IOR => lambda {|x, y| x | y },
  :XOR => lambda {|x, y| x ^ y },
  :SHL => lambda {|x, y| x << y },
  :SHR => lambda {|x, y| x >> y },
  :NE => lambda {|x, y| x != y ? 1 : 0 },
  :EQ => lambda {|x, y| x == y ? 1 : 0 },
  :LT => lambda {|x, y| x < y ? 1 : 0 },
  :LE => lambda {|x, y| x <= y ? 1 : 0 },
  :GT => lambda {|x, y| x > y ? 1 : 0 },
  :GE => lambda {|x, y| x >= y ? 1 : 0 },
  :NOTL => lambda {|x| (!(x!=0)) ? 1 : 0 },
  :ANDL => lambda {|x, y| ((x!=0) && (y!=0)) ? 1 : 0 },
  :IORL => lambda {|x, y| ((x!=0) or (y!=0)) ? 1 : 0 },
  :XORL => lambda {|x, y| ((!(x!=0) && (y!=0)) || ((x!=0) && !(y!=0))) ? 1 : 0 },
  :MUL => lambda {|x, y| x * y },
  :MAX => lambda {|x, y| x > y ? x : y},
  :MIN => lambda {|x, y| x < y ? x : y},
  :ROL => lambda {|n, x, shift| (x << shift) | (x >> (n - shift))},
  :ROR => lambda {|n, x, shift| (x >> shift) | (x << (n - shift))},
  :CBS => lambda {|n, x|
                 s = 0 
                 0.upto(n-1) do |i|
                    s += 1 if ((x & (1 << i)) != 0)
                end
                return s
          },
 :CLZ => lambda {|n, x|
                s = 0
                (n-1).downto(0) do |i|
                    if ((x & (1 << i)) != 0)
                      break
                    else
                      s +=1
                    end
                end
                return s
          },
  :CLS => lambda {|n, x|
                s = 0
                p = (x & (1 << (n-1))) >> (n-1) 
                (n-2).downto(0) do |i|
                  if (((x & (1 << i)) >> i) == p)
                    s += 1
                  else
                    break
                  end
                end
                return s
          },
 :CTZ => lambda {|n, x|
                s = 0
                (0).upto(n-1) do |i|
                    if ((x & (1 << i)) == 0)
                      s +=1
                    else
                      break
                    end
                end
                return s
          },
  :SWAP => lambda {|n, x|
                  # Beware, SWAP does not allow for arbitrary size numbers
                  # else, it would swap to infinity ! We choose 256 as a limit.
                  s = 0
                  syll = :first
                  0.step(255, n) do |i|
                    mask = ((2 ** n) - 1) << i
                    k = (x & mask) >> i
                    if syll  == :first
                      s |= k << (i + n)
                      syll = :second
                    else
                      s |= k << (i - n)
                      syll = :first
                    end
                  end
                  return s
           },
    :SATU => lambda {|n, x|
                  max = (1 << n) - 1
                  min = 0
                  if(x > max) then
                    return max
                  elsif(x < min) then
                    return min
                  end
                  return x
          },
    :SAT => lambda {|n, x|
                  max = (1 << (n - 1)) - 1
                  min = -((1 << (n - 1)) - 1)
                  if(x > max) then
                    return max
                  elsif(x < min) then
                    return min
                  end
                  return x
          },

}









