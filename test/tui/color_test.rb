# typed: false
# frozen_string_literal: true
require('test_helper')

module TUI
  class ColorTest < Minitest::Test
    def test_hex_roundtrip
      skip
      assert_equal('#00ff66', Color.from_hex('#00ff66').hex)
      assert_equal('#00ff66', Color.from_hex('#00FF66').hex)
      assert_equal('#abcdef', Color.from_hex('#abcdef').hex)
    end
  end
end
