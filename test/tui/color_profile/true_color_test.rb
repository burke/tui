# typed: false
# frozen_string_literal: true
require('test_helper')

module TUI
  module ColorProfile
    class TrueColorTest < Minitest::Test
      def test_true_color_profile
        assert_equal('#123456', TrueColor.convert(Color.from_hex('#123456')).hex)
        assert_equal('#123456', TrueColor.color('#123456').hex)
      end
    end
  end
end
