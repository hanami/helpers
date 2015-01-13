require 'lotus/helpers/html_helper/self_closing_html_node'
require 'lotus/helpers/html_helper/html_node'

module Lotus
  module Helpers
    module HtmlHelper
      class HtmlBuilder < BasicObject
        CLOSING_TAGS = [
          'a',
          'abbr',
          'address',
          'article',
          'aside',
          'b',
          'bdi',
          'bdo',
          'blockquote',
          'body',
          'cite',
          'code',
          'data',
          'del',
          'dfn',
          'div',
          'dl',
          'dt',
          'em',
          'figcaption',
          'figure',
          'footer',
          'h1',
          'h2',
          'h3',
          'h4',
          'h5',
          'h6',
          'head',
          'header',
          'i',
          'iframe',
          'ins',
          'kbd',
          'li',
          'link',
          'main',
          'mark',
          'nav',
          'noscript',
          'ol',
          'p',
          'pre',
          'q',
          'rp',
          'rt',
          'ruby',
          's',
          'samp',
          'script',
          'section',
          'small',
          'span',
          'strong',
          'style',
          'sub',
          'sup',
          'template',
          'time',
          'title',
          'u',
          'ul',
          'object',
          'video',
          'audio',
          'canvas',
          'map',
          'svg',
          'math',
          'table',
          'caption',
        ].freeze

        SELF_CLOSING_TAGS = [
          'base',
          'link',
          'meta',
          'hr',
          'br',
          'wbr',
          'img',
          'embed',
          'param',
          'source',
          'track',
          'area',
        ].freeze

        CLOSING_TAGS.each do |tag|
          class_eval %{
            def #{ tag }(content = nil, attributes = nil, &blk)
              HtmlNode.new(self, :#{ tag }, blk || content, attributes || content)
            end
          }
        end

        SELF_CLOSING_TAGS.each do |tag|
          class_eval %{
            def #{ tag }(attributes = nil)
              SelfClosingHtmlNode.new(:#{ tag }, attributes)
            end
          }
        end

        def method_missing(m, *args, &blk)
          content    = args.shift
          attributes = args.last

          HtmlNode.new(self, m, blk || content, attributes || content)
        end
      end
    end
  end
end
