# typed: false
# frozen_string_literal: true
require('tui')

module TUI
  module Profile
    module ANSI256
      extend(T::Sig)
      extend(Profile)

      sig { override.params(c: TUI::Color).returns(TUI::Color) }
      def self.convert(c)
        Color.new(0.0, 0.0, 0.0) # TODO
      end

      sig { override.params(s: String).returns(TUI::Color) }
      def self.color(s)
        Color.new(0.0, 0.0, 0.0) # TODO
      end

      sig { override.params(c: TUI::Color).returns(TUI::Color) }
      def self.from_color(c)
        Color.new(0.0, 0.0, 0.0) # TODO
      end
    end
  end
end
