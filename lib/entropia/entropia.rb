module ENTROPIA
  Lb = lambda{|n| Math.log(n, 2)}

  class Entropia < BaseConvert::Number
    # Needs to be able to set the entropy capacity of the string
    # without changing its current "value".
    def set_entropy(entropy)
      unless entropy.is_a?(Integer) and entropy >= 0
        raise "entropy request must be a non-negative Integer"
      end
      # Sometimes we need to pad entropy back up.
      zero = @digits[0]
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
        raise "shuffled must be either true or false"
      end
    end

    # This is the set_entropy version in bits.
    def set_bits(bits)
      unless bits.is_a?(Integer) and bits >= 0
        raise "bits request must be a non-negative Integer"
      end
      set_entropy(2**bits)
      bits
    end

    # Needs to keep track of
    # the base the entropy string is in, and
    # how much entropy and randomness it contains.
    # Interpret entropy as a request for a bigger string if string is too short.
    attr_reader :randomness, :entropy
    def initialize(number = '',
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

    def randomize!(random: Random)
      @integer = random.random_number(@entropy)
      @randomness = Lb[@entropy]
      @shuffled = false
      @string = tob
      set_entropy(@entropy)
      self
    end

    # Entropy capacity is often measured in "bits",
    # a logarithmic value of entropy.
    def bits
      Lb[@entropy]
    end

    # Increase the length of the string.
    def increase!(n=1, random: nil)
      if random
        n.times{@string.prepend @digits[random.random_number(@base)]}
        @randomness += n*Lb[@base]
        @integer = toi
      else
        n.times{@string.prepend @digits[0]}
        @shuffled = false
      end
      # Revaluate entropy as a whole.
      @entropy = @base ** @string.length
      self
    end
    alias p! increase!

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
      f = x.shuffled? and y.shuffled?
      d = x.digits # or y.digits # same
      Entropia.new(string,
                   base:       b,
                   entropy:    e,
                   randomness: r,
                   shuffled:   f,
                   digits:     d)
    end

    # Entropia objects representing state should equal eachother.
    def ==(e)
      @integer      == e.to_i       and
        @entropy    == e.entropy    and
        @randomness == e.randomness and
        @shuffled   == e.shuffled?
    end

    # xor
    def ^(y)
      x = self
      x,y = y,x  if x.entropy > y.entropy

      k = x.to_i.to_s(2).bytes.reverse
      l = x.bits.ceil
      m = y.to_i.to_s(2).bytes.reverse
      n = y.bits.ceil
      c = ''
      (0).upto(n-1) do |i|
        a = k[i%l] || 48
        b = m[i] || 48
        c.prepend (a^b).to_s
      end
      integer = c.to_i(2)

      Entropia.new(integer,
                   base:       [x.base, y.base].max,
                   entropy:    y.entropy, # y has the bigger entropy
                   randomness: [x.randomness, y.randomness].max,
                   shuffled:   y.shuffled?,
                   digits:     (x.digits.length < y.digits.length)? y.digits : x.digits)
    end

    def shuffled?
      @shuffled
    end

    def shuffle(random: Random)
      s = (@base==2)? self : self*2
      # I think that with a good enough random number generator
      # for the shuffle and truly random bits, this should suffice.
      s = s.to_s.chars.shuffle(random: random).join
      s = Entropia.new(s,
                       base:       2,
                       entropy:    @entropy,
                       randomness: @randomness,
                       shuffled:   true,
                       digits:     @digits)
      s = s*@base unless @base==2
      return s
    end

    # The mathematical notation should be as terse as possible.
    # This will contruct a new entropy string.
    def self.[](n)
      if block_given?
        Entropia.new.p!(n, random: yield)
      else
        Entropia.new.p!(n)
      end
    end
  end

  # For concision
  E = Entropia
  O = 8
  H = 16
  W = 62
  B = 64
  Q = 91
end
