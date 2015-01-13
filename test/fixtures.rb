require 'lotus/helpers/html_helper'

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

  def div_with_attr
    html.div(id: 'container')
  end

  def div_with_undescore_attr
    html.div('data_where' => 'up')
  end

  def div_with_attrs
    html.div(id: 'content', class: 'filled')
  end

  # FIXME add more cases from:
  # https://html.spec.whatwg.org/multipage/syntax.html#before-attribute-name-state

  def div_with_string_content_and_attrs
    html.div('ciao', id: 'greeting', class: 'blink')
  end

  def div_with_block_content_as_string_and_attrs
    html.div(id: 'sidebar', class: 'blue') { 'bonjour' }
  end
end
