require 'test_helper'

describe Lotus::Helpers::HtmlHelper::HtmlBuilder do
  before do
    @builder = Lotus::Helpers::HtmlHelper::HtmlBuilder.new
  end

  ##############################################################################
  # TAGS                                                                       #
  ##############################################################################

  describe 'unknown tag' do
    it 'generates it' do
      result = @builder.custom('Foo', id: 'content').to_s
      result.must_equal %(<custom id="content">Foo</custom>)
    end
  end

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

      result.must_equal %(<a href="http://lotusrb.org">\n<img src="/images/logo.png">\n</a>)
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

  describe '<script>' do
    it 'generates a script tag with a link to a javascript' do
      result = @builder.script(src: '/assets/application.js').to_s
      result.must_equal %(<script src="/assets/application.js"></script>)
    end

    it 'generates a script tag with javascript code' do
      result = @builder.script { %(alert("hello")) }.to_s
      result.must_equal %(<script>\nalert("hello")\n</script>)
    end
  end

  describe '<template>' do
    it 'generates a template tag' do
      result = @builder.template(id: 'product') do
        div 'Computer'
      end.to_s

      result.must_equal %(<template id="product">\n<div>Computer</div>\n</template>)
    end

    it 'generates a script tag with javascript code' do
      result = @builder.script { %(alert("hello")) }.to_s
      result.must_equal %(<script>\nalert("hello")\n</script>)
    end
  end

  describe '<title>' do
    it 'generates a title' do
      result = @builder.title('Welcome to Foo').to_s
      result.must_equal %(<title>Welcome to Foo</title>)
    end
  end

  ##############################################################################
  # EMPTY TAGS                                                                 #
  ##############################################################################

  describe 'empty tag' do
    it 'generates it' do
      result = @builder.empty(:xr, id: 'foo').to_s
      result.must_equal %(<xr id="foo">)
    end
  end

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

  describe '<link>' do
    it 'generates a link to a stylesheet' do
      result = @builder.link(href: '/assets/application.css', rel: 'stylesheet').to_s
      result.must_equal %(<link href="/assets/application.css" rel="stylesheet">)
    end
  end

  describe '<meta>' do
    it 'generates HTML4 content type' do
      result = @builder.meta(http_equiv: 'Content-Type', content: 'text/html; charset=utf-8').to_s
      result.must_equal %(<meta http-equiv="Content-Type" content="text/html; charset=utf-8">)
    end

    it 'generates HTML5 content type' do
      result = @builder.meta(charset: 'utf-8').to_s
      result.must_equal %(<meta charset="utf-8">)
    end

    it 'generates a page refresh' do
      result = @builder.meta(http_equiv: 'refresh', content: '23;url=http://lotusrb.org').to_s
      result.must_equal %(<meta http-equiv="refresh" content="23;url=http://lotusrb.org">)
    end
  end
end
