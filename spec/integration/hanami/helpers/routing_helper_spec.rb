# frozen_string_literal: true

RSpec.describe "Routing helper" do
  it "uses helper" do
    rendered = FullStack::Views::Dashboard::Index.new.call(format: :html).to_s
    expect(rendered).to include(%(/dashboard))
  end
end
