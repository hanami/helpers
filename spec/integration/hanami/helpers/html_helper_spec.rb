# frozen_string_literal: true

RSpec.describe "Html helper" do
  subject do
    Books::Show.new.call(format: :html, book: book).to_s
  end

  let(:book) { Book.new(title: "The Work of Art in the Age of Mechanical Reproduction") }

  it "renders the generated html" do
    expect(subject).to match("<div>\n<h1>The Work of Art in the Age of Mechanical Reproduction</h1>\n</div>")
  end

  it "raises an error when referencing an unknown local variable" do
    expect { Books::Error.new.call(format: :html, book: book) }.to raise_error(NoMethodError, /unknown_local_variable/)
  end
end
