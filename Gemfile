# frozen_string_literal: true

source "https://rubygems.org"
gemspec

unless ENV["CI"]
  gem "byebug", require: false, platforms: :mri
  gem "yard", require: false
  gem "benchmark-ips", require: false
end

gem "dry-core", git: "http://github.com/dry-rb/dry-core", branch: "feature/basic-object"
gem "erbse"

gem "hanami-utils",       "~> 2.0.alpha", git: "https://github.com/hanami/utils.git",       branch: "main"
gem "hanami-validations", "~> 2.0.alpha", git: "https://github.com/hanami/validations.git", branch: "main"
gem "hanami-controller",  "~> 2.0.alpha", git: "https://github.com/hanami/controller.git",  branch: "main"
gem "hanami-view",        "~> 2.0.alpha", git: "https://github.com/hanami/view.git",        branch: "main"

gem "hanami-devtools", git: "https://github.com/hanami/devtools.git", branch: "main", require: false
