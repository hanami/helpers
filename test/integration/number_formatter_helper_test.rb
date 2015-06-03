require 'test_helper'

describe 'Number formatting helper' do
  before do
    @rendered = FullStack::Views::Cart::Show.render(format: :html, total: 1234.56)
  end

  it 'formats number' do
    @rendered.must_include '1,234.56'
  end
end
