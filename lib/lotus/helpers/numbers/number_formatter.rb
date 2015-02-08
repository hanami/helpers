module Lotus
  module Helpers
    module Numbers
      # Numbers
      #
      # @since x.x.x
      class NumberFormatter
        # NumberFormatter
        #
        # @since x.x.x
        # @api private

        def parse
          parts.join(separator)
        end

        private

        DELIMITED_REGEX = /(\d)(?=(\d\d\d)+(?!\d))/

        attr_accessor :number, :delimiter, :separator, :precision

        def initialize(number, delimiter, separator, precision)
          @number = number
          @delimiter = delimiter
          @separator = separator
          @precision = precision
        end

        def parts
          left, right = split_number
          left.gsub!(DELIMITED_REGEX) do |digit_to_delimit|
            "#{digit_to_delimit}#{delimiter}"
          end
          [left, right].compact
        end

        def split_number
          type_check!
          rounded_number.to_s.split('.')
        end

        def rounded_number
          if precision
            number.round(precision)
          elsif(number.is_a? Float)
            number.round(2)
          else
            number
          end
        end

        def type_check!
          if nil_or_non_numeric
            raise TypeError
          elsif rational_complex_or_decimal
            self.number = Lotus::Utils::Kernel.Float(number)
          end
        end

        def nil_or_non_numeric
          (number == nil) || (!number.is_a? Numeric)
        end

        def rational_complex_or_decimal
          (number.is_a? Rational) || (number.is_a? Complex) || (number.is_a? BigDecimal)
        end

      end
    end
  end
end
