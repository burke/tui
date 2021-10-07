# typed: false
# frozen_string_literal: true
require('test_helper')

module TUI
  module Color
    class NoColorTest < Minitest::Test
      def test_no_color
        assert_equal('', NoColor.new.hex)
        assert_equal('', NoColor.new.sequence_fg)
        assert_equal('', NoColor.new.sequence_bg)
      end

      def test_bounds_checking
        RGBColor.new(0.0, 0.0, 0.0)
        assert_raises(ArgumentError) { RGBColor.new(-0.00001, 0.0, 0.0) }
        assert_raises(ArgumentError) { RGBColor.new(0.0, -0.00001, 0.0) }
        assert_raises(ArgumentError) { RGBColor.new(0.0, 0.0, -0.00001) }
        assert_raises(ArgumentError) { RGBColor.new(1.00001, 0.0, 0.0) }
        assert_raises(ArgumentError) { RGBColor.new(0.0, 1.00001, 0.0) }
        assert_raises(ArgumentError) { RGBColor.new(0.0, 0.0, 1.00001) }
      end
    end
  end
end
