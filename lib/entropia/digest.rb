module ENTROPIA
  class Entropia
    def digest(d=Digest::SHA2.new(256))
      string = d.hexdigest @string
      Entropia.new(string,
                   base: 16,
                   # entropy becomes that in string
                   randomness: [256.0, @randomness].min,
                   shuffled: true,
                   digits: '0123456789abcdef').to_base(@base, @digits)
    end

    def sha2(n=256)
      digest(Digest::SHA2.new(n))
    end

    def sha1
      digest(Digest::SHA1)
    end

    def md5
      digest(Digest::MD5)
    end

    def rmd160
      digest(Digest::RMD160)
    end
  end
end
