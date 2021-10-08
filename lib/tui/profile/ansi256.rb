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
        c.to_ansi256
      end

      sig { override.params(hex: String).returns(Color::ANSI256Color) }
      def self.color(hex)
        convert(Color.from_hex(hex))
      end
    end
  end
end
