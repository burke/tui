# typed: strict
# frozen_string_literal: true
require('tui')
require('tui/color/iface')

module TUI
  module Color
    class ANSIColor < Color::Base
      extend(T::Sig)

      sig { params(n: Integer).void }
      def initialize(n)
        raise(ArgumentError, "invalid color index: #{n}") unless n >= 0 && n < 16
        @n = n
      end

      sig { override.returns(String) }
      def to_s
        T.must(PALETTE[@n]) # verified in initialize
      end

      sig { override.returns(String) }
      def sequence_fg
        'wtf'
      end

      sig { override.returns(String) }
      def sequence_bg
        ''
      end

      PALETTE = T.let(%w(
        #000000 #800000 #008000 #808000 #000080 #800080 #008080 #c0c0c0
        #808080 #ff0000 #00ff00 #ffff00 #0000ff #ff00ff #00ffff #ffffff
      ).freeze, T::Array[String])
    end

    # class ANSIColor
    #   BLACK          = T.let(new(0), ANSIColor)
    #   RED            = T.let(new(1), ANSIColor)
    #   GREEN          = T.let(new(2), ANSIColor)
    #   YELLOW         = T.let(new(3), ANSIColor)
    #   BLUE           = T.let(new(4), ANSIColor)
    #   MAGENTA        = T.let(new(5), ANSIColor)
    #   CYAN           = T.let(new(6), ANSIColor)
    #   WHITE          = T.let(new(7), ANSIColor)
    #   BRIGHT_BLACK   = T.let(new(8), ANSIColor)
    #   BRIGHT_RED     = T.let(new(9), ANSIColor)
    #   BRIGHT_GREEN   = T.let(new(10), ANSIColor)
    #   BRIGHT_YELLOW  = T.let(new(11), ANSIColor)
    #   BRIGHT_BLUE    = T.let(new(12), ANSIColor)
    #   BRIGHT_MAGENTA = T.let(new(13), ANSIColor)
    #   BRIGHT_CYAN    = T.let(new(14), ANSIColor)
    #   BRIGHT_WHITE   = T.let(new(15), ANSIColor)
    # end
  end
end
