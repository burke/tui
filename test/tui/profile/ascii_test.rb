# typed: false
# frozen_string_literal: true
require('test_helper')

module TUI
  module Profile
    class ASCIITest < Minitest::Test
      def test_ascii_profile
        assert_kind_of(Color::NoColor, ASCII.convert(Color.from_hex('#123478')))
        assert_kind_of('#000080', ASCII.color('#123478'))
      end
    end
  end
end
