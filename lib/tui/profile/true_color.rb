# typed: strict
# frozen_string_literal: true
require('tui')

module TUI
  module Profile
    module TrueColor
      extend(T::Sig)
      extend(Profile)

      sig { override.params(c: TUI::Color).returns(Color::RGBColor) }
      def self.convert(c)
        c.to_rgb
      end

      sig { override.params(hex: String).returns(Color::RGBColor) }
      def self.color(hex)
        convert(Color.from_hex(hex))
      end
    end
  end
end
