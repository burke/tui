# typed: false
# frozen_string_literal: true
require('test_helper')

module TUI
  class Color
    class HSLuvTest < Minitest::Test
      def test_sanity
        # https://leonardocolor.io/converter.html
        # check(r: 0x95, g: 0x23, b: 0x23, h: 12, s: 76, l: 33)
        # check(r: 0x00, g: 0x00, b: 0x00, h: 0, s: 0, l: 0)
        check(r: 0xFF, g: 0xFF, b: 0xFF, h: 0, s: 0, l: 100)
      end

      def check(r:, g:, b:, h:, s:, l:)
        h2, s2, l2 = HSLuv.from_rgb(r.to_f/255, g.to_f/255, b.to_f/255)
        raise([h2, s2, l2].inspect)
        assert_in_delta(h, h2, 1)
        assert_in_delta(s, s2, 1)
        assert_in_delta(l, l2, 1)
      end
    end
  end
end
