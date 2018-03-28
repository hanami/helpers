require 'hanami/view'
require 'hanami/controller'
require 'hanami/helpers/html_helper'
require 'hanami/helpers/escape_helper'
require 'dry/struct'

module Types
  include Dry::Types.module
end

Store = Struct.new(:code, :label) do
  def to_ary
    [label, code]
  end
end

class Signup < Dry::Struct
  attribute :password, Types::String.optional
end

class HtmlView
  include Hanami::Helpers::HtmlHelper

  def empty_div
    html.div
  end

  def div_with_string_content
    html.div('hello world')
  end

  def div_with_block_content_as_string
    html.div { 'hola' }
  end

  def div_with_block_content_with_tag_helper
    html.div(html.p('inner'))
  end

  def div_with_block_content_with_nested_calls
    html.div do
      span 'hello'
    end
  end

  def div_with_block_content_and_multiple_nested_calls
    html.form(action: '/users', method: 'POST') do
      div do
        label 'First name', for: 'user-first-name'
        input type: 'text', id: 'user-first-name', name: 'user[first_name]', value: 'L'
      end

      input type: 'submit', value: 'Save changes'
    end
  end

  def concatenation_of_multiple_fragments
    hello  = html { div 'Hello' }
    hanami = html { div 'Hanami' }

    hello + hanami
  end

  def concatenation_of_multiple_divs
    html.div('Hello') + html.div('Hanami')
  end

  def concatenation_of_fragment_and_div
    html { div 'Hello' } + html.div('Hanami')
  end

  def fragment_with_block_content
    html do
      div 'Hello'
      div 'Hanami'
    end
  end

  def div_with_attr
    html.div(id: 'container')
  end

  # RUBY_VERSION >= '2.2'
  # def div_with_data_attr
  #   html.div('data-where': 'up')
  # end
  def div_with_data_attr
    html.div('data-where': 'up')
  end

  def div_with_attrs
    html.div(id: 'content', class: 'filled')
  end

  def div_with_string_content_and_attrs
    html.div('ciao', id: 'greeting', class: 'blink')
  end

  def div_with_block_content_as_string_and_attrs
    html.div(id: 'sidebar', class: 'blue') { 'bonjour' }
  end

  def custom_tag
    html.tag(:custom, 'Foo', id: 'next')
  end

  def custom_empty_tag
    html.empty_tag(:xr, id: 'next')
  end

  def evil_string_content
    html.div("<script>alert('xss')</script>")
  end

  def evil_block_content
    html.div { "<script>alert('xss')</script>" }
  end

  def evil_tag_helper
    html.div(html.p("<script>alert('xss')</script>"))
  end

  def evil_nested_block_content
    html.div do
      p "<script>alert('xss')</script>"
    end
  end
end

class NumbersView
  include Hanami::Helpers::NumberFormattingHelper

  def single_digit
    format_number 1
  end

  def thousand_digits
    format_number 1_000
  end

  def million_digits
    format_number 1_000_000
  end

  def zero_point_one
    format_number 0.1
  end

  def precision_default_format
    format_number 3.141592
  end

  def precision_format
    format_number 3.141592, precision: 4
  end

  def precision_higher_than_numbers_precision
    format_number 3.14, precision: 4
  end

  def zero_precision
    format_number 3.14, precision: 0
  end

  def mixed_digits
    format_number 5002.007, precision: 3
  end

  def euro_format
    format_number 1234.12, delimiter: '.', separator: ','
  end

  def pass_nil
    format_number nil
  end

  def pass_class_name
    format_number Object
  end

  def pass_string
    format_number 'string'
  end

  def pass_non_numeric_integer
    format_number '1'
  end

  def pass_non_numeric_float
    format_number '1.0'
  end

  def big_decimal
    format_number BigDecimal.new('0.0001'), precision: 4
  end

  def complex
    format_number Complex(1)
  end

  def rational
    format_number Rational(1)
  end

  def string
    format_number Rational(1)
  end

  def infinity
    format_number Float::INFINITY
  end

  def nan
    format_number 0.0 / 0
  end
end

