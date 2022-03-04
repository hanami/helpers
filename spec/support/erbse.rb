# frozen_string_literal: true

require "tilt"
require "erbse"

# Tilt template class copied from cells-erb gem
class ErbseTemplate < ::Tilt::Template
  def prepare
    @template = ::Erbse::Engine.new
  end

  def precompiled_template(*)
    @template.call(data)
  end
end

Tilt.default_mapping.register(ErbseTemplate, "erb")
