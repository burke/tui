# typed: false
# frozen_string_literal: true
require('test_helper')

module TUI
  class Color
    class ANSI256ColorTest < Minitest::Test
      def test_ansi256_colors
        assert_equal('#000000', ANSI256Color.new(0).hex)
        assert_equal('#eeeeee', ANSI256Color.new(255).hex)

        assert_equal('38;5;200', ANSI256Color.new(200).sequence_fg)
        assert_equal('48;5;158', ANSI256Color.new(158).sequence_bg)

        assert_equal(RGBColor.new(1.0, 0.0, 0.0), ANSI256Color.new(9).to_rgb)
      end

      def test_conversions
        c = ANSI256Color.new(200)
        assert_equal(c, c.to_ansi256)
        assert_equal('#ff00ff', c.to_ansi.hex)
      end

      def test_bounds_checking
        ANSI256Color.new(0)
        ANSI256Color.new(255)
        assert_raises(ArgumentError) { ANSI256Color.new(256) }
        assert_raises(ArgumentError) { ANSI256Color.new(-1) }
      end
    end
  end
end
