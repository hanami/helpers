RSpec.describe 'Html helper' do
  before do
    @book   = Book.new(title: 'The Work of Art in the Age of Mechanical Reproduction')
    @actual = Books::Show.render(format: :html, book: @book)
  end

  it 'renders the generated html' do
    expect(@actual).to match("<div>\n<h1>The Work of Art in the Age of Mechanical Reproduction</h1>\n</div>")
  end

  it 'raises an error when referencing an unknown local variable' do
    expect do
      Books::Error.render(format: :html, book: @book)
    end.to raise_error(NoMethodError)
  end
end
