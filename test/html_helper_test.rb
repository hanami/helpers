require 'test_helper'

describe Lotus::Helpers::HtmlHelper do
  before do
    @view = HtmlView.new
  end

  it 'has a private html builder' do
    -> { @view.html }.must_raise NoMethodError
  end

  it 'returns an empty tag' do
    @view.empty_div.to_s.must_equal %(<div></div>)
  end

  it 'returns a tag with string content' do
    @view.div_with_string_content.to_s.must_equal %(<div>hello world</div>)
  end

  it 'returns a tag with block content as string' do
    @view.div_with_block_content_as_string.to_s.must_equal %(<div>\nhola\n</div>)
  end

  it 'returns a tag with block content as tag helper' do
    @view.div_with_block_content_with_tag_helper.to_s.must_equal %(<div><p>inner</p></div>)
  end

  it 'returns a tag with block content with nested calls' do
    @view.div_with_block_content_with_nested_calls.to_s.must_equal %(<div>\n<span>hello</span>\n</div>)
  end

  it 'returns a tag with attribute' do
    @view.div_with_attr.to_s.must_equal %(<div id="container"></div>)
  end

  it 'returns a tag with undescore attribute' do
    @view.div_with_undescore_attr.to_s.must_equal %(<div data-where="up"></div>)
  end

  it 'returns a tag with attributes' do
    @view.div_with_attrs.to_s.must_equal %(<div id="content" class="filled"></div>)
  end

  it 'returns a tag with string content and attributes' do
    @view.div_with_string_content_and_attrs.to_s.must_equal %(<div id="greeting" class="blink">ciao</div>)
  end

  it 'returns a tag with block content as string and attributes' do
    @view.div_with_block_content_as_string_and_attrs.to_s.must_equal %(<div id="sidebar" class="blue">\nbonjour\n</div>)
  end
end
