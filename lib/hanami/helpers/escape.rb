# frozen_string_literal: true

require "temple/utils"
require "temple/html/safe"

module Hanami
  module Helpers
    module Escape
      def self.call(string)
        Temple::Utils.escape_html_safe(string.to_s)
      end

      def self.safe_string(string)
        Temple::HTML::SafeString.new(string.to_s)
      end
    end
  end
end
