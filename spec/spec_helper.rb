# frozen_string_literal: true

$LOAD_PATH.unshift "lib"
SPEC_ROOT = Pathname(__FILE__).dirname
TEMPLATES_PATH = SPEC_ROOT.join("support/fixtures/templates")

require "hanami/utils"
require "hanami/devtools/unit"

require "hanami/helpers"
require_relative "./support/fixtures"

Hanami::Utils.require!("spec/support")