class EscapeView
  include Hanami::Helpers::EscapeHelper

  def good_string
    escape_html 'this is a good string'
  end

  def evil_string
    escape_html "<script>alert('xss')</script>"
  end

  def good_attributes_string
    "<a title='#{escape_html_attribute('foo')}'>link</a>"
  end

  def evil_attributes_string
    "<a title='#{escape_html_attribute('<script>alert(\'xss\')</script>')}'>link</a>"
  end

  def good_url_string
    escape_url 'http://hanamirb.org'
  end

  def evil_url_string
    escape_url "javascript:alert('xss')"
  end

  def raw_string
    raw "<div>I'm a raw string</div>"
  end

  def html_string_alias
    h 'this is a good string'
  end

  def html_attribute_string_alias
    "<a title='#{ha('foo')}'>link</a>"
  end

  def url_string_alias
    hu 'http://hanamirb.org'
  end
end

class Book < Dry::Struct
  constructor_type :schema

  attribute :title,               Types::String.optional
  attribute :search_title,        Types::String.optional
  attribute :description,         Types::String.optional
  attribute :author_id,           Types::Form::Int.optional
  attribute :category,            Types::String.optional
  attribute :cover,               Types::String.optional
  attribute :image_cover,         Types::String.optional
  attribute :percent_read,        Types::Form::Int.optional
  attribute :discount_percentage, Types::Form::Int.optional
  attribute :published_at,        Types::String.optional
  attribute :website,             Types::String.optional
  attribute :publisher_email,     Types::String.optional
  attribute :publisher_telephone, Types::String.optional
  attribute :release_date,        Types::Form::Date.optional
  attribute :release_hour,        Types::String.optional
  attribute :release_week,        Types::String.optional
  attribute :release_month,       Types::Form::Date.optional
  attribute :store,               Types::String.optional
end

User = Struct.new(:name, :website, :snippet)

module TestView
  def self.included(view)
    view.class_eval do
      include Hanami::View
      include Hanami::Helpers
      root __dir__ + '/fixtures/templates'
    end
  end
end

module Books
  class Show
    include TestView

    def title_widget
      html.div do
        h1 book.title
      end
    end
  end

  class Error
    include TestView

    def error_widget
      html.div do
        unknown_local_variable
      end
    end

    def render
      error_widget.to_s
    end
  end
end

module Users
  class Show
    include TestView

    def title
      html.h1(user.name)
    end

    def details
      html.div(id: 'details') do
        ul do
          li do
            a('website', href: hu(user.website), title: "#{ha(user.name)}'s website")
          end

          li raw(user.snippet)
        end
      end
    end
  end
end

class FormHelperView
  include Hanami::Helpers::FormHelper
  attr_reader :params

  def initialize(params)
    @params = _build_params(params)
  end

  private

  def _build_params(params)
    parameters = params.to_h

    # Randomly use Hanami::Action::BaseParams or the given raw Hash in order to
    # simulate Hash usage during the spec setup of unit specs in Hanami projects.
    if parameters.respond_to?(:dig)
      [true, false].sample ? Hanami::Action::BaseParams.new(parameters) : parameters
    else
      Hanami::Action::BaseParams.new(parameters)
    end
  end
end

class SessionFormHelperView < FormHelperView
  def initialize(params, csrf_token)
    super(params)
    @csrf_token = csrf_token
  end

  def session
    { _csrf_token: @csrf_token }
  end
end

class Address
  attr_reader :id, :street

  def initialize(attributes = {})
    @id     = attributes[:id]
    @street = attributes[:street]
  end
end

class Delivery
  attr_reader :id, :customer_id, :address

  def initialize(attributes = {})
    @id          = attributes[:id]
    @customer_id = attributes[:customer_id]
    @address     = attributes[:address]
  end
end

class Bill
  attr_reader :id, :addresses

  def initialize(attributes = {})
    @id        = attributes[:id]
    @addresses = attributes[:addresses]
  end
end

class DeliveryParams < Hanami::Action::Params
  params do
    required(:delivery).schema do
      required(:customer_id, :int).filled
      required(:address).schema do
        required(:street, :string).filled
      end
    end
  end
end

class BillParams < Hanami::Action::Params
  params do
    required(:bill).schema do
      required(:addresses).each do
        schema do
          required(:street, :string).filled
        end
      end
    end
  end
end

class Session
  def initialize(values)
    @values = values.to_h
  end

  def [](key)
    @values[key]
  end
end

