module Lotus
  module Helpers
    module HtmlHelper
      class EmptyHtmlNode
        ATTRIBUTES_SEPARATOR = ' '.freeze
        ATTRIBUTES_ESCAPE = {
          '_' => '-'
        }.freeze
        ATTRIBUTES_ESCAPE_PATTERN = Regexp.union(*ATTRIBUTES_ESCAPE.keys)

        def initialize(name, attributes)
          @name       = name
          @attributes = attributes
        end

        def to_s
          %(<#{ @name }#{attributes}>)
        end

        private
        def attributes
          return if @attributes.nil?
          result = [nil]

          @attributes.each do |attr, value|
            result << %(#{ attr.to_s.gsub(ATTRIBUTES_ESCAPE_PATTERN){|c| ATTRIBUTES_ESCAPE[c] } }="#{ value }")
          end

          result.join(ATTRIBUTES_SEPARATOR)
        end
      end
    end
  end
end
