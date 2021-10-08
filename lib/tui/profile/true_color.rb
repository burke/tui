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

      sig { override.params(spec: String).returns(Color::RGBColor) }
      def self.color(spec)
        convert(Color[spec])
      end
    end
  end
end
