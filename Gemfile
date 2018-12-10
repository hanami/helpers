source 'https://rubygems.org'
gemspec

unless ENV['CI']
  gem 'byebug', require: false, platforms: :mri
  gem 'pry-debugger-jruby', require: false, platforms: :jruby
  gem 'yard', require: false
end

gem 'hanami-utils',       '~> 1.3', git: 'https://github.com/hanami/utils.git',       branch: 'develop'
gem 'hanami-validations', '~> 1.3', git: 'https://github.com/hanami/validations.git', branch: 'develop'
gem 'hanami-controller',  '~> 1.3', git: 'https://github.com/hanami/controller.git',  branch: 'develop'
gem 'hanami-view',        '~> 1.3', git: 'https://github.com/hanami/view.git',        branch: 'develop'

gem 'hanami-devtools', git: 'https://github.com/hanami/devtools.git', require: false
