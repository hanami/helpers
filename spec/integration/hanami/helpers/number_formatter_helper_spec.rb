# frozen_string_literal: true

RSpec.describe "Number formatting helper" do
  it "formats number" do
    rendered = FullStack::Views::Cart::Show.new.call(format: :html, total: 1234.56).to_s
    expect(rendered).to match("1,234.56")
  end
end
