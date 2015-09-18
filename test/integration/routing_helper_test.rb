require 'test_helper'

describe 'Routing helper' do
  before do
    @actual = FullStack::Views::Dashboard::Index.render(format: :html)
  end

  it 'uses helper' do
    @actual.must_include %(/dashboard)
  end
end
