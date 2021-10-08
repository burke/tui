# typed: false
# frozen_string_literal: true
require('test_helper')

module TUI
  module Profile
    class ANSITest < Minitest::Test
      def test_ansi_profile
        # Tries. There's not a lot you can do with 16 colors.
        assert_equal('#000080', ANSI.convert(Color.from_hex('#123478')).hex)
        assert_equal('#000080', ANSI.color('#123478').hex)

        # Maps things in our guesstimate of ANSI16 correctly
        assert_equal('#000080', ANSI.convert(Color.from_hex('#000080')).hex)
        assert_equal('#000080', ANSI.color('#000080').hex)

        # maps colors in ANSI256 to their closest match
        assert_equal('#000080', ANSI.convert(Color.from_hex('#000087')).hex)
        assert_equal('#000080', ANSI.color('#000087').hex)
      end
    end
  end
end
