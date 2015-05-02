require 'lotus/helpers/numbers/number_formatter'

module Lotus
  module Helpers
    # Number formatter
    #
    # You can include this module inside your view and
    # the view will have access all methods.
    #
    # By including <tt>Lotus::Helpers::Numbers</tt> it will inject private
    # methods as markup escape utilities.
    #
    # @since x.x.x
    module Numbers
      private
      # Number formatting
      #
      # This helper formats raw numbers to make them more human readable
      #
      # @param number [Numeric] the number to be formatted
      #
      # @return [String] formatted number
      #
      # @since x.x.x
      #
      # @example Basic usage
      #   require 'lotus/helpers/numbers'
      #
      #   class Checkout
      #     include Lotus::Helpers::Numbers
      #
      #     def total
      #       format_number 1999.99
      #     end
      #
      #     def euros
      #       format_number 1256.95, delimiter: '.', separator: ','
      #     end
      #   end
      #
      #   view = MyView.new
      #
      #   view.total
      #     # => "1,999.99"
      #
      #   view.euros
      #     # => "1.256,95"
      def format_number(number, options = {})
        number_parser = NumberFormatter.new(number, options)
        number_parser.parse
      end
    end
  end
end
