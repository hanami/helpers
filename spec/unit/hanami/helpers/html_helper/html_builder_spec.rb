RSpec.describe Hanami::Helpers::HtmlHelper::HtmlBuilder do
  before do
    @builder = Hanami::Helpers::HtmlHelper::HtmlBuilder.new
  end

  ##############################################################################
  # TAGS                                                                       #
  ##############################################################################

  describe 'unknown tag' do
    it 'generates it' do
      result = @builder.tag(:custom, 'Foo', id: 'content').to_s
      expect(result).to eq(%(<custom id="content">Foo</custom>))
    end
  end

  describe '<a>' do
    it 'generates a link' do
      result = @builder.a('Hanami', href: 'http://hanamirb.org').to_s
      expect(result).to eq(%(<a href="http://hanamirb.org">Hanami</a>))
    end

    it 'generates a link with target' do
      result = @builder.a('Hanami', href: 'http://hanamirb.org', target: '_blank').to_s
      expect(result).to eq(%(<a href="http://hanamirb.org" target="_blank">Hanami</a>))
    end

    it 'generates a link with image' do
      result = @builder.a('Hanami', href: 'http://hanamirb.org') do
        img(src: '/images/logo.png')
      end.to_s

      expect(result).to eq(%(<a href="http://hanamirb.org">\n<img src="/images/logo.png">\n</a>))
    end
  end

  describe '<abbr>' do
    it 'generates an abbreviation' do
      result = @builder.abbr('MVC', title: 'Model View Controller').to_s
      expect(result).to eq(%(<abbr title="Model View Controller">MVC</abbr>))
    end
  end

  describe '<addr>' do
    it 'generates an address' do
      content = Hanami::Utils::Escape::SafeString.new(
        <<-CONTENT
Mozilla Foundation<br>
1981 Landings Drive<br>
Building K<br>
Mountain View, CA 94043-0801<br>
USA
CONTENT
      )

      result = @builder.address(content).to_s
      expect(result).to eq(%(<address>#{content}</address>))
    end
  end

  describe '<script>' do
    it 'generates a script tag with a link to a javascript' do
      result = @builder.script(src: '/assets/application.js').to_s
      expect(result).to eq(%(<script src="/assets/application.js"></script>))
    end

    it 'generates a script tag with javascript code' do
      result = @builder.script { Hanami::Utils::Escape::SafeString.new(%(alert("hello"))) }.to_s
      expect(result).to eq(%(<script>\nalert("hello")\n</script>))
    end
  end

  describe '<template>' do
    it 'generates a template tag' do
      result = @builder.template(id: 'product') do
        div 'Computer'
      end.to_s

      expect(result).to eq(%(<template id="product">\n<div>Computer</div>\n</template>))
    end

    it 'generates a script tag with javascript code' do
      result = @builder.script { Hanami::Utils::Escape::SafeString.new(%(alert("hello"))) }.to_s
      expect(result).to eq(%(<script>\nalert("hello")\n</script>))
    end
  end

  describe '<title>' do
    it 'generates a title' do
      result = @builder.title('Welcome to Foo').to_s
      expect(result).to eq(%(<title>Welcome to Foo</title>))
    end
  end

  describe '<dialog>' do
    it 'generates a dialog' do
      result = @builder.dialog('Greetings, one and all!').to_s
      expect(result).to eq(%(<dialog>Greetings, one and all!</dialog>))
    end
  end

  describe '<hgroup>' do
    it 'generates a hgroup' do
      result = @builder.hgroup do
        h1 "Hello"
      end.to_s

      expect(result).to eq(%(<hgroup>\n<h1>Hello</h1>\n</hgroup>))
    end
  end

  describe '<rtc>' do
    it 'generates a rtc' do
      result = @builder.rtc("Rome").to_s
      expect(result).to eq(%(<rtc>Rome</rtc>))
    end
  end

  describe '<slot>' do
    it 'generates a slot' do
      result = @builder.slot("Need description").to_s
      expect(result).to eq(%(<slot>Need description</slot>))
    end
  end

  describe '<var>' do
    it 'generates a var' do
      result = @builder.var("x").to_s
      expect(result).to eq(%(<var>x</var>))
    end
  end

  ##############################################################################
  # EMPTY TAGS                                                                 #
  ##############################################################################

  describe 'empty tag' do
    it 'generates it' do
      result = @builder.empty_tag(:xr, id: 'foo').to_s
      expect(result).to eq(%(<xr id="foo">))
    end
  end

  describe '<img>' do
    it 'generates an image' do
      result = @builder.img(src: '/images/logo.png', alt: 'Hanami logo').to_s
      expect(result).to eq(%(<img src="/images/logo.png" alt="Hanami logo">))
    end

    it 'generates an image with size' do
      result = @builder.img(src: '/images/logo.png', height: 128, width: 128).to_s
      expect(result).to eq(%(<img src="/images/logo.png" height="128" width="128">))
    end
  end

  describe '<link>' do
    it 'generates a link to a stylesheet' do
      result = @builder.link(href: '/assets/application.css', rel: 'stylesheet').to_s
      expect(result).to eq(%(<link href="/assets/application.css" rel="stylesheet">))
    end
  end

  describe '<meta>' do
    it 'generates HTML4 content type' do
      # RUBY_VERSION >= 2.2
      # result = @builder.meta('http-equiv': 'Content-Type', content: 'text/html; charset=utf-8').to_s
      result = @builder.meta(:'http-equiv' => 'Content-Type', content: 'text/html; charset=utf-8').to_s
      expect(result).to eq(%(<meta http-equiv="Content-Type" content="text/html; charset=utf-8">))
    end

    it 'generates HTML5 content type' do
      result = @builder.meta(charset: 'utf-8').to_s
      expect(result).to eq(%(<meta charset="utf-8">))
    end

    it 'generates a page refresh' do
      # RUBY_VERSION >= 2.2
      # result = @builder.meta('http-equiv': 'refresh', content: '23;url=http://hanamirb.org').to_s
      result = @builder.meta(:'http-equiv' => 'refresh', content: '23;url=http://hanamirb.org').to_s
      expect(result).to eq(%(<meta http-equiv="refresh" content="23;url=http://hanamirb.org">))
    end
  end

  ##############################################################################
  # FRAGMENTS
  ##############################################################################

  describe 'fragment' do
    it 'generates a html fragment' do
      result = @builder.fragment do
        span 'Hello'
        span 'Hanami'
      end.to_s

      expect(result).to eq(%(<span>Hello</span>\n<span>Hanami</span>))
    end
  end

  ##############################################################################
  # ATTRIBUTES                                                                 #
  ##############################################################################

  describe 'attributes' do
    it 'handles no attribute list' do
      result = @builder.input.to_s
      expect(result).to eq('<input>')
    end

    it 'handles empty attribute list' do
      result = @builder.input({}).to_s
      expect(result).to eq('<input>')
    end

    it 'handles nil attribute list' do
      result = @builder.input(nil).to_s
      expect(result).to eq('<input>')
    end

    it 'does not render boolean attribute when its value is false' do
      result = @builder.input(required: false).to_s
      expect(result).to eq('<input>')
    end

    it 'does not render boolean attribute when its value is nil' do
      result = @builder.input(required: nil).to_s
      expect(result).to eq('<input>')
    end

    it 'does render boolean attribute when its value is true' do
      result = @builder.input(required: true).to_s
      expect(result).to eq('<input required="required">')
    end

    it 'does render boolean attribute when its value is trueish' do
      result = @builder.input(required: 'yes').to_s
      expect(result).to eq('<input required="required">')
    end

    it 'also handles strings for detection of boolean attributes' do
      result = @builder.input('required' => true).to_s
      expect(result).to eq('<input required="required">')
    end

    it 'renders multiple attributes' do
      result = @builder.input('required' => true, 'value' => 'Title "book"', 'something' => 'bar').to_s
      expect(result).to eq('<input required="required" value="Title "book"" something="bar">')
    end
  end

  ##############################################################################
  # TEXT
  ##############################################################################

  describe 'plain text' do
    it 'renders plain text' do
      result = @builder.text('Foo').to_s
      expect(result).to eq('Foo')
    end

    it 'accepts any object that respond to #to_s' do
      result = @builder.text(23).to_s
      expect(result).to eq('23')
    end

    it 'renders plain text inside a tag' do
      result = @builder.p do
        span('Foo')
        text('Bar')
      end.to_s

      expect(result).to eq(%(<p>\n<span>Foo</span>\nBar\n</p>))
    end

    it 'ignores block' do
      result = @builder.text('Foo') { p 'Bar' }.to_s
      expect(result).to eq('Foo')
    end

    it 'allows concatenation with raw string' do
      result = @builder.p do
        span('Foo') +
          'Bar'
      end.to_s

      expect(result).to eq(%(<p>\n<span>Foo</span>\nBar\n</p>))
    end

    it 'escapes HTML inside' do
      result = @builder.text(%(<p>Foo</p>)).to_s
      expect(result).to eq('&lt;p&gt;Foo&lt;&#x2F;p&gt;')
    end
  end
end
