# typed: strict
# frozen_string_literal: true
require('tui')

module TUI
  class Color
    class Adaptive < Color
      extend(T::Sig)

      sig { returns(Color) }
      attr_reader(:light)

      sig { returns(Color) }
      attr_reader(:dark)

      sig { params(light: Color, dark: Color).void }
      def initialize(light:, dark:)
        @light = light
        @dark = dark
        super()
      end

      sig { returns(Color) }
      def resolve
        return(@resolved) if @resolved
        res = if Term.dark_background?
          @dark
        else
          @light
        end
        @resolved = T.let(res, T.nilable(Color))
        res
      end

      sig { params(other: T.untyped).returns(T::Boolean) }
      def ==(other)
        self.class == other.class && light == other.light && dark == other.dark
      end

      sig { override.returns(String) }
      def hex
        resolve.hex
      end

      sig { override.returns(String) }
      def sequence_fg
        resolve.sequence_fg
      end

      sig { override.returns(String) }
      def sequence_bg
        resolve.sequence_bg
      end

      sig { override.returns(RGBColor) }
      def to_rgb
        resolve.to_rgb
      end

      sig { override.returns(ANSI256Color) }
      def to_ansi256
        resolve.to_ansi256
      end

      sig { override.returns(ANSIColor) }
      def to_ansi
        resolve.to_ansi
      end
    end
  end
end
