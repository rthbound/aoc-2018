require "test_helper"

class DayTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Day::VERSION
  end

  def test_it_does_something_useful
    assert "super useful"[-1] == ?l
  end
end
