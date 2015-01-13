require 'test_helper'

describe Lotus::Helpers::HtmlHelper::HtmlBuilder do
  before do
    @builder = Lotus::Helpers::HtmlHelper::HtmlBuilder.new
  end

  ##############################################################################
  # CLOSING TAGS                                                               #
  ##############################################################################

  describe '<a>' do
    it 'generates a link' do
      result = @builder.a('Lotus', href: 'http://lotusrb.org').to_s
      result.must_equal %(<a href="http://lotusrb.org">Lotus</a>)
    end

    it 'generates a link with target' do
      result = @builder.a('Lotus', href: 'http://lotusrb.org', target: '_blank').to_s
      result.must_equal %(<a href="http://lotusrb.org" target="_blank">Lotus</a>)
    end

    it 'generates a link with image' do
      result = @builder.a('Lotus', href: 'http://lotusrb.org') do
        img(src: '/images/logo.png')
      end.to_s

      result.must_equal %(<a href="http://lotusrb.org"><img src="/images/logo.png"></a>)
    end
  end

  describe '<abbr>' do
    it 'generates an abbreviation' do
      result = @builder.abbr('MVC', title: 'Model View Controller').to_s
      result.must_equal %(<abbr title="Model View Controller">MVC</abbr>)
    end
  end

  describe '<addr>' do
    it 'generates an address' do
      content = <<-CONTENT
Mozilla Foundation<br>
1981 Landings Drive<br>
Building K<br>
Mountain View, CA 94043-0801<br>
USA
CONTENT

      result = @builder.address(content).to_s
      result.must_equal %(<address>#{ content }</address>)
    end
  end

  ##############################################################################
  # SELF-CLOSING TAGS                                                          #
  ##############################################################################

  describe '<img>' do
    it 'generates an image' do
      result = @builder.img(src: '/images/logo.png', alt: 'Lotus logo').to_s
      result.must_equal %(<img src="/images/logo.png" alt="Lotus logo">)
    end

    it 'generates an image with size' do
      result = @builder.img(src: '/images/logo.png', height: 128, width: 128).to_s
      result.must_equal %(<img src="/images/logo.png" height="128" width="128">)
    end
  end
end
