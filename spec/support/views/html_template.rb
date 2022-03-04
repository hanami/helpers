# frozen_string_literal: true

class HTMLTemplate
  include Hanami::Helpers::HtmlHelper

  def xss_attack
    html.p { name }
  end

  def name
    "</p><script>alert('xss');</script><p>"
  end
end
