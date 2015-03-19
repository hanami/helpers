module Lotus
  module Helpers
    # Routing helper for full stack Lotus web applications.
    #
    # For a given application called <tt>Web::Application</tt>, at runtime
    # Lotus creates a routes factory called <tt>Web::Routes</tt>.
    #
    # By including this module in a view, it makes that factory avaliable as
    # <tt>routes</tt>.
    #
    # @since 0.1.0
    #
    # @example Basic usage in template
    #   require 'lotus'
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
    #   require 'lotus'
    #
    #   module Web::Views::Home
    #     class Index
    #       include Web::View
    #     end
    #
    #     def link_to_home
    #       %(<a href="#{ routes.home_path }">Home</a>)
    #     end
    #   end
    #
    #   # ERB template
    #   # <%= link_to_home %>
    module RoutingHelper
      def self.included(base)
        factory = "#{ Utils::String.new(base).namespace }::Routes"

        base.class_eval <<-END_EVAL, __FILE__, __LINE__
          def routes
            #{ factory }
          end
        END_EVAL
      end
    end
  end
end
