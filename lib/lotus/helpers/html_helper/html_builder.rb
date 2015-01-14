require 'lotus/helpers/html_helper/empty_html_node'
require 'lotus/helpers/html_helper/html_node'

module Lotus
  module Helpers
    module HtmlHelper
      class HtmlBuilder < BasicObject
        CONTENT_TAGS = [
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
          'colgroup',
          'tbody',
          'thead',
          'tfoot',
          'tr',
          'td',
          'th',
          'form',
          'fieldset',
          'legend',
          'label',
          'button',
          'select',
          'datalist',
          'optgroup',
          'option',
          'textarea',
          'output',
          'progress',
          'meter',
          'details',
          'summary',
          'menu',
        ].freeze

        EMPTY_TAGS = [
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
          'col',
          'input',
          'keygen',
          'menuitem',
        ].freeze

        CONTENT_TAGS.each do |tag|
          class_eval %{
            def #{ tag }(content = nil, attributes = nil, &blk)
              HtmlNode.new(self, :#{ tag }, blk || content, attributes || content)
            end
          }
        end

        EMPTY_TAGS.each do |tag|
          class_eval %{
            def #{ tag }(attributes = nil)
              EmptyHtmlNode.new(:#{ tag }, attributes)
            end
          }
        end

        def empty(name, attributes = nil)
          EmptyHtmlNode.new(name, attributes)
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
