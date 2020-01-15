module ENTROPIA
  Lb = lambda{|n| Math.log(n, 2)}

  class Entropia < BaseConvert::Number
    # Return self and y as an x,y pair with common base and digits.
    def Entropia.xy(x,y)
      unless x.base == y.base and  x.digits == y.digits
        digits = (y.digits.length > x.digits.length)? y.digits : x.digits
        base   = (y.base > x.base)?                   y.base   : x.base
        x = x.to_base(base, digits)
        y = y.to_base(base, digits)
      end
      return x,y
    end

    def Entropia.length(entropy, base)
      n,e = 0,1
      while e < entropy
        n += 1
        e *= base
      end
      return n
    end

    def length
      Entropia.length(@entropy, @base)
    end

    # Needs to be able to set the entropy capacity of the string
    # without changing its current Integer value.
    # Will only set increased entropy.
    def set_entropy(entropy, number=nil)
      unless entropy.is_a?(Integer) and entropy > 0
        raise "entropy request must be a positive Integer"
      end
      @shuffled = false  if @shuffled and entropy > @entropy
      if number.is_a?(String) and (e=@base**number.length) > entropy
        entropy = e
      elsif @integer and (e=[@integer,@base].max) > entropy # the minimum entropy is @base
        entropy = e
      end
      # entropy = @base ** @string.length
      # entropy = @base ** '0'.length #=> @base
      # entropy = @base ** ''.length #=> 1
      entropy = @base ** Entropia.length(entropy, @base)
      @entropy = entropy  if entropy > @entropy
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
    def set_bits(b)
      unless b.is_a?(Integer) and b >= 0
        raise "bits request must be a non-negative Integer"
      end
      set_entropy(2**b) and bits
    end

    # Needs to keep track of
    # the base the entropy string is in, and
    # how much entropy and randomness it contains.
    # Interpret entropy as a request for a bigger string if string is too short.
    attr_reader :randomness, :entropy
    def initialize(number = '',
                   base: nil,
                   entropy: 1,
                   randomness: 0.0,
                   shuffled: false,
                   digits: nil)
      base = 2  if number.is_a?(Integer) and base.nil? and digits.nil?
      super(number, base: base, digits: digits)
      @entropy, @randomness, @shuffled = 1, 0.0, false # init but to be overridden below
      set_entropy(entropy, number)
      set_randomness(randomness)
      set_shuffled(shuffled)
    end

    def to_s
      string = tos
      (length - string.length).times{string.prepend @digits[0]}
      string
    end

    def inspect
      rpb = ((b=bits)>0.0)?  @randomness/b :  0.0
      precission = (rpb<0.1)? 1: 0
      percent_random = (100*rpb).round(precission)
      shuffled = (@shuffled)? '+' : '-'
      "#{super} #{percent_random}% #{shuffled}"
    end

    def randomize!(random: Random)
      @integer = random.random_number(@entropy)
      @randomness = Lb[@entropy]
      @shuffled = false
      self
    end

    # Entropy capacity is often measured in "bits",
    # a logarithmic value of entropy.
    def bits
      Lb[@entropy]
    end

    # Increase the length of the string.
    def increment!(n=1, rng=nil, random: rng)
      raise "increment value must be a positive Integer"  unless n.is_a?(Integer) and n > 0
      rng ||= random
      if rng
        string = to_s
        n.times{string.prepend @digits[rng.random_number(@base)]}
        @randomness += n*Lb[@base]  if random
        @integer = toi(string)
      else
        @shuffled &&= false
        @integer ||= 0
      end
      # Revaluate entropy as a whole.
      @entropy = @base ** (n + length)
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

    # We need to convert to a common base and digits
    # before concatenation and then
    # create the new entropy object.
    def concat(*entropies)
      x = self
      entropies.each do |y|
        raise "concat items must be Entropia" unless y.is_a? Entropia
        x,y = Entropia.xy(x,y)
        string = x.to_s + y.to_s
        b = x.base # or y.base # same
        e = x.entropy * y.entropy
        r = x.randomness + y.randomness
        f = x.shuffled? and y.shuffled?
        d = x.digits # or y.digits # same
        x = Entropia.new(string,
                         base:       b,
                         entropy:    e,
                         randomness: r,
                         shuffled:   f,
                         digits:     d)
      end
      return x
    end

    # Entropia objects representing the same entropies should equal eachother.
    def ==(e)
      @integer      == e.to_i       and
        @entropy    == e.entropy    and
        @randomness == e.randomness and
        @shuffled   == e.shuffled?
    end

    def shuffled?
      @shuffled
    end

    def binary
      string = @integer.to_s(2)
      (Entropia.length(@entropy, 2) - string.length).times{string.prepend '0'}
      return string
    end

    def shuffle(rng=Random, random: rng)
      Entropia.new(binary.chars.shuffle(random: random).join.to_i(2),
                   base:       @base,
                   entropy:    @entropy,
                   randomness: @randomness,
                   shuffled:   true,
                   digits:     @digits)
    end

    def each_bit
      integer = @integer
      Entropia.length(@entropy, 2).times do
        integer,i = integer.divmod(2)
        yield i
      end
    end

    def xor(message)
      key = self
      # Want the lesser entropy to act as key.
      key,message = message,key  if key.entropy > message.entropy

      j = Fiber.new do
        while true # just keep giving the next key bit
          key.each_bit do |bit|
            Fiber.yield bit
          end
        end
      end

      d,integer = 1,0 
      message.each_bit do |i|
        integer += d if (i^j.resume)>0
        d*=2
      end

      Entropia.new(integer,
                   base:       [key.base, message.base].max,
                   entropy:    message.entropy, # the bigger entropy
                   randomness: [key.randomness, message.randomness].max,
                   shuffled:   message.shuffled?,
                   digits:     (key.digits.length < message.digits.length)? message.digits : key.digits)
    end
  end
end
