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

  spec.files         = `git ls-files -- lib/* CHANGELOG.md LICENSE.md README.md hanami-helpers.gemspec`.split($/)

  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.required_ruby_version = ">= 3.0"

  spec.add_dependency "hanami-utils", "~> 2.0.alpha"
  spec.add_dependency "escape_utils", "~> 1.2"
  spec.add_dependency "temple", "~> 0.8"
  spec.add_dependency "dry-types", "~> 1.5"
  spec.add_dependency "dry-core", "~> 0.7"

  spec.add_development_dependency "bundler",    ">= 1.6", "< 3"
  spec.add_development_dependency "dry-struct", "~> 1.1"
  spec.add_development_dependency "rake",       "~> 13"
  spec.add_development_dependency "rspec",      "~> 3.9"
  spec.add_development_dependency "rubocop",    "~> 1.0"
  spec.add_development_dependency "erbse",      "~> 0.1"
  spec.add_development_dependency "slim",       "~> 4.1"
end
