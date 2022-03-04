# frozen_string_literal: true

class NumbersView
  include Hanami::Helpers::NumberFormattingHelper

  def single_digit
    format_number 1
  end

  def thousand_digits
    format_number 1_000
  end

  def million_digits
    format_number 1_000_000
  end

  def zero_point_one
    format_number 0.1
  end

  def precision_default_format
    format_number 3.141592
  end

  def precision_format
    format_number 3.141592, precision: 4
  end

  def precision_higher_than_numbers_precision
    format_number 3.14, precision: 4
  end

  def zero_precision
    format_number 3.14, precision: 0
  end

  def mixed_digits
    format_number 5002.007, precision: 3
  end

  def euro_format
    format_number 1234.12, delimiter: ".", separator: ","
  end

  def pass_nil
    format_number nil
  end

  def pass_class_name
    format_number Object
  end

  def pass_string
    format_number "string"
  end

  def pass_non_numeric_integer
    format_number "1"
  end

  def pass_non_numeric_float
    format_number "1.0"
  end

  def big_decimal
    format_number BigDecimal("0.0001"), precision: 4
  end

  def complex
    format_number Complex(1)
  end

  def rational
    format_number Rational(1)
  end

  def string
    format_number Rational(1)
  end

  def infinity
    format_number Float::INFINITY
  end

  def nan
    format_number 0.0 / 0
  end
end
