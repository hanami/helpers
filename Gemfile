source 'https://rubygems.org'
gemspec

unless ENV['TRAVIS']
  gem 'byebug', require: false, platforms: :mri
  gem 'yard',   require: false
end

gem 'hanami-utils',       '~> 0.8', github: 'hanami/utils',       branch: '0.8.x'
gem 'hanami-validations', '~> 0.6', github: 'hanami/validations', branch: '0.6.x'
gem 'hanami-controller',  '~> 0.7', github: 'hanami/controller',  branch: '0.7.x'
gem 'hanami-view',        '~> 0.7', github: 'hanami/view',        branch: '0.7.x'

gem 'coveralls', require: false
