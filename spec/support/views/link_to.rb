# frozen_string_literal: true

class LinkTo
  include Hanami::Helpers::LinkToHelper

  class Index < MyApp::View::Base
    def link_to_home
      link_to("Home", "/")
    end

    def link_to_relative
      link_to("Relative", "relative")
    end

    def link_to_home_with_html_content
      link_to("/") do
        p "Home with html content"
      end
    end

    def link_to_home_with_html_content_id_and_class
      link_to("/", id: "home__link", class: "first") do
        p "Home with html content, id and class"
      end
    end

    def link_to_external_url_with_content
      link_to("External", "http://external.com")
    end

    def link_to_external_url_with_html_content
      link_to("http://external.com") do
        strong "External with html content"
      end
    end

    def link_to_xss_content
      link_to(%(<script>alert('xss')</script>), "/")
    end

    def link_to_xss_raw_content_block
      link_to("/") do
        %(<script>alert('xss2')</script>)
      end
    end

    def link_to_xss_html_builder_content_block
      link_to("/") do
        p %(<script>alert('xss3')</script>)
      end
    end
  end

  class Routes
    def self.path(name, id = nil)
      "/#{name}/#{id}"
    end
  end

  def routes
    Routes
  end

  def link_to_relative_posts
    link_to("Posts", "posts")
  end

  def link_to_posts
    link_to("Posts", routes.path(:posts))
  end

  def link_to_post
    link_to("Post", routes.path(:post, 1))
  end

  def link_to_with_class
    link_to("Post", routes.path(:posts), class: "first")
  end

  def link_to_with_id
    link_to("Post", routes.path(:posts), id: "posts__link")
  end

  def link_to_with_html_content
    link_to(routes.path(:posts)) do
      strong "Post"
    end
  end

  def link_to_with_content_and_html_content
    link_to("Post", routes.path(:posts)) do
      strong "Post"
    end
  end

  def link_to_with_html_content_id_and_class
    link_to(routes.path(:posts), id: "posts__link", class: "first") do
      strong "Post"
    end
  end

  def link_to_without_args
    link_to
  end

  def link_to_without_args_and_empty_block
    link_to do
      # this block was left intentionally blank ;)
    end
  end

  def link_to_with_only_content
    link_to "Post"
  end

  def link_to_with_content_html_content_id_and_class
    link_to("Post", routes.path(:posts), id: "posts__link", class: "first") do
      strong "Post"
    end
  end

  def link_to_evil_url
    link_to("content", "fo<o>bar")
  end
end
