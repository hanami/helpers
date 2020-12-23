# frozen_string_literal: true

RSpec.describe Hanami::Helpers::RoutingHelper do
  describe "when routing constant is defined" do
    it "has access to routing helper" do
      rendered = FullStack::Views::Dashboard::Index.new.call.to_s
      expect(rendered).to match(%(/dashboard))
    end
  end

  describe "when routing constant is not defined" do
    it "raises an exception when trying to access routing helper" do
      expect { ViewWithoutRoutingHelper.new.call.to_s }.to raise_error(NameError, /routes/)
    end
  end
end
