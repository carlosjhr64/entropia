require 'test/unit'
require 'entropia'

class TestLb < Test::Unit::TestCase
  include ENTROPIA

  def test_001_lb
    assert_equal 0.0, Lb[1]
    assert_equal 1.0, Lb[2]
    assert_equal 2.0, Lb[4]
    assert_equal 3.0, Lb[8]
    assert_equal 4.0, Lb[2**4]
  end

end
