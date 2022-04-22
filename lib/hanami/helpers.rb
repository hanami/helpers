# frozen_string_literal: true

# @since 0.1.0
module Hanami
  # View helpers for Ruby applications
  #
  # @since 0.1.0
  module Helpers
    require "hanami/helpers/version"
    require "hanami/helpers/errors"
    require "hanami/helpers/html_helper"
    require "hanami/helpers/link_to_helper"
    require "hanami/helpers/number_formatting_helper"

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
        include Hanami::Helpers::LinkToHelper
        include Hanami::Helpers::NumberFormattingHelper
      end

      super
    end
  end
end
