# typed: false
# frozen_string_literal: true
require('test_helper')

module TUI
  class Color
    class RGBColorTest < Minitest::Test
      def test_rgb_colors
        assert_equal('#000000', RGBColor.new(0.0, 0.0, 0.0).hex)
        assert_equal('#ffffff', RGBColor.new(1.0, 1.0, 1.0).hex)

        assert_equal('38;2;255;255;255', RGBColor.new(1.0, 1.0, 1.0).sequence_fg)
        assert_equal('48;2;128;128;128', RGBColor.new(0.5, 0.5, 0.5).sequence_bg)
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
