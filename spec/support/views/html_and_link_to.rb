# frozen_string_literal: true

class HtmlAndLinkTo
  include Hanami::Helpers::HtmlHelper
  include Hanami::Helpers::LinkToHelper

  def two_links_to_in_div
    html.div do
      link_to("Comments", "/comments") +
        link_to("Posts", "/posts")
    end
  end

  def span_and_link_to_in_div
    html.div do
      span("hello") +
        link_to("Comments", "/comments")
    end
  end
end
