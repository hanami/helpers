# frozen_string_literal: true

source "https://rubygems.org"
gemspec

unless ENV["CI"]
  gem "byebug", require: false, platforms: :mri
  gem "yard", require: false
end

gem "hanami-utils",       "~> 1.3", git: "https://github.com/hanami/utils.git", branch: "develop"
gem "hanami-validations", "~> 2.0.alpha", git: "https://github.com/hanami/validations.git", branch: "unstable"
gem "hanami-controller",  "~> 1.3", git: "https://github.com/hanami/controller.git",  branch: "develop"
gem "hanami-view",        "~> 1.3", git: "https://github.com/hanami/view.git",        branch: "1.x-master"

gem "hanami-devtools", git: "https://github.com/hanami/devtools.git", require: false
