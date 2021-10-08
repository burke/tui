# typed: strict
# frozen_string_literal: true
require('tui')

module TUI
  class Color
    class ANSI256Color < Color
      extend(T::Sig)

      sig { params(index: Integer).void }
      def initialize(index)
        raise(ArgumentError, "invalid color index: #{index}") unless index >= 0 && index < 256
        @index = index
        super()
      end

      sig { returns(Integer) }
      attr_reader(:index)

      sig { params(other: T.untyped).returns(T::Boolean) }
      def ==(other)
        self.class == other.class && index == other.index
      end

      sig { override.returns(String) }
      def hex
        T.must(PALETTE[@index]) # verified in initialize
      end

      sig { override.returns(String) }
      def sequence_fg
        "38;5;#{@index}"
      end

      sig { override.returns(String) }
      def sequence_bg
        "48;5;#{@index}"
      end

      sig { override.returns(RGBColor) }
      def to_rgb
        Color.from_hex(hex)
      end
    end
  end
end
