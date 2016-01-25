require 'test_helper'

describe Hanami::Helpers::HtmlHelper do
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

  it 'returns a tag with block content with multiple nested calls' do
    @view.div_with_block_content_and_multiple_nested_calls.to_s.must_equal %(<form action="/users" method="POST">\n<div>\n<label for="user-first-name">First name</label>\n<input type="text" id="user-first-name" name="user[first_name]" value="L">\n</div>\n<input type="submit" value="Save changes">\n</form>)
  end

  it 'returns a concatenation of multiple divs' do
    @view.concatenation_of_multiple_divs.to_s.must_equal %(<div>Hello</div>\n<div>Hanami</div>)
  end

  it 'returns a concatenation of multiple fragments' do
    @view.concatenation_of_multiple_fragments.to_s.must_equal %(<div>Hello</div>\n<div>Hanami</div>)
  end

  it 'returns a concatenation of fragment and div' do
    @view.concatenation_of_fragment_and_div.to_s.must_equal %(<div>Hello</div>\n<div>Hanami</div>)
  end

  it 'returns a fragment with block content as string' do
    @view.fragment_with_block_content.to_s.must_equal %(<div>Hello</div>\n<div>Hanami</div>)
  end

  it 'returns a tag with attribute' do
    @view.div_with_attr.to_s.must_equal %(<div id="container"></div>)
  end

  it 'returns a tag with data attribute' do
    @view.div_with_data_attr.to_s.must_equal %(<div data-where="up"></div>)
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

  it 'returns a custom tag' do
    @view.custom_tag.to_s.must_equal %(<custom id="next">Foo</custom>)
  end

  it 'returns a custom empty tag' do
    @view.custom_empty_tag.to_s.must_equal %(<xr id="next">)
  end

  it 'autoescapes string contents' do
    @view.evil_string_content.to_s.must_equal %(<div>&lt;script&gt;alert(&apos;xss&apos;)&lt;&#x2F;script&gt;</div>)
  end

  it 'autoescapes block contents' do
    @view.evil_block_content.to_s.must_equal %(<div>\n&lt;script&gt;alert(&apos;xss&apos;)&lt;&#x2F;script&gt;\n</div>)
  end

  it 'autoescapes nested helpers contents' do
    @view.evil_tag_helper.to_s.must_equal %(<div><p>&lt;script&gt;alert(&apos;xss&apos;)&lt;&#x2F;script&gt;</p></div>)
  end

  it 'autoescapes nested blocks' do
    @view.evil_nested_block_content.to_s.must_equal %(<div>\n<p>&lt;script&gt;alert(&apos;xss&apos;)&lt;&#x2F;script&gt;</p>\n</div>)
  end

  describe 'with link_to helper' do
    before do
      @view = HtmlAndLinkTo.new
    end

    it 'returns two links in div' do
      @view.two_links_to_in_div.to_s.must_equal %(<div>\n<a href=\"comments\">Comments</a>\n<a href=\"posts\">Posts</a>\n</div>)
    end

    it 'returns span and link in div' do
      @view.span_and_link_to_in_div.to_s.must_equal %(<div>\n<span>hello</span>\n<a href=\"posts\">Posts</a>\n</div>)
    end
  end
end
