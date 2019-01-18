# Hanami::Helpers
View helpers for Ruby web applications

## v1.3.1 - 2019-01-18
### Added
- [Luca Guidi] Official support for Ruby: MRI 2.6
- [Luca Guidi] Support `bundler` 2.0+

## v1.3.0 - 2018-10-24

## v1.3.0.beta1 - 2018-08-08
### Added
- [Luca Guidi] Official support for JRuby 9.2.0.0

## v1.2.2 - 2018-06-12
### Fixed
- [Sean Collins] Ensure `csrf_meta_tags` helper to generate `<meta>` tags with `content` attribute instead of `value`

## v1.2.1 - 2018-06-04
### Fixed
- [Lucas Gomes] Ensure to mark `<option>` as selected when `select` helper has a collection of non-`String` values

## v1.2.0 - 2018-04-11

## v1.2.0.rc2 - 2018-04-06
### Added
- [Ponomarev Ilya] Allow `submit` and `button` form helpers to accept blocks
- [Ferdinand Niedermann] let `fields_for_collection` to iterate thru the given collection and yield current index and value

## v1.2.0.rc1 - 2018-03-30
### Fixed
- [Gustavo Caso] Ensure `select` helper to set the `selected` attribute properly when an `<option>` has a `nil` value

## v1.2.0.beta2 - 2018-03-23

## v1.2.0.beta1 - 2018-02-28
### Added
- [Luca Guidi] Introduced `csrf_meta_tags` helper to print meta tags for CSRF protection
- [Luca Guidi] Added support for `form_for(..., remote: true)` which translates to `<form ... data-remote="true">`
- [Sean Collins] Allow HTML attributes to be specified as an array of strings or symbols (eg `<%= html.span("foo", class: %w(ui form)) %>`)

## v1.1.2 - 2018-04-05
### Fixed
- [Luca Guidi] Ensure correct arity of `#form_for`, to be used in conjuction with `Hanami::Helpers::FormHelper::Form` (eg. `<%= form_for(form) { ... } %>`)

## v1.1.1 - 2018-02-27
### Fixed
- [Alfonso Uceda] Ensure `#select` form helper to not select options with `nil` value
- [Alfonso Uceda] Ensure `#fields_for_collection` form helper to produce input fields with correct `name` attribute
- [Luca Guidi] Ensure `#select` form helper to respect `:selected` option

## v1.1.0 - 2017-10-25

## v1.1.0.rc1 - 2017-10-16

## v1.1.0.beta3 - 2017-10-04

## v1.1.0.beta2 - 2017-10-03

## v1.1.0.beta1 - 2017-08-11

## v1.0.0 - 2017-04-06

## v1.0.0.rc1 - 2017-03-31

## v1.0.0.beta2 - 2017-03-17
### Added
- [Luca Guidi] Added `time_field` form helper
- [Luca Guidi] Added `month_field` form helper
- [Luca Guidi] Added `week_field` form helper
- [Luca Guidi] Added `range_field` form helper
- [Luca Guidi] Added `search_field` form helper
- [Luca Guidi] Added `url_field` form helper
- [Luca Guidi] Added `tel_field` form helper
- [Luca Guidi] Added `image_button` form helper
- [Luca Guidi] Added support for `<dialog>`, `<hgroup>`, `<rtc>`, `<slot>`, and `<var>` HTML5 tags

## v1.0.0.beta1 - 2017-02-14
### Added
- [Luca Guidi] Official support for Ruby: MRI 2.4
- [Marion Duprey] Introduced Form helper `fields_for_collection` to support arrays of nested fields

## Fixed
- [Ksenia Zalesnaya] Ensure radio buttons and selects to coerce the value to boolean before to decide if they should be checked or not.
- [Anton Davydov] Escape form values to prevent XSS attacks

## v0.5.1 - 2016-12-19
### Fixed
- [Alex Coles] Ensure `#form_for`'s `values:` to accept `Hanami::Entity` instances
- [Ksenia Zalesnaya & Marion Duprey] Ensure checkboxes to check/uncheck when a boolean is passed as value
- [Paweł Świątkowski] Ensure `#format_number` to respect given precision

## v0.5.0 - 2016-11-15
### Added
- [Marion Duprey] Allow `select` form helper to generate a multiple select (via `multiple: true` option)

### Fixed
- [Luca Guidi] Ensure `form_for` to be compatible with params passed as `Hash`. This is useful for unit tests.

### Changed
- [Luca Guidi] Official support for Ruby: MRI 2.3+ and JRuby 9.1.5.0+

## v0.4.0 - 2016-07-22
### Added
- [Luca Guidi] Allow `link_to` to be concat with other helpers. Eg `link_to(...) + link_to(...)`, `span(...) + link_to(...)`.
- [Anton Davydov] Support blank `<option>` tag for `select` form helper. Eg. `select :store, [...], options: { prompt: '' }`
- [Sebastjan Hribar] Support selected `<option>` for `select` form helper. Eg. `select :store, [...], options: { selected: 'it' }`
- [Cang Ta] Added `datalist` form helper

### Changed
- [Luca Guidi] Drop support for Ruby 2.0 and 2.1. Official support for JRuby 9.0.5.0+.
- [Luca Guidi] Inverted options (label, value) for `select` form helper. Now the syntax is `select :store, { 'Italy' => 'it', 'United States' => 'us' }`

### Fixed
- [Nikolay Shebanov] Explicitly require some `hanami-utils` dependencies

## v0.3.0 - 2016-01-22
### Changed
- [Luca Guidi] Renamed the project

## v0.2.6 - 2016-01-12
### Added
- [Cam Huynh] Added support for HTML helper (`#html`) block syntax (eg. `html { div('hello') }`)
- [Shin-ichi Ueda] Added support for `<dd>` HTML tag

### Fixed
- [Rodrigo Panachi] Don't generate CSRF token hidden input for forms with `GET` method

## v0.2.5 - 2015-09-30
### Added
- [Leonardo Saraiva] Improved support for HTML content in `#link_to` helper. It now accepts blocks to build markup inside an anchor tag.
- [José Mota] Added `#text` to the form builder
- [Alex Wochna] Added `#number_field` to the form builder
- [Scott Le] Added `#text_area` to the form builder

### Fixed
- [Pascal Betz] Ensure boolean attributes in HTML forms to not be printed if their value is `nil` (eg. avoid to print `disabled=""`).

### Changed
- [Luca Guidi] Form `#label` helper outputs capitalized strings, instead of titleized (eg. `"Remember me"` instead of `"Remember Me"`).

## v0.2.0 - 2015-06-23
### Added
- [Luca Guidi] Introduced `Lotus::Helpers::FormHelper`. HTML5 form generator (`#form_for`).
- [Tom Kadwill & Luca Guidi] Introduced `Lotus::Helpers::NumberFormattingHelper`. Format numbers (`#format_number`).
- [Tom Kadwill] Introduced `Lotus::Helpers::LinkToHelper`. Link helper (`#link_to`).

## v0.1.0 - 2015-03-23
### Added
- [Luca Guidi] Introduced `Lotus::Helpers::RoutingHelper`. It exposes `#routes` in views for compatibility with Lotus (`hanamirb` gem)
- [Alfonso Uceda Pompa] Introduced `Lotus::Helpers::EscapeHelper`. It implements OWASP/ESAPI suggestions for HTML, HTML attribute and URL escape helpers.
- [Luca Guidi] Introduced `Lotus::Helpers::HtmlHelper`. It allows to generate complex HTML5 markup with Ruby.
