# typed: strict
# frozen_string_literal: true
require('tui')

module TUI
  class Color
    class ANSIColor < Color
      extend(T::Sig)

      FOREGROUND = 30
      BACKGROUND = 40
      BRIGHT = 60

      sig { params(index: Integer).void }
      def initialize(index)
        raise(ArgumentError, "invalid color index: #{index}") unless index >= 0 && index < 16
        @index = index
        super()
      end

      sig { returns(Integer) }
      attr_reader(:index)

      sig { params(other: T.untyped).returns(T::Boolean) }
      def ==(other)
        self.class == other.class && index == other.index
      end

      sig { override.returns(ANSIColor) }
      def to_ansi
        self
      end

      sig { override.returns(ANSI256Color) }
      def to_ansi256
        # we could try to cast into the higher space and stay out of the bottom
        # 16, but I think this is probably the most appropriate behaviour?
        ANSI256Color.new(@index)
      end

      sig { override.returns(String) }
      def hex
        T.must(PALETTE[@index]) # verified in initialize
      end

      sig { override.returns(String) }
      def sequence_fg
        if @index < 8
          (FOREGROUND + @index).to_s
        else
          (FOREGROUND + BRIGHT + @index - 8).to_s
        end
      end

      sig { override.returns(String) }
      def sequence_bg
        if @index < 8
          (BACKGROUND + @index).to_s
        else
          (BACKGROUND + BRIGHT + @index - 8).to_s
        end
      end

      sig { override.returns(RGBColor) }
      def to_rgb
        Color.from_hex(hex)
      end

      BLACK          = T.let(new(0), ANSIColor)
      RED            = T.let(new(1), ANSIColor)
      GREEN          = T.let(new(2), ANSIColor)
      YELLOW         = T.let(new(3), ANSIColor)
      BLUE           = T.let(new(4), ANSIColor)
      MAGENTA        = T.let(new(5), ANSIColor)
      CYAN           = T.let(new(6), ANSIColor)
      WHITE          = T.let(new(7), ANSIColor)
      BRIGHT_BLACK   = T.let(new(8), ANSIColor)
      BRIGHT_RED     = T.let(new(9), ANSIColor)
      BRIGHT_GREEN   = T.let(new(10), ANSIColor)
      BRIGHT_YELLOW  = T.let(new(11), ANSIColor)
      BRIGHT_BLUE    = T.let(new(12), ANSIColor)
      BRIGHT_MAGENTA = T.let(new(13), ANSIColor)
      BRIGHT_CYAN    = T.let(new(14), ANSIColor)
      BRIGHT_WHITE   = T.let(new(15), ANSIColor)
    end
  end
end
