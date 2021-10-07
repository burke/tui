# typed: strict
# frozen_string_literal: true
require('tui')

module TUI
  module Profile
    module ANSI256
      extend(T::Sig)
      extend(Profile)

      sig { override.params(c: Color).returns(Color::ANSI256Color) }
      def self.convert(c)
        Color::ANSI256Color.new(0)
      end

      sig { override.params(s: String).returns(Color::ANSI256Color) }
      def self.color(s)
        Color::ANSI256Color.new(0)
      end
    end
  end
end
