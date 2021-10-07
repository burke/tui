# typed: strict
# frozen_string_literal: true
require('tui')

module TUI
  module Color
    class Base
      extend(T::Sig)
      extend(T::Helpers)
      abstract!

      sig { abstract.returns(String) }
      def hex; end

      sig { abstract.returns(String) }
      def sequence_fg; end

      sig { abstract.returns(String) }
      def sequence_bg; end
    end
  end
end
