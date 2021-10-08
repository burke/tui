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
