# typed: strict
# frozen_string_literal: true
require('tui')

module TUI
  module ColorProfile
    module ANSI
      extend(T::Sig)
      extend(ColorProfile)

      sig { override.params(c: Color).returns(Color::ANSIColor) }
      def self.convert(c)
        c.to_ansi
      end

      sig { override.params(spec: String).returns(Color::ANSIColor) }
      def self.color(spec)
        convert(Color[spec])
      end
    end
  end
end
