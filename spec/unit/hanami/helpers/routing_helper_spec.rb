# frozen_string_literal: true

RSpec.describe Hanami::Helpers::RoutingHelper do
  xdescribe "when routing constant is defined" do
    let(:view) { FullStack::Views::Dashboard::Index.new }

    it "has access to routing helper" do
      expect(view.routing_helper_path).to eq(%(/dashboard))
    end
  end

  xdescribe "when routing constant is not defined" do
    let(:view) { ViewWithoutRoutingHelper.new }

    it "raises an exception when trying to access routing helper" do
      expect { view.routing_helper_path }.to raise_error(NameError)
    end
  end
end
