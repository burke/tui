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
        Color::RGBColor.new(0.0, 0.0, 0.0) # TODO
      end

      sig { override.params(s: String).returns(Color::RGBColor) }
      def self.color(s)
        Color::RGBColor.new(0.0, 0.0, 0.0) # TODO
      end

      sig { override.params(c: TUI::Color).returns(Color::RGBColor) }
      def self.from_color(c)
        Color::RGBColor.new(0.0, 0.0, 0.0) # TODO
      end
    end
  end
end
