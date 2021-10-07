# typed: strict
# frozen_string_literal: true
require('tui')

module TUI
  class Color
    class NoColor < Color
      extend(T::Sig)

      sig { override.returns(String) }
      def hex
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

      sig { override.returns(NoColor) }
      def to_rgb
        self
      end
    end
  end
end
