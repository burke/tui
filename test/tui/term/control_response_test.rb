# typed: true
# frozen_string_literal: true
require('test_helper')

module TUI
  module Term
    class ControlResponseTest < Minitest::Test
      def test_parse
        exp = { osc: { 10 => 'rgb:0000/0000/0000' }, ansi: [[1, 1, 'R']] }
        act = ControlResponse.parse("\x1b]10;rgb:0000/0000/0000\a\x1b[1;1R").data
        assert_equal(exp, act)
      end
    end
  end
end
