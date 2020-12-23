# frozen_string_literal: true

$LOAD_PATH.unshift "lib"
require "hanami/utils"
require "hanami/devtools/unit"

require "hanami/helpers"
require_relative "./support/fixtures"

Hanami::Utils.require!("spec/support")
