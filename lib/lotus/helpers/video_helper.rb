module Lotus
  module Helpers
    module VideoHelper
      include Lotus::Helpers::HtmlHelper

      # Generates a video tag for the given arguments.
      #
      # Contents are automatically escaped.
      #
      # @overload link_to(content, url, options)
      #   Use string as content
      #   @param content [String] content used in the a tag
      #   @param url [String] url used in href attribute
      #   @param options [Hash] HTML attributes to pass to the a tag
      #
      # @overload link_to(url, options, &blk)
      #   Use block as content
      #   @param url [String] url used in href attribute
      #   @param options [Hash] HTML attributes to pass to the a tag
      #   @param blk [Proc] A block that describes the contents of the a tag
      #
      # @return [String] HTML markup for the video
      #
      # @raise [ArgumentError] if the signature isn't respected
      #
      # @since 0.5.0
      #
      # @see Lotus::Helpers::HtmlHelper#html
      #
      # @example Basic usage
      #   <%= video('movie.mp4') %>
      #     # => <video src="/assets/movie.mp4"></video>
      #
      # @example HTML attributes
      #   <%= video('movie.mp4', autoplay: true, controls: true) %>
      #     # => <video src="/assets/movie.mp4" autoplay="autoplay" controls="controls"></video>
      #
      # @example Fallback Content
      #   <%=
      #     video('movie.mp4') do
      #       "Your browser does not support the video tag"
      #     end
      #   %>
      #     # => <video src="/assets/movie.mp4">\nYour browser does not support the video tag\n</video>
      #
      # @example Tracks
      #   <%=
      #     video('movie.mp4') do
      #       track kind: 'captions', src: view.asset_path('movie.en.vtt'), srclang: 'en', label: 'English'
      #     end
      #   %>
      #     # => <video src="/assets/movie.mp4">\n<track kind="captions" src="/assets/movie.en.vtt" srclang="en" label="English">\n</video>
      #
      # @example Sources
      #   <%=
      #     video do
      #       text "Your browser does not support the video tag"
      #       source src: view.asset_path('movie.mp4'), type: 'video/mp4'
      #       source src: view.asset_path('movie.ogg'), type: 'video/ogg'
      #     end
      #   %>
      #     # => <video>\nYour browser does not support the video tag\n<source src="/assets/movie.mp4" type="video/mp4">\n<source src="/assets/movie.ogg" type="video/ogg">\n</video>
      #
      # @example Without any argument
      #   <%= video %>
      #     # => ArgumentError
      #
      # @example Without src and without block
      #   <%= video(content: true) %>
      #     # => ArgumentError
      def video(src = nil, options = {}, &blk)
        if src.is_a?(String)
          options = {src: asset_path(src)}.merge(options)
        elsif src.is_a?(Hash)
          options = src
        end

        if !options[:src] && !block_given?
          raise ArgumentError
        end

        html.video(blk, options).to_s
      end
    end
  end
end
