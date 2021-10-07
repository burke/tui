# typed: strict
# frozen_string_literal: true
require('tui')

module TUI
  class Color
    extend(T::Sig)

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

      Color.new(rgb[0], rgb[1], rgb[2])
    end

    sig { returns(String) }
    def hex
      [@r, @g, @b]                   # [0.0, 1.0, 0.4]
        .map { |v| (v * 255).round } # [0, 255, 102]
        .map(&:chr).join             # "\x00\xFFf"
        .unpack('H*')                # ["00ff66"]
        .first                       # "00ff66"
        .prepend('#')                # "#00ff66"
    end

    sig { params(r: Float, g: Float, b: Float).void }
    def initialize(r, g, b)
      @r = r
      @g = g
      @b = b
    end
  end
end
