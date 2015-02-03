require 'lotus/helpers/version'

module Lotus
  module Helpers
    def self.included(base)
      base.class_eval do
        include Lotus::Helpers::HtmlHelper
      end
    end
  end
end
