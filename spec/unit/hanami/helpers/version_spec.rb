RSpec.describe "Hanami::Helpers::VERSION" do
  it "exposes version" do
    expect(Hanami::Helpers::VERSION).to eq("1.2.0.rc2")
  end
end
