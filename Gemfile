source 'https://rubygems.org'
gemspec

unless ENV['TRAVIS']
  gem 'byebug', require: false, platforms: :mri
  gem 'yard',   require: false
end

gem 'hanami-utils',       '~> 1.0.0.beta1', github: 'hanami/utils',       branch: '1.0.x'
gem 'hanami-validations', '~> 1.0.0.beta1', github: 'hanami/validations', branch: '1.0.x'
gem 'hanami-controller',  '~> 1.0.0.beta1', github: 'hanami/controller',  branch: '1.0.x'
gem 'hanami-view',        '~> 1.0.0.beta1', github: 'hanami/view',        branch: '1.0.x'

gem 'rubocop', '~> 0.45', require: false
gem 'coveralls',          require: false
