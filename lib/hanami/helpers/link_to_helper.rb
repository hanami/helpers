# frozen_string_literal: true
require "hanami/helpers/html_helper"

module Hanami
  module Helpers
    # LinkTo Helper
    #
    # Including <tt>Hanami::Helpers::LinkTo</tt> will include the
    # <tt>link_to</tt> public method.
    #
    # This helper can be used both in views and templates.
    #
    # @since 0.2.0
    module LinkToHelper
      include Hanami::Helpers::HtmlHelper

      # Generates an anchor tag for the given arguments.
      #
      # Contents are automatically escaped.
      #
      # @overload link_to(content, url, options)
      #   Use string as content
      #   @param content [String] content used in the a tag
      #   @param url [String] url used in href attribute
      #   @param options [Hash] HTML attributes to pass to the a tag
      #
      # @overload link_to(url, options, &blk)
      #   Use block as content
      #   @param url [String] url used in href attribute
      #   @param options [Hash] HTML attributes to pass to the a tag
      #   @param blk [Proc] A block that describes the contents of the a tag
      #
      # @return [String] HTML markup for the link
      #
      # @raise [ArgumentError] if the signature isn't respected
      #
      # @since 0.2.0
      #
      # @see Hanami::Helpers::HtmlHelper#html
      #
      # @example Both content and URL are strings
      #   <%= link_to('Home', '/') %>
      #     # => <a href="/">Home</a>
      #
      # @example Content string with route helper
      #   <%= link_to('Home', routes.path(:home)) %>
      #     # => <a href="/">Home</a>
      #
      # @example HTML attributes
      #   <%= link_to('Home', routes.path(:home), class: 'button') %>
      #     # => <a href="/" class="button">Home</a>
      #
      # @example Automatic content escape (XSS protection)
      #   <%= link_to(%(<script>alert('xss')</script>), '/') %>
      #     # => <a href="/">&lt;script&gt;alert(&apos;xss&apos;)&lt;&#x2F;script&gt;</a>
      #
      # @example Automatic content block escape (XSS protection)
      #   <%=
      #     link_to('/') do
      #       %(<script>alert('xss')</script>)
      #     end
      #   %>
      #     # => <a href="/">\n&lt;script&gt;alert(&apos;xss&apos;)&lt;&#x2F;script&gt;\n</a>
      #
      # @example Content as block with string URL
      #   <%=
      #     link_to('/') do
      #       'Home'
      #     end
      #   %>
      #     # => <a href="/">Home</a>
      #
      # @example Content as block
      #   <%=
      #     link_to(routes.path(:home)) do
      #       'Home'
      #     end
      #   %>
      #     # => <a href="/">Home</a>
      #
      # @example Content as block with HTML attributes
      #   <%=
      #     link_to(routes.path(:home), id: 'home-link') do
      #       'Home'
      #     end
      #   %>
      #     # => <a href="/" id: 'home-link'>Home</a>
      #
      # @example Content as HTML builder block
      #   <%=
      #     link_to(routes.path(:home)) do
      #       strong 'Home'
      #     end
      #   %>
      #     # => <a href="/"><strong>Home</strong></a>
      #
      # @example Provides both content as first argument and block
      #   <%=
      #     link_to('Home', routes.path(:home)) do
      #       strong 'Home'
      #     end
      #   %>
      #     # => ArgumentError
      #
      # @example Without any argument
      #   <%= link_to %>
      #     # => ArgumentError
      #
      # @example Without any argument and empty block
      #   <%=
      #     link_to do
      #     end
      #   %>
      #     # => ArgumentError
      #
      # @example With only content
      #   <%= link_to 'Home' %>
      #     # => ArgumentError
      def link_to(content, url = nil, options = {}, &blk) # rubocop:disable Metrics/MethodLength
        if block_given?
          options = url || {}
          url     = content
          content = nil
        end

        begin
          options[:href] = url or raise ArgumentError
        rescue TypeError
          raise ArgumentError
        end

        html.a(blk || content, options)
      end
    end
  end
end
