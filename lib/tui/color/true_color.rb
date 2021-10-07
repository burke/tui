# typed: strict
# frozen_string_literal: true
require('tui')

module TUI
  module Color
    class TrueColor
      extend(T::Sig)
      extend(Color)

      sig { override.returns(String) }
      def to_s
        ''
      end

      sig { override.returns(String) }
      def sequence_fg
        ''
      end

      sig { override.returns(String) }
      def sequence_bg
        ''
      end
    end
  end
end
