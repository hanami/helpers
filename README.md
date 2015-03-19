# Lotus::Helpers

View helpers for Ruby applications

## Status

[![Gem Version](http://img.shields.io/gem/v/lotus-helpers.svg)](https://badge.fury.io/rb/lotus-helpers)
[![Build Status](http://img.shields.io/travis/lotus/helpers/master.svg)](https://travis-ci.org/lotus/helpers?branch=master)
[![Coverage](http://img.shields.io/coveralls/lotus/helpers/master.svg)](https://coveralls.io/r/lotus/helpers)
[![Code Climate](http://img.shields.io/codeclimate/github/lotus/helpers.svg)](https://codeclimate.com/github/lotus/helpers)
[![Dependencies](http://img.shields.io/gemnasium/lotus/helpers.svg)](https://gemnasium.com/lotus/helpers)
[![Inline Docs](http://inch-ci.org/github/lotus/helpers.svg)](http://inch-ci.org/github/lotus/helpers)

## Contact

* Home page: http://lotusrb.org
* Mailing List: http://lotusrb.org/mailing-list
* API Doc: http://rdoc.info/gems/lotus-helpers
* Bugs/Issues: https://github.com/lotus/helpers/issues
* Support: http://stackoverflow.com/questions/tagged/lotus-ruby
* Chat: https://gitter.im/lotus/chat

## Rubies

__Lotus::Helpers__ supports Ruby (MRI) 2+ and JRuby 1.7 (with 2.0 mode).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lotus-helpers'
```

And then execute:

```shell
$ bundle
```

Or install it yourself as:

```shell
$ gem install lotus-helpers
```

## Usage

`Lotus::Helpers` offers a set of utilities to enrich web views.

### HTML helper

HTML5 markup generator (`#html`).

View:

```ruby
module Users
  class Show
    include Lotus::Helpers

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

### Escape helper

HTML (`#h`), HTML attribute (`#ha`) and URL (`#hu`) escape helpers.

View:

```ruby
module Users
  class Show
    include Lotus::Helpers

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

### Routing helper

Lotus and Lotus::Router integration (`#routes`).

View:

```ruby
module Home
  class Index
    include Lotus::Helpers

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

## Philosophy

All the Lotus helpers are modules to include.

Most of the time they inject **private** methods.
This restriction prevents helper methods to be used on the outside (eg. in a template).

We want to encourage developers to use **meaningful** and **simple APIs** in their templates.

### Bad style example

```ruby
module Users
  class Show
    include Lotus::Helpers
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
    include Lotus::Helpers

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

__Lotus::Helpers__ uses [Semantic Versioning 2.0.0](http://semver.org)

## Contributing

1. Fork it ( https://github.com/lotus/helpers/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Copyright

Copyright © 2014-2015 Luca Guidi – Released under MIT License
