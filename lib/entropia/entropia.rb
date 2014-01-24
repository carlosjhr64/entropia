module ENTROPIA
  class Entropia < String
    # Needs to be able to set the
    # entropy capacity of the string
    # without changing its current "value".
    def set_entropy(entropy)
      # Sometimes we need to pad entropy back up.
      zero = @digits.first
      while entropy > @base ** self.length
        self.insert(0, zero)
      end
      @entropy = entropy
    end
    # This is the set_entropy version in bits.
    def set_bits(bits)
      set_entropy(2**bits)
    end

    # Needs to keep track of
    # the base the entropy string is in,
    # and how much entropy and randomness it contains.
    attr_reader :base, :randomness, :entropy
    def initialize(string='', base=2, randomness=0, entropy=nil, digits=nil)
      super(string)
      @base       = base
      @digits     = (digits)?  digits  :
                    (@base>BaseConvert::DIGITS.length)? BaseConvert::QGRAPH :
                     BaseConvert::DIGITS
      @randomness = randomness
      set_entropy((entropy)? entropy : base ** self.length)
    end
    # Entropy capacity is often measured in "bits",
    # a logarithmic value of entropy.
    def bits
      Lb[@entropy]
    end
    # Needs to be able to increase
    # the entropy in the string.
    def increase(n=1, random=false)
      if block_given?
        n.times{self<<@digits[yield(@base)]}
        @randomness += n*Lb[@base] if random
      else
        n.times{self<<@digits[SecureRandom.random_number(@base)]}
        # Note that because rand is pseudo, we don't increment randomness.
      end
      # We can revaluate entropy as a whole.
      @entropy = @base ** self.length
      self
    end
    alias pp increase

    # The operator for base convert.
    def *(n, digits=nil)
      b = BaseConvert.new(self.base, n)
      # Ensure the choice of digits
      (digits)? (b.to_digits=digits) : (digits=b.to_digits)
      b.from_digits = @digits
      #def initialize(string='', base=2, randomness=0, entropy=nil, digits=nil)
      return Entropia.new(b.convert(self.to_s), n, self.randomness, self.entropy, digits)
    end
    # We need to convert our given s to our base
    # before concatination and then
    # create the new entropy object in our base.
    def +(s)
      n = self.base
      r = self.randomness + s.randomness
      e = self.entropy * s.entropy
      s = s*n unless n == s.base
      #def initialize(string='', base=2, randomness=0, entropy=nil, digits=nil)
      return Entropia.new(super(s), n, r, e, @digits)
    end
    # Entropia objects representing the same value should be equal eachother.
    def ==(e)
      e = e*@base unless e.base == @base
      self.to_s == e.to_s
    end
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
