module Lotus
  module Helpers
    # Number formatter
    #
    # You can include this module inside your view and
    # the view will have access all methods.
    #
    # By including <tt>Lotus::Helpers::NumberFormattingHelper</tt> it will
    # inject private method: <tt>format_number</tt>.
    #
    # @since x.x.x
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
      # @since x.x.x
      #
      # @example
      #   require 'lotus/helpers/number_formatter_helper'
      #
      #   class Checkout
      #     include Lotus::Helpers::NumberFormattingHelper
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
      # @since x.x.x
      # @api private
      class Formatter
        # Regex to delimitate integer part of a number
        #
        # @return [Regexp] the delimitation regex
        #
        # @since x.x.x
        # @api private
        #
        # @see Lotus::Helpers::NumberFormatter::Formatter#delimitate
        DELIMITATION_REGEX = /(\d)(?=(\d{3})+$)/

        # Regex to guess if the number is a integer
        #
        # @return [Regexp] the guessing regex
        #
        # @since x.x.x
        # @api private
        #
        # @see Lotus::Helpers::NumberFormatter::Formatter#to_number
        INTEGER_REGEXP     = /\A[\d]+\z/

        # Default separator
        #
        # @return [String] default separator
        #
        # @since x.x.x
        # @api private
        DEFAULT_SEPARATOR  = '.'.freeze

        # Default delimiter
        #
        # @return [String] default delimiter
        #
        # @since x.x.x
        # @api private
        DEFAULT_DELIMITER  = ','.freeze

        # Default precision
        #
        # @return [String] default precision
        #
        # @since x.x.x
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
        # @since x.x.x
        # @api private
        #
        # @see Lotus::Helpers::NumberFormatter::Formatter::DEFAULT_DELIMITER
        # @see Lotus::Helpers::NumberFormatter::Formatter::DEFAULT_SEPARATOR
        # @see Lotus::Helpers::NumberFormatter::Formatter::DEFAULT_PRECISION
        def initialize(number, options)
          @number = number
          @delimiter = options.fetch(:delimiter, DEFAULT_DELIMITER)
          @separator = options.fetch(:separator, DEFAULT_SEPARATOR)
          @precision = options.fetch(:precision, DEFAULT_PRECISION)
        end

        # Format number according to the specified options
        #
        # @return [String] formatted number
        #
        # @raise [TypeError] if number can't be formatted
        #
        # @since x.x.x
        # @api private
        def format
          parts.join(@separator)
        end

        private

        # Return integer and fractional parts
        #
        # @return [Array] parts
        #
        # @since x.x.x
        # @api private
        def parts
          integer_part, fractional_part = to_str.split(DEFAULT_SEPARATOR)
          [delimitate(integer_part), fractional_part].compact
        end

        # Delimitate the given part
        #
        # @return [String] delimitated string
        #
        # @since x.x.x
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
        # @since x.x.x
        # @api private
        def to_str
          to_number.to_s
        end

        # Numeric coercion
        #
        # @return [Numeric] coerced number
        #
        # @raise [TypeError] if number can't be formatted
        #
        # @since x.x.x
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

        # Round number in case we need to return a <tt>Float</tt> representation.
        # If <tt>@number</tt> doesn't respond to <tt>#round</tt> return the number as it is.
        #
        # @return [Float,Complex,Rational,BigDecimal] rounded number, if applicable
        #
        # @since x.x.x
        # @api private
        def rounded_number
          if @number.respond_to?(:round)
            @number.round(@precision)
          else
            @number
          end
        end
      end
    end
  end
end
