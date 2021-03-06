# typed: false
# frozen_string_literal: true
require('test_helper')

module TUI
  module ColorProfile
    class ANSI256Test < Minitest::Test
      def test_ansi256_profile
        # tries its best with RGB values (note that this selection could likely
        # be improved by using HSLuv distance instead of Riemersma)
        assert_equal('#005f87', ANSI256.convert(Color.from_hex('#123478')).hex)
        assert_equal('#005f87', ANSI256.color('#123478').hex)

        # Doesn't return our guesstimates of ANSI16 colors
        assert_equal('#000087', ANSI256.convert(Color.from_hex('#000080')).hex)
        assert_equal('#000087', ANSI256.color('#000080').hex)

        # maps colors in ANSI256 but not ANSI16 directly
        assert_equal('#eeeeee', ANSI256.convert(Color.from_hex('#eeeeee')).hex)
        assert_equal('#eeeeee', ANSI256.color('#eeeeee').hex)
      end
    end
  end
end
