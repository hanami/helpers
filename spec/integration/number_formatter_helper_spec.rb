# frozen_string_literal: true

RSpec.describe "Number formatting helper" do
  before do
    @rendered = FullStack::Views::Cart::Show.render(format: :html, total: 1234.56)
  end

  it "formats number" do
    expect(@rendered).to include("1,234.56")
  end
end
