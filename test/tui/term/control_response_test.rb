# typed: true
# frozen_string_literal: true
require('test_helper')

module TUI
  module Term
    class ControlResponseTest < Minitest::Test
      def test_parse
        cr = ControlResponse.parse("\x1b]10;rgb:0000/0000/0000\a\x1b[1;1R")
        assert_equal([10], cr.osc_attributes)
        assert_equal('rgb:0000/0000/0000', cr.osc_attribute(10))
        assert_equal(['R'], cr.ansi_sequences.map(&:code))
        assert_equal([[1, 1]], cr.ansi_sequences.map(&:args))

        cr = ControlResponse.parse("\x1b[1;1R")
        assert_equal([], cr.osc_attributes)
        assert_equal(['R'], cr.ansi_sequences.map(&:code))
        assert_equal([[1, 1]], cr.ansi_sequences.map(&:args))

        bad("\x1b10;rgb:0000/0000/0000\a\x1b[1;1R", 'unexpected byte')
        bad("\x1b]10;rgb:0000/0000/0000\a\x1b[1;1", 'incomplete input')
        bad("]10;rgb:0000/0000/0000\a\x1b[1;1R", 'unexpected byte')
      end

      private

      def bad(str, msg)
        ControlResponse.parse(str)
      rescue => e
        raise unless e.is_a?(ControlResponse::ParseError)
        assert_includes(e.to_s, msg)
      else
        assert(false, 'exception not raised')
      end
    end
  end
end
