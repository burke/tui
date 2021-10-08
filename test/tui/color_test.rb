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
    end

    def test_to_ansi
      assert_equal('#ff0000', Color.from_hex('#fe0000').to_ansi.hex)
      assert_equal('#000080', Color.from_hex('#123456').to_ansi.hex) # HSLuv would choose 008080
    end
  end
end
