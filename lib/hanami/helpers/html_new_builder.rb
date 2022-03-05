# frozen_string_literal: true

require "dry/core/basic_object"
require "hanami/helpers/escape"

# Adapted from `papercraft` gem implementation
#
# Papercraft is Copyright (c) digital-fabric
# Released under the MIT License
module Hanami
  module Helpers
    class HtmlNewBuilder < Dry::Core::BasicObject
      S_LT              = "<"
      S_GT              = ">"
      S_LT_SLASH        = "</"
      S_SPACE_LT_SLASH  = " </"
      S_SLASH_GT        = "/>"
      S_SPACE           = " "
      S_EQUAL_QUOTE     = '="'
      S_QUOTE           = '"'

      S_TAG_METHOD_LINE = __LINE__ + 2
      S_TAG_METHOD = <<~RUBY
        S_TAG_%<TAG>s_PRE = %<tag_pre>s
        S_TAG_%<TAG>s_CLOSE = %<tag_close>s
        def %<tag>s(content = nil, **attributes, &blk)
          if content.is_a?(::Hash) && attributes.empty?
            attributes = content
            content = nil
          end
          @buffer << S_TAG_%<TAG>s_PRE
          emit_attributes(attributes) unless attributes.empty?
          if blk
            @buffer << S_GT
            instance_eval(&blk)
            @buffer << S_TAG_%<TAG>s_CLOSE
          elsif content
            @buffer << S_GT << escape_content(content.to_s) << S_TAG_%<TAG>s_CLOSE
          else
            @buffer << S_SLASH_GT
          end
        end
      RUBY

      def initialize(&blk)
        super()
        @buffer = Escape.safe_string("")
        instance_eval(&blk) if blk
      end

      def to_s
        Escape.safe_string(@buffer)
      end

      def txt(content)
        @buffer << escape_content(content)
      end

      def +(other)
        to_s + other.to_s
      end

      def method_missing(method_name, *args, **kwargs, &blk)
        tag = method_name.to_s
        type = tag_name(tag)
        code = S_TAG_METHOD % {
          tag: tag,
          TAG: tag.upcase,
          tag_pre: "<#{type}".inspect,
          tag_close: "</#{type}>".inspect
        }

        self.class.class_eval(code, __FILE__, S_TAG_METHOD_LINE)

        __send__(method_name, *args, **kwargs, &blk)
      end

      def respond_to_missing?(*)
        true
      end

      private

      def tag_name(tag)
        tag.tr("_", "-")
      end

      alias_method :attribute_name, :tag_name

      def escape_content(content)
        Escape.(content)
      end

      def emit_attributes(attributes)
        attributes.each do |name, value|
          case name
          when :src, :href
            @buffer << S_SPACE << name.to_s << S_EQUAL_QUOTE <<
              EscapeUtils.escape_uri(value) << S_QUOTE
          else
            case value
            when true
              @buffer << S_SPACE << attribute_name(name.to_s)
            when false, nil
              # emit nothing
            else
              @buffer << S_SPACE << attribute_name(name.to_s) <<
                S_EQUAL_QUOTE << value << S_QUOTE
            end
          end
        end
      end
    end
  end
end
