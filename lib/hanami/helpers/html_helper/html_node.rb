# frozen_string_literal: true

require "hanami/helpers/html_helper/empty_html_node"
require "hanami/helpers/escape"

module Hanami
  module Helpers
    module HtmlHelper
      # HTML node
      #
      # @since 0.1.0
      # @api private
      #
      # @see Hanami::Helpers::HtmlHelper::EmptyHtmlNode
      class HtmlNode < EmptyHtmlNode
        # Initialize a new HTML node
        #
        # @param name [Symbol,String] the name of the tag
        # @param content [String,Proc,Hanami::Helpers::HtmlHelper::HtmlBuilder,NilClass] the optional content
        # @param attributes [Hash,NilClass] the optional tag attributes
        # @param _options [Hash] a optional set of data
        #
        # @return [Hanami::Helpers::HtmlHelper::HtmlNode]
        def initialize(name, content, attributes, _options = {}) # rubocop:disable Lint/MissingSuper
          @builder = HtmlBuilder.new
          @name    = name
          @content = if content.is_a?(::Hash)
                       @attributes = content
                       nil
                     else
                       attributes_hash = attributes.to_h if attributes.respond_to?(:to_h)
                       @attributes = prepare_html_attributes(attributes_hash)
                       content
                     end
        end

        # Resolve and return the output
        #
        # @return [String] the output
        #
        # @since 0.1.0
        # @api private
        #
        # @see Hanami::Helpers::HtmlHelper::EmptyHtmlNode#to_s
        def to_s
          %(#{super}#{content}</#{@name}>)
        end

        private

        # Resolve the (nested) content
        #
        # @return [String] the content
        #
        # @since 0.1.0
        # @api private
        def content
          case @content
          when Proc
            result = @builder.resolve(&@content)

            if @builder.nested?
              "\n#{@builder}\n"
            else
              "\n#{Helpers::Escape.(result)}\n"
            end
          else
            Helpers::Escape.(@content)
          end
        end
      end
    end
  end
end
