# typed: strict
# frozen_string_literal: true
require('tui')
require('io/console')

module TUI
  module Term
    class Style
      extend(T::Sig)

      sig { returns(T.nilable(TUI::Color)) }
      attr_reader(:foreground)

      sig { returns(T.nilable(TUI::Color)) }
      attr_reader(:background)

      sig { returns(T.nilable(T::Boolean)) }
      attr_reader(:bold)

      sig { returns(T.nilable(T::Boolean)) }
      attr_reader(:faint)

      sig { returns(T.nilable(T::Boolean)) }
      attr_reader(:italic)

      sig { returns(T.nilable(T::Boolean)) }
      attr_reader(:underline)

      sig { returns(T.nilable(T::Boolean)) }
      attr_reader(:overline)

      sig { returns(T.nilable(T::Boolean)) }
      attr_reader(:blink)

      sig { returns(T.nilable(T::Boolean)) }
      attr_reader(:reverse)

      sig { returns(T.nilable(T::Boolean)) }
      attr_reader(:cross_out)

      sig do
        params(
          foreground: T.nilable(TUI::Color),
          background: T.nilable(TUI::Color),
          bold: T.nilable(T::Boolean),
          faint: T.nilable(T::Boolean),
          italic: T.nilable(T::Boolean),
          underline: T.nilable(T::Boolean),
          overline: T.nilable(T::Boolean),
          blink: T.nilable(T::Boolean),
          reverse: T.nilable(T::Boolean),
          cross_out: T.nilable(T::Boolean),
        ).void
      end
      def initialize(
        foreground: nil, background: nil, bold: nil, faint: nil, italic: nil,
        underline: nil, overline: nil, blink: nil, reverse: nil, cross_out: nil
      )
        @foreground = foreground
        @background = background
        @bold = bold
        @faint = faint
        @italic = italic
        @underline = underline
        @overline = overline
        @blink = blink
        @reverse = reverse
        @cross_out = cross_out
      end

      sig do
        params(
          foreground: T.nilable(TUI::Color),
          background: T.nilable(TUI::Color),
          bold: T.nilable(T::Boolean),
          faint: T.nilable(T::Boolean),
          italic: T.nilable(T::Boolean),
          underline: T.nilable(T::Boolean),
          overline: T.nilable(T::Boolean),
          blink: T.nilable(T::Boolean),
          reverse: T.nilable(T::Boolean),
          cross_out: T.nilable(T::Boolean),
        ).returns(Style)
      end
      def extend(
        foreground: nil, background: nil, bold: nil, faint: nil, italic: nil,
        underline: nil, overline: nil, blink: nil, reverse: nil, cross_out: nil
      )
        resolve = ->(a, b) { a.nil? ? b : a }
        self.class.new(
          foreground: resolve.call(foreground, self.foreground),
          background: resolve.call(background, self.background),
          bold:       resolve.call(bold,       self.bold),
          faint:      resolve.call(faint,      self.faint),
          italic:     resolve.call(italic,     self.italic),
          underline:  resolve.call(underline,  self.underline),
          overline:   resolve.call(overline,   self.overline),
          blink:      resolve.call(blink,      self.blink),
          reverse:    resolve.call(reverse,    self.reverse),
          cross_out:  resolve.call(cross_out,  self.cross_out),
        )
      end

      sig { params(text: String).returns(String) }
      def render(text)
        seq = sgr_sequence
        return(text) if seq == ''
        CSI + seq + SGR + text + CSI + RESET_SEQ + SGR
      end

      sig { returns(String) }
      def sgr_sequence
        return(@sgr_sequence) if @sgr_sequence

        seq =  []
        seq << T.must(foreground).sequence_fg if foreground
        seq << T.must(background).sequence_bg if background

        seq << BOLD_SEQ      if bold
        seq << FAINT_SEQ     if faint
        seq << ITALIC_SEQ    if italic
        seq << UNDERLINE_SEQ if underline
        seq << BLINK_SEQ     if blink
        seq << REVERSE_SEQ   if reverse
        seq << CROSS_OUT_SEQ if cross_out
        seq << OVERLINE_SEQ  if overline

        @sgr_sequence = T.let(seq.join(';'), T.nilable(String))
        T.must(@sgr_sequence)
      end
    end
  end
end
