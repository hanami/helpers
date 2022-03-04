# frozen_string_literal: true

require "hanami/helpers/escape"

module Hanami
  module Helpers
    module HtmlHelper
      # Text node. Allows for text to be inserted between HTML tags.
      #
      # @since 0.2.5
      # @api private
      class TextNode
        # Initialize a new text node
        #
        # @param content [String,#to_s] The content to be added.
        #
        # @return [Hanami::Helpers::HtmlHelper::TextNode]
        #
        # @since 0.2.5
        # @api private
        def initialize(content)
          @content = content.to_s
        end

        # Resolve and return the output
        #
        # @return [String] the output
        #
        # @since 0.2.5
        # @api private
        def to_s
          Helpers::Escape.(@content)
        end
      end
    end
  end
end
