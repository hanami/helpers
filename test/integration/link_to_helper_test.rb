require 'test_helper'

describe 'Escape helper' do
  before do
    @user   = LinkTo.new()
    @actual = LinkTo::Index.render(format: :html)
  end

  it 'renders the title' do
    @actual.must_match(%(<a href="/">Home</a>))
  end

  it 'renders relative link' do
    @actual.must_match(%(<a href="relative">Relative</a>))
  end

  it 'renders link using html content' do
    @actual.must_match(%(<a href="/">\n<p>Home with html content</p>\n</a>))
  end

  it 'renders link using html content, id and class' do
    @actual.must_match(%(<a id="home__link" class="first" href="/">\n<p>Home with html content, id and class</p>\n</a>))
  end

  it 'renders link using content' do
    @actual.must_match(%(<a href="http://external.com">External</a>))
  end

  it 'renders link using html content' do
    @actual.must_match(%(<a href="http://external.com">\n<strong>External with html content</strong>\n</a>))
  end
end
