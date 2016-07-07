require 'rubygems'
require 'bundler/setup'

if ENV['COVERALL']
  require 'coveralls'
  Coveralls.wear!
end

require 'minitest/autorun'
$LOAD_PATH.unshift 'lib'
require 'hanami/helpers'
require_relative './fixtures'

Hanami::View.load!
