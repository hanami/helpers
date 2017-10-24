source 'https://rubygems.org'
gemspec

unless ENV['TRAVIS']
  gem 'byebug', require: false, platforms: :mri
  gem 'yard',   require: false
end

gem 'hanami-utils',       '~> 1.1', git: 'https://github.com/hanami/utils.git',       branch: 'develop'
gem 'hanami-validations', '~> 1.1', git: 'https://github.com/hanami/validations.git', branch: 'develop'
gem 'hanami-controller',  '~> 1.1', git: 'https://github.com/hanami/controller.git',  branch: 'develop'
gem 'hanami-view',        '~> 1.1', git: 'https://github.com/hanami/view.git',        branch: 'develop'

gem 'hanami-devtools', git: 'https://github.com/hanami/devtools.git', require: false
gem 'coveralls', require: false
