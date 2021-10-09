# typed: strict
# frozen_string_literal: true
require('tui')

module TUI
  module Border
    extend(T::Sig)

    sig do
      params(
        top: String, bottom: String, left: String, right: String, top_left:
        String, top_right: String, bottom_left: String, bottom_right: String
      ).void
    end
    def initialize(
      top:, bottom:, left:, right:, top_left:, top_right:,
      bottom_left:, bottom_right:
    )
      @top = top
      @bottom = bottom
      @left = left
      @right = right
      @top_left = top_left
      @top_right = top_right
      @bottom_left = bottom_left
      @bottom_right = bottom_right
    end
  end
end
