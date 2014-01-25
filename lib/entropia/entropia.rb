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
        @shuffled = false if @shuffled
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
    attr_reader :base, :randomness, :shuffled, :entropy, :digits
    def initialize(string='',
                   base=2,
                   randomness=0,
                   shuffled=false,
                   entropy=nil,
                   digits=nil)
      super(string)
      @base       = base
      @digits     = (digits)?  digits  :
                    (@base>BaseConvert::DIGITS.length)? BaseConvert::QGRAPH :
                     BaseConvert::DIGITS
      @randomness = randomness
      set_entropy((entropy)? entropy : base ** self.length)
      @shuffled = shuffled
    end

    def self.novi(string, o, h={})
      Entropia.new(string,
                   h[:b] || h[:base]       || o.base       || 2,
                   h[:r] || h[:randomness] || o.randomness || 0,
                   [h[:s], h[:shuffled], o.shuffled, false].detect{|f| !f.nil?},
                   h[:e] || h[:entropy]    || o.entropy,
                   h[:d] || h[:digits]     || o.digits)
    end

    def self.nuevo(string, h)
      Entropia.new(string,
                   h[:b] || h[:base]       || 2,
                   h[:r] || h[:randomness] || 0,
                   [h[:s], h[:shuffled], false].detect{|f| !f.nil?},
                   h[:e] || h[:entropy],
                   h[:d] || h[:digits])
    end

    # Entropy capacity is often measured in "bits",
    # a logarithmic value of entropy.
    def bits
      Lb[@entropy]
    end

    # Needs to be able to increase
    # the entropy in the string.
    def increase(n=1, random=false)
      @shuffled = false unless random
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
    def convert(n, digits=nil)
      b = BaseConvert.new(@base, n)
      # Ensure the choice of digits
      (digits)? (b.to_digits=digits) : (digits=b.to_digits)
      b.from_digits = @digits
      return Entropia.novi(b.convert(self.to_s), self, :b=>n, :d=>digits)
    end

    def *(n)
      convert(n)
    end

    # We need to convert our given s to our base
    # before concatination and then
    # create the new entropy object in our base.
    def +(s)
      r = @randomness + s.randomness
      f = @shuffled and s.shuffled
      e = @entropy * s.entropy
      s = s*@base unless @base == s.base
      return Entropia.novi(super(s), self, :r=>r, :s=>f, :e=>e)
    end

    # Entropia objects representing the same value should be equal eachother.
    def ==(e)
      e = e*@base unless e.base == @base
      self.to_s == e.to_s
    end

    # xor
    def ^(b)
      r = [@randomness, b.randomness].min
      f = @shuffled and b.shuffled
      e = [@entropy,    b.entropy].min

      a = (@base==2)?  self : self*2
      z, u = a.digits[0], a.digits[1]

      b = (b.base==2)? b    : b.convert(2, [z, u])

      a = a.chars
      l = a.length
      i = -1
      s = b.chars.inject('') do |s, c|
        i += 1
        y = (a[i%l].to_s==u)
        x = (c.to_s==u)
        s+((x^y)? u : z)
      end

      s = Entropia.new(s, 2, r, f, e, [z, u])
      s = s.convert(@base, @digits) unless @base==2

      return s
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
