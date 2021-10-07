# typed: false
# frozen_string_literal: true
require('test_helper')

module TUI
  module Color
    class RGBColorTest < Minitest::Test
      def test_rgb_colors
        assert_equal('#000000', RGBColor.new(0.0, 0.0, 0.0).hex)
        assert_equal('#ffffff', RGBColor.new(1.0, 1.0, 1.0).hex)
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
