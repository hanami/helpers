source 'https://rubygems.org'
gemspec

unless ENV['TRAVIS']
  gem 'byebug', require: false, platforms: :mri
  gem 'pry-debugger-jruby', require: false, platforms: :jruby
  gem 'yard', require: false
end

gem 'hanami-utils',       '~> 1.1', git: 'https://github.com/hanami/utils.git',       branch: '1.1.x'
gem 'hanami-validations', '~> 1.1', git: 'https://github.com/hanami/validations.git', branch: '1.1.x'
gem 'hanami-controller',  '~> 1.1', git: 'https://github.com/hanami/controller.git',  branch: '1.1.x'
gem 'hanami-view',        '~> 1.1', git: 'https://github.com/hanami/view.git',        branch: '1.1.x'

gem 'hanami-devtools', git: 'https://github.com/hanami/devtools.git', require: false
gem 'coveralls', require: false
