# typed: strict
# frozen_string_literal: true
require('tui')

module TUI
  module Color
    class NoColor
      extend(T::Sig)
      extend(Color)
    end
  end
end
