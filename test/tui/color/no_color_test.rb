# typed: false
# frozen_string_literal: true
require('test_helper')

module TUI
  class Color
    class NoColorTest < Minitest::Test
      def test_no_color
        n = NoColor.new
        assert_equal('', n.hex)
        assert_equal('', n.sequence_fg)
        assert_equal('', n.sequence_bg)
        assert_raises { n.to_rgb }
      end
    end
  end
end
