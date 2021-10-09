# typed: strict
# frozen_string_literal: true
require('tui')

module TUI
  module ColorProfile
    module ANSI256
      extend(T::Sig)
      extend(ColorProfile)

      sig { override.params(c: Color).returns(Color::ANSI256Color) }
      def self.convert(c)
        c.to_ansi256
      end

      sig { override.params(spec: String).returns(Color::ANSI256Color) }
      def self.color(spec)
        convert(Color[spec])
      end
    end
  end
end
