# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "hanami/helpers/version"

Gem::Specification.new do |spec|
  spec.name          = "hanami-helpers"
  spec.version       = Hanami::Helpers::VERSION
  spec.authors       = ["Luca Guidi"]
  spec.email         = ["me@lucaguidi.com"]
  spec.summary       = "Hanami helpers"
  spec.description   = "View helpers for Ruby applications"
  spec.homepage      = "http://hanamirb.org"
  spec.license       = "MIT"

  spec.files         = `git ls-files -- lib/* CHANGELOG.md LICENSE.md README.md hanami-helpers.gemspec`.split($/) # rubocop:disable Style/SpecialGlobalVars

  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 2.5.0"

  spec.add_dependency "hanami-utils", "~> 2.0.alpha"

  spec.add_development_dependency "bundler",    ">= 1.6", "< 3"
  spec.add_development_dependency "dry-struct", "~> 1.1"
  spec.add_development_dependency "rake",       "~> 12"
  spec.add_development_dependency "rspec",      "~> 3.7"
end
