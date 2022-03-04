# frozen_string_literal: true

require "hanami/helpers/types"

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
      # Default delimiter
      #
      # @return [String] default delimiter
      #
      # @since 2.0.0
      # @api private
      DEFAULT_DELIMITER = ","
      private_constant :DEFAULT_DELIMITER

      # Default separator
      #
      # @return [String] default separator
      #
      # @since 2.0.0
      # @api private
      DEFAULT_SEPARATOR = "."
      private_constant :DEFAULT_SEPARATOR

      # Default precision
      #
      # @return [Integer] default rounding precision
      #
      # @since 2.0.0
      # @api private
      DEFAULT_PRECISION = 2
      private_constant :DEFAULT_PRECISION

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
      # <tt>Hanami::Helpers::CoercionError</tt>.
      #
      # @param number [Numeric,String] the number to be formatted
      # @param delimiter [String] hundred delimiter
      # @param separator [String] fractional part separator
      # @param precision [String] rounding precision
      #
      # @return [String] formatted number
      #
      # @raise [Hanami::Helpers::CoercionError] if number can't be formatted
      #
      # @since 0.2.0
      #
      # @example
      #   require "hanami/helpers/number_formatting_helper"
      #
      #   class Checkout
      #     include Hanami::Helpers::NumberFormattingHelper
      #
      #     def total
      #       format_number 1999.99
      #     end
      #
      #     def euros
      #       format_number(1256.95, delimiter: ".", separator: ",")
      #     end
      #
      #     def visitors_count
      #       format_number "1000"
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
      def format_number(number, delimiter: DEFAULT_DELIMITER, separator: DEFAULT_SEPARATOR, precision: DEFAULT_PRECISION) # rubocop:disable Layout/LineLength
        Formatter.call(number, delimiter: delimiter, separator: separator, precision: precision)
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

        def self.call(number, delimiter:, separator:, precision:)
          number = coerce(number)
          str = to_str(number, precision)
          array = parts(str, delimiter)

          array.join(separator)
        end

        # Numeric coercion
        #
        # @return [Numeric] coerced number
        #
        # @raise [Hanami::Helpers::CoercionError] if number can't be formatted
        #
        # @since 2.0.0
        # @api private
        def self.coerce(number)
          case number
          when NilClass
            raise Hanami::Helpers::CoercionError.new("failed to convert #{number.inspect} to number")
          when ->(n) { n.to_s.match(INTEGER_REGEXP) }
            Types::Coercible::Integer[number]
          else
            begin
              Types::Coercible::Float[number]
            rescue Dry::Types::CoercionError
              raise Hanami::Helpers::CoercionError.new("failed to convert #{number.inspect} to float")
            end
          end
        end

        # String coercion
        #
        # @param number [Numeric] number to be coerced to string
        # @param precision [Integer] rounding precision
        #
        # @return [String] coerced number to string
        #
        # @raise [Hanami::Helpers::CoercionError] if number can't be formatted
        #
        # @since 2.0.0
        # @api private
        def self.to_str(number, precision)
          case number
          when Integer
            number.to_s
          else
            ::Kernel.format("%.#{precision}f", number)
          end
        end

        # Return integer and fractional parts
        #
        # @param string [String] string representation of the number
        #
        # @return [Array<String>] parts
        #
        # @since 2.0.0
        # @api private
        def self.parts(string, delimiter)
          integer_part, fractional_part = string.split(DEFAULT_SEPARATOR)
          [delimitate(integer_part, delimiter), fractional_part].compact
        end

        # Delimitate the given part
        #
        # @return [String] delimitated string
        #
        # @since 2.0.0
        # @api private
        def self.delimitate(part, delimiter)
          part.gsub(DELIMITATION_REGEX) { |digit| "#{digit}#{delimiter}" }
        end
      end
    end
  end
end
