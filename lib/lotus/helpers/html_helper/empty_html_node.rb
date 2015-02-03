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

        # Attributes escape
        # This is for data-* attributes.
        #
        # @since x.x.x
        # @api private
        ATTRIBUTES_ESCAPE = {
          '_' => '-'
        }.freeze

        # Attributes escape
        # This is for data-* attributes.
        #
        # @since x.x.x
        # @api private
        #
        # @see Lotus::Helpers::HtmlHelper::EmptyHtmlNode::ATTRIBUTES_ESCAPE
        ATTRIBUTES_ESCAPE_PATTERN = Regexp.union(*ATTRIBUTES_ESCAPE.keys)

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

          @attributes.each do |attr, value|
            result << %(#{ attr.to_s.gsub(ATTRIBUTES_ESCAPE_PATTERN){|c| ATTRIBUTES_ESCAPE[c] } }="#{ value }")
          end

          result.join(ATTRIBUTES_SEPARATOR)
        end
      end
    end
  end
end
