module Lotus
  module Helpers
    module HtmlHelper
      # Empty HTML node
      #
      # @since x.x.x
      # @api private
      class EmptyHtmlNode
        # Attributes separator
        #
        # @since x.x.x
        # @api private
        ATTRIBUTES_SEPARATOR = ' '.freeze

        # Initialize a new empty HTML node
        #
        # @param name [Symbol,String] the name of the tag
        # @param attributes [Hash,NilClass] the optional tag attributes
        #
        # @return [Lotus::Helpers::HtmlHelper::EmptyHtmlNode]
        #
        # @since x.x.x
        # @api private
        def initialize(name, attributes)
          @name       = name
          @attributes = attributes
        end

        # Resolve and return the output
        #
        # @return [String] the output
        #
        # @since x.x.x
        # @api private
        def to_s
          %(<#{ @name }#{attributes}>)
        end

        private
        # Resolve the attributes
        #
        # @return [String,NilClass] the tag attributes
        #
        # @since x.x.x
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
