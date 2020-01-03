# Make notation as terse a possible.
module ENTROPIA
  O = 8
  H = 16
  W = 62
  B = 64
  Q = 91
  G = 94

  E = Entropia
  def E.[](n)
    if block_given?
      E.new.increment!(n, random: yield)
    else
      E.new.increment!(n)
    end
  end

  class E
    alias p! increment!
    alias increase! increment! # for back compatibility
  end
end
