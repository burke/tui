# typed: true
# frozen_string_literal: true
require('test_helper')

module TUI
  module Term
    class QueryTest < Minitest::Test
      def test_osc_10
        mocks("\e[\e]10;?\a\e[6n", "\x1b]10;rgb:0000/0000/0000\a\x1b[1;1R")
        assert_equal('rgb:0000/0000/0000', Query.osc(10))
      end

      def test_dsr
        mocks("\e[6n", "\x1b]10;rgb:0000/0000/0000\a\x1b[1;1R")
        assert_equal([1, 1], Query.dsr('R'))
      end

      def test_dsr_default
        mocks("\e[6n", "\x1b]10;rgb:0000/0000/0000\a\x1b[1;1R")
        assert_equal([1, 1], Query.dsr)
      end

      def test_osc_11
        mocks("\e[\e]11;?\a\e[6n", "\x1b]11;rgb:ffab/12e8/0000\a\x1b[1;1R")
        assert_equal('rgb:ffab/12e8/0000', Query.osc(11))
      end

      def test_unavaialble_attribute
        mocks("\e[\e]42;?\a\e[6n", "\x1b[1;1R")
        assert_raises(Query::Error) { Query.osc(42) }
      end

      def test_osc_with_no_tty
        io, w = IO.pipe
        w.close
        Query.stubs(:stdin).returns(io)
        Query.stubs(:stdout).returns(io)
        assert_raises(Query::Error) { Query.osc(10) }
      ensure
        io&.close
      end

      def test_dsr_with_no_tty
        io, w = IO.pipe
        w.close
        Query.stubs(:stdin).returns(io)
        Query.stubs(:stdout).returns(io)
        assert_raises(Query::Error) { Query.dsr }
      ensure
        io&.close
      end

      private

      def mocks(inmsg, outmsg)
        Query.stubs(:stdin).returns(stdin_mock(outmsg))
        Query.stubs(:stdout).returns(stdout_mock(inmsg))
      end

      def stdin_mock(msg)
        m = mock
        m.expects(:raw).yields.returns(msg)
        m.expects(:noecho).yields.returns(msg)
        m.expects(:readpartial).with(128).returns(msg)
        m
      end

      def stdout_mock(msg)
        m = mock
        m.expects(:print).with(msg)
        m
      end
    end
  end
end
