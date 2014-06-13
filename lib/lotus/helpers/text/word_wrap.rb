module Lotus
  module Helpers
    module Text
      module WordWrap
        def word_wrap(text, options)
          WordWrap.new(text, options).call
        end

        class WordWrap
          def initialize(text, options)
            @text    = text
            @options = options
          end

          def call
            text
              .split(/\W+/)
              .inject(['']) { |acc, word| append_word(acc, word) }
              .map(&:strip)
              .join("\n")
          end

          private

          attr_reader :text, :options

          def append_word(acc, word)
            acc.tap do
              (break_line?(acc, word) ? acc.last : acc) << " #{ word }"
            end
          end

          def break_line?(buffer, next_word)
            buffer.last.size + next_word.size <= line_width
          end

          def line_width
            options.fetch(:line_width)
          end
        end
      end
    end
  end
end
