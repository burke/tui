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
          raise(ArgumentError, "component out of bounds in (#{r},#{g},#{b})")
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

      # like with distance, there are better ways to do this, but this is good
      # enough for now.
      sig { returns(Float) }
      def luminance
        Math.sqrt(0.299 * r**2 + 0.587 * g**2 + 0.114 * b**2)
      end

      sig { params(v: Float).returns(Integer) }
      def v2ci(v)
        v *= 255.0
        return(0) if v < 48.0
        return(1) if v < 115.0
        ((v - 35.0) / 40.0).to_i
      end

      # gray values are [8, 18, 28, 38, ..., 238]
      # There are 24 of them. They start at 8, and go up by 10, stopping at
      # 238.
      sig { params(v: Float).returns(Integer) }
      def v2gi(v) # 0.0 .. 1.0
        v *= 255.0
        gi = (v - 8.0) / 10.0
        [23, [0, gi.round].max].min
      end

      sig { override.returns(ANSI256Color) }
      def to_ansi256
        # Calculate the nearest 0-based color index at 16..231
        r = v2ci(@r) # 0..5 each
        g = v2ci(@g)
        b = v2ci(@b)
        ci = 36 * r + 6 * g + b # 0..215

        # Calculate the represented colors back from the index
        i2cv = [0, 0x5f, 0x87, 0xaf, 0xd7, 0xff]
        cr = T.must(i2cv[r]) # r/g/b, 0..255 each
        cg = T.must(i2cv[g])
        cb = T.must(i2cv[b])

        rg = v2gi(@r) # 0..23
        gg = v2gi(@g)
        bg = v2gi(@b)

        # Calculate the nearest 0-based gray index at 232..255
        average = (rg + gg + bg) / 3.0
        gray_idx = average.round
        gv = 8 + 10 * gray_idx # same value for r/g/b, 0..255

        # Return the one which is nearer to the original input rgb value
        c2 = RGBColor.new(cr / 255.0, cg / 255.0, cb / 255.0)
        g2 = RGBColor.new(gv / 255.0, gv / 255.0, gv / 255.0)
        color_dist = distance(c2)
        gray_dist = distance(g2)

        if color_dist <= gray_dist
          ANSI256Color.new(16 + ci)
        else
          ANSI256Color.new(232 + gray_idx)
        end
      end

      sig { override.returns(ANSIColor) }
      def to_ansi
        # TODO: test this better
        index = T.must(16.times.min_by { |i| distance(ANSIColor.new(i).to_rgb) })
        ANSIColor.new(index)
      end

      # termenv uses HSLuv distance, but converting to HSLuv is fairly
      # expensive (and I couldn't get code working properly for it after a few
      # hours of effort). Replacing this code with HSLuv distance would
      # probably be an improvement as long as it's not unreasonably expensive.
      #
      # This is is a color distance algorithm developed by Thiadmer Riemersma.
      # It uses RGB coordinates, but he claims it has similar results to
      # CIELUV. This makes it dramatically faster than HSLuv while still being
      # reasonably perceptually accurate.
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
