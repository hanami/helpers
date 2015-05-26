require 'lotus/view'
require 'lotus/controller'
require 'lotus/helpers/html_helper'
require 'lotus/helpers/escape_helper'

class HtmlView
  include Lotus::Helpers::HtmlHelper

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

  def div_with_attr
    html.div(id: 'container')
  end

  # RUBY_VERSION >= '2.2'
  # def div_with_data_attr
  #   html.div('data-where': 'up')
  # end
  def div_with_data_attr
    html.div(:'data-where' => 'up')
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


class EscapeView
  include Lotus::Helpers::EscapeHelper

  def good_string
    escape_html "this is a good string"
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
    escape_url "http://lotusrb.org"
  end

  def evil_url_string
    escape_url "javascript:alert('xss')"
  end

  def raw_string
    raw "<div>I'm a raw string</div>"
  end

  def html_string_alias
    h "this is a good string"
  end

  def html_attribute_string_alias
    "<a title='#{ha('foo')}'>link</a>"
  end

  def url_string_alias
    hu "http://lotusrb.org"
  end
end

Book = Struct.new(:title)
User = Struct.new(:name, :website, :snippet)

module TestView
  def self.included(view)
    view.class_eval do
      include Lotus::View
      include Lotus::Helpers
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
            a('website', href: hu(user.website), title: "#{ ha(user.name) }'s website")
          end

          li raw(user.snippet)
        end
      end
    end
  end
end

class FormHelperView
  include Lotus::Helpers::FormHelper
  attr_reader :params

  def initialize(params)
    @params = Lotus::Action::Params.new(params)
  end
end

class Address
  attr_reader :street

  def initialize(attributes = {})
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

class DeliveryParams < Lotus::Action::Params
  param :delivery do
    param :customer_id, type: Integer, presence: true
    param :address do
      param :street, type: String, presence: true
    end
  end
end

module FullStack
  class Routes
    def self.path(name)
      _escape "/#{ name }"
    end

    def self.sessions_path
      _escape '/sessions'
    end

    def self.deliveries_path
      _escape '/deliveries'
    end

    def self.delivery_path(attrs = {})
      _escape "/deliveries/#{ attrs.fetch(:id) }"
    end

    def self._escape(string)
      Lotus::Utils::Escape::SafeString.new(string)
    end
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

    module Deliveries
      class New
        include TestView
        template 'deliveries/new'

        def form
          Form.new(:delivery, routes.deliveries_path)
        end

        def form_values
          Hash[]
        end

        def form_action
          routes.deliveries_path
        end

        def form_verb
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
                   values: {delivery: delivery})
        end

        def form_values
          Hash[delivery: delivery]
        end

        def form_action
          routes.delivery_path(id: delivery.id)
        end

        def form_verb
          :patch
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
