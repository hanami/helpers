require 'lotus/view'
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
    u "http://lotusrb.org"
  end
end

Book = Struct.new(:title)

module Books
  class Show
    include Lotus::View
    include Lotus::Helpers
    root __dir__ + '/fixtures/templates'

    def title_widget
      html.div do
        h1 book.title
      end
    end
  end

  class Error
    include Lotus::View
    include Lotus::Helpers
    root __dir__ + '/fixtures/templates'

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

