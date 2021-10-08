# frozen_string_literal: true
source('https://rubygems.org')

gemspec

group(:development, :test) do
  gem('rake')
  gem('rubocop')
  gem('rubocop-rake')
  gem('rubocop-shopify')
  gem('byebug')
  gem('sorbet')
  gem('simplecov')
  gem('tapioca', require: false)
end

group(:test) do
  gem('mocha', '~> 1.12.0', require: false)
  gem('minitest', '>= 5.0.0', require: false)
  gem('minitest-reporters', require: false)
end
