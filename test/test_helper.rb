require 'bundler/setup'

if ENV['COVERAGE'] == 'true'
  require 'simplecov'
  require 'coveralls'

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ]

  SimpleCov.start do
    command_name 'test'
    add_filter   'test'
  end
end

require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use! #Minitest::Reporters::SpecReporter.new

module MiniTest
  class Spec
    class << self
      alias_method :context, :describe
    end
  end
end

$LOAD_PATH.unshift 'lib'
