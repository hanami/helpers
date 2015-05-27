module Lotus
  module Helpers
    module HtmlHelper
      # Empty HTML node
      #
      # @since 0.1.0
      # @api private
      class EmptyHtmlNode
        # Attributes separator
        #
        # @since 0.1.0
        # @api private
        ATTRIBUTES_SEPARATOR = ' '.freeze

        # Initialize a new empty HTML node
        #
        # @param name [Symbol,String] the name of the tag
        # @param attributes [Hash,NilClass] the optional tag attributes
        #
        # @return [Lotus::Helpers::HtmlHelper::EmptyHtmlNode]
        #
        # @since 0.1.0
        # @api private
        def initialize(name, attributes)
          @name       = name
          @attributes = attributes
        end

        # Resolve and return the output
        #
        # @return [String] the output
        #
        # @since 0.1.0
        # @api private
        def to_s
          %(<#{ @name }#{attributes}>)
        end

        private
        # Resolve the attributes
        #
        # @return [String,NilClass] the tag attributes
        #
        # @since 0.1.0
        # @api private
        def attributes
          return if @attributes.nil?
          result = [nil]

          @attributes.each do |name, value|
            result << %(#{ name }="#{ value }")
          end

          result.join(ATTRIBUTES_SEPARATOR)
        end
      end
    end
  end
end
