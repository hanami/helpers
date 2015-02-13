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
        DEFAULT_SEPARATOR = '.'

        attr_accessor :number, :delimiter, :separator, :precision

        def initialize(number, options)
          @number = number
          @delimiter = options.fetch(:delimiter, ',')
          @separator = options.fetch(:separator, '.')
          @precision = options.fetch(:precision, nil)
        end

        def parts
          left, right = split_number
          left.gsub!(DELIMITED_REGEX) do |digit_to_delimit|
            "#{digit_to_delimit}#{delimiter}"
          end
          [left, right].compact
        end

        def split_number
          to_str.split(DEFAULT_SEPARATOR)
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

        def to_f
          case rounded_number
          when NilClass
            raise TypeError
          when String
            raise TypeError
          when Fixnum
            number
          else
            Utils::Kernel.Float(rounded_number)
          end
        end

        def to_str
          to_f.to_s
        end

      end
    end
  end
end
