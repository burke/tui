# typed: true
# frozen_string_literal: true
require('tui')

module TUI
  class Color
    # copied from https://github.com/hsluv/hsluv-ruby (which is under MIT license)
    # with some modification.
    module HSLuv
      extend(self)

      M = [
        [3.240969941904521, -1.537383177570093, -0.498610760293],
        [-0.96924363628087, 1.87596750150772, 0.041555057407175],
        [0.055630079696993, -0.20397695888897, 1.056971514242878],
      ]

      M_INV = [
        [0.41239079926595, 0.35758433938387, 0.18048078840183],
        [0.21263900587151, 0.71516867876775, 0.072192315360733],
        [0.019330818715591, 0.11919477979462, 0.95053215224966],
      ]

      REF_Y = 1.0
      REF_Z = 1.089057750759878
      REF_U = 0.19783000664283
      REF_V = 0.46831999493879
      KAPPA = 903.2962962
      EPSILON = 0.0088564516

      def rgb_to_hsluv(r, g, b)
        l, c, h = rgb_to_lch(r, g, b)
        lch_to_hsluv(l, c, h)
      end

      def hex_to_hsluv(hex)
        r, g, b = hex_to_rgb(hex)
        rgb_to_hsluv(r, g, b)
      end

      def rgb_to_lch(r, g, b)
        x, y, z = rgb_to_xyz(r, g, b)
        l, u, v = xyz_to_luv(x, y, z)
        luv_to_lch(l, u, v)
      end

      def hex_to_rgb(hex)
        hex = hex.tr('#', '')
        [].tap { |arr| hex.split('').each_slice(2) { |block| arr << block.join.to_i(16) / 255.0 } }
      end

      def rgb_to_xyz(x, y, z)
        rgbl = [x, y, z].map { |val| to_linear(val) }
        M_INV.map { |i| dot_product(i, rgbl) }
      end

      def xyz_to_luv(x, y, z)
        l = f(y)

        return [0.0, 0.0, 0.0] if [x, y, z, 0.0].uniq.length == 1 || l == 0.0

        var_u = (4.0 * x) / (x + (15.0 * y) + (3.0 * z))
        var_v = (9.0 * y) / (x + (15.0 * y) + (3.0 * z))
        u = 13.0 * l * (var_u - REF_U)
        v = 13.0 * l * (var_v - REF_V)

        [l, u, v]
      end

      def luv_to_lch(l, u, v)
        c = ((u**2) + (v**2))**(1 / 2.0)
        hrad = Math.atan2(v, u)
        h = radians_to_degrees(hrad)
        h += 360.0 if h < 0.0
        [l, c, h]
      end

      def lch_to_hsluv(l, c, h)
        return [h, 0.0, 100.0] if l > 99.9999999
        return [h, 0.0, 0.0] if l < 0.00000001

        s = c / max_chroma(l, h) * 100.0

        [h, s, l]
      end

      def radians_to_degrees(rad)
        rad * 180.0 / Math::PI
      end

      def max_chroma(l, h)
        hrad = h / 360.0 * Math::PI * 2.0
        lengths = []

        get_bounds(l).each do |line|
          l = length_of_ray_until_intersect(hrad, line)
          lengths << l if l
        end

        lengths.min
      end

      def get_bounds(l)
        sub1 = ((l + 16.0)**3.0) / 1560896.0
        sub2 = sub1 > EPSILON ? sub1 : l / KAPPA
        ret = []

        M.each do |m1, m2, m3|
          [0, 1].each do |t|
            top1 = (284517.0 * m1 - 94839.0 * m3) * sub2
            top2 = (838422.0 * m3 + 769860.0 * m2 + 731718.0 * m1) * l * sub2 - 769860.0 * t * l
            bottom = (632260.0 * m3 - 126452.0 * m2) * sub2 + 126452.0 * t
            ret << [top1 / bottom, top2 / bottom]
          end
        end

        ret
      end

      def length_of_ray_until_intersect(theta, line)
        m1, b1 = line
        length = b1 / (Math.sin(theta) - m1 * Math.cos(theta))
        return nil if length < 0
        length
      end

      def f(t)
        t > EPSILON ? 116 * ((t / REF_Y)**(1.0 / 3.0)) - 16.0 : t / REF_Y * KAPPA
      end

      def to_linear(c)
        c > 0.04045 ? ((c + 0.055) / 1.055)**2.4 : c / 12.92
      end

      def dot_product(a, b)
        a.zip(b).map { |i, j| i * j }.inject(:+)
      end
    end
  end
end
