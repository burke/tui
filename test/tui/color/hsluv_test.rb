# typed: false
# frozen_string_literal: true
require('test_helper')

module TUI
  class Color
    class HSLuvTest < Minitest::Test
      def test_sanity
        # https://www.hsluv.org/
        HSL_ANSI16.each.with_index do |(h, s, l), i|
          check(PALETTE[i], h, s, l)
        end
        check2(r: 0xfe, g: 0xfe, b: 0xfd, h: 85.9, s: 6.6, l: 99.6)
        check2(r: 0xff, g: 0xff, b: 0xfd, h: 85.9, s: 100, l: 100)
        check2(r: 0xff, g: 0xff, b: 0xfd, h: 85.9, s: 100, l: 100)
        check2(r: 0xff, g: 0xff, b: 0xff, h: 19.9, s: 0, l: 100)
      end

      HSL_ANSI16 = [
        [0.0, 0.0, 0.0],      # 000000
        [12.2, 100.0, 25.5],  # 800000
        [127.7, 100.0, 46.2], # 008000
        [85.9, 100.0, 51.9],  # 808000
        [265.9, 100.0, 13.0], # 000080
        [307.7, 100.0, 29.8], # 800080
        [192.2, 100.0, 48.3], # 008080
        [19.9, 0.0, 77.7],    # c0c0c0 I expected [0,... but it seems ok
      ]

      def check(hex, h, s, l)
        h2, s2, l2 = HSLuv.hex_to_hsluv(hex)
        msg = "wanted (#{h},#{s},#{l}) but got #{h2.round(1)},#{s2.round(1)},#{l2.round(1)})"
        assert_in_delta(h, h2, 1, msg)
        assert_in_delta(s, s2, 1, msg)
        assert_in_delta(l, l2, 1, msg)
      end

      def check2(r:, g:, b:, h:, s:, l:)
        h2, s2, l2 = HSLuv.rgb_to_hsluv(r.to_f/255, g.to_f/255, b.to_f/255)
        msg = "wanted (#{h},#{s},#{l}) but got #{h2.round(1)},#{s2.round(1)},#{l2.round(1)})"
        assert_in_delta(h, h2, 1, msg)
        assert_in_delta(s, s2, 1, msg)
        assert_in_delta(l, l2, 1, msg)
      end
    end
  end
end
