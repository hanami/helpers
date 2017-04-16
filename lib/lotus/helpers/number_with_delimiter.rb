module Lotus
  module Helpers
    module NumberWithDelimiter
      DELIMITED_REGEX = /(\d)(?=(\d\d\d)+(?!\d))/.freeze
      DEFAULT_DELIMITER = ','.freeze
      DEFAULT_SEPARATOR = '.'.freeze

      # @param number [#to_s]
      # @param options [Hash]
      # @option options [String] :delimiter the string that delimits the
      #   thousands
      # @option options [String] :separator the string separates the integer
      #   and decimal portions of the number
      #
      # @returns [String] that is a human readable number
      #
      # @since x.x.x
      def number_with_delimiter(number, options = {})
        # TODO - What if we don't have a number?
        # TODO - Internationalization please
        delimiter = options.fetch(:delimiter, DEFAULT_DELIMITER)
        separator = options.fetch(:separator, DEFAULT_SEPARATOR)
        integer, decimal = number.to_s.split('.')
        integer.gsub!(DELIMITED_REGEX) do |integer_to_delimit|
          "#{integer_to_delimit}#{delimiter}"
        end
        [integer, decimal].compact.join(separator)
      end
    end
  end
end