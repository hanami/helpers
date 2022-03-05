# frozen_string_literal: true

require "hanami/helpers/html_new_builder"

class HtmlView
  def html(&blk)
    Hanami::Helpers::HtmlNewBuilder.new(&blk)
  end

  def empty
    html.to_s
  end

  def empty_div
    html.div {}
  end

  def div_with_string_content
    html.div("hello world")
  end

  def div_with_block_content_as_string
    html.div { txt("hola") }
  end

  def div_with_block_content_with_tag_helper
    html.div(html.p("inner"))
  end

  def div_with_block_content_with_nested_calls
    html.div do
      span "hello"
    end
  end

  def div_with_block_content_and_multiple_nested_calls
    html.form(action: "/users", method: "POST") do
      div do
        label "First name", for: "user-first-name"
        input type: "text", id: "user-first-name", name: "user[first_name]", value: "L"
      end

      input type: "submit", value: "Save changes"
    end
  end

  def concatenation_of_multiple_fragments
    hello  = html { div "Hello" }
    hanami = html { div "Hanami" }

    hello + hanami
  end

  def concatenation_of_multiple_divs
    html.div("Hello") + html.div("Hanami")
  end

  def concatenation_of_fragment_and_div
    html { div "Hello" } + html.div("Hanami")
  end

  def fragment_with_block_content
    html do
      div "Hello"
      div "Hanami"
    end
  end

  def div_with_attr
    html.div(id: "container") {}
  end

  # RUBY_VERSION >= '2.2'
  # def div_with_data_attr
  #   html.div('data-where': 'up')
  # end
  def div_with_data_attr
    html.div("data-where": "up") {}
  end

  def div_with_attrs
    html.div(id: "content", class: "filled") {}
  end

  def div_with_string_content_and_attrs
    html.div("ciao", id: "greeting", class: "blink")
  end

  def div_with_block_content_as_string_and_attrs
    html.div(id: "sidebar", class: "blue") { txt "bonjour" }
  end

  def custom_tag
    html.custom("Foo", id: "next")
  end

  def custom_empty_tag
    html.xr(id: "next")
  end

  def evil_string_content
    html.div("<script>alert('xss')</script>")
  end

  def evil_block_content
    html.div { txt "<script>alert('xss')</script>" }
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
