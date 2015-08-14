module Lotus
  module Helpers
    module HtmlHelper
      # Text node. Allows for text to be inserted between HTML tags.
      #
      # @since x.x.x
      # @api private
      class TextNode
        # Initialize a new text node
        #
        # @param content [String] The content to be added.
        #
        # @return [Lotus::Helpers::HtmlHelper::TextNode]
        def initialize content
          @content = content
        end

        # Resolve and return the output
        #
        # @return [String] the output
        #
        # @since x.x.x
        # @api private
        def to_s
          Utils::Escape.html(@content)
        end
      end
    end
  end
end
