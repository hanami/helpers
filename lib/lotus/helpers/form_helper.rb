require 'lotus/helpers/form_helper/form_builder'

module Lotus
  module Helpers
    module FormHelper
      DEFAULT_METHOD = 'POST'.freeze

      def form_for(name, url, attributes = {}, &blk)
        attributes = { action: url, id: "#{ name }-form", method: DEFAULT_METHOD }.merge(attributes)
        FormBuilder.new(name, params, attributes, &blk)
      end
    end
  end
end
