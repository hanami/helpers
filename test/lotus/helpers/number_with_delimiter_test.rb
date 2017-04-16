require 'test_helper'
require 'lotus/helpers/number_with_delimiter'

describe Lotus::Helpers::NumberWithDelimiter do
  before do
    class TestView
      include Lotus::Helpers::NumberWithDelimiter
      def initialize(number, options = {})
        @number, @options = number, options
      end

      def number
        number_with_delimiter(@number, @options)
      end
    end
  end

  after do
    Object.send(:remove_const, :TestView)
  end

  it 'returns a string of digits separated by comma' do
    TestView.new(1234567).number.must_equal('1,234,567')
  end
end
