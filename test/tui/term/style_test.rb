# typed: true
# frozen_string_literal: true
require('test_helper')

module TUI
  module Term
    class StyleTest < Minitest::Test
      def test_style
        # foreground, ANSI16
        s = Style.new(foreground: Color::ANSIColor.new(3))
        assert_equal("\x1b[33mword\x1b[0m", s.render('word'))

        # background, ANSI256
        s = Style.new(background: Color::ANSI256Color.new(222))
        assert_equal("\x1b[48;5;222mword\x1b[0m", s.render('word'))

        # TrueColor
        s = Style.new(foreground: Color.from_hex('#123456'))
        assert_equal("\x1b[38;2;18;52;86mword\x1b[0m", s.render('word'))

        s = Style.new(bold: true)
        assert_equal("\x1b[1mword\x1b[0m", s.render('word'))

        s = Style.new(faint: true)
        assert_equal("\x1b[2mword\x1b[0m", s.render('word'))

        s = Style.new(italic: true)
        assert_equal("\x1b[3mword\x1b[0m", s.render('word'))

        s = Style.new(underline: true)
        assert_equal("\x1b[4mword\x1b[0m", s.render('word'))

        s = Style.new(blink: true)
        assert_equal("\x1b[5mword\x1b[0m", s.render('word'))

        s = Style.new(reverse: true)
        assert_equal("\x1b[7mword\x1b[0m", s.render('word'))

        s = Style.new(cross_out: true)
        assert_equal("\x1b[9mword\x1b[0m", s.render('word'))

        s = Style.new(overline: true)
        assert_equal("\x1b[53mword\x1b[0m", s.render('word'))

        # joining
        s = Style.new(bold: true, overline: true)
        assert_equal("\x1b[1;53mword\x1b[0m", s.render('word'))

        # everything!
        everything = Style.new(
          foreground: Color.from_hex('#123456'),
          background: Color.from_hex('#c0ffee'),
          bold: true, faint: true, italic: true, underline: true, overline:
          true, blink: true, reverse: true, cross_out: true,
        )
        assert_equal(
          "\x1b[38;2;18;52;86;48;2;192;255;238;1;2;3;4;5;7;9;53mword\x1b[0m",
          everything.render('word'),
        )

        # extend
        s = Style.new(bold: true).extend(italic: true)
        assert_equal("\x1b[1;3mword\x1b[0m", s.render('word'))

        s = Style.new(bold: true).extend(bold: false)
        assert_equal('word', s.render('word'))
      end
    end
  end
end
