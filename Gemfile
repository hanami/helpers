source 'https://rubygems.org'
gemspec


unless ENV['TRAVIS']
  gem 'byebug', require: false, platforms: :mri
  gem 'yard',   require: false
end

gem 'lotus-utils',      github: 'lotus/utils',      branch: '0.4.x'
gem 'lotus-controller', github: 'lotus/controller', branch: '0.4.x'
gem 'lotus-view',       github: 'lotus/view',       branch: '0.4.x'

gem 'simplecov', require: false
gem 'coveralls', require: false
