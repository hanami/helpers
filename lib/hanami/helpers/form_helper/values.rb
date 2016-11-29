require 'hanami/utils/hash'

module Hanami
  module Helpers
    module FormHelper
      # Values from params and form helpers.
      #
      # It's responsible to populate input values with data coming from params
      # and inline values specified via form helpers like `text_field`.
      #
      # @since 0.2.0
      # @api private
      class Values
        # @since 0.2.0
        # @api private
        GET_SEPARATOR = '.'.freeze

        # @since 0.2.0
        # @api private
        def initialize(values, params)
          @values = Utils::Hash.new(values || {}).symbolize!
          @params = params
        end

        # Returns the value (if present) for the given key.
        # Nested values are expressed with an array if symbols.
        #
        # @since 0.2.0
        # @api private
        def get(*keys)
          _get_from_params(*keys) || _get_from_values(*keys)
        end

        private

        # @since 0.5.0
        # @api private
        def _get_from_params(*keys)
          @params.dig(*keys)
        end

        # @since 0.2.0
        # @api private
        def _get_from_values(*keys)
          head, *tail = *keys
          result      = @values[head]

          tail.each do |k|
            break if result.nil?

            result = case result
                     when Utils::Hash, ::Hash        then result[k]
                     when ->(r) { r.respond_to?(k) } then result.public_send(k)
                     end
          end

          result
        end
      end
    end
  end
end
