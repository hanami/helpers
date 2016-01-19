require 'hanami/helpers/version'
require 'hanami/helpers/html_helper'
require 'hanami/helpers/escape_helper'
require 'hanami/helpers/routing_helper'
require 'hanami/helpers/link_to_helper'
require 'hanami/helpers/form_helper'
require 'hanami/helpers/number_formatting_helper'

module Hanami
  # View helpers for Ruby applications
  #
  # @since 0.1.0
  module Helpers
    # Override for Module.included
    #
    # It injects all the available helpers.
    #
    # @since 0.1.0
    # @api private
    #
    # @see http://www.ruby-doc.org/core/Module.html#method-i-included
    def self.included(base)
      base.class_eval do
        include Hanami::Helpers::HtmlHelper
        include Hanami::Helpers::EscapeHelper
        include Hanami::Helpers::RoutingHelper
        include Hanami::Helpers::LinkToHelper
        include Hanami::Helpers::FormHelper
        include Hanami::Helpers::NumberFormattingHelper
      end
    end
  end
end
