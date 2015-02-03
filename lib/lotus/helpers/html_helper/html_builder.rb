require 'lotus/utils/escape'
require 'lotus/helpers/html_helper/empty_html_node'
require 'lotus/helpers/html_helper/html_node'

module Lotus
  module Helpers
    module HtmlHelper
      # HTML Builder
      #
      # @since x.x.x
      class HtmlBuilder
        # HTML5 content tags
        #
        # @since x.x.x
        # @api private
        #
        # @see Lotus::Helpers::HtmlHelper::HtmlNode
        # @see https://developer.mozilla.org/en-US/docs/Web/HTML/Element
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

        # HTML5 empty tags
        #
        # @since x.x.x
        # @api private
        #
        # @see Lotus::Helpers::HtmlHelper::EmptyHtmlNode
        # @see https://developer.mozilla.org/en-US/docs/Web/HTML/Element
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

        # New line separator
        #
        # @since x.x.x
        # @api private
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

        # Initialize a new builder
        #
        # @return [Lotus::Helpers::HtmlHelper::HtmlBuilder] the builder
        #
        # @since x.x.x
        # @api private
        def initialize
          @nodes = []
        end

        # Defines a custom tag
        #
        # @param name [Symbol,String] the name of the tag
        # @param content [String,Lotus::Helpers::HtmlHelper::HtmlBuilder,NilClass] the optional content
        # @param attributes [Hash,NilClass] the optional tag attributes
        # @param blk [Proc] the optional nested content espressed as a block
        #
        # @return [self]
        #
        # @since x.x.x
        # @api public
        #
        # @see Lotus::Helpers::HtmlHelper
        #
        # @example
        #   html.tag(:custom) # => <custom></custom>
        #
        #   html.tag(:custom, 'foo') # => <custom>foo</custom>
        #
        #   html.tag(:custom, html.p('hello')) # => <custom><p>hello</p></custom>
        #
        #   html.tag(:custom) { 'foo' }
        #   # =>
        #   #<custom>
        #   #  foo
        #   #</custom>
        #
        #   html.tag(:custom) do
        #     p 'hello'
        #   end
        #   # =>
        #   #<custom>
        #   #  <p>hello</p>
        #   #</custom>
        #
        #   html.tag(:custom, 'hello', id: 'foo', 'data-xyz': 'bar') # => <custom id="foo" data-xyz="bar">hello</custom>
        #
        #   html.tag(:custom, id: 'foo') { 'hello' }
        #   # =>
        #   #<custom id="foo">
        #   #  hello
        #   #</custom>
        def tag(name, content = nil, attributes = nil, &blk)
          @nodes << HtmlNode.new(name, blk || content, attributes || content)
          self
        end

        # Defines a custom empty tag
        #
        # @param name [Symbol,String] the name of the tag
        # @param attributes [Hash,NilClass] the optional tag attributes
        #
        # @return [self]
        #
        # @since x.x.x
        # @api public
        #
        # @see Lotus::Helpers::HtmlHelper
        #
        # @example
        #   html.empty_tag(:xr) # => <xr>
        #
        #   html.empty_tag(:xr, id: 'foo') # => <xr id="foo">
        #
        #   html.empty_tag(:xr, id: 'foo', 'data-xyz': 'bar') # => <xr id="foo" data-xyz="bar">
        def empty_tag(name, attributes = nil)
          @nodes << EmptyHtmlNode.new(name, attributes)
          self
        end

        # Resolves all the nodes and generates the markup
        #
        # @return [Lotus::Utils::Escape::SafeString] the output
        #
        # @since x.x.x
        # @api private
        #
        # @see http://www.rubydoc.info/gems/lotus-utils/Lotus/Utils/Escape/SafeString
        def to_s
          Utils::Escape::SafeString.new(@nodes.map(&:to_s).join(NEWLINE))
        end

        # Check if there are nested nodes
        #
        # @return [TrueClass,FalseClass] the result of the check
        #
        # @since x.x.x
        # @api private
        def nested?
          @nodes.any?
        end

        # Resolve the context for nested contents
        #
        # @since x.x.x
        # @api private
        def resolve(&blk)
          @context = blk.binding.receiver
          instance_exec(&blk)
        end

        # Forward missing methods to the current context.
        # This allows to access views local variables from nested content blocks.
        #
        # @since x.x.x
        # @api private
        def method_missing(m, *args, &blk)
          @context.__send__(m, *args, &blk)
        end
      end
    end
  end
end
