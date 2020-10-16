RSpec.describe Hanami::Helpers::HtmlHelper do
  before do
    @view = HtmlView.new
  end

  it "has a private html builder" do
    expect { @view.html }.to raise_error(NoMethodError)
  end

  it "returns an empty tag" do
    expect(@view.empty_div.to_s).to eq(%(<div></div>))
  end

  it "returns a tag with string content" do
    expect(@view.div_with_string_content.to_s).to eq(%(<div>hello world</div>))
  end

  it "returns a tag with block content as string" do
    expect(@view.div_with_block_content_as_string.to_s).to eq(%(<div>\nhola\n</div>))
  end

  it "returns a tag with block content as tag helper" do
    expect(@view.div_with_block_content_with_tag_helper.to_s).to eq(%(<div><p>inner</p></div>))
  end

  it "returns a tag with block content with nested calls" do
    expect(@view.div_with_block_content_with_nested_calls.to_s).to eq(%(<div>\n<span>hello</span>\n</div>))
  end

  it "returns a tag with block content with multiple nested calls" do
    expect(@view.div_with_block_content_and_multiple_nested_calls.to_s).to eq(%(<form action="/users" method="POST">\n<div>\n<label for="user-first-name">First name</label>\n<input type="text" id="user-first-name" name="user[first_name]" value="L">\n</div>\n<input type="submit" value="Save changes">\n</form>))
  end

  it "returns a concatenation of multiple divs" do
    expect(@view.concatenation_of_multiple_divs.to_s).to eq(%(<div>Hello</div>\n<div>Hanami</div>))
  end

  it "returns a concatenation of multiple fragments" do
    expect(@view.concatenation_of_multiple_fragments.to_s).to eq(%(<div>Hello</div>\n<div>Hanami</div>))
  end

  it "returns a concatenation of fragment and div" do
    expect(@view.concatenation_of_fragment_and_div.to_s).to eq(%(<div>Hello</div>\n<div>Hanami</div>))
  end

  it "returns a fragment with block content as string" do
    expect(@view.fragment_with_block_content.to_s).to eq(%(<div>Hello</div>\n<div>Hanami</div>))
  end

  it "returns a tag with attribute" do
    expect(@view.div_with_attr.to_s).to eq(%(<div id="container"></div>))
  end

  it "returns a tag with data attribute" do
    expect(@view.div_with_data_attr.to_s).to eq(%(<div data-where="up"></div>))
  end

  it "returns a tag with attributes" do
    expect(@view.div_with_attrs.to_s).to eq(%(<div id="content" class="filled"></div>))
  end

  it "returns a tag with string content and attributes" do
    expect(@view.div_with_string_content_and_attrs.to_s).to eq(%(<div id="greeting" class="blink">ciao</div>))
  end

  it "returns a tag with block content as string and attributes" do
    expect(@view.div_with_block_content_as_string_and_attrs.to_s).to eq(%(<div id="sidebar" class="blue">\nbonjour\n</div>))
  end

  it "returns a custom tag" do
    expect(@view.custom_tag.to_s).to eq(%(<custom id="next">Foo</custom>))
  end

  it "returns a custom empty tag" do
    expect(@view.custom_empty_tag.to_s).to eq(%(<xr id="next">))
  end

  it "autoescapes string contents" do
    expect(@view.evil_string_content.to_s).to eq(%(<div>&lt;script&gt;alert(&apos;xss&apos;)&lt;&#x2F;script&gt;</div>))
  end

  it "autoescapes block contents" do
    expect(@view.evil_block_content.to_s).to eq(%(<div>\n&lt;script&gt;alert(&apos;xss&apos;)&lt;&#x2F;script&gt;\n</div>))
  end

  it "autoescapes nested helpers contents" do
    expect(@view.evil_tag_helper.to_s).to eq(%(<div><p>&lt;script&gt;alert(&apos;xss&apos;)&lt;&#x2F;script&gt;</p></div>))
  end

  it "autoescapes nested blocks" do
    expect(@view.evil_nested_block_content.to_s).to eq(%(<div>\n<p>&lt;script&gt;alert(&apos;xss&apos;)&lt;&#x2F;script&gt;</p>\n</div>))
  end

  describe "with link_to helper" do
    before do
      @view = HtmlAndLinkTo.new
    end

    it "returns two links in div" do
      expect(@view.two_links_to_in_div.to_s).to eq(%(<div>\n<a href=\"/comments\">Comments</a>\n<a href=\"/posts\">Posts</a>\n</div>))
    end

    it "returns span and link in div" do
      expect(@view.span_and_link_to_in_div.to_s).to eq(%(<div>\n<span>hello</span>\n<a href=\"/comments\">Comments</a>\n</div>))
    end
  end
end
