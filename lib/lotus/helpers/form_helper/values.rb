require 'lotus/utils/hash'

module Lotus
  module Helpers
    module FormHelper
      class Values
        GET_SEPARATOR = '.'.freeze

        def initialize(values, params)
          @values = Utils::Hash.new(values).stringify!
          @params = params
        end

        def get(key)
          @params.get(key) || _get_from_values(key)
        end

        private
        def _get_from_values(key)
          initial_key, *keys = key.to_s.split(GET_SEPARATOR)
          result             = @values[initial_key]

          Array(keys).each do |k|
            break if result.nil?

            result = if result.respond_to?(k)
              result.public_send(k)
            else
              nil
            end
          end

          result
        end
      end
    end
  end
end
