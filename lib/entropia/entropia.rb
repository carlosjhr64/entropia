module ENTROPIA
  Lb = lambda{|n| Math.log(n, 2)}

  # For Entropia#inspect,
  # keys I want to recognize in DIGITS
  # in the order I want them recognized.
  DIGITS_KEYS = [:g94, :q, :g, :w_, :b64, :u]

  class Entropia < BaseConvert::Number
    # Needs to be able to set the entropy capacity of the string
    # without changing its current "value".
    def set_entropy(entropy)
      unless entropy.is_a?(Integer) and entropy >= 0
        raise "entropy request must be a non-negative Integer"
      end
      if entropy > 0
        # Sometimes we need to pad entropy back up.
        n = Math.log(entropy, @base).ceil - @string.length
        if n > 0
          @shuffled &&= false
          zero = @digits[0]
          n.times{@string.prepend zero}
        end
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

    def inspect
      digits_key = ''
      DIGITS_KEYS.each do |key|
        if DIGITS[key].start_with?(@digits)
          digits_key = key
          break
        end
      end
      rpb = ((b=bits)>0.0)?  @randomness/b :  0.0
      precission = (rpb<0.1)? 1: 0
      percent_random = (100*rpb).round(precission)
      shuffled = (@shuffled)? '+' : '-'
      "#{@string} #{base}:#{digits_key} #{percent_random}% #{shuffled}"
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
    def increment!(n=1, rng=nil, random: rng)
      rng ||= random
      if rng
        n.times{@string.prepend @digits[rng.random_number(@base)]}
        @randomness += n*Lb[@base]  if random
        @integer = toi
      else
        n.times{@string.prepend @digits[0]}
        @shuffled = false
      end
      # Revaluate entropy as a whole.
      @entropy = @base ** @string.length
      self
    end

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
      case y
      when Entropia
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
      when Integer
        raise "String increase request must be a non-negative Integer" if y < 0
        Entropia.new(@integer,
                     base:       @base,
                     entropy:    @entropy,
                     randomness: @randomness,
                     shuffled:   @shuffled,
                     digits:     @digits
                    ).increment!(y)
      else
        raise "y must be Entropia|Integer"
      end
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

    def shuffle(rng=Random, random: rng)
      s = @integer.to_s(2)
      (bits.ceil - s.length).times{s.prepend '0'}
      s = s.chars.shuffle(random: random).join
      Entropia.new(s.to_i(2),
                   base:       @base,
                   entropy:    @entropy,
                   randomness: @randomness,
                   shuffled:   true,
                   digits:     @digits)
    end
  end
end
