require 'test_helper'

describe Lotus::Helpers::FormHelper do
  let(:view)   { FormHelperView.new(params) }
  let(:params) { Hash[] }
  let(:action) { '/books' }

  #
  # FORM
  #

  describe '#form_for' do
    it 'renders' do
      actual = view.form_for(:book, action).to_s
      actual.must_equal %(<form action="/books" method="POST" accept-charset="utf-8" id="book-form"></form>)
    end

    it "allows to override 'id' attribute" do
      actual = view.form_for(:book, action, id: 'books').to_s
      actual.must_equal %(<form action="/books" method="POST" accept-charset="utf-8" id="books"></form>)
    end

    it "allows to override 'method' attribute (get)" do
      actual = view.form_for(:book, action, method: 'get').to_s
      actual.must_equal %(<form action="/books" method="GET" accept-charset="utf-8" id="book-form"></form>)
    end

    it "allows to override 'method' attribute (:get)" do
      actual = view.form_for(:book, action, method: :get).to_s
      actual.must_equal %(<form action="/books" method="GET" accept-charset="utf-8" id="book-form"></form>)
    end

    it "allows to override 'method' attribute (GET)" do
      actual = view.form_for(:book, action, method: 'GET').to_s
      actual.must_equal %(<form action="/books" method="GET" accept-charset="utf-8" id="book-form"></form>)
    end

    [:patch, :put, :delete].each do |verb|
      it "allows to override 'method' attribute (#{ verb })" do
        actual = view.form_for(:book, action, method: verb) do
          text_field :title
        end.to_s

        actual.must_equal %(<form action="/books" method="POST" accept-charset="utf-8" id="book-form">\n<input type="hidden" name="_method" value="#{ verb.to_s.upcase }">\n<input type="text" name="book[title]" id="book-title" value="">\n</form>)
      end
    end

    it "allows to override 'action' attribute" do
      actual = view.form_for(:book, action, action: '/b').to_s
      actual.must_equal %(<form action="/b" method="POST" accept-charset="utf-8" id="book-form"></form>)
    end

    it "allows to specify HTML attributes" do
      actual = view.form_for(:book, action, class: 'form-horizonal').to_s
      actual.must_equal %(<form action="/books" method="POST" accept-charset="utf-8" id="book-form" class="form-horizonal"></form>)
    end

    describe "CSRF protection" do
      let(:view)       { SessionFormHelperView.new(params, csrf_token) }
      let(:csrf_token) { 'abc123' }

      it "injects hidden field session is enabled" do
        actual = view.form_for(:book, action, class: 'form-horizonal') { }
        actual.to_s.must_equal %(<form action="/books" method="POST" accept-charset="utf-8" id="book-form" class="form-horizonal">\n<input type="hidden" name="_csrf_token" value="#{ csrf_token }">\n</form>)
      end

      describe "with missing token" do
        let(:csrf_token) { nil }

        it "doesn't inject hidden field" do
          actual = view.form_for(:book, action, class: 'form-horizonal') { }
          actual.to_s.must_equal %(<form action="/books" method="POST" accept-charset="utf-8" id="book-form" class="form-horizonal">\n\n</form>)
        end
      end

      [:patch, :put, :delete].each do |verb|
        it "it injects hidden field when Method Override (#{ verb }) is active" do
          actual = view.form_for(:book, action, method: verb) do
            text_field :title
          end.to_s

          actual.must_equal %(<form action="/books" method="POST" accept-charset="utf-8" id="book-form">\n<input type="hidden" name="_method" value="#{ verb.to_s.upcase }">\n<input type="hidden" name="_csrf_token" value="#{ csrf_token }">\n<input type="text" name="book[title]" id="book-title" value="">\n</form>)
        end
      end
    end
  end

  #
  # NESTED FIELDS
  #

  describe '#fields_for' do
    it "renders" do
      actual = view.form_for(:book, action) do
        fields_for :categories do
          text_field :name

          fields_for :subcategories do
            text_field :name
          end

          text_field :name2
        end

        text_field :title
      end.to_s

      actual.must_equal %(<form action="/books" method="POST" accept-charset="utf-8" id="book-form">\n<input type="text" name="book[categories][name]" id="book-categories-name" value="">\n<input type="text" name="book[categories][subcategories][name]" id="book-categories-subcategories-name" value="">\n<input type="text" name="book[categories][name2]" id="book-categories-name2" value="">\n<input type="text" name="book[title]" id="book-title" value="">\n</form>)
    end

    describe "with filled params" do
      let(:params) { Hash[book: { title: 'TDD', categories: { name: 'foo', name2: 'bar', subcategories: { name: 'sub' } } }] }

      it "renders" do
        actual = view.form_for(:book, action) do
          fields_for :categories do
            text_field :name

            fields_for :subcategories do
              text_field :name
            end

            text_field :name2
          end

          text_field :title
        end.to_s

        actual.must_equal %(<form action="/books" method="POST" accept-charset="utf-8" id="book-form">\n<input type="text" name="book[categories][name]" id="book-categories-name" value="foo">\n<input type="text" name="book[categories][subcategories][name]" id="book-categories-subcategories-name" value="sub">\n<input type="text" name="book[categories][name2]" id="book-categories-name2" value="bar">\n<input type="text" name="book[title]" id="book-title" value="TDD">\n</form>)
      end
    end
  end

  #
  # INPUT FIELDS
  #

  describe '#check_box' do
    it 'renders' do
      actual = view.form_for(:book, action) do
        check_box :free_shipping
      end.to_s

      actual.must_include %(<input type="hidden" name="book[free_shipping]" value="0">\n<input type="checkbox" name="book[free_shipping]" id="book-free-shipping" value="1">)
    end

    it 'allows to pass checked and unchecked value' do
      actual = view.form_for(:book, action) do
        check_box :free_shipping, checked_value: 'true', unchecked_value: 'false'
      end.to_s

      actual.must_include %(<input type="hidden" name="book[free_shipping]" value="false">\n<input type="checkbox" name="book[free_shipping]" id="book-free-shipping" value="true">)
    end

    it "allows to override 'id' attribute" do
      actual = view.form_for(:book, action) do
        check_box :free_shipping, id: 'shipping'
      end.to_s

      actual.must_include %(<input type="hidden" name="book[free_shipping]" value="0">\n<input type="checkbox" name="book[free_shipping]" id="shipping" value="1">)
    end

    it "allows to override 'name' attribute" do
      actual = view.form_for(:book, action) do
        check_box :free_shipping, name: 'book[free]'
      end.to_s

      actual.must_include %(<input type="hidden" name="book[free]" value="0">\n<input type="checkbox" name="book[free]" id="book-free-shipping" value="1">)
    end

    it "allows to specify HTML attributes" do
      actual = view.form_for(:book, action) do
        check_box :free_shipping, class: 'form-control'
      end.to_s

      actual.must_include %(<input type="hidden" name="book[free_shipping]" value="0">\n<input type="checkbox" name="book[free_shipping]" id="book-free-shipping" value="1" class="form-control">)
    end

    it "doesn't render hidden field if 'value' attribute is specified" do
      actual = view.form_for(:book, action) do
        check_box :free_shipping, value: 'ok'
      end.to_s

      actual.wont_include %(<input type="hidden" name="book[free_shipping]" value="0">)
      actual.must_include %(<input type="checkbox" name="book[free_shipping]" id="book-free-shipping" value="ok">)
    end

    it "renders hidden field if 'value' attribute and 'unchecked_value' option are both specified" do
      actual = view.form_for(:book, action) do
        check_box :free_shipping, value: 'yes', unchecked_value: 'no'
      end.to_s

      actual.must_include %(<input type="hidden" name="book[free_shipping]" value="no">\n<input type="checkbox" name="book[free_shipping]" id="book-free-shipping" value="yes">)
    end

    it "handles multiple checkboxes" do
      actual = view.form_for(:book, action) do
        check_box :languages, name: 'book[languages][]', value: 'italian' #, id: nil FIXME
        check_box :languages, name: 'book[languages][]', value: 'english' #, id: nil FIXME
      end.to_s

      actual.must_include %(<input type="checkbox" name="book[languages][]" id="book-languages" value="italian">\n<input type="checkbox" name="book[languages][]" id="book-languages" value="english">)
    end

    describe "with filled params" do
      let(:params) { Hash[book: { free_shipping: val }] }

      describe "when the params value equals to check box value" do
        let(:val) { '1' }

        it "renders with 'checked' attribute" do
          actual = view.form_for(:book, action) do
            check_box :free_shipping
          end.to_s

          actual.must_include %(<input type="hidden" name="book[free_shipping]" value="0">\n<input type="checkbox" name="book[free_shipping]" id="book-free-shipping" value="1" checked="checked">)
        end
      end

      describe "when the params value equals to the hidden field value" do
        let(:val) { '0' }

        it "renders without 'checked' attribute" do
          actual = view.form_for(:book, action) do
            check_box :free_shipping
          end.to_s

          actual.must_include %(<input type="hidden" name="book[free_shipping]" value="0">\n<input type="checkbox" name="book[free_shipping]" id="book-free-shipping" value="1">)
        end

        it "allows to override 'checked' attribute" do
          actual = view.form_for(:book, action) do
            check_box :free_shipping, checked: 'checked'
          end.to_s

          actual.must_include %(<input type="hidden" name="book[free_shipping]" value="0">\n<input type="checkbox" name="book[free_shipping]" id="book-free-shipping" value="1" checked="checked">)
        end
      end

      describe "when multiple params are present" do
        let(:params) { Hash[book: { languages: ['italian']}] }

        it "handles multiple checkboxes" do
          actual = view.form_for(:book, action) do
            check_box :languages, name: 'book[languages][]', value: 'italian' #, id: nil FIXME
            check_box :languages, name: 'book[languages][]', value: 'english' #, id: nil FIXME
          end.to_s

          actual.must_include %(<input type="checkbox" name="book[languages][]" id="book-languages" value="italian" checked="checked">\n<input type="checkbox" name="book[languages][]" id="book-languages" value="english">)
        end
      end
    end
  end

  describe "#color_field" do
    it "renders" do
      actual = view.form_for(:book, action) do
        color_field :cover
      end.to_s

      actual.must_include %(<input type="color" name="book[cover]" id="book-cover" value="">)
    end

    it "allows to override 'id' attribute" do
      actual = view.form_for(:book, action) do
        color_field :cover, id: 'b-cover'
      end.to_s

      actual.must_include %(<input type="color" name="book[cover]" id="b-cover" value="">)
    end

    it "allows to override 'name' attribute" do
      actual = view.form_for(:book, action) do
        color_field :cover, name: 'cover'
      end.to_s

      actual.must_include %(<input type="color" name="cover" id="book-cover" value="">)
    end

    it "allows to override 'value' attribute" do
      actual = view.form_for(:book, action) do
        color_field :cover, value: '#ffffff'
      end.to_s

      actual.must_include %(<input type="color" name="book[cover]" id="book-cover" value="#ffffff">)
    end

    it "allows to specify HTML attributes" do
      actual = view.form_for(:book, action) do
        color_field :cover, class: 'form-control'
      end.to_s

      actual.must_include %(<input type="color" name="book[cover]" id="book-cover" value="" class="form-control">)
    end

    describe "with filled params" do
      let(:params) { Hash[book: { cover: val }] }
      let(:val)  { '#d3397e' }

      it "renders with value" do
        actual = view.form_for(:book, action) do
          color_field :cover
        end.to_s

        actual.must_include %(<input type="color" name="book[cover]" id="book-cover" value="#{ val }">)
      end

      it "allows to override 'value' attribute" do
        actual = view.form_for(:book, action) do
          color_field :cover, value: '#000000'
        end.to_s

        actual.must_include %(<input type="color" name="book[cover]" id="book-cover" value="#000000">)
      end
    end
  end

  describe "#date_field" do
    it "renders" do
      actual = view.form_for(:book, action) do
        date_field :release_date
      end.to_s

      actual.must_include %(<input type="date" name="book[release_date]" id="book-release-date" value="">)
    end

    it "allows to override 'id' attribute" do
      actual = view.form_for(:book, action) do
        date_field :release_date, id: 'release-date'
      end.to_s

      actual.must_include %(<input type="date" name="book[release_date]" id="release-date" value="">)
    end

    it "allows to override 'name' attribute" do
      actual = view.form_for(:book, action) do
        date_field :release_date, name: 'release_date'
      end.to_s

      actual.must_include %(<input type="date" name="release_date" id="book-release-date" value="">)
    end

    it "allows to override 'value' attribute" do
      actual = view.form_for(:book, action) do
        date_field :release_date, value: '2015-02-19'
      end.to_s

      actual.must_include %(<input type="date" name="book[release_date]" id="book-release-date" value="2015-02-19">)
    end

    it "allows to specify HTML attributes" do
      actual = view.form_for(:book, action) do
        date_field :release_date, class: 'form-control'
      end.to_s

      actual.must_include %(<input type="date" name="book[release_date]" id="book-release-date" value="" class="form-control">)
    end

    describe "with filled params" do
      let(:params) { Hash[book: { release_date: val }] }
      let(:val)    { '2014-06-23' }

      it "renders with value" do
        actual = view.form_for(:book, action) do
          date_field :release_date
        end.to_s

        actual.must_include %(<input type="date" name="book[release_date]" id="book-release-date" value="#{ val }">)
      end

      it "allows to override 'value' attribute" do
        actual = view.form_for(:book, action) do
          date_field :release_date, value: '2015-03-23'
        end.to_s

        actual.must_include %(<input type="date" name="book[release_date]" id="book-release-date" value="2015-03-23">)
      end
    end
  end

  describe "#datetime_field" do
    it "renders" do
      actual = view.form_for(:book, action) do
        datetime_field :published_at
      end.to_s

      actual.must_include %(<input type="datetime" name="book[published_at]" id="book-published-at" value="">)
    end

    it "allows to override 'id' attribute" do
      actual = view.form_for(:book, action) do
        datetime_field :published_at, id: 'published-timestamp'
      end.to_s

      actual.must_include %(<input type="datetime" name="book[published_at]" id="published-timestamp" value="">)
    end

    it "allows to override 'name' attribute" do
      actual = view.form_for(:book, action) do
        datetime_field :published_at, name: 'book[published][timestamp]'
      end.to_s

      actual.must_include %(<input type="datetime" name="book[published][timestamp]" id="book-published-at" value="">)
    end

    it "allows to override 'value' attribute" do
      actual = view.form_for(:book, action) do
        datetime_field :published_at, value: '2015-02-19T12:50:36Z'
      end.to_s

      actual.must_include %(<input type="datetime" name="book[published_at]" id="book-published-at" value="2015-02-19T12:50:36Z">)
    end

    it "allows to specify HTML attributes" do
      actual = view.form_for(:book, action) do
        datetime_field :published_at, class: 'form-control'
      end.to_s

      actual.must_include %(<input type="datetime" name="book[published_at]" id="book-published-at" value="" class="form-control">)
    end

    describe "with filled params" do
      let(:params) { Hash[book: { published_at: val }] }
      let(:val)    { '2015-02-19T12:56:31Z' }

      it "renders with value" do
        actual = view.form_for(:book, action) do
          datetime_field :published_at
        end.to_s

        actual.must_include %(<input type="datetime" name="book[published_at]" id="book-published-at" value="#{ val }">)
      end

      it "allows to override 'value' attribute" do
        actual = view.form_for(:book, action) do
          datetime_field :published_at, value: '2015-02-19T12:50:36Z'
        end.to_s

        actual.must_include %(<input type="datetime" name="book[published_at]" id="book-published-at" value="2015-02-19T12:50:36Z">)
      end
    end
  end

  describe "#datetime_local_field" do
    it "renders" do
      actual = view.form_for(:book, action) do
        datetime_local_field :released_at
      end.to_s

      actual.must_include %(<input type="datetime-local" name="book[released_at]" id="book-released-at" value="">)
    end

    it "allows to override 'id' attribute" do
      actual = view.form_for(:book, action) do
        datetime_local_field :released_at, id: 'local-release-timestamp'
      end.to_s

      actual.must_include %(<input type="datetime-local" name="book[released_at]" id="local-release-timestamp" value="">)
    end

    it "allows to override 'name' attribute" do
      actual = view.form_for(:book, action) do
        datetime_local_field :released_at, name: 'book[release-timestamp]'
      end.to_s

      actual.must_include %(<input type="datetime-local" name="book[release-timestamp]" id="book-released-at" value="">)
    end

    it "allows to override 'value' attribute" do
      actual = view.form_for(:book, action) do
        datetime_local_field :released_at, value: '2015-02-19T14:01:28+01:00'
      end.to_s

      actual.must_include %(<input type="datetime-local" name="book[released_at]" id="book-released-at" value="2015-02-19T14:01:28+01:00">)
    end

    it "allows to specify HTML attributes" do
      actual = view.form_for(:book, action) do
        datetime_local_field :released_at, class: 'form-control'
      end.to_s

      actual.must_include %(<input type="datetime-local" name="book[released_at]" id="book-released-at" value="" class="form-control">)
    end

    describe "with filled params" do
      let(:params) { Hash[book: { released_at: val }] }
      let(:val)    { '2015-02-19T14:11:19+01:00' }

      it "renders with value" do
        actual = view.form_for(:book, action) do
          datetime_local_field :released_at
        end.to_s

        actual.must_include %(<input type="datetime-local" name="book[released_at]" id="book-released-at" value="#{ val }">)
      end

      it "allows to override 'value' attribute" do
        actual = view.form_for(:book, action) do
          datetime_local_field :released_at, value: '2015-02-19T14:01:28+01:00'
        end.to_s

        actual.must_include %(<input type="datetime-local" name="book[released_at]" id="book-released-at" value="2015-02-19T14:01:28+01:00">)
      end
    end
  end

  describe "#email_field" do
    it "renders" do
      actual = view.form_for(:book, action) do
        email_field :publisher_email
      end.to_s

      actual.must_include %(<input type="email" name="book[publisher_email]" id="book-publisher-email" value="">)
    end

    it "allows to override 'id' attribute" do
      actual = view.form_for(:book, action) do
        email_field :publisher_email, id: 'publisher-email'
      end.to_s

      actual.must_include %(<input type="email" name="book[publisher_email]" id="publisher-email" value="">)
    end

    it "allows to override 'name' attribute" do
      actual = view.form_for(:book, action) do
        email_field :publisher_email, name: 'book[email]'
      end.to_s

      actual.must_include %(<input type="email" name="book[email]" id="book-publisher-email" value="">)
    end

    it "allows to override 'value' attribute" do
      actual = view.form_for(:book, action) do
        email_field :publisher_email, value: 'publisher@example.org'
      end.to_s

      actual.must_include %(<input type="email" name="book[publisher_email]" id="book-publisher-email" value="publisher@example.org">)
    end

    it "allows to specify 'multiple' attribute" do
      actual = view.form_for(:book, action) do
        email_field :publisher_email, multiple: true
      end.to_s

      actual.must_include %(<input type="email" name="book[publisher_email]" id="book-publisher-email" value="" multiple="true">)
    end

    it "allows to specify HTML attributes" do
      actual = view.form_for(:book, action) do
        email_field :publisher_email, class: 'form-control'
      end.to_s

      actual.must_include %(<input type="email" name="book[publisher_email]" id="book-publisher-email" value="" class="form-control">)
    end

    describe "with filled params" do
      let(:params) { Hash[book: { publisher_email: val }] }
      let(:val)    { 'maria@publisher.org' }

      it "renders with value" do
        actual = view.form_for(:book, action) do
          email_field :publisher_email
        end.to_s

        actual.must_include %(<input type="email" name="book[publisher_email]" id="book-publisher-email" value="maria@publisher.org">)
      end

      it "allows to override 'value' attribute" do
        actual = view.form_for(:book, action) do
          email_field :publisher_email, value: 'publisher@example.org'
        end.to_s

        actual.must_include %(<input type="email" name="book[publisher_email]" id="book-publisher-email" value="publisher@example.org">)
      end
    end
  end

  describe "#file_field" do
    it "renders" do
      actual = view.form_for(:book, action) do
        file_field :image_cover
      end.to_s

      actual.must_include %(<input type="file" name="book[image_cover]" id="book-image-cover">)
    end

    it "sets 'enctype' attribute to the form"
    # it "sets 'enctype' attribute to the form" do
    #   actual = view.form_for(:book, action) do
    #     file_field :image_cover
    #   end.to_s

    #   actual.must_include %(<form action="/books" id="book-form" method="POST" enctype="multipart/form-data">)
    # end

    it "sets 'enctype' attribute to the form when there are nested fields"
    # it "sets 'enctype' attribute to the form when there are nested fields" do
    #   actual = view.form_for(:book, action) do
    #     fields_for :images do
    #       file_field :cover
    #     end
    #   end.to_s

    #   actual.must_include %(<form action="/books" id="book-form" method="POST" enctype="multipart/form-data">)
    # end

    it "allows to override 'id' attribute" do
      actual = view.form_for(:book, action) do
        file_field :image_cover, id: 'book-cover'
      end.to_s

      actual.must_include %(<input type="file" name="book[image_cover]" id="book-cover">)
    end

    it "allows to override 'name' attribute" do
      actual = view.form_for(:book, action) do
        file_field :image_cover, name: 'book[cover]'
      end.to_s

      actual.must_include %(<input type="file" name="book[cover]" id="book-image-cover">)
    end

    it "allows to specify 'multiple' attribute" do
      actual = view.form_for(:book, action) do
        file_field :image_cover, multiple: true
      end.to_s

      actual.must_include %(<input type="file" name="book[image_cover]" id="book-image-cover" multiple="true">)
    end

    it "allows to specify single value for 'accept' attribute" do
      actual = view.form_for(:book, action) do
        file_field :image_cover, accept: 'application/pdf'
      end.to_s

      actual.must_include %(<input type="file" name="book[image_cover]" id="book-image-cover" accept="application/pdf">)
    end

    it "allows to specify multiple values for 'accept' attribute" do
      actual = view.form_for(:book, action) do
        file_field :image_cover, accept: 'image/png,image/jpg'
      end.to_s

      actual.must_include %(<input type="file" name="book[image_cover]" id="book-image-cover" accept="image/png,image/jpg">)
    end

    it "allows to specify multiple values (array) for 'accept' attribute" do
      actual = view.form_for(:book, action) do
        file_field :image_cover, accept: ['image/png', 'image/jpg']
      end.to_s

      actual.must_include %(<input type="file" name="book[image_cover]" id="book-image-cover" accept="image/png,image/jpg">)
    end

    describe "with filled params" do
      let(:params) { Hash[book: { image_cover: val }] }
      let(:val)    { 'image' }

      it "ignores value" do
        actual = view.form_for(:book, action) do
          file_field :image_cover
        end.to_s

        actual.must_include %(<input type="file" name="book[image_cover]" id="book-image-cover">)
      end
    end
  end

  describe "#hidden_field" do
    it "renders" do
      actual = view.form_for(:book, action) do
        hidden_field :author_id
      end.to_s

      actual.must_include %(<input type="hidden" name="book[author_id]" id="book-author-id" value="">)
    end

    it "allows to override 'id' attribute" do
      actual = view.form_for(:book, action) do
        hidden_field :author_id, id: 'author-id'
      end.to_s

      actual.must_include %(<input type="hidden" name="book[author_id]" id="author-id" value="">)
    end

    it "allows to override 'name' attribute" do
      actual = view.form_for(:book, action) do
        hidden_field :author_id, name: 'book[author]'
      end.to_s

      actual.must_include %(<input type="hidden" name="book[author]" id="book-author-id" value="">)
    end

    it "allows to override 'value' attribute" do
      actual = view.form_for(:book, action) do
        hidden_field :author_id, value: '23'
      end.to_s

      actual.must_include %(<input type="hidden" name="book[author_id]" id="book-author-id" value="23">)
    end

    it "allows to specify HTML attributes" do
      actual = view.form_for(:book, action) do
        hidden_field :author_id, class: 'form-details'
      end.to_s

      actual.must_include %(<input type="hidden" name="book[author_id]" id="book-author-id" value="" class="form-details">)
    end

    describe "with filled params" do
      let(:params) { Hash[book: { author_id: val }] }
      let(:val)    { '1' }

      it "renders with value" do
        actual = view.form_for(:book, action) do
          hidden_field :author_id
        end.to_s

        actual.must_include %(<input type="hidden" name="book[author_id]" id="book-author-id" value="1">)
      end

      it "allows to override 'value' attribute" do
        actual = view.form_for(:book, action) do
          hidden_field :author_id, value: '23'
        end.to_s

        actual.must_include %(<input type="hidden" name="book[author_id]" id="book-author-id" value="23">)
      end
    end
  end

  describe '#text_area' do
    it "renders the element" do
      actual = view.form_for(:book, action) do
        text_area :description
      end.to_s

      actual.must_include %(<textarea name="book[description]" id="book-description"></textarea>)
    end

    it "allows to override 'id' attribute" do
      actual = view.form_for(:book, action) do
        text_area :description, nil, id: 'desc'
      end.to_s

      actual.must_include %(<textarea name="book[description]" id="desc"></textarea>)
    end

    it "allows to override 'name' attribute" do
      actual = view.form_for(:book, action) do
        text_area :description, nil, name: 'book[desc]'
      end.to_s

      actual.must_include %(<textarea name="book[desc]" id="book-description"></textarea>)
    end

    it "allows to specify HTML attributes" do
      actual = view.form_for(:book, action) do
        text_area :description, nil, class: 'form-control', cols: '5'
      end.to_s

      actual.must_include %(<textarea name="book[description]" id="book-description" class="form-control" cols="5"></textarea>)
    end

    describe "set content explicitly" do
      let(:content) { "A short description of the book" }
      it "allows to set content" do
        actual = view.form_for(:book, action) do
          text_area :description, content
        end.to_s

        actual.must_include %(<textarea name="book[description]" id="book-description">#{content}</textarea>)
      end
    end

    describe "with filled params" do
      let(:params) { Hash[book: {description: val}] }
      let(:val) { "A short description of the book" }

      it "renders with value" do
        actual = view.form_for(:book, action) do
          text_area :description
        end.to_s

        actual.must_include %(<textarea name="book[description]" id="book-description">#{val}</textarea>)
      end

      it "allows to override 'value' attribute" do
        actual = view.form_for(:book, action) do
          text_area :description, 'Just a simple description'
        end.to_s

        actual.must_include %(<textarea name="book[description]" id="book-description">Just a simple description</textarea>)
      end
    end
  end
  describe "#text_field" do
    it "renders" do
      actual = view.form_for(:book, action) do
        text_field :title
      end.to_s

      actual.must_include %(<input type="text" name="book[title]" id="book-title" value="">)
    end

    it "allows to override 'id' attribute" do
      actual = view.form_for(:book, action) do
        text_field :title, id: 'book-short-title'
      end.to_s

      actual.must_include %(<input type="text" name="book[title]" id="book-short-title" value="">)
    end

    it "allows to override 'name' attribute" do
      actual = view.form_for(:book, action) do
        text_field :title, name: 'book[short_title]'
      end.to_s

      actual.must_include %(<input type="text" name="book[short_title]" id="book-title" value="">)
    end

    it "allows to override 'value' attribute" do
      actual = view.form_for(:book, action) do
        text_field :title, value: 'Refactoring'
      end.to_s

      actual.must_include %(<input type="text" name="book[title]" id="book-title" value="Refactoring">)
    end

    it "allows to specify HTML attributes" do
      actual = view.form_for(:book, action) do
        text_field :title, class: 'form-control'
      end.to_s

      actual.must_include %(<input type="text" name="book[title]" id="book-title" value="" class="form-control">)
    end

    describe "with filled params" do
      let(:params) { Hash[book: { title: val }] }
      let(:val)    { 'PPoEA' }

      it "renders with value" do
        actual = view.form_for(:book, action) do
          text_field :title
        end.to_s

        actual.must_include %(<input type="text" name="book[title]" id="book-title" value="PPoEA">)
      end

      it "allows to override 'value' attribute" do
        actual = view.form_for(:book, action) do
          text_field :title, value: 'DDD'
        end.to_s

        actual.must_include %(<input type="text" name="book[title]" id="book-title" value="DDD">)
      end
    end
  end

  describe "#password_field" do
    it "renders" do
      actual = view.form_for(:signup, action) do
        password_field :password
      end.to_s

      actual.must_include %(<input type="password" name="signup[password]" id="signup-password" value="">)
    end

    it "allows to override 'id' attribute" do
      actual = view.form_for(:signup, action) do
        password_field :password, id: 'signup-pass'
      end.to_s

      actual.must_include %(<input type="password" name="signup[password]" id="signup-pass" value="">)
    end

    it "allows to override 'name' attribute" do
      actual = view.form_for(:signup, action) do
        password_field :password, name: 'password'
      end.to_s

      actual.must_include %(<input type="password" name="password" id="signup-password" value="">)
    end

    it "allows to override 'value' attribute" do
      actual = view.form_for(:signup, action) do
        password_field :password, value: 'topsecret'
      end.to_s

      actual.must_include %(<input type="password" name="signup[password]" id="signup-password" value="topsecret">)
    end

    it "allows to specify HTML attributes" do
      actual = view.form_for(:signup, action) do
        password_field :password, class: 'form-control'
      end.to_s

      actual.must_include %(<input type="password" name="signup[password]" id="signup-password" value="" class="form-control">)
    end

    describe "with filled params" do
      let(:params) { Hash[signup: { password: val }] }
      let(:val)    { 'secret' }

      it "ignores value" do
        actual = view.form_for(:signup, action) do
          password_field :password
        end.to_s

        actual.must_include %(<input type="password" name="signup[password]" id="signup-password" value="">)
      end

      it "allows to override 'value' attribute" do
        actual = view.form_for(:signup, action) do
          password_field :password, value: '123'
        end.to_s

        actual.must_include %(<input type="password" name="signup[password]" id="signup-password" value="123">)
      end
    end
  end

  describe "#radio_button" do
    it "renders" do
      actual = view.form_for(:book, action) do
        radio_button :category, 'Fiction'
        radio_button :category, 'Non-Fiction'
      end.to_s

      actual.must_include %(<input type="radio" name="book[category]" value="Fiction">\n<input type="radio" name="book[category]" value="Non-Fiction">)
    end

    it "allows to override 'name' attribute" do
      actual = view.form_for(:book, action) do
        radio_button :category, 'Fiction',     name: 'category_name'
        radio_button :category, 'Non-Fiction', name: 'category_name'
      end.to_s

      actual.must_include %(<input type="radio" name="category_name" value="Fiction">\n<input type="radio" name="category_name" value="Non-Fiction">)
    end

    it "allows to specify HTML attributes" do
      actual = view.form_for(:book, action) do
        radio_button :category, 'Fiction',     class: 'form-control'
        radio_button :category, 'Non-Fiction', class: 'radio-button'
      end.to_s

      actual.must_include %(<input type="radio" name="book[category]" value="Fiction" class="form-control">\n<input type="radio" name="book[category]" value="Non-Fiction" class="radio-button">)
    end

    describe "with filled params" do
      let(:params) { Hash[book: { category: val }] }
      let(:val)    { 'Non-Fiction' }

      it "renders with value" do
        actual = view.form_for(:book, action) do
          radio_button :category, 'Fiction'
          radio_button :category, 'Non-Fiction'
        end.to_s

        actual.must_include %(<input type="radio" name="book[category]" value="Fiction">\n<input type="radio" name="book[category]" value="Non-Fiction" checked="checked">)
      end
    end
  end

  describe "#select" do
    let(:values) { Hash['it' => 'Italy', 'us' => 'United States'] }

    it "renders" do
      actual = view.form_for(:book, action) do
        select :store, values
      end.to_s

      actual.must_include %(<select name="book[store]" id="book-store">\n<option value="it">Italy</option>\n<option value="us">United States</option>\n</select>)
    end

    it "allows to override 'id' attribute" do
      actual = view.form_for(:book, action) do
        select :store, values, id: 'store'
      end.to_s

      actual.must_include %(<select name="book[store]" id="store">\n<option value="it">Italy</option>\n<option value="us">United States</option>\n</select>)
    end

    it "allows to override 'name' attribute" do
      actual = view.form_for(:book, action) do
        select :store, values, name: 'store'
      end.to_s

      actual.must_include %(<select name="store" id="book-store">\n<option value="it">Italy</option>\n<option value="us">United States</option>\n</select>)
    end

    it "allows to specify HTML attributes" do
      actual = view.form_for(:book, action) do
        select :store, values, class: 'form-control'
      end.to_s

      actual.must_include %(<select name="book[store]" id="book-store" class="form-control">\n<option value="it">Italy</option>\n<option value="us">United States</option>\n</select>)
    end

    it "allows to specify HTML attributes for options" do
      actual = view.form_for(:book, action) do
        select :store, values, options: { class: 'form-option' }
      end.to_s

      actual.must_include %(<select name="book[store]" id="book-store">\n<option value="it" class="form-option">Italy</option>\n<option value="us" class="form-option">United States</option>\n</select>)
    end

    describe "with filled params" do
      let(:params) { Hash[book: { store: val }] }
      let(:val)    { 'it' }

      it "renders with value" do
        actual = view.form_for(:book, action) do
          select :store, values
        end.to_s

        actual.must_include %(<select name="book[store]" id="book-store">\n<option value="it" selected="selected">Italy</option>\n<option value="us">United States</option>\n</select>)
      end
    end
  end
end
