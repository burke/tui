# frozen_string_literal: true
# typed: strict

require('sorbet-runtime')

module TUI
  Error = Class.new(StandardError)
  ROOT = T.let(File.expand_path('..', __dir__), String)

  autoload(:Color, 'tui/color')
  autoload(:Term,  'tui/term')
end
