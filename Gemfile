source 'https://rubygems.org'
gemspec


unless ENV['TRAVIS']
  gem 'byebug', require: false, platforms: :mri
  gem 'yard',   require: false
end

gem 'lotus-utils',       '~> 0.6', github: 'lotus/utils',       branch: '0.6.x'
gem 'lotus-validations', '~> 0.3', github: 'lotus/validations', branch: '0.3.x'
gem 'lotus-controller',  '~> 0.5', github: 'lotus/controller',  branch: '0.5.x'
gem 'lotus-view',        '~> 0.5', github: 'lotus/view',        branch: '0.5.x'

gem 'simplecov', require: false
gem 'coveralls', require: false
