# typed: strict
# frozen_string_literal: true
require('tui')

module TUI
  module Profile
    module ANSI
      extend(T::Sig)
      extend(Profile)

      sig { override.params(c: Color).returns(Color) }
      def self.convert(c)
        c
        # case c
        # when Color::NoColor
        #   c
        # when Color::ANSIColor
        #   c
        # when Color::ANSI256Color
        #   # c.to_ansi
        #   c
        # when Color::RGBColor
        #   # c.to_ansi
        #   c
        # end
      end

      sig { override.params(s: String).returns(Color) }
      def self.color(s)
        Color::ANSIColor.new(0)
      end
    end
  end
end
