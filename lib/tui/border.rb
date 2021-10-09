# typed: strict
# frozen_string_literal: true
require('tui')
require('unicode/display_width')

module TUI
  class Border
    extend(T::Sig)

    sig do
      params(
        top: T.nilable(String),
        bottom: T.nilable(String),
        left: T.nilable(String),
        right: T.nilable(String),
        top_left: T.nilable(String),
        top_right: T.nilable(String),
        bottom_left: T.nilable(String),
        bottom_right: T.nilable(String)
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

    NONE = new(
      top:          nil,
      bottom:       nil,
      left:         nil,
      right:        nil,
      top_left:     nil,
      top_right:    nil,
      bottom_left:  nil,
      bottom_right: nil,
    )

    NORMAL = new(
      top:          '─',
      bottom:       '─',
      left:         '│',
      right:        '│',
      top_left:     '┌',
      top_right:    '┐',
      bottom_left:  '└',
      bottom_right: '┘',
    )

    ROUNDED = new(
      top:          '─',
      bottom:       '─',
      left:         '│',
      right:        '│',
      top_left:     '╭',
      top_right:    '╮',
      bottom_left:  '╰',
      bottom_right: '╯',
    )

    THICK = new(
      top:          '━',
      bottom:       '━',
      left:         '┃',
      right:        '┃',
      top_left:     '┏',
      top_right:    '┓',
      bottom_left:  '┗',
      bottom_right: '┛',
    )

    DOUBLE = new(
      top:          '═',
      bottom:       '═',
      left:         '║',
      right:        '║',
      top_left:     '╔',
      top_right:    '╗',
      bottom_left:  '╚',
      bottom_right: '╝',
    )

    HIDDEN = new(
      top:          ' ',
      bottom:       ' ',
      left:         ' ',
      right:        ' ',
      top_left:     ' ',
      top_right:    ' ',
      bottom_left:  ' ',
      bottom_right: ' ',
    )
  end
end
