require 'lotus/helpers/html_helper/html_builder'

module Lotus
  module Helpers
    module HtmlHelper
      private
      def html
        HtmlBuilder.new
      end
    end
  end
end
