# typed: false
# frozen_string_literal: true
require('test_helper')
require('pty')

module TUI
  class ColorProfileTest < Minitest::Test
    def test_profile_detect
      tty, ttys = PTY.open
      ttys.close

      pipe, pw = IO.pipe
      pw.close

      check(ColorProfile::ASCII,     'xterm-256color',        'truecolor',        pipe)
      check(ColorProfile::TrueColor, 'xterm-256color',        'truecolor',        tty)
      check(ColorProfile::TrueColor, 'xterm-256color',        '24bit',            tty)
      check(ColorProfile::ANSI256,   'xterm-256color',        'some-other-value', tty)
      check(ColorProfile::ANSI,      'xterm-color',           'some-other-value', tty)
      check(ColorProfile::ANSI256,   'xterm-color',           'yes',              tty)
      check(ColorProfile::ANSI256,   'xterm-color',           'true',             tty)
      check(ColorProfile::ASCII,     'xterm',                 'some-other-value', tty)
      check(ColorProfile::TrueColor, 'screen',                'truecolor',        tty)
      check(ColorProfile::ANSI256,   'screen.xterm-256color', 'truecolor',        tty)
    ensure
      tty.close
      pipe.close
    end

    private

    def check(exp, term, colorterm, stdout)
      assert_equal(exp, ColorProfile.detect(term: term, colorterm: colorterm, stdout: stdout))
    end
  end
end
