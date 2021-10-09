# typed: strict
# frozen_string_literal: true
require('tui')

module TUI
  module ColorProfile
    module TrueColor
      extend(T::Sig)
      extend(ColorProfile)

      sig { override.params(c: TUI::Color).returns(Color::RGB) }
      def self.convert(c)
        c.to_rgb
      end

      sig { override.params(spec: String).returns(Color::RGB) }
      def self.color(spec)
        convert(Color[spec])
      end
    end
  end
end
