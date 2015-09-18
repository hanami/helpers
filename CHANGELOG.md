# Lotus::Helpers
View helpers for Ruby applications

## v0.2.5 - 2015-09-23
### Added
- [Leonardo Saraiva] Improved support for HTML content in `#link_to` helper. It now accepts blocks to build markup inside an anchor tag.
- [José Mota] Added `#text` for form builder
- [Scott Le] Added `#text_area` for form builder

### Fixed
- [Pascal Betz] Ensure boolean attributes in HTML forms to not be printed if their value is `nil` (eg. avoid to print `disabled=""`).

## v0.2.0 - 2015-06-23
### Added
- [Luca Guidi] Introduced `Lotus::Helpers::FormHelper`. HTML5 form generator (`#form_for`).
- [Tom Kadwill & Luca Guidi] Introduced `Lotus::Helpers::NumberFormattingHelper`. Format numbers (`#format_number`).
- [Tom Kadwill] Introduced `Lotus::Helpers::LinkToHelper`. Link helper (`#link_to`).

## v0.1.0 - 2015-03-23
### Added
- [Luca Guidi] Introduced `Lotus::Helpers::RoutingHelper`. It exposes `#routes` in views for compatibility with Lotus (`lotusrb` gem)
- [Alfonso Uceda Pompa] Introduced `Lotus::Helpers::EscapeHelper`. It implements OWASP/ESAPI suggestions for HTML, HTML attribute and URL escape helpers.
- [Luca Guidi] Introduced `Lotus::Helpers::HtmlHelper`. It allows to generate complex HTML5 markup with Ruby.
