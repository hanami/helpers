# frozen_string_literal: true

require "dry/core/basic_object"
require "hanami/helpers/escape"

# Adapted from `papercraft` gem implementation
#
# Papercraft is Copyright (c) digital-fabric
# Released under the MIT License
module Hanami
  module Helpers
    class HtmlAstBuilder # < Dry::Core::BasicObject
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

      # ast = [:body, {} [
      #   [:div, {}, []],
      #   [:div, {id: "foo"}, []],
      #   [:div, {}, [[:p, {}, "Hello, World"]]],
      #   [:div, {}, [[:p, {}, ->(name) { "hello, #{name}" }]]],
      #   [:form, {}, [[:input, {value: ->(ctx) { ctx.dig(:search, :q) }}, []]]],
      # ]]

      def initialize(ctx, &blk)
        super()
        @ctx = ctx
        # @ast = [[:body, {}, [
        #   [:div, {}, []],
        #   [:div, {id: "foo"}, []],
        #   [:div, {}, [
        #     [:p, {}, "Hello, World"]
        #   ]],
        #   [:div, {}, ->(*) { Time.now }],
        #   [:div, {}, ["Hello ", ->(*) { user.name }, ", welcome!"]],
        #   [:form, {action: "/settings", method: "PATCH"}, [
        #     [:input, {type: "email", name: "user[email]", value: ->(*) { user.email }}, []]
        #   ]]
        # ]]]
        @buffer = Escape.safe_string("")
        @ast = [instance_eval(&blk)]
      end

      def form(content = nil, **attributes, &blk)
        if content.is_a?(::Hash) && attributes.empty?
          attributes = content
          content = nil
        end

        [__method__, attributes, [content || instance_eval(&blk)]]
      end

      def div(content = nil, **attributes, &blk)
        if content.is_a?(::Hash) && attributes.empty?
          attributes = content
          content = nil
        end

        [__method__, attributes, [content || instance_eval(&blk)]]
      end

      def label(content = nil, **attributes, &blk)
        if content.is_a?(::Hash) && attributes.empty?
          attributes = content
          content = nil
        end

        [__method__, attributes, [content || instance_eval(&blk)]]
      end

      def input(content = nil, **attributes, &blk)
        if content.is_a?(::Hash) && attributes.empty?
          attributes = content
          content = nil
        end

        [__method__, attributes, [content || (blk && instance_eval(&blk))].compact]
      end

      attr_reader :ctx, :ast

      def to_s(ast: self.ast)
        ast.map do |(tag, attrs, content)|
          c = case content
              in String
                content
              in [pre, Proc => prc, post]
                String.new(pre) << emit_content(&prc) << post
              in Array
                to_s(ast: content)
              in Proc
                emit_content(&content)
              end

          buffer = String.new
          tag = tag.to_s
          buffer << S_LT << tag
          emit_attributes(attrs, buffer)
          buffer << S_GT << c << S_LT_SLASH << tag << S_GT
        end.join("\n")
      end

      def emit_content(&content)
        escape_content(
          ctx.instance_eval(&content).to_s
        )
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

      def emit_attributes(attributes, buffer)
        return if attributes.empty?

        attributes.each do |name, value|
          case name
          when :src, :href
            buffer << S_SPACE << name.to_s << S_EQUAL_QUOTE <<
              EscapeUtils.escape_uri(value) << S_QUOTE
          else
            case value
            when true
              buffer << S_SPACE << attribute_name(name.to_s)
            when false, nil
              # emit nothing
            when Proc
              buffer << S_SPACE << name.to_s << S_EQUAL_QUOTE <<
                emit_content(&value) << S_QUOTE
            else
              buffer << S_SPACE << attribute_name(name.to_s) <<
                S_EQUAL_QUOTE << value << S_QUOTE
            end
          end
        end
      end
    end
  end
end
