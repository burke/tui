# typed: false
# frozen_string_literal: true
require('test_helper')
require('pty')

module TUI
  class ProfileTest < Minitest::Test
    def test_profile
      tty, ttys = PTY.open
      ttys.close

      pipe, pw = IO.pipe
      pw.close

      check(Profile::ASCII,     'xterm-256color',        'truecolor',        pipe)
      check(Profile::TrueColor, 'xterm-256color',        'truecolor',        tty)
      check(Profile::TrueColor, 'xterm-256color',        '24bit',            tty)
      check(Profile::ANSI256,   'xterm-256color',        'some-other-value', tty)
      check(Profile::ANSI,      'xterm-color',           'some-other-value', tty)
      check(Profile::ANSI256,   'xterm-color',           'yes',              tty)
      check(Profile::ANSI256,   'xterm-color',           'true',             tty)
      check(Profile::ASCII,     'xterm',                 'some-other-value', tty)
      check(Profile::TrueColor, 'screen',                'truecolor',        tty)
      check(Profile::ANSI256,   'screen.xterm-256color', 'truecolor',        tty)
    ensure
      tty.close
      pipe.close
    end

    private

    def check(exp, term, colorterm, stdout)
      assert_equal(exp, Profile.current(term: term, colorterm: colorterm, stdout: stdout))
    end
  end
end
