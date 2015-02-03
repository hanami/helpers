source 'https://rubygems.org'
gemspec


unless ENV['TRAVIS']
  gem 'byebug', require: false, platforms: :mri
  gem 'yard',   require: false
end

gem 'lotus-utils', github: 'lotus/utils', branch: 'html-escape' # FIXME set the proper branch
gem 'lotus-view',  github: 'lotus/view',  branch: '0.3.x'

gem 'simplecov', require: false
gem 'coveralls', require: false
