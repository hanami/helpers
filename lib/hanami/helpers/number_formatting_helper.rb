# frozen_string_literal: true

require "hanami/utils/kernel"

module Hanami
  module Helpers
    # Number formatter
    #
    # You can include this module inside your view and
    # the view will have access all methods.
    #
    # By including <tt>Hanami::Helpers::NumberFormattingHelper</tt> it will
    # inject private method: <tt>format_number</tt>.
    #
    # @since 0.2.0
    module NumberFormattingHelper
      private

      # Format the given number, according to the options
      #
      # It accepts a number (<tt>Numeric</tt>) or a string representation.
      #
      # If an integer is given, no precision is applied.
      # For the rest of the numbers, it will format as a float representation.
      # This is the case of: <tt>Float</tt>, <tt>BigDecimal</tt>,
      # <tt>Complex</tt>, <tt>Rational</tt>.
      #
      # If the argument cannot be coerced into a number, it will raise a
      # <tt>TypeError</tt>.
      #
      # @param number [Numeric,String] the number to be formatted
      #
      # @return [String] formatted number
      #
      # @raise [TypeError] if number can't be formatted
      #
      # @since 0.2.0
      #
      # @example
      #   require 'hanami/helpers/number_formatting_helper'
      #
      #   class Checkout
      #     include Hanami::Helpers::NumberFormattingHelper
      #
      #     def total
      #       format_number 1999.99
      #     end
      #
      #     def euros
      #       format_number 1256.95, delimiter: '.', separator: ','
      #     end
      #
      #     def visitors_count
      #       format_number '1000'
      #     end
      #   end
      #
      #   view = Checkout.new
      #
      #   view.total
      #     # => "1,999.99"
      #
      #   view.euros
      #     # => "1.256,95"
      #
      #   view.visitors_count
      #     # => "1,000"
      def format_number(number, options = {})
        Formatter.new(number, options).format
      end

      # Formatter
      #
      # @since 0.2.0
      # @api private
      class Formatter
        # Regex to delimitate integer part of a number
        #
        # @return [Regexp] the delimitation regex
        #
        # @since 0.2.0
        # @api private
        #
        # @see Hanami::Helpers::NumberFormatter::Formatter#delimitate
        DELIMITATION_REGEX = /(\d)(?=(\d{3})+$)/

        # Regex to guess if the number is a integer
        #
        # @return [Regexp] the guessing regex
        #
        # @since 0.2.0
        # @api private
        #
        # @see Hanami::Helpers::NumberFormatter::Formatter#to_number
        INTEGER_REGEXP     = /\A\d+\z/

        # Default separator
        #
        # @return [String] default separator
        #
        # @since 0.2.0
        # @api private
        DEFAULT_SEPARATOR  = "."

        # Default delimiter
        #
        # @return [String] default delimiter
        #
        # @since 0.2.0
        # @api private
        DEFAULT_DELIMITER  = ","

        # Default precision
        #
        # @return [Integer] default precision
        #
        # @since 0.2.0
        # @api private
        DEFAULT_PRECISION  = 2

        # Initialize a new formatter
        #
        # @param number [Numeric,String] the number to format
        # @param options [Hash] options for number formatting
        # @option options [String] :delimiter hundred delimiter
        # @option options [String] :separator fractional part delimiter
        # @option options [Integer] :precision rounding precision
        #
        # @since 0.2.0
        # @api private
        #
        # @see Hanami::Helpers::NumberFormatter::Formatter::DEFAULT_DELIMITER
        # @see Hanami::Helpers::NumberFormatter::Formatter::DEFAULT_SEPARATOR
        # @see Hanami::Helpers::NumberFormatter::Formatter::DEFAULT_PRECISION
        def initialize(number, options)
          @number = number
          @delimiter = options.fetch(:delimiter, DEFAULT_DELIMITER)
          @separator = options.fetch(:separator, DEFAULT_SEPARATOR)
          @precision = options.fetch(:precision, nil)
        end

        # Format number according to the specified options
        #
        # @return [String] formatted number
        #
        # @raise [TypeError] if number can't be formatted
        #
        # @since 0.2.0
        # @api private
        def format
          parts.join(@separator)
        end

        private

        # Return integer and fractional parts
        #
        # @return [Array] parts
        #
        # @since 0.2.0
        # @api private
        def parts
          integer_part, fractional_part = to_str.split(DEFAULT_SEPARATOR)
          [delimitate(integer_part), fractional_part].compact
        end

        # Delimitate the given part
        #
        # @return [String] delimitated string
        #
        # @since 0.2.0
        # @api private
        def delimitate(part)
          part.gsub(DELIMITATION_REGEX) { |digit| "#{digit}#{@delimiter}" }
        end

        # String coercion
        #
        # @return [String] coerced number
        #
        # @raise [TypeError] if number can't be formatted
        #
        # @since 0.2.0
        # @api private
        def to_str
          number = to_number
          if precision_requested_explicitly?
            Kernel.format("%.#{precision}f", number)
          else
            number.to_s
          end
        end

        # Numeric coercion
        #
        # @return [Numeric] coerced number
        #
        # @raise [TypeError] if number can't be formatted
        #
        # @since 0.2.0
        # @api private
        def to_number
          case @number
          when NilClass
            raise TypeError
          when ->(n) { n.to_s.match(INTEGER_REGEXP) }
            Utils::Kernel.Integer(@number)
          else
            Utils::Kernel.Float(rounded_number)
          end
        end

        # Returns precision with a fallback to default value
        #
        # @return [Numeric] precision
        #
        # @since 1.0.0
        # @api private
        def precision
          @precision || DEFAULT_PRECISION
        end

        # Checks if precision was requested in options
        #
        # @return [TrueClass,FalseClass] the result of the check
        #
        # @since 1.0.0
        # @api private
        def precision_requested_explicitly?
          !@precision.nil?
        end

        # Round number in case we need to return a <tt>Float</tt> representation.
        # If <tt>@number</tt> doesn't respond to <tt>#round</tt> return the number as it is.
        #
        # @return [Float,Complex,Rational,BigDecimal] rounded number, if applicable
        #
        # @since 0.2.0
        # @api private
        def rounded_number
          if @number.respond_to?(:round)
            @number.round(precision)
          else
            @number
          end
        end
      end
    end
  end
end
