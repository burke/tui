# typed: false
# frozen_string_literal: true
require('test_helper')

module TUI
  class Color
    class AdaptiveTest < Minitest::Test
      def test_adaptive_light
        Term.stubs(:dark_background?).returns(false)

        c = Adaptive.new(light: Color[0], dark: Color[15])
        assert_equal(Color[0], c.resolve)
        assert_equal(c, Adaptive.new(light: Color[0], dark: Color[15]))
        assert_equal('#000000', c.hex)
        assert_equal('30', c.sequence_fg)
        assert_equal('40', c.sequence_bg)
        assert_equal(Color['#000000'], c.to_rgb)
        assert_equal(Color[0], c.to_ansi)
        assert_equal(Color::ANSI256Color.new(0), c.to_ansi256)
      end

      def test_adaptive_dark
        Term.stubs(:dark_background?).returns(true)

        c = Adaptive.new(light: Color[0], dark: Color[15])
        assert_equal(Color[15], c.resolve)
        assert_equal('#ffffff', c.hex)
        assert_equal('97', c.sequence_fg)
        assert_equal('107', c.sequence_bg)
        assert_equal(Color['#ffffff'], c.to_rgb)
        assert_equal(Color[15], c.to_ansi)
        assert_equal(Color::ANSI256Color.new(15), c.to_ansi256)
      end
    end
  end
end
