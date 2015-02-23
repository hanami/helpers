require 'lotus/helpers/html_helper/html_node'

module Lotus
  module Helpers
    module FormHelper
      class HtmlNode < ::Lotus::Helpers::HtmlHelper::HtmlNode
        def initialize(name, content, attributes, options)
          super
          @builder = FormBuilder.new(options.fetch(:form_name), options.fetch(:params))
          @verb    = options.fetch(:verb, nil)
        end

        private
        def content
          _method_override!
          super
        end

        def _method_override!
          return if @verb.nil?

          verb = @verb
          @builder.resolve do
            input(type: :hidden, name: :_method, value: verb)
          end
        end
      end
    end
  end
end
