# typed: false
# frozen_string_literal: true
require('test_helper')

module TUI
  module Profile
    class ASCIITest < Minitest::Test
      def test_ascii_profile
        assert_nil(ASCII.convert(Color.from_hex('#123478')))
        assert_nil(ASCII.color('#123478'))
      end
    end
  end
end
