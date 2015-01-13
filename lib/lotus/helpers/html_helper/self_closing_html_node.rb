module Lotus
  module Helpers
    module HtmlHelper
      class SelfClosingHtmlNode
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

          @attributes.each_with_object([nil]) do |(attr,value), result|
            result << %(#{ attr.to_s.gsub(/_/, '-') }="#{ value }")
          end.join(' ')
        end
      end
    end
  end
end
