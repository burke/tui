# typed: false
# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require('tui/version')

Gem::Specification.new do |spec|
  spec.name          = 'tui'
  spec.version       = TUI::VERSION
  spec.authors       = ['Burke Libbey']
  spec.email         = ['burke.libbey@shopify.com']
  spec.license       = 'MIT'

  spec.summary       = 'TUI libraries'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/burke/tui'

  spec.metadata['bug_tracker_uri']   = 'https://github.com/Shopify/tui/issues'
  spec.metadata['source_code_uri']   = 'https://github.com/Shopify/tui'
  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.files = %x(git ls-files -z ext lib).split("\x0") + %w(LICENSE README.md)
  spec.require_paths = %w(lib)

  spec.required_ruby_version = '>= 2.6.0'

  spec.add_runtime_dependency('sorbet-runtime', '~> 0.5.9155')
end
