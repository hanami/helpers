require 'test_helper'

describe Lotus::Helpers::NumberFormattingHelper do
  before do
    @view = NumbersView.new
  end

  it 'returns string representation of one' do
    @view.single_digit.must_equal '1'
  end

  it 'returns string representation of one thousand' do
    @view.thousand_digits.must_equal '1,000'
  end

  it 'returns string representation of one million' do
    @view.million_digits.must_equal '1,000,000'
  end

  it 'returns string representation of point one' do
    @view.zero_point_one.must_equal '0.1'
  end

  it 'returns string representation of 5 thousand and 2 point 007' do
    @view.mixed_digits.must_equal '5,002.007'
  end

  it 'formats precision to 2dp by default' do
    @view.precision_default_format.must_equal '3.14'
  end

  it 'returns string formatted to 4dp' do
    @view.precision_format.must_equal '3.1416'
  end

  it 'returns string with "." delimiter and "," separator' do
    @view.euro_format.must_equal '1.234,12'
  end

  it 'raises TypeError when nil is passed' do
    -> { @view.pass_nil }.must_raise TypeError
  end

  it 'raises a TypeError when a class name is passed' do
    -> { @view.pass_class_name }.must_raise TypeError
  end

  it 'raises a TypeError when a string cannot be coerced into a float' do
    -> { @view.pass_string }.must_raise TypeError
  end

  it 'returns string when passed a string that represent an integer' do
    @view.pass_non_numeric_integer.must_equal '1'
  end

  it 'returns string when passed a string that represent a float' do
    @view.pass_non_numeric_float.must_equal '1.0'
  end

  it 'returns string when passed BigDecimal' do
    @view.big_decimal.must_equal '0.0001'
  end

  it 'returns string when passed Complex' do
    @view.complex.must_equal '1.0'
  end

  it 'returns string when passed a Rational' do
    @view.rational.must_equal '1.0'
  end

  it 'returns infinity representation' do
    @view.infinity.must_equal 'Infinity'
  end

  it 'returns NaN representation' do
    @view.nan.must_equal 'NaN'
  end
end
