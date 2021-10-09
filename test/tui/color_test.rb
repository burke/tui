# typed: false
# frozen_string_literal: true
require('test_helper')

module TUI
  class ColorTest < Minitest::Test
    def test_hex_roundtrip
      assert_equal(Color::RGBColor.new(0.0, 1.0, 0.4), Color.from_hex('#00ff66'))
      assert_equal('#00ff66', Color.from_hex('#00ff66').hex)
      assert_equal('#00ff66', Color.from_hex('#00FF66').hex)
      assert_equal('#abcdef', Color.from_hex('#abcdef').hex)

      bad_hex('#abc')
      bad_hex('#abcdefg')
      bad_hex('abcdef')
    end

    def test_luminance
      assert_in_delta(1.0, Color['#ffffff'].luminance, 0.01)
      assert_in_delta(0.0, Color[0].luminance, 0.01)
      # these three would be subject to change under a more accurate luminance
      # calculation
      assert_in_delta(0.54, Color['#ff0000'].luminance, 0.01)
      assert_in_delta(0.77, Color['#00ff00'].luminance, 0.01)
      assert_in_delta(0.34, Color['#0000ff'].luminance, 0.01)
    end

    def test_from_index
      assert_equal(Color::ANSIColor.new(0), Color.from_index(0))
      refute_equal(Color::ANSI256Color.new(0), Color.from_index(0))
      assert_equal(Color::ANSI256Color.new(17), Color.from_index(17))
      assert_raises(ArgumentError) { Color.from_index(256) }
    end

    def test_squares
      assert_equal(Color::ANSIColor.new(0), Color['0'])
      assert_equal(Color::ANSIColor.new(0), Color[0])
      refute_equal(Color::ANSI256Color.new(0), Color[0])
      assert_equal(Color::ANSI256Color.new(17), Color[17])
      assert_equal('#00ff66', Color['#00FF66'].hex)
      assert_raises(ArgumentError) { Color['neato'] }
    end

    def test_to_rgb
      assert_kind_of(Color::RGBColor, Color::RGBColor.new(1.0, 1.0, 1.0).to_rgb)
      assert_kind_of(Color::RGBColor, Color::ANSI256Color.new(1).to_rgb)
      assert_kind_of(Color::RGBColor, Color::ANSIColor.new(1).to_rgb)
    end

    def test_to_ansi
      assert_equal('#ff0000', Color.from_hex('#fe0000').to_ansi.hex)
      assert_equal('#000080', Color.from_hex('#123456').to_ansi.hex) # HSLuv would choose 008080
    end

    def test_from_xterm
      assert_equal('#abcdef', Color.from_xterm('rgb:ab12/cd34/ef56').hex)
      assert_equal('#abcdef', Color.from_xterm('rgb:ab12/cd34/ef56').hex)
      bad_xterm('rgb:1234/1234/123')
      bad_xterm('1234/1234/1234')
      bad_xterm('rgb:1234/12k4/1234')
    end

    def bad_xterm(s)
      assert_raises(ArgumentError) { Color.from_xterm(s) }
    end

    def bad_hex(s)
      assert_raises(ArgumentError) { Color.from_hex(s) }
    end
  end
end
