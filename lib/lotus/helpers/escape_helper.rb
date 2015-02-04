require 'lotus/utils/escape'

module Lotus
  module Helpers
    # Escape helpers
    #
    # You can include this module inside your view and 
    # the view will have access all methods.
    #
    # Features:
    #   * Auto escape html (1)
    #   * Auto escape html attributes (2)
    #   * Auto escape urls (3)
    #   * Mark strings as safe strings (4)
    #
    # @since x.x.x
    #
    # @see Lotus::Helpers::EscapeHelper#escape_html
    # @see Lotus::Helpers::EscapeHelper#escape_html_attribute
    # @see Lotus::Helpers::EscapeHelper#escape_url
    # @see Lotus::Helpers::EscapeHelper#raw
    #
    # @example Usage
    #   # 1
    #   escape_html "<script>alert('xss')</script>" # => &lt;script&gt;alert(&apos;xss&apos;)&lt;&#x2F;script&gt;
    #
    #   # 2
    #   <a title='#{escape_html_attribute('<script>alert(\'xss\')</script>')}'>link</a> 
    #     # => <a title='&lt;script&gt;alert&#x28;&#x27;xss&#x27;&#x29;&lt;&#x2f;script&gt;'>link</a>
    #
    #   # 3
    #   escape_url "javascript:alert('xss')" #=> ""
    #
    #   # 4
    #   raw "<div>I'm a raw string</div>"        # => <div>I'm a raw string</div>
    #   raw("<div>I'm a raw string</div>").class # => Lotus::Utils::Escape::SafeString
    module EscapeHelper
      private
      # Escape html string
      #
      # @param input [String] the input
      #
      # @return [String] the escaped string
      #
      # @since x.x.x
      #
      # @see Lotus::Utils::Escape.html
      def escape_html(input)
        Utils::Escape.html(input)
      end

      alias_method :h, :escape_html

      # Escape html attribute string
      #
      # @param input [String] the input
      #
      # @return [String] the escaped string
      #
      # @since x.x.x
      #
      # @see Lotus::Utils::Escape.html_attribute
      def escape_html_attribute(input)
        Utils::Escape.html_attribute(input)
      end

      alias_method :ha, :escape_html_attribute

      # Escape an url
      #
      # @param input [String] the input
      # @param schemes [Array<String>] an array of whitelisted schemes
      #
      # @return [String] the escaped string
      #
      # @since x.x.x
      #
      # @see Lotus::Utils::Escape.url
      # @see Lotus::Utils::Escape::DEFAULT_URL_SCHEMES
      def escape_url(input, schemes = Utils::Escape::DEFAULT_URL_SCHEMES)
        Utils::Escape.url(input, schemes)
      end

      alias_method :u, :escape_url

      # Mark safe a string
      #
      # @param input [String] the input
      #
      # @return [String] the string marked as safe string
      #
      # @since x.x.x
      #
      # @see Lotus::Utils::Escape.raw
      def raw(input)
        Utils::Escape::SafeString.new(input)
      end
    end
  end
end
