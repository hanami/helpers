require 'lotus/helpers/html_helper/html_node'

module Lotus
  module Helpers
    module FormHelper
      # HTML form node
      #
      # @since x.x.x
      # @api private
      #
      # @see Lotus::Helpers::HtmlHelper::HtmlNode
      class HtmlNode < ::Lotus::Helpers::HtmlHelper::HtmlNode
        # Initialize a new HTML form node
        #
        # @param name [Symbol,String] the name of the tag
        # @param content [String,Proc,Lotus::Helpers::HtmlHelper::FormBuilder,NilClass] the optional content
        # @param attributes [Hash,NilClass] the optional tag attributes
        # @param options [Hash] a set of data
        #
        # @return [Lotus::Helpers::FormHelper::HtmlNode]
        #
        # @since x.x.x
        # @api private
        def initialize(name, content, attributes, options)
          super
          @builder = FormBuilder.new(
            options.fetch(:form_name),
            options.fetch(:values)
          )
          @verb    = options.fetch(:verb, nil)
        end

        private
        # Resolve the (nested) content
        #
        # @return [String] the content
        #
        # @since x.x.x
        # @api private
        #
        # @see Lotus::Helpers::HtmlHelper::HtmlNode#content
        def content
          _method_override!
          super
        end

        # Inject a hidden field to make Method Override possible
        #
        # @since x.x.x
        # @api private
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
