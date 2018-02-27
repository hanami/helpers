module Hanami
  module Helpers
    module HtmlHelper
      # Empty HTML node
      #
      # @since 0.1.0
      # @api private
      class EmptyHtmlNode
        # List of attributes that get special treatment when rendering.
        #
        # @since 0.2.5
        # @api private
        #
        # @see http://www.w3.org/html/wg/drafts/html/master/infrastructure.html#boolean-attribute
        BOOLEAN_ATTRIBUTES = %w[
          allowfullscreen
          async
          autobuffer
          autofocus
          autoplay
          checked
          compact
          controls
          declare
          default
          defaultchecked
          defaultmuted
          defaultselected
          defer
          disabled
          draggable
          enabled
          formnovalidate
          hidden
          indeterminate
          inert
          ismap
          itemscope
          loop
          multiple
          muted
          nohref
          noresize
          noshade
          novalidate
          nowrap
          open
          pauseonexit
          pubdate
          readonly
          required
          reversed
          scoped
          seamless
          selected
          sortable
          spellcheck
          translate
          truespeed
          typemustmatch
          visible
        ].freeze

        # Attributes separator
        #
        # @since 0.1.0
        # @api private
        ATTRIBUTES_SEPARATOR = ' '.freeze

        # Initialize a new empty HTML node
        #
        # @param name [Symbol,String] the name of the tag
        # @param attributes [Hash,NilClass] the optional tag attributes
        #
        # @return [Hanami::Helpers::HtmlHelper::EmptyHtmlNode]
        #
        # @since 0.1.0
        # @api private
        def initialize(name, attributes)
          @name       = name
          @attributes = htmlified_array_attributes(attributes)
        end

        # Resolve and return the output
        #
        # @return [String] the output
        #
        # @since 0.1.0
        # @api private
        def to_s
          %(<#{@name}#{attributes}>)
        end

        private

        # Resolve the attributes
        #
        # @return [String,NilClass] the tag attributes
        #
        # @since 0.1.0
        # @api private
        def attributes
          return unless defined?(@attributes) && !@attributes.nil?
          result = ''

          @attributes.each do |attribute_name, value|
            if boolean_attribute?(attribute_name)
              result << boolean_attribute(attribute_name, value) if value
            else
              result << attribute(attribute_name, value)
            end
          end

          result
        end

        # @api private
        def boolean_attribute?(attribute_name)
          BOOLEAN_ATTRIBUTES.include?(attribute_name.to_s)
        end

        # Do not render boolean attributes when their value is _false_.
        # @api private
        def boolean_attribute(attribute_name, _value)
          %(#{ATTRIBUTES_SEPARATOR}#{attribute_name}="#{attribute_name}")
        end

        # @api private
        def attribute(attribute_name, value)
          %(#{ATTRIBUTES_SEPARATOR}#{attribute_name}="#{value}")
        end

        # Changes any attributes values that are arrays into a string joined by
        # a space, as HTML expects it.
        #
        # @param attributes [Hash] the attributes with values to be HTMLified
        #
        # @return [Hash] the attributes transformed into HTML friendly values, i.e space separated strings
        #
        # @since x.x.x
        def htmlified_array_attributes(attributes)
          attributes&.inject({}) do |attrs, (key, value)|
            attrs[key] = value.is_a?(Array) ? value.join(ATTRIBUTES_SEPARATOR) : value
            attrs
          end
        end
      end
    end
  end
end
