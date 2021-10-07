# typed: false
# frozen_string_literal: true
require('test_helper')

module TUI
  module Color
    class ANSIColorTest < Minitest::Test
      def test_ansi_colors
        assert_equal('#000000', ANSIColor::BLACK.hex)
        assert_equal('#00ff00', ANSIColor::BRIGHT_GREEN.hex)

        assert_equal('30', ANSIColor::BLACK.sequence_fg)
        assert_equal('31', ANSIColor::RED.sequence_fg)
        assert_equal('42', ANSIColor::GREEN.sequence_bg)
        assert_equal('43', ANSIColor::YELLOW.sequence_bg)
        assert_equal('34', ANSIColor::BLUE.sequence_fg)
        assert_equal('35', ANSIColor::MAGENTA.sequence_fg)
        assert_equal('36', ANSIColor::CYAN.sequence_fg)
        assert_equal('37', ANSIColor::WHITE.sequence_fg)

        assert_equal('90', ANSIColor::BRIGHT_BLACK.sequence_fg)
        assert_equal('91', ANSIColor::BRIGHT_RED.sequence_fg)
        assert_equal('102', ANSIColor::BRIGHT_GREEN.sequence_bg)
        assert_equal('103', ANSIColor::BRIGHT_YELLOW.sequence_bg)
        assert_equal('94', ANSIColor::BRIGHT_BLUE.sequence_fg)
        assert_equal('95', ANSIColor::BRIGHT_MAGENTA.sequence_fg)
        assert_equal('96', ANSIColor::BRIGHT_CYAN.sequence_fg)
        assert_equal('97', ANSIColor::BRIGHT_WHITE.sequence_fg)
      end

      def test_bounds_checking
        ANSIColor.new(0)
        ANSIColor.new(15)
        assert_raises(ArgumentError) { ANSIColor.new(16) }
        assert_raises(ArgumentError) { ANSIColor.new(-1) }
      end
    end
  end
end