# typed: strict
# frozen_string_literal: true
require('tui')

module TUI
  module ColorProfile
    module ASCII
      extend(T::Sig)
      extend(ColorProfile)

      sig { override.params(c: TUI::Color).returns(NilClass) }
      def self.convert(c)
        nil
      end

      sig { override.params(spec: String).returns(NilClass) }
      def self.color(spec)
        nil
      end
    end
  end
end
