# frozen_string_literal: true

RSpec.describe "Hanami::Helpers::VERSION" do
  it "exposes version" do
    expect(Hanami::Helpers::VERSION).to eq("1.3.3")
  end
end
