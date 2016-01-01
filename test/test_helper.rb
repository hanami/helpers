require 'rubygems'
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
$:.unshift 'lib'
require 'lotus/helpers'
require_relative './fixtures'

Lotus::View.load!

require 'stackprof'
require 'minitest/around/spec'

class Minitest::Test
  def around(&example)
    path = "/Users/anton/work/repositories/lotus/helpers/tmp/stackprof-test-#{Time.now.to_i}-#{rand(200)}.dump"
    StackProf.run(mode: :object, out: path.to_s) do
      example.call
    end
  end
end
