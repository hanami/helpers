require 'test_helper'

describe 'Escape helper' do
  before do
    @user   = LinkTo.new()
    @actual = LinkTo::Index.render(format: :html)
  end

  it 'renders the title' do
    @actual.must_match(%(<a href="/">Home</a>))
  end
end
