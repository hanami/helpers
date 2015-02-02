require 'lotus/utils/escape'
require 'lotus/helpers/html_helper/empty_html_node'
require 'lotus/helpers/html_helper/html_node'

module Lotus
  module Helpers
    module HtmlHelper
      class HtmlBuilder
        CONTENT_TAGS = [
          'a',
          'abbr',
          'address',
          'article',
          'aside',
          'audio',
          'b',
          'bdi',
          'bdo',
          'blockquote',
          'body',
          'button',
          'canvas',
          'caption',
          'cite',
          'code',
          'colgroup',
          'data',
          'datalist',
          'del',
          'details',
          'dfn',
          'div',
          'dl',
          'dt',
          'em',
          'fieldset',
          'figcaption',
          'figure',
          'footer',
          'form',
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
          'label',
          'legend',
          'li',
          'link',
          'main',
          'map',
          'mark',
          'math',
          'menu',
          'meter',
          'nav',
          'noscript',
          'object',
          'ol',
          'optgroup',
          'option',
          'output',
          'p',
          'pre',
          'progress',
          'q',
          'rp',
          'rt',
          'ruby',
          's',
          'samp',
          'script',
          'section',
          'select',
          'small',
          'span',
          'strong',
          'style',
          'sub',
          'summary',
          'sup',
          'svg',
          'table',
          'tbody',
          'td',
          'template',
          'textarea',
          'tfoot',
          'th',
          'thead',
          'time',
          'title',
          'tr',
          'u',
          'ul',
          'video',
        ].freeze

        EMPTY_TAGS = [
          'area',
          'base',
          'br',
          'col',
          'embed',
          'hr',
          'img',
          'input',
          'keygen',
          'link',
          'menuitem',
          'meta',
          'param',
          'source',
          'track',
          'wbr',
        ].freeze

        NEWLINE = "\n".freeze

        CONTENT_TAGS.each do |tag|
          class_eval %{
            def #{ tag }(content = nil, attributes = nil, &blk)
              @nodes << HtmlNode.new(:#{ tag }, blk || content, attributes || content)
              self
            end
          }
        end

        EMPTY_TAGS.each do |tag|
          class_eval %{
            def #{ tag }(attributes = nil)
              @nodes << EmptyHtmlNode.new(:#{ tag }, attributes)
              self
            end
          }
        end

        def initialize
          @nodes = []
        end

        def to_s
          Utils::Escape::SafeString.new(@nodes.map(&:to_s).join(NEWLINE))
        end

        def nested?
          @nodes.any?
        end

        def tag(name, content = nil, attributes = nil, &blk)
          @nodes << HtmlNode.new(name, blk || content, attributes || content)
          self
        end

        def empty_tag(name, attributes = nil)
          @nodes << EmptyHtmlNode.new(name, attributes)
          self
        end
      end
    end
  end
end
