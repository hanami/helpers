require 'hanami/utils' # RUBY_VERSION >= '2.2'
require 'hanami/utils/class_attribute'
require 'hanami/utils/escape'
require 'hanami/helpers/html_helper/empty_html_node'
require 'hanami/helpers/html_helper/html_node'
require 'hanami/helpers/html_helper/html_fragment'
require 'hanami/helpers/html_helper/text_node'

module Hanami
  module Helpers
    module HtmlHelper
      # HTML Builder
      #
      # @since 0.1.0
      class HtmlBuilder
        # HTML5 content tags
        #
        # @since 0.1.0
        # @api private
        #
        # @see Hanami::Helpers::HtmlHelper::HtmlNode
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
          'dd',
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
        # @since 0.1.0
        # @api private
        #
        # @see Hanami::Helpers::HtmlHelper::EmptyHtmlNode
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
        # @since 0.1.0
        # @api private
        NEWLINE = "\n".freeze

        CONTENT_TAGS.each do |tag|
          class_eval %{
            def #{ tag }(content = nil, attributes = nil, &blk)
              @nodes << self.class.html_node.new(:#{ tag }, blk || content, attributes || content, options)
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

        include Utils::ClassAttribute

        class_attribute :html_node
        self.html_node = ::Hanami::Helpers::HtmlHelper::HtmlNode

        # Initialize a new builder
        #
        # @return [Hanami::Helpers::HtmlHelper::HtmlBuilder] the builder
        #
        # @since 0.1.0
        # @api private
        def initialize
          @nodes = []
        end

        def options
        end

        # Define a custom tag
        #
        # @param name [Symbol,String] the name of the tag
        # @param content [String,Hanami::Helpers::HtmlHelper::HtmlBuilder,NilClass] the optional content
        # @param attributes [Hash,NilClass] the optional tag attributes
        # @param blk [Proc] the optional nested content espressed as a block
        #
        # @return [self]
        #
        # @since 0.1.0
        # @api public
        #
        # @see Hanami::Helpers::HtmlHelper
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
          @nodes << HtmlNode.new(name, blk || content, attributes || content, options)
          self
        end

        # Define a HTML fragment
        #
        # @param blk [Proc] the optional nested content espressed as a block
        #
        # @return [self]
        #
        # @since 0.2.6
        # @api public
        #
        # @see Hanami::Helpers::HtmlHelper
        #
        # @example
        #   html.fragment('Hanami') # => Hanami
        #
        #   html do
        #     p 'hello'
        #     p 'hanami'
        #   end
        #   # =>
        #     <p>hello</p>
        #     <p>hanami</p>
        def fragment(&blk)
          @nodes << HtmlFragment.new(&blk)
          self
        end

        # Defines a custom empty tag
        #
        # @param name [Symbol,String] the name of the tag
        # @param attributes [Hash,NilClass] the optional tag attributes
        #
        # @return [self]
        #
        # @since 0.1.0
        # @api public
        #
        # @see Hanami::Helpers::HtmlHelper
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

        # Defines a plain string of text. This particularly useful when you
        # want to build more complex HTML.
        #
        # @param content [String] the text to be rendered.
        #
        # @return [self]
        #
        # @see Hanami::Helpers::HtmlHelper
        # @see Hanami::Helpers::HtmlHelper::TextNode
        #
        # @example
        #
        #   html.label do
        #     text "Option 1"
        #     radio_button :option, 1
        #   end
        #
        #   # <label>
        #   #   Option 1
        #   #   <input type="radio" name="option" value="1" />
        #   # </label>
        def text(content)
          @nodes << TextNode.new(content)
          self
        end

        # @since 0.2.5
        # @api private
        alias_method :+, :text

        # Resolves all the nodes and generates the markup
        #
        # @return [Hanami::Utils::Escape::SafeString] the output
        #
        # @since 0.1.0
        # @api private
        #
        # @see http://www.rubydoc.info/gems/hanami-utils/Hanami/Utils/Escape/SafeString
        def to_s
          Utils::Escape::SafeString.new(@nodes.map(&:to_s).join(NEWLINE))
        end

        # Encode the content with the given character encoding
        #
        # @param encoding [Encoding,String] the encoding or its string representation
        #
        # @return [String] the encoded string
        #
        # @since 0.2.5
        # @api private
        def encode(encoding)
          to_s.encode(encoding)
        end

        # Check if there are nested nodes
        #
        # @return [TrueClass,FalseClass] the result of the check
        #
        # @since 0.1.0
        # @api private
        def nested?
          @nodes.any?
        end

        # Resolve the context for nested contents
        #
        # @since 0.1.0
        # @api private
        if RUBY_VERSION >= '2.2' && !Utils.jruby?
          def resolve(&blk)
            @context = blk.binding.receiver
            instance_exec(&blk)
          end
        else
          def resolve(&blk)
            @context = eval 'self', blk.binding
            instance_exec(&blk)
          end
        end

        # Forward missing methods to the current context.
        # This allows to access views local variables from nested content blocks.
        #
        # @since 0.1.0
        # @api private
        def method_missing(m, *args, &blk)
          @context.__send__(m, *args, &blk)
        end
      end
    end
  end
end
