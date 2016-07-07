require 'test_helper'

describe Hanami::Helpers::EscapeHelper do
  before do
    @view = EscapeView.new
  end

  it 'has a private escape html method' do
    -> { @view.escape_html }.must_raise NoMethodError
  end

  it 'has a private escape html attribute method' do
    -> { @view.escape_html_attribute }.must_raise NoMethodError
  end

  it 'has a private escape url method' do
    -> { @view.escape_url }.must_raise NoMethodError
  end

  it 'has a private raw method' do
    -> { @view.raw }.must_raise NoMethodError
  end

  it 'autoscape evil string' do
    @view.evil_string.must_equal %(&lt;script&gt;alert(&apos;xss&apos;)&lt;&#x2F;script&gt;)
  end

  it "don't autoscape safe string" do
    @view.good_string.must_equal %(this is a good string)
  end

  it 'autoscape attributes evil string' do
    @view.good_attributes_string.must_equal %(<a title='foo'>link</a>)
  end

  it "don't autoscape attributes safe string" do
    @view.evil_attributes_string.must_equal %(<a title='&lt;script&gt;alert&#x28;&#x27;xss&#x27;&#x29;&lt;&#x2f;script&gt;'>link</a>)
  end

  it 'autoscape url evil string' do
    @view.good_url_string.must_equal %(http://hanamirb.org)
  end

  it "don't autoscape url evil string" do
    @view.evil_url_string.must_be_empty
  end

  it 'raw string is returned' do
    @view.raw_string.must_equal %(<div>I'm a raw string</div>)
  end

  it 'raw string is a Hanami::Helpers::Escape::SafeString class' do
    @view.raw_string.class.must_equal Hanami::Utils::Escape::SafeString
  end

  it 'html helper alias' do
    @view.html_string_alias.must_equal %(this is a good string)
  end

  it 'html attribute helper alias' do
    @view.html_attribute_string_alias.must_equal %(<a title='foo'>link</a>)
  end

  it 'url helper alias' do
    @view.url_string_alias.must_equal %(http://hanamirb.org)
  end
end
