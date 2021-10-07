# typed: false
# frozen_string_literal: true
require('test_helper')

module TUI
  class Color
    class NoColorTest < Minitest::Test
      def test_no_color
        assert_equal('', NoColor.new.hex)
        assert_equal('', NoColor.new.sequence_fg)
        assert_equal('', NoColor.new.sequence_bg)
      end
    end
  end
end
