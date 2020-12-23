# frozen_string_literal: true

source "https://rubygems.org"
gemspec

unless ENV["CI"]
  gem "byebug", require: false, platforms: :mri
  gem "yard", require: false
end

gem "hanami-utils",       "~> 2.0.alpha", git: "https://github.com/hanami/utils.git",       branch: "unstable"
gem "hanami-validations", "~> 2.0.alpha", git: "https://github.com/hanami/validations.git", branch: "unstable"
gem "hanami-controller",  "~> 2.0.alpha", git: "https://github.com/hanami/controller.git",  branch: "unstable"
gem "hanami-view",        "~> 2.0.alpha", git: "https://github.com/hanami/view.git",        branch: "feature/custom-anonymous-scope" # rubocop:disable Layout/LineLength
gem "erbse"

gem "hanami-devtools", git: "https://github.com/hanami/devtools.git", require: false
