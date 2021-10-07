# typed: false
# frozen_string_literal: true
require('test_helper')

module TUI
  module Color
    class ANSI256ColorTest < Minitest::Test
      def test_ansi256_colors
        assert_equal('#000000', ANSI256Color.new(0).hex)
        assert_equal('#eeeeee', ANSI256Color.new(255).hex)

        assert_equal('38;5;200', ANSI256Color.new(200).sequence_fg)
        assert_equal('48;5;158', ANSI256Color.new(158).sequence_bg)
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
