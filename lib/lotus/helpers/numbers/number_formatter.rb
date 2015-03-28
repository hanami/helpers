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

        REGEX_TO_DELIMIT = /(\d)(?=(\d{3})+$)/
        DEFAULT_SEPARATOR = '.'

        attr_accessor :number, :delimiter, :separator, :precision

        def initialize(number, options)
          @number = number
          @delimiter = options.fetch(:delimiter, ',')
          @separator = options.fetch(:separator, '.')
          @precision = options.fetch(:precision, nil)
        end

        def parts
          first, second = split_number
          [add_delimiter_to(first), second].compact
        end

        def split_number
          to_str.split(DEFAULT_SEPARATOR)
        end

        def add_delimiter_to(n)
          n.gsub(REGEX_TO_DELIMIT) { |digit| "#{digit}#{delimiter}" }
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
