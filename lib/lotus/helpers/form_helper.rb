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

      # Instantiate a HTML5 form builder
      #
      # @param name [Symbol] the toplevel name of the form, it's used to generate
      #   input names, ids, and to lookup params to fill values.
      # @param url [String] the form action URL
      # @param attributes [Hash] HTML attributes to pass to the form tag
      # @param blk [Proc] A block that describes the contents of the form
      #
      # @return [Lotus::Helpers::FormHelper::FormBuilder] the form builder
      #
      # @since x.x.x
      #
      # @see Lotus::Helpers::FormHelper
      # @see Lotus::Helpers::FormHelper::FormBuilder
      #
      # @example Basic usage
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
      #     # <form action="/books" id="book-form" method="POST" class="form-horizontal">
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
      #     form_for :book, routes.book_path(book.id), method: :put do
      #       text_field :title
      #
      #       submit 'Update'
      #     end
      #   %>
      #
      #   Output:
      #     # <form action="/books/23" id="book-form" method="POST">
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
      #     # <form action="/deliveries" id="delivery-form" method="POST">
      #     #   <input type="text" name="delivery[customer_name]" id="delivery-customer-name" value="">
      #     #   <input type="text" name="delivery[address][city]" id="delivery-address-city" value="">
      #     #
      #     #   <button type="submit">Create</button>
      #     # </form>
      def form_for(name, url, attributes = {}, &blk)
        attributes = { action: url, id: "#{ name }-form", method: DEFAULT_METHOD }.merge(attributes)
        FormBuilder.new(name, params, attributes, &blk)
      end
    end
  end
end
