require 'lotus/helpers/form_helper/html_node'
require 'lotus/helpers/html_helper/html_builder'
require 'lotus/utils/string'

module Lotus
  module Helpers
    module FormHelper
      class FormBuilder < ::Lotus::Helpers::HtmlHelper::HtmlBuilder
        BROWSER_METHODS = ['GET', 'POST'].freeze

        CHECKED           = 'checked'.freeze
        SELECTED          = 'selected'.freeze
        ACCEPT_SEPARATOR  = ','.freeze
        # ENCTYPE_MULTIPART = 'multipart/form-data'.freeze

        self.html_node = ::Lotus::Helpers::FormHelper::HtmlNode

        def initialize(name, params, attributes = {}, &blk)
          super()

          @name       = name
          @params     = params
          @attributes = attributes
          @blk        = blk
        end

        def options
          Hash[form_name: @name, params: @params, verb: @verb]
        end

        def to_s
          if toplevel?
            _method_override!
            form(@blk, @attributes)
          end

          super
        end

        def fields_for(name)
          current_name = @name
          @name        = _input_name(name)
          yield
        ensure
          @name = current_name
        end

        def label(content, attributes = {}, &blk)
          attributes = { for: _for(content, attributes.delete(:for)) }.merge(attributes)
          content    = Utils::String.new(content).titleize

          super(content, attributes, &blk)
        end

        def color_field(name, attributes = {})
          input _attributes(:color, name, attributes)
        end

        def date_field(name, attributes = {})
          input _attributes(:date, name, attributes)
        end

        def datetime_field(name, attributes = {})
          input _attributes(:datetime, name, attributes)
        end

        def datetime_local_field(name, attributes = {})
          input _attributes(:'datetime-local', name, attributes)
        end

        def email_field(name, attributes = {})
          input _attributes(:email, name, attributes)
        end

        def hidden_field(name, attributes = {})
          input _attributes(:hidden, name, attributes)
        end

        def file_field(name, attributes = {})
          attributes[:accept] = Array(attributes[:accept]).join(ACCEPT_SEPARATOR) if attributes.key?(:accept)
          attributes = { type: :file, name: _input_name(name), id: _input_id(name) }.merge(attributes)

          input(attributes)
        end

        def text_field(name, attributes = {})
          input _attributes(:text, name, attributes)
        end
        alias_method :input_text, :text_field

        def radio_button(name, value, attributes = {})
          attributes = { type: :radio, name: _input_name(name), value: value }.merge(attributes)
          attributes[:checked] = CHECKED if _value(name) == value
          input(attributes)
        end

        def select(name, values, attributes = {})
          options    = attributes.delete(:options) || {}
          attributes = { name: _input_name(name), id: _input_id(name) }.merge(attributes)

          super(attributes) do
            values.each do |value, content|
              if _value(name) == value
                option(content, {value: value, selected: SELECTED}.merge(options))
              else
                option(content, {value: value}.merge(options))
              end
            end
          end
        end

        def submit(content, attributes = {})
          attributes = { type: :submit }.merge(attributes)
          button(content, attributes)
        end

        private
        def toplevel?
          @attributes.any?
        end

        def _method_override!
          verb = (@attributes.fetch(:method) { DEFAULT_METHOD }).to_s.upcase

          if BROWSER_METHODS.include?(verb)
            @attributes[:method] = verb
          else
            @attributes[:method] = DEFAULT_METHOD
            @verb                = verb
          end
        end

        def _attributes(type, name, attributes)
          { type: type, name: _input_name(name), id: _input_id(name), value: _value(name) }.merge(attributes)
        end

        def _input_name(name)
          "#{ @name }[#{ name }]"
        end

        def _input_id(name)
          name = _input_name(name).gsub(/\[(?<token>[[[:word:]]\-]*)\]/, '-\k<token>')
          Utils::String.new(name).dasherize
        end

        def _value(name)
          name = _input_name(name).gsub(/\[(?<token>[[:word:]]*)\]/, '.\k<token>')
          @params.get(name)
        end

        def _for(content, name)
          _input_id(name || content)
        end
      end
    end
  end
end

