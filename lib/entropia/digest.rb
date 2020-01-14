module ENTROPIA
  class Entropia
    def digest(d=Digest::SHA2.new(256), r=256.0)
      Entropia.new(d.hexdigest @string,
                   base: 16,
                   # entropy becomes that in string
                   randomness: [r, @randomness].min,
                   shuffled: true,
                   digits: '0123456789abcdef'
                  ).to_base(@base, @digits)
    end

    def sha2(n=256)
      digest(Digest::SHA2.new(n), n.to_f)
    end

    def sha1
      digest(Digest::SHA1, 160.0)
    end

    def md5
      digest(Digest::MD5, 128.0)
    end

    def rmd160
      digest(Digest::RMD160, 160.0)
    end
  end
end
