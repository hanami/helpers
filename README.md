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

TODO: Write usage instructions here

## Design

All the Lotus helpers will be modules to include.

They inject **private** methods.
The reason is simple: this will prevent those facilities to leak on the outside.

We want to encourage developers to use meaningful and simple methods in their templates.

### Bad style example

```ruby
class ProductView
  include Lotus::Helpers::CurrencyFormatter
end
```

```erb
<%= format_currency product.price %>
```

This increases the cluttering of the template markup.
Test the price that will be printed is hard.

### Good style example

```ruby
class ProductView
  include Lotus::Helpers::CurrencyFormatter

  def formatted_price
    format_currency product.price
  end
end
```

```erb
<%= formatted_price %>
```

This simplifies the markup.
Test the price that will be printed is easy by introspecting `ProductView#formatted_price`.

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
