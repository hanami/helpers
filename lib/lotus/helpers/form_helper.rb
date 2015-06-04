require 'lotus/helpers/form_helper/form_builder'

module Lotus
  module Helpers
    # Form builder
    #
    # By including <tt>Lotus::Helpers::FormHelper</tt> it will inject one public method: <tt>form_for</tt>.
    # This is a HTML5 form builder.
    #
    # To understand the general HTML5 builder syntax of this framework, please
    # consider to have a look at <tt>Lotus::Helpers::HtmlHelper</tt> documentation.
    #
    # This builder is independent from any template engine.
    # This was hard to achieve without a compromise: the form helper should be
    # used in one output block in a template or as a method in a view (see the examples below).
    #
    # Features:
    #
    #   * Support for complex markup without the need of concatenation
    #   * Auto closing HTML5 tags
    #   * Support for view local variables
    #   * Method override support (PUT/PATCH/DELETE HTTP verbs aren't understood by browsers)
    #   * Automatic generation of HTML attributes for inputs: <tt>id</tt>, <tt>name</tt>, <tt>value</tt>
    #   * Allow to override HTML attributes
    #   * Extract values from request params and fill <tt>value</tt> attributes
    #   * Automatic selection of current value for radio button and select inputs
    #   * Infinite nested fields
    #
    # Supported tags and inputs:
    #
    #   * <tt>color_field</tt>
    #   * <tt>date_field</tt>
    #   * <tt>datetime_field</tt>
    #   * <tt>datetime_local_field</tt>
    #   * <tt>email_field</tt>
    #   * <tt>hidden_field</tt>
    #   * <tt>file_field</tt>
    #   * <tt>fields_for</tt>
    #   * <tt>form_for</tt>
    #   * <tt>label</tt>
    #   * <tt>text_field</tt>
    #   * <tt>password_field</tt>
    #   * <tt>radio_button</tt>
    #   * <tt>select</tt>
    #   * <tt>submit</tt>
    #
    # @since x.x.x
    #
    # @see Lotus::Helpers::FormHelper#form_for
    # @see Lotus::Helpers::HtmlHelper
    #
    # @example One output block (template)
    #   <%=
    #     form_for :book, routes.books_path do
    #       text_field :title
    #
    #       submit 'Create'
    #     end
    #   %>
    #
    # @example Method (view)
    #   require 'lotus/helpers'
    #
    #   class MyView
    #     include Lotus::Helpers::FormHelper
    #
    #     def my_form
    #       form_for :book, routes.books_path do
    #         text_field :title
    #       end
    #     end
    #   end
    #
    #   # Corresponding template:
    #   #
    #   #  <%= my_form %>
    module FormHelper
      # Default HTTP method for form
      #
      # @since x.x.x
      # @api private
      DEFAULT_METHOD = 'POST'.freeze

      # Default charset
      #
      # @since x.x.x
      # @api private
      DEFAULT_CHARSET = 'utf-8'.freeze

      # CSRF Token session key
      #
      # This key is shared with <tt>lotusrb</tt>, <tt>lotus-controller</tt>.
      #
      # @since x.x.x
      # @api private
      CSRF_TOKEN = :_csrf_token

      # Form object
      #
      # @since x.x.x
      class Form
        # @return [Symbol] the form name
        #
        # @since x.x.x
        # @api private
        attr_reader :name

        # @return [String] the form action
        #
        # @since x.x.x
        # @api private
        attr_reader :url

        # @return [::Hash] the form values
        #
        # @since x.x.x
        # @api private
        attr_reader :values

        # Initialize a form
        #
        # It accepts a set of values that are used in combination with request
        # params to autofill <tt>value</tt> attributes for fields.
        #
        # The keys of this Hash, MUST correspond to the structure of the (nested)
        # fields of the form.
        #
        # For a given input where the <tt>name</tt> is `book[title]`, Lotus will
        # look for `:book` key in values.
        #
        # If the current params have the same key, it will be PREFERRED over the
        # given values.
        #
        # For instance, if <tt>params.get('book.title')</tt> equals to
        # <tt>"TDD"</tt> while <tt>values[:book].title</tt> returns
        # <tt>"No test"</tt>, the first will win.
        #
        # @param name [Symbol] the name of the form
        # @param url [String] the action of the form
        # @param values [Hash,NilClass] a Hash of values to be used to autofill
        #   <tt>value</tt> attributes for fields
        # @param attributes [Hash,NilClass] a Hash of attributes to pass to the
        #   <tt>form</tt> tag
        #
        # @since x.x.x
        #
        # @example Pass A Value
        #   # Given the following view
        #
        #   module Web::Views::Deliveries
        #     class Edit
        #       include Web::View
        #
        #       def form
        #         Form.new(:delivery, routes.delivery_path(id: delivery.id),
        #         {delivery: delivery, customer: customer},
        #         {method: :patch})
        #       end
        #     end
        #   end
        #
        #   # And the corresponding template:
        #
        #   <%=
        #     form_for form do
        #       date_field :delivered_on
        #
        #       fields_for :customer do
        #         text_field :name
        #
        #         fields_for :address do
        #           # ...
        #           text_field :city
        #         end
        #       end
        #
        #       submit 'Update'
        #     end
        #   %>
        #
        #   # It will render:
        #   #
        #   #  <form action="/deliveries/1" method="POST" accept-charset="utf-8">
        #   #    <input type="hidden" name="_method" value="PATCH">
        #   #
        #   #    # Value taken from delivery.delivered_on
        #   #    <input type="date" name="delivery[delivered_on]" id="delivery-delivered-on" value="2015-05-27">
        #   #
        #   #    # Value taken from customer.name
        #   #    <input type="text" name="delivery[customer][name]" id="delivery-customer-name" value="Luca">
        #   #
        #   #    # Value taken from customer.address.city
        #   #    <input type="text" name="delivery[customer][address][city]" id="delivery-customer-address-city" value="Rome">
        #   #
        #   #    <button type="submit">Update</button>
        #   #  </form>
        def initialize(name, url, values = {}, attributes = {})
          @name       = name
          @url        = url
          @values     = values
          @attributes = attributes || {}
        end

        # Return the method specified by the given attributes or fall back to
        # the default value
        #
        # @return [String] the method for the action
        #
        # @since x.x.x
        # @api private
        #
        # @see Lotus::Helpers::FormHelper::DEFAULT_METHOD
        def verb
          @attributes.fetch(:method, DEFAULT_METHOD)
        end
      end

      # Instantiate a HTML5 form builder
      #
      # @overload form_for(name, url, options, &blk)
      #   Use inline values
      #   @param name [Symbol] the toplevel name of the form, it's used to generate
      #     input names, ids, and to lookup params to fill values.
      #   @param url [String] the form action URL
      #   @param options [Hash] HTML attributes to pass to the form tag and form values
      #   @option options [Hash] :values An optional payload of objects to pass
      #   @param blk [Proc] A block that describes the contents of the form
      #
      # @overload form_for(form, attributes, &blk)
      #   Use Form
      #   @param form [Lotus::Helpers::FormHelper::Form] a form object
      #   @param attributes [Hash] HTML attributes to pass to the form tag and form values
      #   @param blk [Proc] A block that describes the contents of the form
      #
      # @return [Lotus::Helpers::FormHelper::FormBuilder] the form builder
      #
      # @since x.x.x
      #
      # @see Lotus::Helpers::FormHelper
      # @see Lotus::Helpers::FormHelper::Form
      # @see Lotus::Helpers::FormHelper::FormBuilder
      #
      # @example Inline Values In Template
      #   <%=
      #     form_for :book, routes.books_path, class: 'form-horizontal' do
      #       div do
      #         label      :title
      #         text_field :title, class: 'form-control'
      #       end
      #
      #       submit 'Create'
      #     end
      #   %>
      #
      #   Output:
      #     # <form action="/books" method="POST" accept-charset="utf-8" id="book-form" class="form-horizontal">
      #     #   <div>
      #     #     <label for="book-title">Title</label>
      #     #     <input type="text" name="book[title]" id="book-title" value="Test Driven Development">
      #     #   </div>
      #     #
      #     #   <button type="submit">Create</button>
      #     # </form>
      #
      #
      #
      # @example Use In A View
      #
      #   module Web::Views::Books
      #     class New
      #
      #     def form
      #       form_for :book, routes.books_path, class: 'form-horizontal' do
      #         div do
      #           label      :title
      #           text_field :title, class: 'form-control'
      #         end
      #
      #         submit 'Create'
      #       end
      #     end
      #   end
      #
      #   <%= form %>
      #
      #   Output:
      #     # <form action="/books" method="POST" accept-charset="utf-8" id="book-form" class="form-horizontal">
      #     #   <div>
      #     #     <label for="book-title">Title</label>
      #     #     <input type="text" name="book[title]" id="book-title" value="Test Driven Development">
      #     #   </div>
      #     #
      #     #   <button type="submit">Create</button>
      #     # </form>
      #
      # @example Share Code Between Views
      #
      #   # Given the following views to create and update a resource
      #   module Web::Views::Books
      #     class New
      #       include Web::View
      #
      #       def form
      #         Form.new(:book, routes.books_path)
      #       end
      #
      #       def submit_label
      #         'Create'
      #       end
      #     end
      #
      #     class Edit
      #       include Web::View
      #
      #       def form
      #         Form.new(:book, routes.book_path(id: book.id),
      #           {book: book}, {method: :patch})
      #       end
      #
      #       def submit_label
      #         'Update'
      #       end
      #     end
      #   end
      #
      #   # The respective templates can be identical:
      #
      #   ## books/new.html.erb
      #   <%= render partial: 'books/form' %>
      #
      #   ## books/edit.html.erb
      #   <%= render partial: 'books/form' %>
      #
      #   # While the partial can have the following markup:
      #
      #   ## books/_form.html.erb
      #   <%=
      #     form_for form, class: 'form-horizontal' do
      #       div do
      #         label      :title
      #         text_field :title, class: 'form-control'
      #       end
      #
      #       submit submit_label
      #     end
      #   %>
      #
      #   Output:
      #     # <form action="/books" method="POST" accept-charset="utf-8" id="book-form" class="form-horizontal">
      #     #   <div>
      #     #     <label for="book-title">Title</label>
      #     #     <input type="text" name="book[title]" id="book-title" value="Test Driven Development">
      #     #   </div>
      #     #
      #     #   <button type="submit">Create</button>
      #     # </form>
      #
      # @example Method override
      #   <%=
      #     form_for :book, routes.book_path(id: book.id), method: :put do
      #       text_field :title
      #
      #       submit 'Update'
      #     end
      #   %>
      #
      #   Output:
      #     # <form action="/books/23" accept-charset="utf-8" id="book-form" method="POST">
      #     #   <input type="hidden" name="_method" value="PUT">
      #     #   <input type="text" name="book[title]" id="book-title" value="Test Driven Development">
      #     #
      #     #   <button type="submit">Update</button>
      #     # </form>
      #
      # @example Nested fields
      #   <%=
      #     form_for :delivery, routes.deliveries_path do
      #       text_field :customer_name
      #
      #       fields_for :address do
      #         text_field :city
      #       end
      #
      #       submit 'Create'
      #     end
      #   %>
      #
      #   Output:
      #     # <form action="/deliveries" accept-charset="utf-8" id="delivery-form" method="POST">
      #     #   <input type="text" name="delivery[customer_name]" id="delivery-customer-name" value="">
      #     #   <input type="text" name="delivery[address][city]" id="delivery-address-city" value="">
      #     #
      #     #   <button type="submit">Create</button>
      #     # </form>
      def form_for(name, url, options = {}, &blk)
        form = if name.is_a?(Form)
          options = url
          name
        else
          Form.new(name, url, options.delete(:values))
        end

        attributes = { action: form.url, method: form.verb, :'accept-charset' => DEFAULT_CHARSET, id: "#{ form.name }-form" }.merge(options)
        FormBuilder.new(form, attributes, self, &blk)
      end

      # Returns CSRF Protection Token stored in session.
      #
      # It returns <tt>nil</tt> if sessions aren't enabled or the value is missing.
      #
      # @return [String,NilClass] token, if present
      #
      # @since x.x.x
      def csrf_token
        if defined?(session)
          session[CSRF_TOKEN]
        elsif defined?(locals) && locals[:session]
          locals[:session][CSRF_TOKEN]
        end
      end
    end
  end
end
