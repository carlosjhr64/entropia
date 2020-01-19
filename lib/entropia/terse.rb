# Make notation as terse a possible.
module ENTROPIA
  O = 8
  H = 16
  W = 62
  B = 64
  Q = 91
  G = 94

  E = Entropia
  def E.[](bits)
    entropy, counter, randomness = 2**bits, 0, 0.0
    if block_given?
      obj = yield
      case obj
      when Integer, String
        counter = obj
      else
        counter = obj.random_number(entropy)
        randomness = bits.to_f
      end
    end
    E.new counter, entropy: entropy, randomness: randomness
  end

  class E
    alias p! increment!
    alias * to_base
    alias + concat
    alias ^ xor
    alias increase! increment! # for back compatibility
  end
end
