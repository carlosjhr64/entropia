module ENTROPIA
  Lb = lambda{|n| Math.log(n, 2)}

  class Entropia < Number
    # Needs to be able to set the entropy capacity of the string
    # without changing its current "value".
    def set_entropy(entropy)
      unless entropy.is_a?(Integer) and entropy >= 0
        raise "entropy request must be a non-negative Integer"
      end
      # Sometimes we need to pad entropy back up.
      zero = @digits.first
      while entropy > @base ** @string.length
        @string.prepend zero
        @shuffled &&= false
      end
      @entropy = @base ** @string.length
    end

    def set_randomness(randomness)
      unless randomness.is_a?(Float) and randomness.between?(0.0, Lb[@entropy])
        raise "randomness must be a Float in [0.0, Lb(entropy)]"
      end
      @randomness = randomness
    end

    def set_shuffled(shuffled)
      case shuffled
      when false, true
        @shuffled = shuffled
      else
        raise "shuffle must be either true or false"
      end
    end

    # This is the set_entropy version in bits.
    def set_bits(bits)
      unless bits.is_a?(Integer) and bits >= 0
        raise "bits request must be a non-negative Integer"
      end
      set_entropy(2**bits)
    end

    # Needs to keep track of
    # the base the entropy string is in, and
    # how much entropy and randomness it contains.
    # Interpret entropy as a request for a bigger string if string is too short.
    attr_reader :randomness, :shuffled, :entropy
    def initialize(number = 0,
                   base: 2,
                   entropy: 0,
                   randomness: 0.0,
                   shuffled: false,
                   digits: nil)
      super(number, base: base, digits: digits)
      set_entropy(entropy)
      set_randomness(randomness)
      set_shuffled(shuffled)
    end

    # Entropy capacity is often measured in "bits",
    # a logarithmic value of entropy.
    def bits
      Lb[@entropy]
    end

    # Increase the entropy in the string.
    # Assume that if a block is given, it's random unless explicitly denied.
    def increase(n=1, random: true)
      if block
        n.times{@string << @digits[block.call(@base)]}
        random ?  @randomness += n*Lb[@base]  :  @shuffled = false
      else
        # Note that because rand is pseudo, we don't increment randomness.
        @shuffled = false
        n.times{@string << @digits[SecureRandom.random_number(@base)]}
      end
      # We can revaluate entropy as a whole.
      @entropy = @base ** @string.length
      self
    end
    alias pp increase

    # The method for base convert.
    def to_base(base, digits=@digits)
      Entropia.new(@integer,
                   base:       base,
                   entropy:    @entropy,
                   randomness: @randomness,
                   shuffled:   @shuffled,
                   digits:     digits)
    end

    # The method for change of digits.
    def to_digits(digits, base=@base)
      Entropia.new(@integer,
                   base:       base,
                   entropy:    @entropy,
                   randomness: @randomness,
                   shuffled:   @shuffled,
                   digits:     digits)
    end

    def *(n)
      to_base(n)
    end

    # Return self and y as an x,y pair with common base and digits.
    def _x_(y)
      x = self
      unless x.base == y.base and  x.digits == y.digits
        digits = (y.digits.length > x.digits.length)? y.digits : x.digits
        base   = (y.base > x.base)?                   y.base   : x.base
        x = x.to_base(base, digits)
        y = y.to_base(base, digits)
      end
      return x,y
    end

    # We need to convert to a common base and digits
    # before concatenation and then
    # create the new entropy object.
    def +(y)
      x,y = _x_(y)
      string = x.to_s + y.to_s
      b = x.base # or y.base # same
      e = x.entropy * y.entropy
      r = x.randomness + y.randomness
      f = x.shuffled and y.shuffled
      d = x.digits # or y.digits # same
      Entropia.new(string,
                   base:       b,
                   entropy:    e,
                   randomness: r,
                   shuffled:   f,
                   digits:     d)
    end

    # Entropia objects representing the same values should be equal eachother.
    def ==(e)
      @integer      == e.to_i       and
        @entropy    == e.entropy    and
        @randomness == e.randomness and
        @shuffled   == e.shuffled
    end

    # xor
    def ^(y)
      x,y = _x_(y)
      x,y = y,x  if x.entropy > y.entropy

      s,l = '',xbits.length
      xbits = x.to_base(2, '01').to_s.chars.map{|_|_.ord - 48}
      ybits = y.to_base(2, '01').to_s.chars.map{|_|_.ord - 48}
      ybits.each_with_index do |ybit, i|
        s << (xbits[i%l] ^ ybit).to_s
      end

      Entropia.new(s,
                   base:       2,
                   entropy:    [x.entropy, y.entropy].min,
                   randomness: [x.randomness, y.randomness].min,
                   shuffled:   (x.shuffled and y.shuffled),
                   digits:     '01'
                  ).to_base(x.base, x.digits)
    end

    def shuffled?
      @shuffled
    end

    # TODO
#   def shuffle
#     s = (@base==2)? self : self*2
#     # I think that with a good enough random number generator
#     # for the shuffle and truly random bits, this should suffice.
#     s = s.to_s.chars.shuffle.join
#     s = Entropia.novi(s, self, :b=>2, :s=>true)
#     s = s*@base unless @base==2

#     return s
#   end

    # The mathematical notation should be as terse as possible.
    # This will contruct a new entropy string.
    def self.[](n)
      Entropia.new.pp(n)
    end

  end
  # For consision
  E = Entropia

  O = 8
  H = 16
  W = 62
  Q = 91
end
