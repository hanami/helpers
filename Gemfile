source 'https://rubygems.org'
gemspec

unless ENV['TRAVIS']
  gem 'byebug', require: false, platforms: :mri
  gem 'yard',   require: false
end

gem 'hanami-utils',       '~> 1.0', git: 'https://github.com/hanami/utils.git',       branch: '1.0.x'
gem 'hanami-validations', '~> 1.0', git: 'https://github.com/hanami/validations.git', branch: '1.0.x'
gem 'hanami-controller',  '~> 1.0', git: 'https://github.com/hanami/controller.git',  branch: '1.0.x'
gem 'hanami-view',        '~> 1.0', git: 'https://github.com/hanami/view.git',        branch: '1.0.x'

gem 'rubocop', '0.48.0', require: false
gem 'coveralls',         require: false
