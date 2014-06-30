require 'test_helper'

require 'lotus/helpers/text/word_wrap'

require 'pry'

describe Lotus::Helpers::Text::WordWrap do
  describe '#word_wrap' do
    let(:word_wrap_impl) {
      Object.new.tap do |o|
        o.extend Lotus::Helpers::Text::WordWrap
      end
    }

    let(:word_wrap) { ->(*args) { word_wrap_impl.word_wrap(*args) } }

    context 'text is shorter than desired line width' do
      context 'with a single line' do
        it 'returns the given text untouched' do
          single_line_short_text = 'Shorter than desired width'

          word_wrap.(single_line_short_text, line_width: 27).must_equal single_line_short_text
        end
      end

      context 'with multiple lines' do
        it 'returns a string with one line' do
          multi_line_short_text  = "Shorter than\ndesired width"
          single_line_short_text = 'Shorter than desired width'

          word_wrap.(multi_line_short_text, line_width: 27).must_equal single_line_short_text
        end
      end
    end

    context 'text is longer than desired line width' do
      context 'with a single line' do
        it 'returns a string with one line' do
          long_text = 'This is a very long text but it is laid out in a single line'
          long_text_wrapped = "This is a very long\ntext but it is laid\nout in a single line"

          word_wrap.(long_text, line_width: 20).must_equal long_text_wrapped
        end
      end
    end
  end
end
