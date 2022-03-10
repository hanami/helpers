# frozen_string_literal: true

require "hanami/helpers/form_helper/values"
require "hanami/helpers/html_helper/html_builder"
require "hanami/helpers/escape_helper"
require "dry-inflector"

module Hanami
  module Helpers
    module FormHelper
      # Form builder
      #
      # @since 0.2.0
      #
      # @see Hanami::Helpers::HtmlHelper::HtmlBuilder
      class FormBuilder
        # Set of HTTP methods that are understood by web browsers
        #
        # @since 0.2.0
        # @api private
        BROWSER_METHODS = %w[GET POST].freeze
        private_constant :BROWSER_METHODS

        # Set of HTTP methods that should NOT generate CSRF token
        #
        # @since 0.2.0
        # @api private
        EXCLUDED_CSRF_METHODS = %w[GET].freeze
        private_constant :EXCLUDED_CSRF_METHODS

        # Checked attribute value
        #
        # @since 0.2.0
        # @api private
        #
        # @see Hanami::Helpers::FormHelper::FormBuilder#radio_button
        CHECKED = "checked"
        private_constant :CHECKED

        # Separator for accept attribute of file input
        #
        # @since 0.2.0
        # @api private
        #
        # @see Hanami::Helpers::FormHelper::FormBuilder#file_input
        ACCEPT_SEPARATOR = ","
        private_constant :ACCEPT_SEPARATOR

        # Default value for unchecked check box
        #
        # @since 0.2.0
        # @api private
        #
        # @see Hanami::Helpers::FormHelper::FormBuilder#check_box
        DEFAULT_UNCHECKED_VALUE = "0"
        private_constant :DEFAULT_UNCHECKED_VALUE

        # Default value for checked check box
        #
        # @since 0.2.0
        # @api private
        #
        # @see Hanami::Helpers::FormHelper::FormBuilder#check_box
        DEFAULT_CHECKED_VALUE = "1"
        private_constant :DEFAULT_CHECKED_VALUE

        # Input name separator
        #
        # @since 2.0.0
        # @api private
        INPUT_NAME_SEPARATOR = "."
        private_constant :INPUT_NAME_SEPARATOR

        # Empty string
        #
        # @since 2.0.0
        # @api private
        #
        # @see Hanami::Helpers::FormHelper::FormBuilder#password_field
        EMPTY_STRING = ""
        private_constant :EMPTY_STRING

        include Helpers::EscapeHelper

        def initialize(html: Hanami::Helpers::HtmlHelper::HtmlBuilder.new, values: Values.new, inflector: Dry::Inflector.new, **attributes, &blk)
          super()

          @html = html
          @values = values
          @inflector = inflector

          method_override, original_form_method = _form_method(attributes)
          csrf_token, token = _csrf_token(values, attributes)
          attributes[:accept_charset] ||= DEFAULT_CHARSET

          form_builder = self
          @html.form(**attributes) do
            input(type: "hidden", name: "_method", value: original_form_method) if method_override
            input(type: "hidden", name: "_csrf_token", value: token) if csrf_token
            blk&.call(form_builder)
          end
        end

        # Resolves all the nodes and generates the markup
        #
        # @return [Hanami::Utils::Escape::SafeString] the output
        #
        # @since 0.2.0
        # @api private
        #
        # @see Hanami::Helpers::HtmlHelper::HtmlBuilder#to_s
        # @see http://www.rubydoc.info/gems/hanami-utils/Hanami/Utils/Escape/SafeString
        def to_s
          html.to_s
        end

        # Label tag
        #
        # The first param <tt>content</tt> can be a <tt>Symbol</tt> that represents
        # the target field (Eg. <tt>:extended_title</tt>), or a <tt>String</tt>
        # which is used as it is.
        #
        # @param content [Symbol,String] the field name or a content string
        # @param attributes [Hash] HTML attributes to pass to the label tag
        #
        # @since 0.2.0
        #
        # @example Basic usage
        #   <%=
        #     # ...
        #     label :extended_title
        #   %>
        #
        #   <!-- output -->
        #   <label for="book-extended-title">Extended title</label>
        #
        # @example HTML attributes
        #   <%=
        #     # ...
        #     label :title, class: "form-label"
        #   %>
        #
        #   <!-- output -->
        #   <label for="book-title" class="form-label">Title</label>
        #
        # @example Custom content
        #   <%=
        #     # ...
        #     label 'Title', for: :extended_title
        #   %>
        #
        #   <!-- output -->
        #   <label for="book-extended-title">Title</label>
        #
        # @example Custom "for" attribute
        #   <%=
        #     # ...
        #     label :extended_title, for: 'ext-title'
        #   %>
        #
        #   <!-- output -->
        #   <label for="ext-title">Extended title</label>
        #
        # @example Nested fields usage
        #   <%=
        #     # ...
        #     fields_for :address do
        #       label :city
        #       text_field :city
        #     end
        #   %>
        #
        #   <!-- output -->
        #   <label for="delivery-address-city">City</label>
        #   <input type="text" name="delivery[address][city] id="delivery-address-city" value="">
        #
        # @example Block syntax
        #   <%=
        #     # ...
        #     label for: :free_shipping do
        #       text "Free shipping"
        #       abbr "*", title: "optional", "aria-label": "optional"
        #     end
        #   %>
        #
        #   <!-- output -->
        #   <label for="book-free-shipping">
        #     Free Shipping
        #     <abbr title="optional" aria-label="optional">*</abbr>
        #   </label>
        def label(content = nil, **attributes, &blk)
          for_attribute_given = attributes.key?(:for)

          attributes[:for] = _for(content, attributes[:for])
          if content && !for_attribute_given
            content = inflector.humanize(content.split(INPUT_NAME_SEPARATOR).last)
          end

          html.label(content, **attributes, &blk)
        end

        # Fieldset
        #
        # @param content [Symbol,String,NilClass] the content
        # @param attributes [Hash] HTML attributes to pass to the label tag
        #
        # @since 1.0.0
        #
        # @example Basic usage
        #   <%=
        #     # ...
        #     fieldset do
        #       legend "Author"
        #
        #       fields_for :author do
        #         label :name
        #         text_field :name
        #       end
        #     end
        #   %>
        #
        #   <!-- output -->
        #   <fieldset>
        #     <legend>Author</legend>
        #     <label for="book-author-name">Name</label>
        #     <input type="text" name="book[author][name]" id="book-author-name" value="">
        #   </fieldset>
        def fieldset(...)
          # This is here only for documentation purposes
          html.fieldset(...)
        end

        # Check box
        #
        # It renders a check box input.
        #
        # When a form is submitted, browsers don't send the value of unchecked
        # check boxes. If an user unchecks a check box, their browser won't send
        # the unchecked value. On the server side the corresponding value is
        # missing, so the application will assume that the user action never
        # happened.
        #
        # To solve this problem the form renders a hidden field with the
        # "unchecked value". When the user unchecks the input, the browser will
        # ignore it, but it will still send the value of the hidden input. See
        # the examples below.
        #
        # When editing a resource, the form automatically assigns the
        # <tt>checked="checked"</tt> attribute.
        #
        # @param name [Symbol] the input name
        # @param attributes [Hash] HTML attributes to pass to the input tag
        # @option attributes [String] :checked_value (defaults to "1")
        # @option attributes [String] :unchecked_value (defaults to "0")
        #
        # @since 0.2.0
        #
        # @example Basic usage
        #   <%=
        #     check_box :free_shipping
        #   %>
        #
        #   <!-- output -->
        #   <input type="hidden" name="delivery[free_shipping]" value="0">
        #   <input type="checkbox" name="delivery[free_shipping]" id="delivery-free-shipping" value="1">
        #
        # @example HTML Attributes
        #   <%=
        #     check_box :free_shipping, class: "form-check-input"
        #   %>
        #
        #   <!-- output -->
        #   <input type="hidden" name="delivery[free_shipping]" value="0">
        #   <input type="checkbox" name="delivery[free_shipping]" id="delivery-free-shipping" value="1" class="form-check-input">
        #
        # @example Specify (un)checked values
        #   <%=
        #     check_box :free_shipping, checked_value: 'true', unchecked_value: 'false'
        #   %>
        #
        #   <!-- output -->
        #   <input type="hidden" name="delivery[free_shipping]" value="false">
        #   <input type="checkbox" name="delivery[free_shipping]" id="delivery-free-shipping" value="true">
        #
        # @example Automatic "checked" attribute
        #   # For this example the params are:
        #   #
        #   #  { delivery: { free_shipping: '1' } }
        #   <%=
        #     check_box :free_shipping
        #   %>
        #
        #   <!-- output -->
        #   <input type="hidden" name="delivery[free_shipping]" value="0">
        #   <input type="checkbox" name="delivery[free_shipping]" id="delivery-free-shipping" value="1" checked="checked">
        #
        # @example Force "checked" attribute
        #   # For this example the params are:
        #   #
        #   #  { delivery: { free_shipping: '0' } }
        #   <%=
        #     check_box :free_shipping, checked: 'checked'
        #   %>
        #
        #   <!-- output -->
        #   <input type="hidden" name="delivery[free_shipping]" value="0">
        #   <input type="checkbox" name="delivery[free_shipping]" id="delivery-free-shipping" value="1" checked="checked">
        #
        # @example Multiple check boxes
        #   <%=
        #     check_box :languages, name: 'book[languages][]', value: 'italian', id: nil
        #     check_box :languages, name: 'book[languages][]', value: 'english', id: nil
        #   %>
        #
        #   <!-- output -->
        #   <input type="checkbox" name="book[languages][]" value="italian">
        #   <input type="checkbox" name="book[languages][]" value="english">
        #
        # @example Automatic "checked" attribute for multiple check boxes
        #   # For this example the params are:
        #   #
        #   #  { book: { languages: ['italian'] } }
        #   <%=
        #     check_box :languages, name: 'book[languages][]', value: 'italian', id: nil
        #     check_box :languages, name: 'book[languages][]', value: 'english', id: nil
        #   %>
        #
        #   <!-- output -->
        #   <input type="checkbox" name="book[languages][]" value="italian" checked="checked">
        #   <input type="checkbox" name="book[languages][]" value="english">
        def check_box(name, **attributes)
          _hidden_field_for_check_box(name, attributes)
          input(**_attributes_for_check_box(name, attributes))
        end

        # Color input
        #
        # @param name [Symbol] the input name
        # @param attributes [Hash] HTML attributes to pass to the input tag
        #
        # @since 0.2.0
        #
        # @example Basic usage
        #   <%=
        #     # ...
        #     color_field :background
        #   %>
        #
        #   <!-- output -->
        #   <input type="color" name="user[background]" id="user-background" value="">
        #
        # @example HTML Attributes
        #   <%=
        #     # ...
        #     color_field :background, class: "form-control"
        #   %>
        #
        #   <!-- output -->
        #   <input type="color" name="user[background]" id="user-background" value="" class="form-control">
        def color_field(name, **attributes)
          input(**_attributes(:color, name, attributes))
        end

        # Date input
        #
        # @param name [Symbol] the input name
        # @param attributes [Hash] HTML attributes to pass to the input tag
        #
        # @since 0.2.0
        #
        # @example Basic usage
        #   <%=
        #     # ...
        #     date_field :birth_date
        #   %>
        #
        #   <!-- output -->
        #   <input type="date" name="user[birth_date]" id="user-birth-date" value="">
        #
        # @example HTML Attributes
        #   <%=
        #     # ...
        #     date_field :birth_date, class: "form-control"
        #   %>
        #
        #   <!-- output -->
        #   <input type="date" name="user[birth_date]" id="user-birth-date" value="" class="form-control">
        def date_field(name, **attributes)
          input(**_attributes(:date, name, attributes))
        end

        # Datetime input
        #
        # @param name [Symbol] the input name
        # @param attributes [Hash] HTML attributes to pass to the input tag
        #
        # @since 0.2.0
        #
        # @example Basic usage
        #   <%=
        #     # ...
        #     datetime_field :delivered_at
        #   %>
        #
        #   <!-- output -->
        #   <input type="datetime" name="delivery[delivered_at]" id="delivery-delivered-at" value="">
        #
        # @example HTML Attributes
        #   <%=
        #     # ...
        #     datetime_field :delivered_at, class: "form-control"
        #   %>
        #
        #   <!-- output -->
        #   <input type="datetime" name="delivery[delivered_at]" id="delivery-delivered-at" value="" class="form-control">
        def datetime_field(name, **attributes)
          input(**_attributes(:datetime, name, attributes))
        end

        # Datetime Local input
        #
        # @param name [Symbol] the input name
        # @param attributes [Hash] HTML attributes to pass to the input tag
        #
        # @since 0.2.0
        #
        # @example Basic usage
        #   <%=
        #     # ...
        #     datetime_local_field :delivered_at
        #   %>
        #
        #   <!-- output -->
        #   <input type="datetime-local" name="delivery[delivered_at]" id="delivery-delivered-at" value="">
        #
        # @example HTML Attributes
        #   <%=
        #     # ...
        #     datetime_local_field :delivered_at, class: "form-control"
        #   %>
        #
        #   <!-- output -->
        #   <input type="datetime-local" name="delivery[delivered_at]" id="delivery-delivered-at" value="" class="form-control">
        def datetime_local_field(name, **attributes)
          input(**_attributes(:"datetime-local", name, attributes))
        end

        # Time field
        #
        # @param name [Symbol] the input name
        # @param attributes [Hash] HTML attributes to pass to the input tag
        #
        # @since 1.0.0
        #
        # @example Basic usage
        #   <%=
        #     # ...
        #     time_field :release_hour
        #   %>
        #
        #   <!-- output -->
        #   <input type="time" name="book[release_hour]" id="book-release-hour" value="">
        #
        # @example HTML Attributes
        #   <%=
        #     # ...
        #     time_field :release_hour, class: "form-control"
        #   %>
        #
        #   <!-- output -->
        #   <input type="time" name="book[release_hour]" id="book-release-hour" value="" class="form-control">
        def time_field(name, **attributes)
          input(**_attributes(:time, name, attributes))
        end

        # Month field
        #
        # @param name [Symbol] the input name
        # @param attributes [Hash] HTML attributes to pass to the input tag
        #
        # @since 1.0.0
        #
        # @example Basic usage
        #   <%=
        #     # ...
        #     month_field :release_month
        #   %>
        #
        #   <!-- output -->
        #   <input type="month" name="book[release_month]" id="book-release-month" value="">
        #
        # @example HTML Attributes
        #   <%=
        #     # ...
        #     month_field :release_month, class: "form-control"
        #   %>
        #
        #   <!-- output -->
        #   <input type="month" name="book[release_month]" id="book-release-month" value="" class="form-control">
        def month_field(name, **attributes)
          input(**_attributes(:month, name, attributes))
        end

        # Week field
        #
        # @param name [Symbol] the input name
        # @param attributes [Hash] HTML attributes to pass to the input tag
        #
        # @since 1.0.0
        #
        # @example Basic usage
        #   <%=
        #     # ...
        #     week_field :release_week
        #   %>
        #
        #   <!-- output -->
        #   <input type="week" name="book[release_week]" id="book-release-week" value="">
        #
        # @example HTML Attributes
        #   <%=
        #     # ...
        #     week_field :release_week, class: "form-control"
        #   %>
        #
        #   <!-- output -->
        #   <input type="week" name="book[release_week]" id="book-release-week" value="" class="form-control">
        def week_field(name, **attributes)
          input(**_attributes(:week, name, attributes))
        end

        # Email input
        #
        # @param name [Symbol] the input name
        # @param attributes [Hash] HTML attributes to pass to the input tag
        #
        # @since 0.2.0
        #
        # @example Basic usage
        #   <%=
        #     # ...
        #     email_field :email
        #   %>
        #
        #   <!-- output -->
        #   <input type="email" name="user[email]" id="user-email" value="">
        #
        # @example HTML Attributes
        #   <%=
        #     # ...
        #     email_field :email, class: "form-control"
        #   %>
        #
        #   <!-- output -->
        #   <input type="email" name="user[email]" id="user-email" value="" class="form-control">
        def email_field(name, **attributes)
          input(**_attributes(:email, name, attributes))
        end

        # URL input
        #
        # @param name [Symbol] the input name
        # @param attributes [Hash] HTML attributes to pass to the input tag
        #
        # @since 1.0.0
        #
        # @example Basic usage
        #   <%=
        #     # ...
        #     url_field :website
        #   %>
        #
        #   <!-- output -->
        #   <input type="url" name="user[website]" id="user-website" value="">
        #
        # @example HTML Attributes
        #   <%=
        #     # ...
        #     url_field :website, class: "form-control"
        #   %>
        #
        #   <!-- output -->
        #   <input type="url" name="user[website]" id="user-website" value="" class="form-control">
        def url_field(name, **attributes)
          attrs         = attributes.dup
          attrs[:value] = escape_url(attrs.fetch(:value) { _value(name) })

          input(**_attributes(:url, name, attrs))
        end

        # Telephone input
        #
        # @param name [Symbol] the input name
        # @param attributes [Hash] HTML attributes to pass to the input tag
        #
        # @since 1.0.0
        #
        # @example Basic usage
        #   <%=
        #     # ...
        #     tel_field :telephone
        #   %>
        #
        #   <!-- output -->
        #   <input type="tel" name="user[telephone]" id="user-telephone" value="">
        #
        # @example HTML Attributes
        #   <%=
        #     # ...
        #     telurl_field :telephone, class: "form-control"
        #   %>
        #
        #   <!-- output -->
        #   <input type="tel" name="user[telephone]" id="user-telephone" value="" class="form-control">
        def tel_field(name, **attributes)
          input(**_attributes(:tel, name, attributes))
        end

        # Hidden input
        #
        # @param name [Symbol] the input name
        # @param attributes [Hash] HTML attributes to pass to the input tag
        #
        # @since 0.2.0
        #
        # @example Basic usage
        #   <%=
        #     # ...
        #     hidden_field :customer_id
        #   %>
        #
        #   <!-- output -->
        #   <input type="hidden" name="delivery[customer_id]" id="delivery-customer-id" value="">
        def hidden_field(name, **attributes)
          input(**_attributes(:hidden, name, attributes))
        end

        # File input
        #
        # **PLEASE REMEMBER TO ADD <tt>enctype: 'multipart/form-data'</tt> ATTRIBUTE TO THE FORM**
        #
        # @param name [Symbol] the input name
        # @param attributes [Hash] HTML attributes to pass to the input tag
        # @option attributes [String,Array] :accept Optional set of accepted MIME Types
        # @option attributes [TrueClass,FalseClass] :multiple Optional, allow multiple file upload
        #
        # @since 0.2.0
        #
        # @example Basic usage
        #   <%=
        #     # ...
        #     file_field :avatar
        #   %>
        #
        #   <!-- output -->
        #   <input type="file" name="user[avatar]" id="user-avatar">
        #
        # @example HTML Attributes
        #   <%=
        #     # ...
        #     file_field :avatar, class: "avatar-upload"
        #   %>
        #
        #   <!-- output -->
        #   <input type="file" name="user[avatar]" id="user-avatar" class="avatar-upload">
        #
        # @example Accepted MIME Types
        #   <%=
        #     # ...
        #     file_field :resume, accept: 'application/pdf,application/ms-word'
        #   %>
        #
        #   <!-- output -->
        #   <input type="file" name="user[resume]" id="user-resume" accept="application/pdf,application/ms-word">
        #
        # @example Accepted MIME Types (as array)
        #   <%=
        #     # ...
        #     file_field :resume, accept: ['application/pdf', 'application/ms-word']
        #   %>
        #
        #   <!-- output -->
        #   <input type="file" name="user[resume]" id="user-resume" accept="application/pdf,application/ms-word">
        #
        # @example Accepted multiple file upload (as array)
        #   <%=
        #     # ...
        #     file_field :resume, multiple: true
        #   %>
        #
        #   <!-- output -->
        #   <input type="file" name="user[resume]" id="user-resume" multiple="multiple">
        def file_field(name, **attributes)
          attributes[:accept] = Array(attributes[:accept]).join(ACCEPT_SEPARATOR) if attributes.key?(:accept)
          attributes = {type: :file, name: _input_name(name), id: _input_id(name)}.merge(attributes)

          input(**attributes)
        end

        # Number input
        #
        # You can also make use of the `max`, `min`, and `step` attributes for
        # the HTML5 number field.
        #
        # @param name [Symbol] the input name
        # @param attributes [Hash] HTML attributes to pass to the number input
        #
        # @example Basic usage
        #   <%=
        #     # ...
        #     number_field :percent_read
        #   %>
        #
        #   <!-- output -->
        #   <input type="number" name="book[percent_read]" id="book-percent-read" value="">
        #
        # @example Advanced attributes
        #   <%=
        #     # ...
        #     number_field :priority, min: 1, max: 10, step: 1
        #   %>
        #
        #   <!-- output -->
        #   <input type="number" name="book[percent_read]" id="book-precent-read" value="" min="1" max="10" step="1">
        def number_field(name, **attributes)
          input(**_attributes(:number, name, attributes))
        end

        # Range input
        #
        # You can also make use of the `max`, `min`, and `step` attributes for
        # the HTML5 number field.
        #
        # @param name [Symbol] the input name
        # @param attributes [Hash] HTML attributes to pass to the number input
        #
        # @since 1.0.0
        #
        # @example Basic usage
        #   <%=
        #     # ...
        #     range_field :discount_percentage
        #   %>
        #
        #   <!-- output -->
        #   <input type="range" name="book[discount_percentage]" id="book-discount-percentage" value="">
        #
        # @example Advanced attributes
        #   <%=
        #     # ...
        #     range_field :discount_percentage, min: 1, max: 10, step: 1
        #   %>
        #
        #   <!-- output -->
        #   <input type="number" name="book[discount_percentage]" id="book-discount-percentage" value="" min="1" max="10" step="1">
        def range_field(name, **attributes)
          input(**_attributes(:range, name, attributes))
        end

        # Text-area input
        #
        # @param name [Symbol] the input name
        # @param content [String] the content of the textarea
        # @param attributes [Hash] HTML attributes to pass to the textarea tag
        #
        # @since 0.2.5
        #
        # @example Basic usage
        #   <%=
        #     # ...
        #     text_area :hobby
        #   %>
        #
        #   <!-- output -->
        #   <textarea name="user[hobby]" id="user-hobby"></textarea>
        #
        # @example Set content
        #   <%=
        #     # ...
        #     text_area :hobby, 'Football'
        #   %>
        #
        #   <!-- output -->
        #   <textarea name="user[hobby]" id="user-hobby">Football</textarea>
        #
        # @example Set content and HTML attributes
        #   <%=
        #     # ...
        #     text_area :hobby, 'Football', class: 'form-control'
        #   %>
        #
        #   <!-- output -->
        #   <textarea name="user[hobby]" id="user-hobby" class="form-control">Football</textarea>
        #
        # @example Omit content and specify HTML attributes
        #   <%=
        #     # ...
        #     text_area :hobby, class: 'form-control'
        #   %>
        #
        #   <!-- output -->
        #   <textarea name="user[hobby]" id="user-hobby" class="form-control"></textarea>
        #
        # @example Force blank value
        #   <%=
        #     # ...
        #     text_area :hobby, '', class: 'form-control'
        #   %>
        #
        #   <!-- output -->
        #   <textarea name="user[hobby]" id="user-hobby" class="form-control"></textarea>
        def text_area(name, content = nil, **attributes)
          if content.respond_to?(:to_hash)
            attributes = content
            content    = nil
          end

          attributes = {name: _input_name(name), id: _input_id(name)}.merge(attributes)
          html.textarea(content || _value(name), **attributes)
        end

        # Text input
        #
        # @param name [Symbol] the input name
        # @param attributes [Hash] HTML attributes to pass to the input tag
        #
        # @since 0.2.0
        #
        # @example Basic usage
        #   <%=
        #     # ...
        #     text_field :first_name
        #   %>
        #
        #   <!-- output -->
        #   <input type="text" name="user[first_name]" id="user-first-name" value="">
        #
        # @example HTML Attributes
        #   <%=
        #     # ...
        #     text_field :first_name, class: "form-control"
        #   %>
        #
        #   <!-- output -->
        #   <input type="text" name="user[first_name]" id="user-first-name" value="" class="form-control">
        def text_field(name, **attributes)
          input(**_attributes(:text, name, attributes))
        end
        alias_method :input_text, :text_field

        # Search input
        #
        # @param name [Symbol] the input name
        # @param attributes [Hash] HTML attributes to pass to the input tag
        #
        # @since 1.0.0
        #
        # @example Basic usage
        #   <%=
        #     # ...
        #     search_field :q
        #   %>
        #
        #   <!-- output -->
        #   <input type="search" name="search[q]" id="search-q" value="">
        #
        # @example HTML Attributes
        #   <%=
        #     # ...
        #     search_field :q, class: "form-control"
        #   %>
        #
        #   <!-- output -->
        #   <input type="search" name="search[q]" id="search-q" value="" class="form-control">
        def search_field(name, **attributes)
          input(**_attributes(:search, name, attributes))
        end

        # Radio input
        #
        # If request params have a value that corresponds to the given value,
        # it automatically sets the <tt>checked</tt> attribute.
        # This Hanami::Controller integration happens without any developer intervention.
        #
        # @param name [Symbol] the input name
        # @param value [String] the input value
        # @param attributes [Hash] HTML attributes to pass to the input tag
        #
        # @since 0.2.0
        #
        # @example Basic usage
        #   <%=
        #     # ...
        #     radio_button :category, 'Fiction'
        #     radio_button :category, 'Non-Fiction'
        #   %>
        #
        #   <!-- output -->
        #   <input type="radio" name="book[category]" value="Fiction">
        #   <input type="radio" name="book[category]" value="Non-Fiction">
        #
        # @example HTML Attributes
        #   <%=
        #     # ...
        #     radio_button :category, 'Fiction', class: "form-check"
        #     radio_button :category, 'Non-Fiction', class: "form-check"
        #   %>
        #
        #   <!-- output -->
        #   <input type="radio" name="book[category]" value="Fiction" class="form-check">
        #   <input type="radio" name="book[category]" value="Non-Fiction" class="form-check">
        #
        # @example Automatic checked value
        #   # Given the following params:
        #   #
        #   # book: {
        #   #   category: 'Non-Fiction'
        #   # }
        #
        #   <%=
        #     # ...
        #     radio_button :category, 'Fiction'
        #     radio_button :category, 'Non-Fiction'
        #   %>
        #
        #   <!-- output -->
        #   <input type="radio" name="book[category]" value="Fiction">
        #   <input type="radio" name="book[category]" value="Non-Fiction" checked="checked">
        def radio_button(name, value, **attributes)
          attributes = {type: :radio, name: _input_name(name), value: value}.merge(attributes)
          attributes[:checked] = CHECKED if _value(name).to_s == value.to_s
          input(**attributes)
        end

        # Password input
        #
        # @param name [Symbol] the input name
        # @param attributes [Hash] HTML attributes to pass to the input tag
        #
        # @since 0.2.0
        #
        # @example Basic usage
        #   <%=
        #     # ...
        #     password_field :password
        #   %>
        #
        #   <!-- output -->
        #   <input type="password" name="signup[password]" id="signup-password" value="">
        def password_field(name, **attributes)
          attrs = {type: :password, name: _input_name(name), id: _input_id(name), value: nil}.merge(attributes)
          attrs[:value] = EMPTY_STRING if attrs[:value].nil?

          input(**attrs)
        end

        # Select input
        #
        # @param name [Symbol] the input name
        # @param values [Hash] a Hash to generate <tt><option></tt> tags.
        # @param attributes [Hash] HTML attributes to pass to the input tag
        #
        # Values is used to generate the list of <tt>&lt;option&gt;</tt> tags, it is an
        # <tt>Enumerable</tt> of pairs of content (the displayed text) and value (the tag's
        # attribute), in that respective order (please refer to the examples for more clarity).
        #
        # If request params have a value that corresponds to one of the given values,
        # it automatically sets the <tt>selected</tt> attribute on the <tt><option></tt> tag.
        # This Hanami::Controller integration happens without any developer intervention.
        #
        # @since 0.2.0
        #
        # @example Basic usage
        #   <%=
        #     # ...
        #     values = Hash['Italy' => 'it', 'United States' => 'us']
        #     select :store, values
        #   %>
        #
        #   <!-- output -->
        #   <select name="book[store]" id="book-store">
        #     <option value="it">Italy</option>
        #     <option value="us">United States</option>
        #   </select>
        #
        # @example HTML Attributes
        #   <%=
        #     # ...
        #     values = Hash['Italy' => 'it', 'United States' => 'us']
        #     select :store, values, class: "form-control"
        #   %>
        #
        #   <!-- output -->
        #   <select name="book[store]" id="book-store" class="form-control">
        #     <option value="it">Italy</option>
        #     <option value="us">United States</option>
        #   </select>
        #
        # @example Automatic selected option
        #   # Given the following params:
        #   #
        #   # book: {
        #   #   store: 'it'
        #   # }
        #
        #   <%=
        #     # ...
        #     values = Hash['Italy' => 'it', 'United States' => 'us']
        #     select :store, values
        #   %>
        #
        #   <!-- output -->
        #   <select name="book[store]" id="book-store">
        #     <option value="it" selected="selected">Italy</option>
        #     <option value="us">United States</option>
        #   </select>
        #
        # @example Prompt option
        #   <%=
        #     # ...
        #     values = Hash['Italy' => 'it', 'United States' => 'us']
        #     select :store, values, options: { prompt: 'Select a store' }
        #   %>
        #
        #   <!-- output -->
        #   <select name="book[store]" id="book-store">
        #     <option>Select a store</option>
        #     <option value="it">Italy</option>
        #     <option value="us">United States</option>
        #   </select>
        #
        # @example Selected option
        #   <%=
        #     # ...
        #     values = Hash['Italy' => 'it', 'United States' => 'us']
        #     select :store, values, options: { selected: book.store }
        #   %>
        #
        #   <!-- output -->
        #   <select name="book[store]" id="book-store">
        #     <option value="it" selected="selected">Italy</option>
        #     <option value="us">United States</option>
        #   </select>
        #
        # @example Prompt option and HTML attributes
        #   <%=
        #     # ...
        #     values = Hash['Italy' => 'it', 'United States' => 'us']
        #     select :store, values, options: { prompt: 'Select a store' }, class: "form-control"
        #   %>
        #
        #   <!-- output -->
        #   <select name="book[store]" id="book-store" class="form-control">
        #     <option disabled="disabled">Select a store</option>
        #     <option value="it">Italy</option>
        #     <option value="us">United States</option>
        #   </select>
        #
        # @example Multiple select
        #   <%=
        #     # ...
        #     values = Hash['Italy' => 'it', 'United States' => 'us']
        #     select :stores, values, multiple: true
        #   %>
        #
        #   <!-- output -->
        #   <select name="book[store][]" id="book-store" multiple="multiple">
        #    <option value="it">Italy</option>
        #     <option value="us">United States</option>
        #   </select>
        #
        # @example Multiple select and HTML attributes
        #   <%=
        #     # ...
        #     values = Hash['Italy' => 'it', 'United States' => 'us']
        #     select :stores, values, multiple: true, class: "form-control"
        #   %>
        #
        #   <!-- output -->
        #   <select name="book[store][]" id="book-store" multiple="multiple" class="form-control">
        #     <option value="it">Italy</option>
        #     <option value="us">United States</option>
        #   </select>
        #
        # @example Array with repeated entries
        #   <%=
        #     # ...
        #     values = [['Italy', 'it'],
        #               ['---', ''],
        #               ['Afghanistan', 'af'],
        #               ...
        #               ['Italy', 'it'],
        #               ...
        #               ['Zimbabwe', 'zw']]
        #     select :stores, values
        #   %>
        #
        #   <!-- output -->
        #   <select name="book[store]" id="book-store">
        #     <option value="it">Italy</option>
        #     <option value="">---</option>
        #     <option value="af">Afghanistan</option>
        #     ...
        #     <option value="it">Italy</option>
        #     ...
        #     <option value="zw">Zimbabwe</option>
        #   </select>
        def select(name, values, **attributes)
          options     = attributes.delete(:options) { {} }
          multiple    = attributes[:multiple]
          attributes  = {name: _select_input_name(name, multiple), id: _input_id(name)}.merge(attributes)
          prompt      = options.delete(:prompt)
          selected    = options.delete(:selected)
          input_value = _value(name)

          option_html = HtmlHelper::HtmlBuilder.new

          already_selected = nil
          option_html.option(prompt, disabled: true) if prompt
          values.each do |content, value|
            if (multiple || !already_selected) && (already_selected = _select_option_selected?(value, selected, input_value, multiple))
              option_html.option(content, **{value: value, selected: true}.merge(options))
            else
              option_html.option(content, **{value: value}.merge(options))
            end
          end

          html.select(option_html, **attributes)
        end

        # Datalist input
        #
        # @param name [Symbol] the input name
        # @param values [Array,Hash] a collection that is transformed into <tt><option></tt> tags.
        # @param list [String] the name of list for the text input, it's also the id of datalist
        # @param attributes [Hash] HTML attributes to pass to the input tag
        #
        # @since 0.4.0
        #
        # @example Basic Usage
        #   <%=
        #     # ...
        #     values = ['Italy', 'United States']
        #     datalist :stores, values, 'books'
        #   %>
        #
        #   <!-- output -->
        #   <input type="text" name="book[store]" id="book-store" value="" list="books">
        #   <datalist id="books">
        #     <option value="Italy"></option>
        #     <option value="United States"></option>
        #   </datalist>
        #
        # @example Options As Hash
        #   <%=
        #     # ...
        #     values = Hash['Italy' => 'it', 'United States' => 'us']
        #     datalist :stores, values, 'books'
        #   %>
        #
        #   <!-- output -->
        #   <input type="text" name="book[store]" id="book-store" value="" list="books">
        #   <datalist id="books">
        #     <option value="Italy">it</option>
        #     <option value="United States">us</option>
        #   </datalist>
        #
        # @example Specify Custom Attributes For Datalist Input
        #   <%=
        #     # ...
        #     values = ['Italy', 'United States']
        #     datalist :stores, values, 'books', datalist: { class: 'form-control' }
        #   %>
        #
        #   <!-- output -->
        #   <input type="text" name="book[store]" id="book-store" value="" list="books">
        #   <datalist id="books" class="form-control">
        #     <option value="Italy"></option>
        #     <option value="United States"></option>
        #   </datalist>
        #
        # @example Specify Custom Attributes For Options List
        #   <%=
        #     # ...
        #     values = ['Italy', 'United States']
        #     datalist :stores, values, 'books', options: { class: 'form-control' }
        #   %>
        #
        #   <!-- output -->
        #   <input type="text" name="book[store]" id="book-store" value="" list="books">
        #   <datalist id="books">
        #     <option value="Italy" class="form-control"></option>
        #     <option value="United States" class="form-control"></option>
        #   </datalist>
        def datalist(name, values, list, **attributes)
          attrs    = attributes.dup
          options  = attrs.delete(:options)  || {}
          datalist = attrs.delete(:datalist) || {}

          attrs[:list]  = list
          datalist[:id] = list

          text_field(name, **attrs)
          html.datalist(**datalist) do
            values.each do |value, content|
              option(content, **{value: value}.merge(options))
            end
          end
        end

        # Button
        #
        # @overload button(content, attributes = {})
        #   Use string content
        #   @param content [String] The content
        #   @param attributes [Hash] HTML attributes to pass to the button tag
        #
        # @overload button(attributes = {}, &blk)
        #   Use block content
        #   @param attributes [Hash] HTML attributes to pass to the button tag
        #   @param blk [Proc] the block content
        #
        # @since 1.0.0
        #
        # @example Basic usage
        #   <%=
        #     # ...
        #     button 'Click me'
        #   %>
        #
        #   <!-- output -->
        #   <button>Click me</button>
        #
        # @example HTML Attributes
        #   <%=
        #     # ...
        #     button 'Click me', class: "btn btn-secondary"
        #   %>
        #
        #   <!-- output -->
        #   <button class="btn btn-secondary">Click me</button>
        #
        # @example Block
        #   <%=
        #     # ...
        #     button class: "btn btn-secondary" do
        #       span class: 'oi oi-check'
        #     end
        #   %>
        #
        #   <!-- output -->
        #   <button class="btn btn-secondary">
        #     <span class="oi oi-check"></span>
        #   </button>
        def button(...)
          html.button(...)
        end

        # Image button
        #
        # Visual submit button
        #
        # **Please note:** for security reasons, please use the absolute URL of the image
        #
        # @param source [String] The **absolute URL** of the image
        # @param attributes [Hash] HTML attributes to pass to the button tag
        #
        # @since 1.0.0
        #
        # @example Basic usage
        #   <%=
        #     # ...
        #     image_button "https://hanamirb.org/assets/button.png"
        #   %>
        #
        #   <!-- output -->
        #   <input type="image" src="https://hanamirb.org/assets/button.png">
        #
        # @example HTML Attributes
        #   <%=
        #     # ...
        #     image_button "https://hanamirb.org/assets/button.png", name: "image", width: "50"
        #   %>
        #
        #   <!-- output -->
        #   <input name="image" width="50" type="image" src="https://hanamirb.org/assets/button.png">
        def image_button(source, **attributes)
          attributes[:type] = :image
          attributes[:src]  = escape_url(source)

          input(**attributes)
        end

        # Submit button
        #
        # @overload submit(content, attributes = {})
        #   Use string content
        #   @param content [String] The content
        #   @param attributes [Hash] HTML attributes to pass to the button tag
        #
        # @overload submit(attributes = {}, &blk)
        #   Use block content
        #   @param attributes [Hash] HTML attributes to pass to the button tag
        #   @param blk [Proc] the block content
        #
        # @since 0.2.0
        #
        # @example Basic usage
        #   <%=
        #     # ...
        #     submit 'Create'
        #   %>
        #
        #   <!-- output -->
        #   <button type="submit">Create</button>
        #
        # @example HTML Attributes
        #   <%=
        #     # ...
        #     submit 'Create', class: "btn btn-primary"
        #   %>
        #
        #   <!-- output -->
        #   <button type="submit" class="btn btn-primary">Create</button>
        #
        # @example Block
        #   <%=
        #     # ...
        #     button class: "btn btn-primary" do
        #       span class: 'oi oi-check'
        #     end
        #   %>
        #
        #   <!-- output -->
        #   <button type="submit" class="btn btn-primary">
        #     <span class="oi oi-check"></span>
        #   </button>
        def submit(content = nil, **attributes, &blk)
          if content.is_a?(::Hash)
            attributes = content
            content = nil
          end

          attributes = {type: :submit}.merge(attributes)
          html.button(content, **attributes, &blk)
        end

        def input(...)
          html.input(...)
        end

        private

        attr_reader :html, :inflector

        def _form_method(attributes)
          attributes[:method] ||= DEFAULT_METHOD
          attributes[:method] = attributes[:method].to_s.upcase

          original_form_method = attributes[:method]

          if (method_override = !BROWSER_METHODS.include?(attributes[:method]))
            attributes[:method] = DEFAULT_METHOD
          end

          [method_override, original_form_method]
        end

        def _csrf_token(values, attributes)
          return [] if values.csrf_token.nil?

          return [] if EXCLUDED_CSRF_METHODS.include?(attributes[:method])

          [true, values.csrf_token]
        end

        def method_missing(method_name, *args, **kwargs, &blk)
          if html.respond_to?(method_name)
            html.__send__(method_name, *args, **kwargs, &blk)
          else
            super
          end
        end

        def respond_to_missing?(method_name, include_all)
          html.respond_to?(method_name, include_all)
        end

        # Return a set of default HTML attributes
        #
        # @api private
        # @since 0.2.0
        def _attributes(type, name, attributes)
          input_name = _input_name(name)

          attrs = {type: type, name: input_name, id: _input_id(name), value: _value_from_input_name(input_name)}
          attrs.merge!(attributes)
          attrs[:value] = escape_html(attrs[:value])
          attrs
        end

        # Full input name, used to construct the input
        # attributes.
        #
        # @api private
        # @since 0.2.0
        def _input_name(name)
          token, *tokens = name.split(INPUT_NAME_SEPARATOR)
          result = String.new(token)

          tokens.each do |t|
            result << "["
            result << t
          end

          result << ("]" * tokens.size)

          result
        end

        # Input <tt>id</tt> HTML attribute
        #
        # @api private
        # @since 0.2.0
        def _input_id(name)
          name.tr("._", "-")
        end

        # Input <tt>value</tt> HTML attribute
        #
        # @api private
        # @since 0.2.0
        def _value(name)
          _value_from_input_name(_input_name(name))
        end

        # Input <tt>value</tt> HTML attribute
        #
        # @api private
        # @since 0.2.0
        def _value_from_input_name(input_name)
          @values.get(
            *input_name.split(/[\[\]]+/).map(&:to_sym)
          )
        end

        # Input <tt>for</tt> HTML attribute
        #
        # @api private
        # @since 0.2.0
        def _for(content, name)
          _input_id(name || content)
        end

        # Hidden field for check box
        #
        # @api private
        # @since 0.2.0
        #
        # @see Hanami::Helpers::FormHelper::FormBuilder#check_box
        def _hidden_field_for_check_box(name, attributes)
          return unless attributes[:value].nil? || !attributes[:unchecked_value].nil?

          input(
            type: :hidden,
            name: attributes[:name] || _input_name(name),
            value: attributes.delete(:unchecked_value) || DEFAULT_UNCHECKED_VALUE
          )
        end

        # HTML attributes for check box
        #
        # @api private
        # @since 0.2.0
        #
        # @see Hanami::Helpers::FormHelper::FormBuilder#check_box
        def _attributes_for_check_box(name, attributes)
          attributes = {
            type: :checkbox,
            name: _input_name(name),
            id: _input_id(name),
            value: (attributes.delete(:checked_value) || DEFAULT_CHECKED_VALUE).to_s
          }.merge(attributes)

          attributes[:checked] = CHECKED if _check_box_checked?(attributes[:value], _value(name))

          attributes
        end

        # @api private
        # @since 1.2.0
        def _select_input_name(name, multiple)
          select_name = _input_name(name)
          select_name = "#{select_name}[]" if multiple
          select_name
        end

        # @api private
        # @since 1.2.0
        def _select_option_selected?(value, selected, input_value, multiple)
          if input_value && selected.nil?
            value.to_s == input_value.to_s
          else
            (value == selected) ||
              _is_in_selected_values?(multiple, selected, value) ||
              _is_current_value?(input_value, value) ||
              _is_in_input_values?(multiple, input_value, value)
          end
        end

        # @api private
        # @since 1.2.0
        def _is_current_value?(input_value, value)
          return unless input_value

          value.to_s == input_value.to_s
        end

        # @api private
        # @since 1.2.0
        def _is_in_selected_values?(multiple, selected, value)
          return unless multiple && selected.is_a?(Array)

          selected.include?(value)
        end

        # @api private
        # @since 1.2.0
        def _is_in_input_values?(multiple, input_value, value)
          return unless multiple && input_value.is_a?(Array)

          input_value.include?(value)
        end

        # @api private
        # @since 1.2.0
        def _check_box_checked?(value, input_value)
          !input_value.nil? &&
            (input_value.to_s == value.to_s || input_value.is_a?(TrueClass) ||
            (input_value.is_a?(Array) && input_value.include?(value)))
        end
      end
    end
  end
end
