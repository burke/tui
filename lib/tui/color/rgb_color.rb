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

      # termenv uses HSLuv distance, but converting to HSLuv is fairly
      # expensive (and couldn't get code working properly for it after a few
      # hours of effort)
      #
      # This is is a color distance algorithm developed by Thiadmer Riemersma.
      # It uses RGB coordinates, but he claims it has similar results to
      # CIELUV. This makes it both fast and accurate.
      sig { params(other: RGBColor).returns(Float) }
      def distance(other)
        r_avg = r + other.r / 2.0
        d_r = r - other.r
        d_g = g - other.g
        d_b = b - other.b
        Math.sqrt((2 + r_avg) * (d_r**2) + 4 * (d_g**2) + (2 + (1 - r_avg)) * (d_b**2))
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
