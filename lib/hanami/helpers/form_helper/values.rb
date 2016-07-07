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
          @values = Utils::Hash.new(values).stringify!
          @params = params
        end

        # Returns the value for the given key, if present
        #
        # @since 0.2.0
        # @api private
        def get(key)
          @params.get(key) || _get_from_values(key)
        end

        private

        # @since 0.2.0
        # @api private
        def _get_from_values(key)
          initial_key, *keys = key.to_s.split(GET_SEPARATOR)
          result             = @values[initial_key]

          Array(keys).each do |k|
            break if result.nil?

            result = if result.respond_to?(k) # rubocop:disable Style/IfUnlessModifier
                       result.public_send(k)
                     end
          end

          result
        end
      end
    end
  end
end
