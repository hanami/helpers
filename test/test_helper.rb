require 'rubygems'
require 'bundler/setup'

if ENV['COVERALL']
  require 'coveralls'
  Coveralls.wear!
end

require 'minitest/autorun'
$:.unshift 'lib'
require 'hanami/helpers'
require_relative './fixtures'

Hanami::View.load!
