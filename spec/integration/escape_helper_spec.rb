# frozen_string_literal: true

RSpec.describe "Escape helper" do
  subject do
    Users::Show.new.call(format: :html, user: user).to_s
  end

  let(:user) { User.new("MG", "http://freud.org", %(<span>hello</span>)) }

  it "renders the title" do
    expect(subject).to match(%(<h1>#{user.name}</h1>))
  end

  it "renders the details" do
    expect(subject).to match(%(<div id="details">\n<ul>\n<li>\n<a href="#{user.website}" title="#{user.name}'s website">website</a>\n</li>\n<li>#{user.snippet}</li>\n</ul>\n</div>))
  end
end
