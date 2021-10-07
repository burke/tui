# typed: ignore
# frozen_string_literal: true
require('tui')

module TUI
  module Color
    extend(T::Sig)

    autoload(:ANSI256Color, 'tui/color/ansi256_color')
    autoload(:ANSIColor,    'tui/color/ansi_color')
    autoload(:Base,         'tui/color/base')
    autoload(:NoColor,      'tui/color/no_color')
    autoload(:RGBColor,     'tui/color/rgb_color')

    sig { params(hex: String).returns(Color) }
    def self.from_hex(hex)
      unless hex.match?(/\A#[0-9a-fA-F]{6}\z/)
        raise(ArgumentError, "invalid hex color: #{hex.inspect}")
      end

      hex = hex.sub(/^#/, '')
      rgb = [hex]              # ["00ff66"]
        .pack('H*')            # "\x00\xFFf"
        .each_byte.to_a        # [0, 255, 102]
        .map { |b| b / 255.0 } # [0.0, 1.0, 0.4]

      RGBColor.new(rgb[0], rgb[1], rgb[2])
    end

    # sig { returns(String) }
    # def hex
    #   unpacked = T.cast([@r, @g, @b] # [0.0, 1.0, 0.4]
    #     .map { |v| (v * 255).round } # [0, 255, 102]
    #     .map(&:chr).join             # "\x00\xFFf"
    #     .unpack('H*'),               # ["00ff66"]
    #   T::Array[String])
    #   T.must(unpacked.first).prepend('#') # "#00ff66"
    # end

    # sig { params(r: Float, g: Float, b: Float).void }
    # def initialize(r, g, b)
    #   @r = r
    #   @g = g
    #   @b = b
    # end
  end
end
