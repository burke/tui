# typed: strict
# frozen_string_literal: true
require('tui')

module TUI
  module Profile
    module ANSI
      extend(T::Sig)
      extend(Profile)

      sig { override.params(c: Color).returns(Color::ANSIColor) }
      def self.convert(c)
        Color::ANSIColor.new(0)
      end

      sig { override.params(s: String).returns(Color::ANSIColor) }
      def self.color(s)
        Color::ANSIColor.new(0)
      end

      sig { override.params(c: TUI::Color).returns(Color::ANSIColor) }
      def self.from_color(c)
        Color::ANSIColor.new(0)
      end
    end
  end
end
