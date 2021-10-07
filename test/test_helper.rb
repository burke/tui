# frozen_string_literal: true
# typed: strict
addpath = ->(p) do
  path = File.expand_path("../../#{p}", __FILE__)
  $LOAD_PATH.unshift(path) unless $LOAD_PATH.include?(path)
end
addpath.call('lib')

require('rubygems')
require('bundler/setup')
require('sorbet-runtime')

require('simplecov')
SimpleCov.start do
  # SimpleCov uses a "creative" DSL here with block rebinding.
  # Sorbet doesn't like it.
  T.unsafe(self).add_filter('/test/')
end

require('tui')
require('byebug')
require('minitest/autorun')
require('minitest/unit')
require('mocha/minitest')
