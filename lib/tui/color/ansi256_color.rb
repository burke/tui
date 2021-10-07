# typed: strict
# frozen_string_literal: true
require('tui')

module TUI
  class Color
    class ANSI256Color < Color
      extend(T::Sig)

      sig { params(n: Integer).void }
      def initialize(n)
        raise(ArgumentError, "invalid color index: #{n}") unless n >= 0 && n < 256
        @n = n
        super()
      end

      sig { override.returns(String) }
      def hex
        T.must(PALETTE[@n]) # verified in initialize
      end

      sig { override.returns(String) }
      def sequence_fg
        "38;5;#{@n}"
      end

      sig { override.returns(String) }
      def sequence_bg
        "48;5;#{@n}"
      end

      sig { override.returns(RGBColor) }
      def to_rgb
        Color.from_hex(hex)
      end
    end
  end
end
