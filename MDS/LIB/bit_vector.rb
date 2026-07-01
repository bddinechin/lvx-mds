class BitVector

  def initialize(value)
    @value = value
  end

  def to_s
    @value
  end

  def get_shared_bits(other)
    if other.to_s.length != @value.length
      raise "ERROR: operands have different length"
    end

    result = "-" * @value.length
    bit_vector_A = other.to_s
    bit_vector_B = @value

    @value.chars.each_index do |idx|
      bitA = bit_vector_A[idx]
      bitB = bit_vector_B[idx]
      if bitA == '-' || bitB == '-' || bitA != bitB
        result[idx] = '-'
      else
        result[idx] = bitA
      end
    end

    return BitVector.new(result)
  end

  def match(other)
    if other.to_s.length != @value.length
      raise "ERROR: operands have different length"
    end

    pattern = other.to_s

    @value.chars.each_index do |idx|
      bitA = pattern[idx]
      bitB = @value[idx]
      next if bitA == '-'
      return false if bitA != bitB
    end

    return true
  end

  def equal2(other)
    if other.to_s.length != @value.length
      raise "ERROR: operands have different length"
    end

    pattern = other.to_s

    @value.chars.each_index do |idx|
      bitA = pattern[idx]
      bitB = @value[idx]
      next if bitA == '-'
      next if bitA == '-' && bitB == '-'
      return false if bitA != bitB
    end

    return true
  end

  def equal(other)
    if other.to_s.length != @value.length
      raise "ERROR: operands have different length"
    end

    bit_vector_A = other.to_s
    bit_vector_B = @value

    @value.chars.each_index do |idx|
      bitA = bit_vector_A[idx]
      bitB = bit_vector_B[idx]
      next if bitA == '-' || bitB == '-'
      return false if bitA != bitB
    end

    return true
  end

  def get_common_envelope(other)
    if other.to_s.length != @value.length
      raise "ERROR: operands have different length"
    end

    new_vector_A = other.to_s.clone
    new_vector_B = @value.clone

    @value.chars.each_index do |idx|
      bitA_is_defined = (new_vector_A[idx] != '-')
      bitB_is_defined = (new_vector_B[idx] != '-')
      should_be_defined = (bitA_is_defined && bitB_is_defined)
      if !should_be_defined
        new_vector_A[idx] = '-' # Mask non-common envelope bits
        new_vector_B[idx] = '-'
      end
    end

    return BitVector.new(new_vector_A), BitVector.new(new_vector_B)
  end

  # The bit-vector envelope is the set of defined bits (non '-' bits)
  # if the envelope of A is a subset of the envelope of B, then A > B.
  # Raise an error if the order is undecidable (A ⊄ B, nor B ⊄ A).
  # 1 if self > other; 0 if self == other; -1 if self < other
  def compare_envelope(other)
    order = 0

    @value.chars.each_index do |idx|
      bitA_is_defined = (@value[idx] != '-')
      bitB_is_defined = (other.to_s[idx] != '-')
      next if bitA_is_defined == bitB_is_defined
      new_order = bitA_is_defined ? -1 : +1
      if order != 0 && order != new_order
        raise "Error: Undecidable envelope order (#{@value}, #{other.to_s})"
      end
      order = new_order
    end

    return order
  end

  # Assuming same envelope, compare bit values from MSB to LSB ('1' > '0').
  # 1 if self > other; 0 if self == other; -1 if self < other
  def compare_value(other)
    @value.chars.each_index do |idx|
      bitA = @value[idx]
      bitB = other.to_s[idx]
      next if bitA == bitB
      return +1 if bitA == '1'
      return -1
    end

    return 0 # A == B
  end

  # Assuming either A or B is a subset of the other.
  # Comparaison rules:
  # * A > B  if A bit-vector envelope have smallest envelope than B
  # * A > B  if A bit values is greater than B ('1' > '0')
  # * A == B if both envelope and values are the same
  #
  # 1 if self > other; 0 if self == other; -1 if self < other
  def <=> (other)
    vecA, vecB = get_common_envelope(other)
    value_cmp = vecA.compare_value(vecB)
    if value_cmp == 0
      raise "Error: Undecidable order (#{vecA}, #{vecB})"
    end
    return value_cmp
  end

end

