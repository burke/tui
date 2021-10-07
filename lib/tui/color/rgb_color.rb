# typed: strict
# frozen_string_literal: true
require('tui')

module TUI
  class Color
    class RGBColor < Color
      extend(T::Sig)

      sig { returns(Float) }
      attr_reader(:r)
      sig { returns(Float) }
      attr_reader(:g)
      sig { returns(Float) }
      attr_reader(:b)

      sig { params(r: Float, g: Float, b: Float).void }
      def initialize(r, g, b)
        if r < 0.0 || r > 1.0 || g < 0.0 || g > 1.0 || b < 0.0 || b > 1.0
          raise(ArgumentError, 'component out of bounds (0.0 .. 1.0)')
        end
        @r = r
        @g = g
        @b = b
        super()
      end

      sig { params(other: T.untyped).returns(T::Boolean) }
      def ==(other)
        self.class == other.class && r == other.r && g == other.g && b == other.b
      end

      sig { override.returns(String) }
      def hex
        unpacked = [@r, @g, @b]        # [0.0, 1.0, 0.4]
          .map { |v| (v * 255).round } # [0, 255, 102]
          .map(&:chr).join             # "\x00\xFFf"
          .unpack('H*')                # ["00ff66"]
        el = T.must(T.cast(unpacked, T::Array[String]).first) # "00ff66"
        el.prepend('#') # "#00ff66"
      end

      sig { override.returns(String) }
      def sequence_fg
        sequence('38')
      end

      sig { override.returns(String) }
      def sequence_bg
        sequence('48')
      end

      sig { override.returns(RGBColor) }
      def to_rgb
        self
      end

      private

      sig { params(prefix: String).returns(String) }
      def sequence(prefix)
        format(
          '%s;2;%d;%d;%d', prefix,
          (@r * 255).round, (@g * 255).round, (@b * 255).round,
        )
      end
    end
  end
end
