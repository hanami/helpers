# Hanami::Helpers
View helpers for Ruby web applications

## v0.4.0 - 2016-07-22
### Added
- [Luca Guidi] Allow `link_to` to be concat with other helpers. Eg `link_to(...) + link_to(...)`, `span(...) + link_to(...)`.
- [Anton Davydov] Support blank `<option>` tag for `select` form helper. Eg. `select :store, [...], options: { prompt: '' }`
- [Sebastjan Hribar] Support selected `<option>` for `select` form helper. Eg. `select :store, [...], options: { selected: 'it' }`
- [Cang Ta] Added `datalist` form helper

### Changed
– [Luca Guidi] Drop support for Ruby 2.0 and 2.1. Official support for JRuby 9.0.5.0+.
- [Luca Guidi] Inverted options (label, value) for `select` form helper. Now the syntax is `select :store, { 'Italy' => 'it', 'United States' => 'us' }`

### Fixed
– [Nikolay Shebanov] Explicitly require some `hanami-utils` dependencies

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
