require 'lotus/helpers/html_helper/empty_html_node'

module Lotus
  module Helpers
    module HtmlHelper
      # HTML node
      #
      # @since 0.1.0
      # @api private
      #
      # @see Lotus::Helpers::HtmlHelper::EmptyHtmlNode
      class HtmlNode < EmptyHtmlNode
        # Initialize a new HTML node
        #
        # @param name [Symbol,String] the name of the tag
        # @param content [String,Proc,Lotus::Helpers::HtmlHelper::HtmlBuilder,NilClass] the optional content
        # @param attributes [Hash,NilClass] the optional tag attributes
        # @param options [Hash] a optional set of data
        #
        # @return [Lotus::Helpers::HtmlHelper::HtmlNode]
        def initialize(name, content, attributes, options = {})
          @builder = HtmlBuilder.new
          @name    = name
          @content = case content
                     when Hash
                       @attributes = content
                       nil
                     else
                       @attributes = attributes.to_h if attributes.respond_to?(:to_h)
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
        # @see Lotus::Helpers::HtmlHelper::EmptyHtmlNode#to_s
        def to_s
          %(#{ super }#{ content }</#{ @name }>)
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
              "\n#{ @builder }\n"
            else
              "\n#{ Utils::Escape.html(result) }\n"
            end
          else
            Utils::Escape.html(@content)
          end
        end
      end
    end
  end
end
