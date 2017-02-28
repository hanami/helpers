module Hanami
  module Helpers
    # Time helpers
    #
    # You can include this module inside your view and
    # the view will have access all methods.
    #
    # By including <tt>Hanami::Helpers::TimeHelper</tt> it will inject some
    # time formatting private method.
    #
    # @since x.x.x
    module TimeHelper
      private

      # Relative time.
      #
      # This method returns time between two time points in words.
      #
      # @param date_to [Time,DateTime] the input
      # @param date_from [Time,DateTime] the input
      #
      # @return [String] the string with date range in words
      #
      # @since 0.1.0
      #
      # @example
      #   require 'hanami/helpers/time_helper'
      #
      #   class PostView
      #     include Hanami::Helpers::TimeHelper
      #
      #     def created_at
      #       relative_time(post.created_at)
      #     end
      #   end
      #
      #   view = PostView.new
      #
      #   view.created_at
      #     # => "less than a minute"
      #
      def relative_time(date_to, date_from = Time.now)
        RelativeTime.new.in_words(date_to, date_from)
      end

      # Relative time base class
      #
      # @since x.x.x
      # @api private
      class RelativeTime
        def in_words(date_to, date_from)
          diff = date_from.to_time - date_to.to_time
          return 'less than a minute' if diff.abs.round <= 59

          date_string = verb_agreement(resolution(diff.abs.round))
          diff >= 0 ? "#{date_string} ago" : "in #{date_string}"
        end

        private

        # @since x.x.x
        # @api private
        MINUTE = 60
        
        # @since x.x.x
        # @api private
        HOUR   = 60 * MINUTE

        # @since x.x.x
        # @api private
        DAY    = 24 * HOUR

        # @since x.x.x
        # @api private
        WEEK   = 7  * DAY

        # @since x.x.x
        # @api private
        MONTH  = 4  * WEEK

        # @since x.x.x
        # @api private
        YEAR   = 12 * MONTH

        # @since x.x.x
        # @api private
        def resolution(diff)
          if diff >= YEAR
            [(diff / YEAR).round, 'years']
          elsif diff >= MONTH
            [(diff / MONTH).round, 'months']
          elsif diff >= WEEK
            [(diff / WEEK).round, 'weeks']
          elsif diff >= DAY
            [(diff / DAY).round, 'days']
          elsif diff >= HOUR
            [(diff / HOUR).round, 'hours']
          else
            [(diff / MINUTE).round, 'minutes']
          end
        end

        # @since x.x.x
        # @api private
        def verb_agreement(resolution)
          if resolution[0] == 1
            "a #{resolution.last[0...-1]}"
          else
            resolution.join(' ')
          end
        end
      end
    end
  end
end
