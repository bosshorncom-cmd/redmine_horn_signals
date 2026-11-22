require 'minitest/autorun'
require_relative '../../lib/redmine_horn_signals/pattern'

class PatternTest < Minitest::Test
  P = RedmineHornSignals::Pattern

  def test_parse_catalog_and_tokens
    assert_equal %i[long long short long], P.parse('crossing')
    assert_equal %i[short short], P.parse('o o')
    assert_raises(ArgumentError) { P.parse('x') }
  end

  def test_intervals
    iv = P.intervals(%i[long short])
    assert_equal [[true, 3000], [false, 1000], [true, 1000]], iv
  end

  def test_onset
    e, l, c = P.onset_window(30)
    assert_in_delta 880, e, 0.01
    assert_in_delta 660, l, 0.01
    refute c
    assert P.onset_window(79)[2]
  end

  def test_level
    assert_in_delta 90.0, P.level_at(110, 1000), 0.001
  end
end
