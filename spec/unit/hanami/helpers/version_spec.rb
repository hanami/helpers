RSpec.describe "Hanami::Helpers::VERSION" do
  it "exposes version" do
    expect(Hanami::Helpers::VERSION).to eq("1.1.0.beta3")
  end
end
