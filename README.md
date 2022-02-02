# Hanami::Helpers

View helpers for Ruby applications

## Status

[![Gem Version](https://badge.fury.io/rb/hanami-helpers.svg)](https://badge.fury.io/rb/hanami-helpers)
[![CI](https://github.com/hanami/helpers/workflows/ci/badge.svg?branch=main)](https://github.com/hanami/helpers/actions?query=workflow%3Aci+branch%3Amain)
[![Test Coverage](https://codecov.io/gh/hanami/helpers/branch/main/graph/badge.svg)](https://codecov.io/gh/hanami/helpers)
[![Depfu](https://badges.depfu.com/badges/7b30c5d2a2a78954e2ad86e5c7230c23/overview.svg)](https://depfu.com/github/hanami/helpers?project=Bundler)
[![Inline Docs](http://inch-ci.org/github/hanami/helpers.svg)](http://inch-ci.org/github/hanami/helpers)

## Contact

* Home page: http://hanamirb.org
* Mailing List: http://hanamirb.org/mailing-list
* API Doc: http://rdoc.info/gems/hanami-helpers
* Bugs/Issues: https://github.com/hanami/helpers/issues
* Support: http://stackoverflow.com/questions/tagged/hanami
* Chat: https//chat.hanamirb.org

## Rubies

__Hanami::Helpers__ supports Ruby (MRI) 3.0+

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hanami-helpers'
```

And then execute:

```shell
$ bundle
```

Or install it yourself as:

```shell
$ gem install hanami-helpers
```

## Usage

`Hanami::Helpers` offers a set of utilities to enrich web views.

### HTML helper

HTML5 markup generator (`#html`).

View:

```ruby
module Users
  class Show
    include Hanami::Helpers

    def sidebar
      html.aside(id: 'sidebar') do
        p "Languages", class: 'title'

        ul do
          li "Italian"
          li "English"
        end
      end
    end
  end
end
```

Template:

```erb
<%= sidebar %>
```

Output:

```html
<aside id="sidebar">
  <p class="title">Languages</p>

  <ul>
    <li>Italian</li>
    <li>English</li>
  </ul>
</aside>
```

### Form Helper

Form generator for HTML5 (`#form_for`)

#### Template Usage

Template:

```erb
<%=
  form_for :book, routes.books_path do
    text_field :title

    submit 'Create'
  end
%>
```

Output:

```html
<form action="/books" method="POST" accept-charset="utf-8" id="book-form">
  <input type="text" name="book[title]" id="book-id" value="">
  <button type="submit">Create</button>
</form>
```

#### View Usage

View:

```ruby
module Books
  class New
    include Hanami::Helpers

    def form
      form_for :book, routes.books_path do
        text_field :title

        submit 'Create'
      end
    end
  end
end
```

Template:

```erb
<%= form %>
```

Output:

```html
<form action="/books" method="POST" accept-charset="utf-8" id="book-form">
  <input type="text" name="book[title]" id="book-id" value="">
  <button type="submit">Create</button>
</form>
```

#### Reuse Code

Views:

```ruby
module Books
  class New
    include Hanami::Helpers

    def form
      Form.new(:book, routes.books_path)
    end

    def submit_label
      'Create'
    end
  end

  class Edit
    include Hanami::Helpers

    def form
      Form.new(:book, routes.book_path(id: book.id), {book: book}, {method: :patch})
    end

    def submit_label
      'Update'
    end
  end
end
```

Templates:

```erb
# books/new.html.erb
<%= render partial: 'books/form' %>
```

```erb
# books/edit.html.erb
<%= render partial: 'books/form' %>
```

```erb
# books/_form.html.erb
<%=
  form_for form, class: 'form-horizontal' do
    text_field :title

    submit submit_label
  end
%>
```

Output for new:

```html
<form action="/books" method="POST" accept-charset="utf-8" id="book-form">
  <input type="text" name="book[title]" id="book-id" value="">
  <button type="submit">Create</button>
</form>
```

Output for edit:

```html
<form action="/books/23" method="POST" accept-charset="utf-8" id="book-form">
  <input type="hidden" name="_method" value="PATCH">
  <input type="text" name="book[title]" id="book-id" value="TDD">
  <button type="submit">Update</button>
</form>
```

### Escape helper

HTML (`#h`), HTML attribute (`#ha`) and URL (`#hu`) escape helpers.

View:

```ruby
module Users
  class Show
    include Hanami::Helpers

    def home_page_link
      %(<a href="#{ hu(user.home_page_url) }" title="#{ ha(user.name} }'s website">#{ h(user.website_name) }</a>)
    end

    def code_snippet
      raw user.code_snippet
    end
  end
end
```

Template:

```erb
<%= home_page_link %>
<%= code_snippet %>
```

Output:

```html
<a href="https://example.org" title="Maria's website">My Blog</a>
<code>puts "Hello, World!"</code>
```

### Routing Helper

Hanami and Hanami::Router integration (`#routes`).

View:

```ruby
module Home
  class Index
    include Hanami::Helpers

    def link_to_home
      %(<a href="#{ routes.home_path }">Home</a>)
    end
  end
end
```

Template:

```erb
<%= link_to_home %>
```

Output:

```html
<a href="/">Home</a>
```

### Number Formatting Helper

Format numbers (`#format_number`).

View:

```ruby
module Home
  class Index
    include Hanami::Helpers

    def visitors_count
      format_number '1000'
    end
  end
end
```

Template:

```erb
<p><%= visitors_count %></p>
```

Output:

```html
<p>1,000</p>
```

## Philosophy

All the Hanami helpers are modules to include.

Most of the time they inject **private** methods.
This restriction prevents helper methods to be used on the outside (eg. in a template).

We want to encourage developers to use **meaningful** and **simple APIs** in their templates.

### Bad style example

```ruby
module Users
  class Show
    include Hanami::Helpers
  end
end
```

```erb
<%= format_number user.followers_count %>
```

This style increases the complexity of the template and it makes testing hard.

### Good style example

```ruby
module Users
  class Show
    include Hanami::Helpers

    def followers_count
      format_number user.followers_count
    end
  end
end
```

```erb
<%= followers_count %>
```

This simplifies the markup.
In order to test the value that will be printed becomes easier: `Users::Show#followers_count`.

## Versioning

__Hanami::Helpers__ uses [Semantic Versioning 2.0.0](http://semver.org)

## Contributing

1. Fork it ( https://github.com/hanami/helpers/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Copyright

Copyright © 2014-2021 Luca Guidi – Released under MIT License

This project was formerly known as Lotus (`lotus-helpers`).
