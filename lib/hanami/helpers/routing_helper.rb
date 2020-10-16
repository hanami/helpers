require "hanami/utils/string"

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
    #   require 'hanami'
    #
    #   module Web::Views::Home
    #     class Index
    #       include Web::View
    #     end
    #   end
    #
    #   # ERB template
    #   # <%= routes.home_path %>
    #
    # @example Basic usage in view
    #   require 'hanami'
    #
    #   module Web::Views::Home
    #     class Index
    #       include Web::View
    #
    #       def link_to_home
    #         %(<a href="#{ routes.home_path }">Home</a>)
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
        factory = "#{Utils::String.namespace(base)}.routes"

        base.class_eval <<-END_EVAL, __FILE__, __LINE__ + 1
          def routes
            #{factory}
          end
        END_EVAL
      end
    end
  end
end
