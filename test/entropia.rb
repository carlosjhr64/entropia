require 'test/unit'
require 'entropia'

class TestEntropia < Test::Unit::TestCase
  include ENTROPIA

  def test_001_new
    s = nil
    assert_nothing_raised(Exception){ s = Entropia.new }
    assert_equal '',    s.to_s
    assert_equal 2,     s.base
    assert_equal 0,     s.randomness
    assert_equal false, s.shuffled
    assert_equal 1,     s.entropy
    assert_equal 0.0,   s.bits

    s = Entropia.new('0000')
    assert_equal 2**4,     s.entropy
  end

  def test_002_increase
    s = Entropia.new
    assert_nothing_raised(Exception){ s.increase(4) }
    assert_equal 4,     s.length
    assert_equal 2,     s.base
    assert_equal 0,     s.randomness
    assert_equal false, s.shuffled
    assert_equal 2**4,  s.entropy
    assert_equal 4.0,   s.bits
  end

  def test_003_pp # alias of increase
    s = Entropia.new
    assert_nothing_raised(Exception){ s.pp }
    assert_nothing_raised(Exception){ s.pp }
    a = s.pp
    assert_equal a,      s
    assert_equal a.to_s, s.to_s
    assert_equal 3,      s.length
    assert_equal 2,      s.base
    assert_equal 0,      s.randomness
    assert_equal false,  s.shuffled
    assert_equal 2**3,   s.entropy
    assert_equal 3.0,    s.bits
  end

  def test_004_pp_block
    s = Entropia.new
    a = s.pp(6){ 0 }
    assert_equal a,        s
    assert_equal a.to_s,   s.to_s
    assert_equal 6,        s.length
    assert_equal '000000', s.to_s
    assert_equal 2,        s.base
    assert_equal 0,        s.randomness
    assert_equal false,    s.shuffled
    assert_equal 2**6,     s.entropy
    assert_equal 6.0,      s.bits
  end

  def test_005_pp_true_block
    s = Entropia.new
    a = s.pp(5, true){ 1 } # as truly random (we lie)
    assert_equal a,       s
    assert_equal a.to_s,  s.to_s
    assert_equal 5,       s.length
    assert_equal '11111', s.to_s
    assert_equal 2,       s.base
    assert_equal 5,       s.randomness
    assert_equal false,   s.shuffled
    assert_equal 2**5,    s.entropy
    assert_equal 5.0,     s.bits
  end

  def test_006_set_entropy
    s = Entropia.new
    assert_equal 0, s.length

    e = s.set_entropy(2**16)
    assert_equal 16,                 s.length
    assert_equal e,                  s.entropy
    assert_equal 2**16,              s.entropy
    assert_equal '0000000000000000', s.to_s
  end

  def test_007_set_bits
    s = Entropia.new
    assert_equal 0, s.length
    e = s.set_bits(16)

    assert_equal 16,                 s.length
    assert_equal e,                  s.entropy
    assert_equal 2**16,              s.entropy
    assert_equal '0000000000000000', s.to_s
  end

  def test_008_convert_base
    s = Entropia.new.increase(16)
    assert_equal 16, s.length

    sh = s*16
    assert_equal 4, sh.length
    refute_nil s=~/^[01]{16}$/
    refute_nil sh=~/^[\dABCDEF]{4}$/

    s = Entropia.new.increase(16){1}
    sh = s*16
    assert_equal 'FFFF', sh.to_s
  end

  def test_009_convert_base_conservation
    s = Entropia.new.increase(8, true){ rand(2) }
    sh = s*16
    assert_equal 2,     sh.length
    assert_equal 8,     sh.randomness
    assert_equal false, sh.shuffled
    assert_equal 16,    sh.base
    assert_equal 2**8,  sh.entropy
  end

  def test_010_concat_2_by_2
    s0 = Entropia.new.increase(4, true){  0 }
    s1 = Entropia.new.increase(4, false){ 1 }
    s = nil
    assert_nothing_raised(Exception){ s = s0 + s1 }
    assert_equal 8,     s.length
    assert_equal 2,     s.base
    assert_equal 2**8,  s.entropy
    assert_equal 4,     s.randomness
    assert_equal false, s.shuffled
  end

  def test_011_concat_16_by_8
    s0 = Entropia.new.increase(4)*16
    assert_equal 16, s0.base
    s1 = Entropia.new.increase(4)*8
    assert_equal 8, s1.base

    s01 = s0 + s1
    assert_equal 16, s01.base
    assert_equal 2,  s01.length

    s10 = s1 + s0
    assert_equal 8, s10.base
    assert_equal 4, s10.length

    assert_equal 2**8, s01.entropy
    assert_equal 2**8, s10.entropy

    assert_equal false, s01.shuffled
    assert_equal false, s10.shuffled
  end

  def test_012_equal
    s = Entropia.new.increase(16)
    sh = s*16
    so = s*8
    assert sh == so
    assert so == sh
  end

  def test_013_notation
    s = E[256]
    assert_equal 256, s.length

    h = s*H
    assert_equal 16, h.base

    o = s*O
    assert_equal 8, o.base

    q = s*Q
    assert_equal 91, q.base

    w = s*W
    assert_equal 62, w.base

    assert h == o
    assert q == o
    assert q == w
  end

end
