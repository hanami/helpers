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
          @values = Utils::Hash.new(values || {}).stringify!
          @params = params
        end

        # Returns the value for the given key, if present
        #
        # @since 0.2.0
        # @api private
        def get(key)
          _get_from_params(key) || _get_from_values(key)
        end

        private

        # Safely access nested values.
        #
        # <tt>Hanami::Action::Params</tt> already supports this feature with
        # <tt>#get</tt>.
        # But during testing phase it could happen to receive a <tt>Hash</tt>
        # instead.
        #
        # For this purpose, we check if <tt>@params</tt> respond to
        # <tt>#dig</tt>, which is a new Ruby 2.3 feature similar to
        # <tt>Hanami::Action::Params#get</tt>.
        # If the check is successful, we try to access the value with
        # <tt>#dig</tt>, otherwise we assume that it responds to <tt>#get</tt>
        # and use it.
        #
        # This implementation is safe to use, but it has several hidden perf costs:
        #
        #   * The runtime check for <tt>#respond_to?</tt>, which is inelegant too
        #   * In case of <tt>#dig</tt> we need to transform a key like
        #     <tt>:'order.customer.address.street'</tt> into
        #     <tt>[:order, :customer, :address, :street]</tt>
        #   * In case of <tt>#get</tt> its internal implementation isn't
        #     efficient because it splits the key into an array and it uses
        #     recursion to access nested values
        #
        # Because as of Ruby 2.3 we have <tt>Hash#dig</tt>, we should use it
        # both in params and here, because it's faster (written in C).
        # To make this possible, we should change the key notation from a dot
        # separated string to an array of symbol.
        #
        # FIXME: Use Hash#dig when we'll support only Ruby 2.3+
        #
        # @since x.x.x
        # @api private
        def _get_from_params(key)
          if @params.respond_to?(:dig)
            @params.dig(*key.to_s.split(GET_SEPARATOR).map!(&:to_sym))
          else
            @params.get(key)
          end
        end

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
