# typed: false
# frozen_string_literal: true
require('test_helper')

module TUI
  class Color
    class RGBTest < Minitest::Test
      def test_rgb_colors
        assert_equal('#000000', RGB.new(0.0, 0.0, 0.0).hex)
        assert_equal('#ffffff', RGB.new(1.0, 1.0, 1.0).hex)

        assert_equal('38;2;255;255;255', RGB.new(1.0, 1.0, 1.0).sequence_fg)
        assert_equal('48;2;128;128;128', RGB.new(0.5, 0.5, 0.5).sequence_bg)

        assert_equal(RGB.new(0.5, 0.5, 0.5), RGB.new(0.5, 0.5, 0.5).to_rgb)
        refute_equal(RGB.new(1.0, 0.5, 0.5), RGB.new(0.5, 0.5, 0.5).to_rgb)
      end

      def test_to_ansi
        16.times do |index|
          assert_equal(
            ANSIColor.new(index),
            ANSIColor.new(index).to_rgb.to_ansi,
          )
        end
      end

      def test_to_ansi256
        # these results are just descriptive of what I got when I made up some
        # stuff. If you are looking at this going "wait, why is it this value
        # and not this other, better one?", then you are right, and feel free
        # to change it.
        assert_equal(ANSI256Color.new(210), RGB.new(1.0, 0.5, 0.5).to_ansi256)
        assert_equal(ANSI256Color.new(94), RGB.new(0.5, 0.2, 0.1).to_ansi256)
        assert_equal(ANSI256Color.new(196), RGB.new(1.0, 0.0, 0.0).to_ansi256)
        256.times do |index|
          # we don't cast into the first 16 slots, because they're more likely
          # to vary based on user config. So, we always select an element from
          # the rest of the space, which doesn't contain all of the estimated
          # values we have for the lower 16.
          next if index < 16
          assert_equal(
            ANSI256Color.new(index),
            ANSI256Color.new(index).to_rgb.to_ansi256,
          )
        end
      end

      def test_bounds_checking
        RGB.new(0.0, 0.0, 0.0)
        assert_raises(ArgumentError) { RGB.new(-0.00001, 0.0, 0.0) }
        assert_raises(ArgumentError) { RGB.new(0.0, -0.00001, 0.0) }
        assert_raises(ArgumentError) { RGB.new(0.0, 0.0, -0.00001) }
        assert_raises(ArgumentError) { RGB.new(1.00001, 0.0, 0.0) }
        assert_raises(ArgumentError) { RGB.new(0.0, 1.00001, 0.0) }
        assert_raises(ArgumentError) { RGB.new(0.0, 0.0, 1.00001) }
      end
    end
  end
end
