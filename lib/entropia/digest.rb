module ENTROPIA
  DIGEST = {}
  DIGEST[:D] = Digest::SHA512
  DIGEST[:C] = Digest::MD5

  module Extensions
    attr_accessor :base, :randomness, :shuffled, :entropy, :digits
    def ^(s, i=-1)
      s = s.to_s.bytes
      s = s.inject(''){|p, b| p+(b^self.bytes[(i+=1)%length]).chr}
      s.extend Extensions
      return s
    end
    def +(x)
      x = super
      x.extend Extensions
      return x
    end
    def *(n)
      e = self.bytes.inject(''){|e, byte| e<<byte.to_s(2)}
      e = Entropia.novi(e, self, :b=>2)
      e = e*n unless n==2
      return e
    end
    def bits
      Lb[self.entropy]
    end
    def shuffled?
      self.shuffled
    end
  end

  module Extended
    def self.[](d, s)
      d.extend Extensions
      d.base = 256
      d.randomness = s.randomness
      d.shuffled = true
      d.entropy = 256**d.length
      d.entropy = s.entropy if s.entropy < d.entropy
      d.randomness = d.bits if d.randomness > d.bits
      d.digits = nil
      return d
    end
  end

  module D
    def self.[](s, d=DIGEST[:D])
      d = d.digest(s.to_s)
      return Extended[d, s]
    end
  end

  module C
    def self.[](s, d=DIGEST[:C])
      d = d.digest(s.to_s)
      return Extended[d, s]
    end
  end
end