module FullStack
  class Routes
    def path(name)
      _escape "/#{name}"
    end

    def sessions_path
      _escape '/sessions'
    end

    def deliveries_path
      _escape '/deliveries'
    end

    def delivery_path(attrs = {})
      _escape "/deliveries/#{attrs.fetch(:id)}"
    end

    def bill_path(attrs = {})
      _escape "/bills/#{attrs.fetch(:id)}"
    end

    private

    def _escape(string)
      Hanami::Utils::Escape::SafeString.new(string)
    end
  end

  def self.routes
    Routes.new
  end

  module Views
    module Dashboard
      class Index
        include TestView
        root __dir__ + '/fixtures/templates/full_stack'
        template 'dashboard/index'

        def routing_helper_path
          routes.path(:dashboard)
        end
      end
    end

    module Sessions
      class New
        include TestView
        template 'sessions/new'
      end
    end

    module Cart
      class Show
        include TestView
        template 'cart/show'

        def total
          format_number locals[:total]
        end
      end
    end

    module Deliveries
      class New
        include TestView
        template 'deliveries/new'

        def form
          Form.new(:delivery, routes.deliveries_path)
        end

        def submit_label
          'Create'
        end
      end

      class Edit
        include TestView
        template 'deliveries/edit'

        def form
          Form.new(:delivery,
                   routes.delivery_path(id: delivery.id),
                   { delivery: delivery }, method: :patch)
        end

        def submit_label
          'Update'
        end
      end
    end

    module Bills
      class Edit
        include TestView
        template 'bills/edit'

        def form
          Form.new(:bill, routes.bill_path(id: bill.id), { bill: bill }, method: :patch)
        end

        def submit_label
          'Update'
        end
      end

      class Edit2
        include TestView
        template 'bills/edit2'

        def form
          Form.new(:bill, routes.bill_path(id: bill.id), { bill: bill }, method: :patch)
        end

        def submit_label
          'Update'
        end
      end
    end
  end
end

class ViewWithoutRoutingHelper
  include TestView
  root __dir__ + '/fixtures/templates/full_stack'
  template 'dashboard/index'

  def routing_helper_path
    routes.path(:dashboard)
  end
end

class LinkTo
  include Hanami::Helpers::LinkToHelper

  class Index
    include TestView

    def link_to_home
      link_to('Home', '/')
    end

    def link_to_relative
      link_to('Relative', 'relative')
    end

    def link_to_home_with_html_content
      link_to('/') do
        p 'Home with html content'
      end
    end

    def link_to_home_with_html_content_id_and_class
      link_to('/', id: 'home__link', class: 'first') do
        p 'Home with html content, id and class'
      end
    end

    def link_to_external_url_with_content
      link_to('External', 'http://external.com')
    end

    def link_to_external_url_with_html_content
      link_to('http://external.com') do
        strong 'External with html content'
      end
    end

    def link_to_xss_content
      link_to(%(<script>alert('xss')</script>), '/')
    end

    def link_to_xss_raw_content_block
      link_to('/') do
        %(<script>alert('xss2')</script>)
      end
    end

    def link_to_xss_html_builder_content_block
      link_to('/') do
        p %(<script>alert('xss3')</script>)
      end
    end
  end

  class Routes
    def self.path(name, id = nil)
      "/#{name}" << "/#{id}"
    end
  end

  def routes
    Routes
  end

  def link_to_relative_posts
    link_to('Posts', 'posts')
  end

  def link_to_posts
    link_to('Posts', routes.path(:posts))
  end

  def link_to_post
    link_to('Post', routes.path(:post, 1))
  end

  def link_to_with_class
    link_to('Post', routes.path(:posts), class: 'first')
  end

  def link_to_with_id
    link_to('Post', routes.path(:posts), id: 'posts__link')
  end

  def link_to_with_html_content
    link_to(routes.path(:posts)) do
      strong 'Post'
    end
  end

  def link_to_with_content_and_html_content
    link_to('Post', routes.path(:posts)) do
      strong 'Post'
    end
  end

  def link_to_with_html_content_id_and_class
    link_to(routes.path(:posts), id: 'posts__link', class: 'first') do
      strong 'Post'
    end
  end

  def link_to_without_args
    link_to
  end

  def link_to_without_args_and_empty_block
    link_to do
      # this block was left intentionally blank ;)
    end
  end

  def link_to_with_only_content
    link_to 'Post'
  end

  def link_to_with_content_html_content_id_and_class
    link_to('Post', routes.path(:posts), id: 'posts__link', class: 'first') do
      strong 'Post'
    end
  end
end

class HtmlAndLinkTo
  include Hanami::Helpers::HtmlHelper
  include Hanami::Helpers::LinkToHelper

  def two_links_to_in_div
    html.div do
      link_to('Comments', '/comments') +
        link_to('Posts', '/posts')
    end
  end

  def span_and_link_to_in_div
    html.div do
      span('hello') +
        link_to('Comments', '/comments')
    end
  end
end
