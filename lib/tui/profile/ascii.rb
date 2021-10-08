# typed: strict
# frozen_string_literal: true
require('tui')

module TUI
  module Profile
    module ASCII
      extend(T::Sig)
      extend(Profile)

      sig { override.params(c: TUI::Color).returns(TUI::Color::NoColor) }
      def self.convert(c)
        Color::NoColor.new
      end

      sig { override.params(hex: String).returns(TUI::Color::NoColor) }
      def self.color(hex)
        Color::NoColor.new
      end
    end
  end
end
