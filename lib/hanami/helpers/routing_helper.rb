# frozen_string_literal: true

module Hanami
  module Helpers
    # Routing helper for full stack Hanami web applications.
    #
    # For a given application called <tt>Web::Application</tt>, at runtime
    # Hanami creates a routes factory called <tt>Web.routes</tt>.
    #
    # By including this module in a view, it makes that factory avaliable as
    # <tt>routes</tt>.
    #
    # @since 0.1.0
    #
    # @example Basic usage in template
    #   require "hanami"
    #
    #   module Main
    #     module Views
    #       module Home
    #         class Index < Main::View::Base
    #         end
    #       end
    #     end
    #   end
    #
    #   # ERB template
    #   # <%= routes.home_path %>
    #
    # @example Basic usage in view
    #   require "hanami"
    #
    #   module Main
    #     module Views
    #       module Home
    #         class Index < Main::View::Base
    #
    #           def link_to_home
    #             %(<a href="#{ routes.home_path }">Home</a>)
    #           end
    #         end
    #       end
    #     end
    #   end
    #
    #   # ERB template
    #   # <%= link_to_home %>
    module RoutingHelper
      # @since 0.1.0
      # @api private
      def self.included(base)
        base.class_eval do
          include Import["routes"]
        end

        super
      end
    end
  end
end
