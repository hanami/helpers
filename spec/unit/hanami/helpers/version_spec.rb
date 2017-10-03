RSpec.describe "Hanami::Helpers::VERSION" do
  it "exposes version" do
    expect(Hanami::Helpers::VERSION).to eq("1.1.0.beta2")
  end
end
