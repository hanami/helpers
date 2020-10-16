RSpec.describe Hanami::Helpers::RoutingHelper do
  before do
    @template = Hanami::View::Template.new("spec/support/fixtures/templates/full_stack/dashboard/index.html.erb", "utf-8")
  end

  describe "when routing constant is defined" do
    before do
      @view = FullStack::Views::Dashboard::Index.new(@template, {})
    end

    it "has access to routing helper" do
      expect(@view.routing_helper_path).to eq(%(/dashboard))
    end
  end

  describe "when routing constant is not defined" do
    before do
      @view = ViewWithoutRoutingHelper.new(@template, {})
    end

    it "raises an exception when trying to access routing helper" do
      expect { @view.routing_helper_path }.to raise_error(NameError)
    end
  end
end
