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

          @verb       = options.fetch(:verb,       nil)
          @csrf_token = options.fetch(:csrf_token, nil)

          @builder = FormBuilder.new(
            options.fetch(:name),
            options.fetch(:values)
          )
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
          _csrf_protection!
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

        # Inject a hidden field for CSRF Protection token
        #
        # @since x.x.x
        # @api private
        def _csrf_protection!
          return if @csrf_token.nil?

          _csrf_token = @csrf_token
          @builder.resolve do
            input(type: :hidden, name: FormHelper::CSRF_TOKEN, value: _csrf_token)
          end
        end
      end
    end
  end
end
