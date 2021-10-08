# typed: strict
# frozen_string_literal: true
require('tui')

module TUI
  module Profile
    module ASCII
      extend(T::Sig)
      extend(Profile)

      sig { override.params(c: TUI::Color).returns(NilClass) }
      def self.convert(c)
        nil
      end

      sig { override.params(hex: String).returns(NilClass) }
      def self.color(hex)
        nil
      end
    end
  end
end
