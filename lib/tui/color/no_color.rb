# typed: strict
# frozen_string_literal: true
require('tui')

module TUI
  class Color
    class NoColor < Color
      extend(T::Sig)

      sig { override.returns(String) }
      def hex
        ''
      end

      sig { override.returns(String) }
      def sequence_fg
        ''
      end

      sig { override.returns(String) }
      def sequence_bg
        ''
      end

      sig { override.returns(ANSIColor) }
      def to_ansi
        raise
      end

      sig { override.returns(ANSI256Color) }
      def to_ansi256
        raise
      end

      sig { override.returns(RGBColor) }
      def to_rgb
        raise
      end
    end
  end
end
