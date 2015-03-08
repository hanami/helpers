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
    #
    # @example Usage
    #   # 1
    #   link_to('home', '/') # => <a href="/">home</a>
    #
    #   # 2
    #   link_to('users', :users_path, class: 'my_users') # => <a href="/users" class="my_users">users</div>
    module LinkToHelper
      include Lotus::Helpers::HtmlHelper

      def link_to(content, url, options = {}, &blk)
        options[:href] = url
        html.a(blk || content, options).to_s
      end
    end
  end
end
