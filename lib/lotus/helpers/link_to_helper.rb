require 'lotus/helpers/html_helper'

module Lotus
  module Helpers
    # LinkTo Helper
    #
    # Including <tt>Lotus::Helpers::LinkTo</tt> will include the `link_to` method.
    #
    # @since x.x.x
    #
    # @see Lotus::Helpers::HtmlHelper#html
    module LinkToHelper
      include Lotus::Helpers::HtmlHelper

      # Link to url using content or html block
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
      # @return [String] the a tag
      #
      # @since x.x.x
      #
      # @example Usage
      #   # 1
      #   link_to('home', '/') # => <a href="/">home</a>
      #
      #   # 2
      #   link_to('users', :users_path, class: 'my_users') # => <a href="/users" class="my_users">users</div>
      #
      #   # 3
      #   link_to(:users_path) do
      #     strong 'Users'
      #   end # => <a href="/users"><strong>Users</strong></a>
      def link_to(*args, **options, &blk)
        if block_given? && args.size != 1
          raise ArgumentError, 'Only an url is expected as an argument when a block is given'
        end

        if !block_given? && args.size != 2
          raise ArgumentError, 'Both content and url are expected as arguments'
        end

        url, content = *args.rotate

        options[:href] = url
        html.a(blk || content, options).to_s
      end
    end
  end
end
