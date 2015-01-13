require 'lotus/helpers/html_helper/self_closing_html_node'

module Lotus
  module Helpers
    module HtmlHelper
      class HtmlNode < SelfClosingHtmlNode
        def initialize(builder, name, content, attributes)
          @builder    = builder
          @name       = name
          @content    = case content
                        when Hash
                          @attributes = content
                          nil
                        else
                          @attributes = attributes.to_h if attributes.respond_to?(:to_h)
                          content
                        end
        end

        def content
          case @content
          when Proc
            @builder.instance_exec(&@content)
          else
            @content
          end
        end

        def to_s
          %(#{ super }#{ content }</#{ @name }>)
        end
      end
    end
  end
end
