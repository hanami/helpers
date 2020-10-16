# frozen_string_literal: true

require "ostruct"

RSpec.describe Hanami::Helpers::FormHelper do
  let(:view)   { FormHelperView.new(params) }
  let(:params) { Hash[] }
  let(:action) { "/books" }

  #
  # FORM
  #

  describe "#form_for" do
    it "renders" do
      actual = view.form_for(:book, action).to_s
      expect(actual).to eq(%(<form action="/books" method="POST" accept-charset="utf-8" id="book-form"></form>))
    end

    it "allows to override 'id' attribute" do
      actual = view.form_for(:book, action, id: "books").to_s
      expect(actual).to eq(%(<form action="/books" method="POST" accept-charset="utf-8" id="books"></form>))
    end

    it "allows to override 'method' attribute (get)" do
      actual = view.form_for(:book, action, method: "get").to_s
      expect(actual).to eq(%(<form action="/books" method="GET" accept-charset="utf-8" id="book-form"></form>))
    end

    it "allows to override 'method' attribute (:get)" do
      actual = view.form_for(:book, action, method: :get).to_s
      expect(actual).to eq(%(<form action="/books" method="GET" accept-charset="utf-8" id="book-form"></form>))
    end

    it "allows to override 'method' attribute (GET)" do
      actual = view.form_for(:book, action, method: "GET").to_s
      expect(actual).to eq(%(<form action="/books" method="GET" accept-charset="utf-8" id="book-form"></form>))
    end

    %i[patch put delete].each do |verb|
      it "allows to override 'method' attribute (#{verb})" do
        actual = view.form_for(:book, action, method: verb) do
          text_field :title
        end.to_s

        expect(actual).to eq(%(<form action="/books" method="POST" accept-charset="utf-8" id="book-form">\n<input type="hidden" name="_method" value="#{verb.to_s.upcase}">\n<input type="text" name="book[title]" id="book-title" value="">\n</form>))
      end
    end

    it "allows to override 'action' attribute" do
      actual = view.form_for(:book, action, action: "/b").to_s
      expect(actual).to eq(%(<form action="/b" method="POST" accept-charset="utf-8" id="book-form"></form>))
    end

    it "allows to specify HTML attributes" do
      actual = view.form_for(:book, action, class: "form-horizonal").to_s
      expect(actual).to eq(%(<form action="/books" method="POST" accept-charset="utf-8" id="book-form" class="form-horizonal"></form>))
    end

    describe "CSRF protection" do
      let(:view)       { SessionFormHelperView.new(params, csrf_token) }
      let(:csrf_token) { "abc123" }

      it "injects hidden field session is enabled" do
        actual = view.form_for(:book, action, class: "form-horizonal") {}
        expect(actual.to_s).to eq(%(<form action="/books" method="POST" accept-charset="utf-8" id="book-form" class="form-horizonal">\n<input type="hidden" name="_csrf_token" value="#{csrf_token}">\n</form>))
      end

      describe "with missing token" do
        let(:csrf_token) { nil }

        it "doesn't inject hidden field" do
          actual = view.form_for(:book, action, class: "form-horizonal") {}
          expect(actual.to_s).to eq(%(<form action="/books" method="POST" accept-charset="utf-8" id="book-form" class="form-horizonal">\n\n</form>))
        end
      end

      describe "with csrf_token on get verb" do
        let(:csrf_token) { "abcd-1234-xyz" }

        it "doesn't inject hidden field" do
          actual = view.form_for(:book, action, method: "GET", class: "form-horizonal") {}
          expect(actual.to_s).to eq(%(<form action="/books" method="GET" accept-charset="utf-8" id="book-form" class="form-horizonal">\n\n</form>))
        end
      end

      %i[patch put delete].each do |verb|
        it "it injects hidden field when Method Override (#{verb}) is active" do
          actual = view.form_for(:book, action, method: verb) do
            text_field :title
          end.to_s

          expect(actual).to eq(%(<form action="/books" method="POST" accept-charset="utf-8" id="book-form">\n<input type="hidden" name="_method" value="#{verb.to_s.upcase}">\n<input type="hidden" name="_csrf_token" value="#{csrf_token}">\n<input type="text" name="book[title]" id="book-title" value="">\n</form>))
        end
      end
    end

    describe "CSRF meta tags" do
      let(:view)       { SessionFormHelperView.new(params, csrf_token) }
      let(:csrf_token) { "abc123" }

      it "prints meta tags" do
        expected = %(<meta name="csrf-param" content="_csrf_token">\n<meta name="csrf-token" content="#{csrf_token}">)
        expect(view.csrf_meta_tags.to_s).to eq(expected)
      end

      context "when CSRF token is nil" do
        let(:csrf_token) { nil }

        it "returns nil" do
          expect(view.csrf_meta_tags).to be(nil)
        end
      end
    end

    describe "remote: true" do
      it "adds data-remote=true to form attributes" do
        actual = view.form_for(:book, action, remote: true) {}
        expect(actual.to_s).to eq(%(<form action="/books" method="POST" accept-charset="utf-8" id="book-form" data-remote="true">\n\n</form>))
      end

      it "adds data-remote=false to form attributes" do
        actual = view.form_for(:book, action, remote: false) {}
        expect(actual.to_s).to eq(%(<form action="/books" method="POST" accept-charset="utf-8" id="book-form" data-remote="false">\n\n</form>))
      end

      it "adds data-remote= to form attributes" do
        actual = view.form_for(:book, action, remote: nil) {}
        expect(actual.to_s).to eq(%(<form action="/books" method="POST" accept-charset="utf-8" id="book-form" data-remote="">\n\n</form>))
      end
    end

    context "inline params" do
      let(:view)   { FormHelperView.new(params) }
      let(:params) { {song: {title: "Orphans"}} }
      let(:inline_params) { {song: {title: "Arabesque"}} }
      let(:action) { "/songs" }

      it "renders" do
        actual = view.form_for(:song, action, params: inline_params) do
          text_field :title
        end.to_s

        expect(actual).to eq(%(<form action="/songs" method="POST" accept-charset="utf-8" id="song-form">\n<input type="text" name="song[title]" id="song-title" value="#{inline_params.dig(:song, :title)}">\n</form>))
      end
    end
  end

  #
  # NESTED FIELDS
  #

  describe "#fields_for" do
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

      expect(actual).to eq(%(<form action="/books" method="POST" accept-charset="utf-8" id="book-form">\n<input type="text" name="book[categories][name]" id="book-categories-name" value="">\n<input type="text" name="book[categories][subcategories][name]" id="book-categories-subcategories-name" value="">\n<input type="text" name="book[categories][name2]" id="book-categories-name2" value="">\n<input type="text" name="book[title]" id="book-title" value="">\n</form>))
    end

    describe "with filled params" do
      let(:params) { Hash[book: {title: "TDD", categories: {name: "foo", name2: "bar", subcategories: {name: "sub"}}}] }

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

        expect(actual).to eq(%(<form action="/books" method="POST" accept-charset="utf-8" id="book-form">\n<input type="text" name="book[categories][name]" id="book-categories-name" value="foo">\n<input type="text" name="book[categories][subcategories][name]" id="book-categories-subcategories-name" value="sub">\n<input type="text" name="book[categories][name2]" id="book-categories-name2" value="bar">\n<input type="text" name="book[title]" id="book-title" value="TDD">\n</form>))
      end
    end
  end

  describe "#fields_for_collection" do
    let(:params) { Hash[book: {categories: [{name: "foo", new: true, genre: nil}]}] }

    it "renders" do
      actual = view.form_for(:book, action) do
        fields_for_collection :categories do
          text_field :name
          hidden_field :name
          text_area :name
          check_box :new
          select :genre, [%w[Terror terror], %w[Comedy comedy]]
          color_field :name
          date_field :name
          datetime_field :name
          datetime_local_field :name
          time_field :name
          month_field :name
          week_field :name
          email_field :name
          url_field :name
          tel_field :name
          file_field :name
          number_field :name
          range_field :name
          search_field :name
          radio_button :name, "Fiction"
          password_field :name
          datalist :name, ["Italy", "United States"], "books"
        end
      end.to_s

      expected = <<~END
        <form action="/books" method="POST" accept-charset="utf-8" id="book-form">
        <input type="text" name="book[categories][][name]" id="book-categories-0-name" value="foo">
        <input type="hidden" name="book[categories][][name]" id="book-categories-0-name" value="foo">
        <textarea name="book[categories][][name]" id="book-categories-0-name">foo</textarea>
        <input type="hidden" name="book[categories][][new]" value="0">
        <input type="checkbox" name="book[categories][][new]" id="book-categories-0-new" value="1" checked="checked">
        <select name="book[categories][][genre]" id="book-categories-0-genre">
        <option value="terror">Terror</option>
        <option value="comedy">Comedy</option>
        </select>
        <input type="color" name="book[categories][][name]" id="book-categories-0-name" value="foo">
        <input type="date" name="book[categories][][name]" id="book-categories-0-name" value="foo">
        <input type="datetime" name="book[categories][][name]" id="book-categories-0-name" value="foo">
        <input type="datetime-local" name="book[categories][][name]" id="book-categories-0-name" value="foo">
        <input type="time" name="book[categories][][name]" id="book-categories-0-name" value="foo">
        <input type="month" name="book[categories][][name]" id="book-categories-0-name" value="foo">
        <input type="week" name="book[categories][][name]" id="book-categories-0-name" value="foo">
        <input type="email" name="book[categories][][name]" id="book-categories-0-name" value="foo">
        <input type="url" name="book[categories][][name]" id="book-categories-0-name" value="">
        <input type="tel" name="book[categories][][name]" id="book-categories-0-name" value="foo">
        <input type="file" name="book[categories][][name]" id="book-categories-0-name">
        <input type="number" name="book[categories][][name]" id="book-categories-0-name" value="foo">
        <input type="range" name="book[categories][][name]" id="book-categories-0-name" value="foo">
        <input type="search" name="book[categories][][name]" id="book-categories-0-name" value="foo">
        <input type="radio" name="book[categories][][name]" value="Fiction">
        <input type="password" name="book[categories][][name]" id="book-categories-0-name" value="">
        <input type="text" name="book[categories][][name]" id="book-categories-0-name" value="foo" list="books">
        <datalist id="books">
        <option value="Italy"></option>
        <option value="United States"></option>
        </datalist>
        </form>
      END

      expect(actual).to eq(expected.chomp)
    end
  end

  #
  # LABEL
  #

  describe "#label" do
    it "renders capitalized string" do
      actual = view.form_for(:book, action) do
        label :free_shipping
      end.to_s

      expect(actual).to include(%(<label for="book-free-shipping">Free shipping</label>))
    end

    it "accepts a string as custom content" do
      actual = view.form_for(:book, action) do
        label "Free Shipping", for: :free_shipping
      end.to_s

      expect(actual).to include(%(<label for="book-free-shipping">Free Shipping</label>))
    end

    it "renders a label with block" do
      actual = view.form_for(:book, action) do
        label for: :free_shipping do
          text "Free Shipping"
          abbr "*", title: "optional", 'aria-label': "optional"
        end
      end.to_s

      expected = <<~END
        <form action="/books" method="POST" accept-charset="utf-8" id="book-form">
        <label for="book-free-shipping">
        Free Shipping
        <abbr title="optional" aria-label="optional">*</abbr>
        </label>
        </form>
      END

      expect(actual).to eq(expected.chomp)
    end

    it 'accepts a string as explicit "for" attribute' do
      actual = view.form_for(:book, action) do
        label :free_shipping, for: "free-shipping"
      end.to_s

      expect(actual).to include(%(<label for="free-shipping">Free shipping</label>))
    end
  end

  #
  # BUTTONS
  #

  describe "#button" do
    it "renders a button" do
      actual = view.form_for(:book, action) do
        button "Click me"
      end.to_s

      expect(actual).to include(%(<button>Click me</button>))
    end

    it "renders a button with HTML attributes" do
      actual = view.form_for(:book, action) do
        button "Click me", class: "btn btn-secondary"
      end.to_s

      expect(actual).to include(%(<button class="btn btn-secondary">Click me</button>))
    end

    it "renders a button with block" do
      actual = view.form_for(:book, action) do
        button class: "btn btn-secondary" do
          span class: "oi oi-check"
        end
      end.to_s

      expected = <<~END
        <form action="/books" method="POST" accept-charset="utf-8" id="book-form">
        <button class="btn btn-secondary">
        <span class="oi oi-check"></span>
        </button>
        </form>
      END

      expect(actual).to eq(expected.chomp)
    end
  end

  describe "#submit" do
    it "renders a submit button" do
      actual = view.form_for(:book, action) do
        submit "Create"
      end.to_s

      expect(actual).to include(%(<button type="submit">Create</button>))
    end

    it "renders a submit button with HTML attributes" do
      actual = view.form_for(:book, action) do
        submit "Create", class: "btn btn-primary"
      end.to_s

      expect(actual).to include(%(<button type="submit" class="btn btn-primary">Create</button>))
    end

    it "renders a submit button with block" do
      actual = view.form_for(:book, action) do
        submit class: "btn btn-primary" do
          span class: "oi oi-check"
        end
      end.to_s

      expected = <<~END
        <form action="/books" method="POST" accept-charset="utf-8" id="book-form">
        <button type="submit" class="btn btn-primary">
        <span class="oi oi-check"></span>
        </button>
        </form>
      END

      expect(actual).to eq(expected.chomp)
    end
  end

  describe "#image_button" do
    it "renders an image button" do
      actual = view.form_for(:book, action) do
        image_button "https://hanamirb.org/assets/image_button.png"
      end.to_s

      expect(actual).to include(%(<input type="image" src="https://hanamirb.org/assets/image_button.png">))
    end

    it "renders an image button with HTML attributes" do
      actual = view.form_for(:book, action) do
        image_button "https://hanamirb.org/assets/image_button.png", name: "image", width: "50"
      end.to_s

      expect(actual).to include(%(<input name="image" width="50" type="image" src="https://hanamirb.org/assets/image_button.png">))
    end

    it "prevents XSS attacks" do
      actual = view.form_for(:book, action) do
        image_button "<script>alert('xss');</script>"
      end.to_s

      expect(actual).to include(%(<input type="image" src="">))
    end
  end

  #
  # FIELDSET
  #
  describe "#fieldset" do
    it "renders a fieldset" do
      actual = view.form_for(:book, action) do
        fieldset do
          legend "Author"

          fields_for :author do
            label :name
            text_field :name
          end
        end
      end.to_s

      expect(actual).to include(%(<fieldset>\n<legend>Author</legend>\n<label for="book-author-name">Name</label>\n<input type="text" name="book[author][name]" id="book-author-name" value="">\n</fieldset>))
    end
  end

  #
  # INPUT FIELDS
  #

  describe "#check_box" do
    it "renders" do
      actual = view.form_for(:book, action) do
        check_box :free_shipping
      end.to_s

      expect(actual).to include(%(<input type="hidden" name="book[free_shipping]" value="0">\n<input type="checkbox" name="book[free_shipping]" id="book-free-shipping" value="1">))
    end

    it "allows to pass checked and unchecked value" do
      actual = view.form_for(:book, action) do
        check_box :free_shipping, checked_value: "true", unchecked_value: "false"
      end.to_s

      expect(actual).to include(%(<input type="hidden" name="book[free_shipping]" value="false">\n<input type="checkbox" name="book[free_shipping]" id="book-free-shipping" value="true">))
    end

    it "allows to override 'id' attribute" do
      actual = view.form_for(:book, action) do
        check_box :free_shipping, id: "shipping"
      end.to_s

      expect(actual).to include(%(<input type="hidden" name="book[free_shipping]" value="0">\n<input type="checkbox" name="book[free_shipping]" id="shipping" value="1">))
    end

    it "allows to override 'name' attribute" do
      actual = view.form_for(:book, action) do
        check_box :free_shipping, name: "book[free]"
      end.to_s

      expect(actual).to include(%(<input type="hidden" name="book[free]" value="0">\n<input type="checkbox" name="book[free]" id="book-free-shipping" value="1">))
    end

    it "allows to specify HTML attributes" do
      actual = view.form_for(:book, action) do
        check_box :free_shipping, class: "form-control"
      end.to_s

      expect(actual).to include(%(<input type="hidden" name="book[free_shipping]" value="0">\n<input type="checkbox" name="book[free_shipping]" id="book-free-shipping" value="1" class="form-control">))
    end

    it "doesn't render hidden field if 'value' attribute is specified" do
      actual = view.form_for(:book, action) do
        check_box :free_shipping, value: "ok"
      end.to_s

      expect(actual).not_to include(%(<input type="hidden" name="book[free_shipping]" value="0">))
      expect(actual).to include(%(<input type="checkbox" name="book[free_shipping]" id="book-free-shipping" value="ok">))
    end

    it "renders hidden field if 'value' attribute and 'unchecked_value' option are both specified" do
      actual = view.form_for(:book, action) do
        check_box :free_shipping, value: "yes", unchecked_value: "no"
      end.to_s

      expect(actual).to include(%(<input type="hidden" name="book[free_shipping]" value="no">\n<input type="checkbox" name="book[free_shipping]" id="book-free-shipping" value="yes">))
    end

    it "handles multiple checkboxes" do
      actual = view.form_for(:book, action) do
        check_box :languages, name: "book[languages][]", value: "italian" # , id: nil FIXME
        check_box :languages, name: "book[languages][]", value: "english" # , id: nil FIXME
      end.to_s

      expect(actual).to include(%(<input type="checkbox" name="book[languages][]" id="book-languages" value="italian">\n<input type="checkbox" name="book[languages][]" id="book-languages" value="english">))
    end

    describe "with filled params" do
      let(:params) { Hash[book: {free_shipping: val}] }

      describe "when the params value equals to check box value" do
        let(:val) { "1" }

        it "renders with 'checked' attribute" do
          actual = view.form_for(:book, action) do
            check_box :free_shipping
          end.to_s

          expect(actual).to include(%(<input type="hidden" name="book[free_shipping]" value="0">\n<input type="checkbox" name="book[free_shipping]" id="book-free-shipping" value="1" checked="checked">))
        end
      end

      describe "when the params value equals to the hidden field value" do
        let(:val) { "0" }

        it "renders without 'checked' attribute" do
          actual = view.form_for(:book, action) do
            check_box :free_shipping
          end.to_s

          expect(actual).to include(%(<input type="hidden" name="book[free_shipping]" value="0">\n<input type="checkbox" name="book[free_shipping]" id="book-free-shipping" value="1">))
        end

        it "allows to override 'checked' attribute" do
          actual = view.form_for(:book, action) do
            check_box :free_shipping, checked: "checked"
          end.to_s

          expect(actual).to include(%(<input type="hidden" name="book[free_shipping]" value="0">\n<input type="checkbox" name="book[free_shipping]" id="book-free-shipping" value="1" checked="checked">))
        end
      end

      describe "with a boolean argument" do
        let(:val) { true }

        it "renders with 'checked' attribute" do
          actual = view.form_for(:book, action) do
            check_box :free_shipping
          end.to_s

          expect(actual).to include(%(<input type="hidden" name="book[free_shipping]" value="0">\n<input type="checkbox" name="book[free_shipping]" id="book-free-shipping" value="1" checked="checked">))
        end
      end

      describe "when multiple params are present" do
        let(:params) { Hash[book: {languages: ["italian"]}] }

        it "handles multiple checkboxes" do
          actual = view.form_for(:book, action) do
            check_box :languages, name: "book[languages][]", value: "italian" # , id: nil FIXME
            check_box :languages, name: "book[languages][]", value: "english" # , id: nil FIXME
          end.to_s

          expect(actual).to include(%(<input type="checkbox" name="book[languages][]" id="book-languages" value="italian" checked="checked">\n<input type="checkbox" name="book[languages][]" id="book-languages" value="english">))
        end
      end

      describe "checked_value is boolean" do
        let(:params) { Hash[book: {free_shipping: "true"}] }

        it "renders with 'checked' attribute" do
          actual = view.form_for(:book, action) do
            check_box :free_shipping, checked_value: true
          end.to_s

          expect(actual).to include(%(<input type="checkbox" name="book[free_shipping]" id="book-free-shipping" value="true" checked="checked">))
        end
      end

      describe "checked_value is boolean" do
        let(:params) { Hash[book: {free_shipping: "true"}] }

        it "renders with 'checked' attribute" do
          actual = view.form_for(:book, action) do
            check_box :free_shipping, checked_value: true
          end.to_s

          expect(actual).to include(%(<input type="checkbox" name="book[free_shipping]" id="book-free-shipping" value="true" checked="checked">))
        end
      end
    end

    describe "automatic values" do
      describe "checkbox" do
        describe "value boolean, helper boolean, values differ" do
          let(:values) { Hash[book: OpenStruct.new(free_shipping: false)] }

          it "renders" do
            actual = view.form_for(:book, action, values: values) do
              check_box :free_shipping, checked_value: true
            end.to_s

            expect(actual).to include(%(<input type="checkbox" name="book[free_shipping]" id="book-free-shipping" value="true">))
          end
        end
      end
    end
  end

  describe "#color_field" do
    it "renders" do
      actual = view.form_for(:book, action) do
        color_field :cover
      end.to_s

      expect(actual).to include(%(<input type="color" name="book[cover]" id="book-cover" value="">))
    end

    it "allows to override 'id' attribute" do
      actual = view.form_for(:book, action) do
        color_field :cover, id: "b-cover"
      end.to_s

      expect(actual).to include(%(<input type="color" name="book[cover]" id="b-cover" value="">))
    end

    it "allows to override 'name' attribute" do
      actual = view.form_for(:book, action) do
        color_field :cover, name: "cover"
      end.to_s

      expect(actual).to include(%(<input type="color" name="cover" id="book-cover" value="">))
    end

    it "allows to override 'value' attribute" do
      actual = view.form_for(:book, action) do
        color_field :cover, value: "#ffffff"
      end.to_s

      expect(actual).to include(%(<input type="color" name="book[cover]" id="book-cover" value="#ffffff">))
    end

    it "allows to specify HTML attributes" do
      actual = view.form_for(:book, action) do
        color_field :cover, class: "form-control"
      end.to_s

      expect(actual).to include(%(<input type="color" name="book[cover]" id="book-cover" value="" class="form-control">))
    end

    describe "with values" do
      let(:values) { Hash[book: Book.new(cover: val)] }
      let(:val) { "#d3397e" }

      it "renders with value" do
        actual = view.form_for(:book, action, values: values) do
          color_field :cover
        end.to_s

        expect(actual).to include(%(<input type="color" name="book[cover]" id="book-cover" value="#{val}">))
      end

      it "allows to override 'value' attribute" do
        actual = view.form_for(:book, action, values: values) do
          color_field :cover, value: "#000000"
        end.to_s

        expect(actual).to include(%(<input type="color" name="book[cover]" id="book-cover" value="#000000">))
      end
    end

    describe "with filled params" do
      let(:params) { Hash[book: {cover: val}] }
      let(:val) { "#d3397e" }

      it "renders with value" do
        actual = view.form_for(:book, action) do
          color_field :cover
        end.to_s

        expect(actual).to include(%(<input type="color" name="book[cover]" id="book-cover" value="#{val}">))
      end

      it "allows to override 'value' attribute" do
        actual = view.form_for(:book, action) do
          color_field :cover, value: "#000000"
        end.to_s

        expect(actual).to include(%(<input type="color" name="book[cover]" id="book-cover" value="#000000">))
      end
    end
  end

  describe "#date_field" do
    it "renders" do
      actual = view.form_for(:book, action) do
        date_field :release_date
      end.to_s

      expect(actual).to include(%(<input type="date" name="book[release_date]" id="book-release-date" value="">))
    end

    it "allows to override 'id' attribute" do
      actual = view.form_for(:book, action) do
        date_field :release_date, id: "release-date"
      end.to_s

      expect(actual).to include(%(<input type="date" name="book[release_date]" id="release-date" value="">))
    end

    it "allows to override 'name' attribute" do
      actual = view.form_for(:book, action) do
        date_field :release_date, name: "release_date"
      end.to_s

      expect(actual).to include(%(<input type="date" name="release_date" id="book-release-date" value="">))
    end

    it "allows to override 'value' attribute" do
      actual = view.form_for(:book, action) do
        date_field :release_date, value: "2015-02-19"
      end.to_s

      expect(actual).to include(%(<input type="date" name="book[release_date]" id="book-release-date" value="2015-02-19">))
    end

    it "allows to specify HTML attributes" do
      actual = view.form_for(:book, action) do
        date_field :release_date, class: "form-control"
      end.to_s

      expect(actual).to include(%(<input type="date" name="book[release_date]" id="book-release-date" value="" class="form-control">))
    end

    describe "with values" do
      let(:values) { Hash[book: Book.new(release_date: val)] }
      let(:val)    { "2014-06-23" }

      it "renders with value" do
        actual = view.form_for(:book, action, values: values) do
          date_field :release_date
        end.to_s

        expect(actual).to include(%(<input type="date" name="book[release_date]" id="book-release-date" value="#{val}">))
      end

      it "allows to override 'value' attribute" do
        actual = view.form_for(:book, action, values: values) do
          date_field :release_date, value: "2015-03-23"
        end.to_s

        expect(actual).to include(%(<input type="date" name="book[release_date]" id="book-release-date" value="2015-03-23">))
      end
    end

    describe "with filled params" do
      let(:params) { Hash[book: {release_date: val}] }
      let(:val)    { "2014-06-23" }

      it "renders with value" do
        actual = view.form_for(:book, action) do
          date_field :release_date
        end.to_s

        expect(actual).to include(%(<input type="date" name="book[release_date]" id="book-release-date" value="#{val}">))
      end

      it "allows to override 'value' attribute" do
        actual = view.form_for(:book, action) do
          date_field :release_date, value: "2015-03-23"
        end.to_s

        expect(actual).to include(%(<input type="date" name="book[release_date]" id="book-release-date" value="2015-03-23">))
      end
    end
  end

  describe "#datetime_field" do
    it "renders" do
      actual = view.form_for(:book, action) do
        datetime_field :published_at
      end.to_s

      expect(actual).to include(%(<input type="datetime" name="book[published_at]" id="book-published-at" value="">))
    end

    it "allows to override 'id' attribute" do
      actual = view.form_for(:book, action) do
        datetime_field :published_at, id: "published-timestamp"
      end.to_s

      expect(actual).to include(%(<input type="datetime" name="book[published_at]" id="published-timestamp" value="">))
    end

    it "allows to override 'name' attribute" do
      actual = view.form_for(:book, action) do
        datetime_field :published_at, name: "book[published][timestamp]"
      end.to_s

      expect(actual).to include(%(<input type="datetime" name="book[published][timestamp]" id="book-published-at" value="">))
    end

    it "allows to override 'value' attribute" do
      actual = view.form_for(:book, action) do
        datetime_field :published_at, value: "2015-02-19T12:50:36Z"
      end.to_s

      expect(actual).to include(%(<input type="datetime" name="book[published_at]" id="book-published-at" value="2015-02-19T12:50:36Z">))
    end

    it "allows to specify HTML attributes" do
      actual = view.form_for(:book, action) do
        datetime_field :published_at, class: "form-control"
      end.to_s

      expect(actual).to include(%(<input type="datetime" name="book[published_at]" id="book-published-at" value="" class="form-control">))
    end

    describe "with values" do
      let(:values) { Hash[book: Book.new(published_at: val)] }
      let(:val)    { "2015-02-19T12:56:31Z" }

      it "renders with value" do
        actual = view.form_for(:book, action, values: values) do
          datetime_field :published_at
        end.to_s

        expect(actual).to include(%(<input type="datetime" name="book[published_at]" id="book-published-at" value="#{val}">))
      end

      it "allows to override 'value' attribute" do
        actual = view.form_for(:book, action, values: values) do
          datetime_field :published_at, value: "2015-02-19T12:50:36Z"
        end.to_s

        expect(actual).to include(%(<input type="datetime" name="book[published_at]" id="book-published-at" value="2015-02-19T12:50:36Z">))
      end
    end

    describe "with filled params" do
      let(:params) { Hash[book: {published_at: val}] }
      let(:val)    { "2015-02-19T12:56:31Z" }

      it "renders with value" do
        actual = view.form_for(:book, action) do
          datetime_field :published_at
        end.to_s

        expect(actual).to include(%(<input type="datetime" name="book[published_at]" id="book-published-at" value="#{val}">))
      end

      it "allows to override 'value' attribute" do
        actual = view.form_for(:book, action) do
          datetime_field :published_at, value: "2015-02-19T12:50:36Z"
        end.to_s

        expect(actual).to include(%(<input type="datetime" name="book[published_at]" id="book-published-at" value="2015-02-19T12:50:36Z">))
      end
    end
  end

  describe "#datetime_local_field" do
    it "renders" do
      actual = view.form_for(:book, action) do
        datetime_local_field :released_at
      end.to_s

      expect(actual).to include(%(<input type="datetime-local" name="book[released_at]" id="book-released-at" value="">))
    end

    it "allows to override 'id' attribute" do
      actual = view.form_for(:book, action) do
        datetime_local_field :released_at, id: "local-release-timestamp"
      end.to_s

      expect(actual).to include(%(<input type="datetime-local" name="book[released_at]" id="local-release-timestamp" value="">))
    end

    it "allows to override 'name' attribute" do
      actual = view.form_for(:book, action) do
        datetime_local_field :released_at, name: "book[release-timestamp]"
      end.to_s

      expect(actual).to include(%(<input type="datetime-local" name="book[release-timestamp]" id="book-released-at" value="">))
    end

    it "allows to override 'value' attribute" do
      actual = view.form_for(:book, action) do
        datetime_local_field :released_at, value: "2015-02-19T14:01:28+01:00"
      end.to_s

      expect(actual).to include(%(<input type="datetime-local" name="book[released_at]" id="book-released-at" value="2015-02-19T14:01:28+01:00">))
    end

    it "allows to specify HTML attributes" do
      actual = view.form_for(:book, action) do
        datetime_local_field :released_at, class: "form-control"
      end.to_s

      expect(actual).to include(%(<input type="datetime-local" name="book[released_at]" id="book-released-at" value="" class="form-control">))
    end

    describe "with filled params" do
      let(:params) { Hash[book: {released_at: val}] }
      let(:val)    { "2015-02-19T14:11:19+01:00" }

      it "renders with value" do
        actual = view.form_for(:book, action) do
          datetime_local_field :released_at
        end.to_s

        expect(actual).to include(%(<input type="datetime-local" name="book[released_at]" id="book-released-at" value="#{val}">))
      end

      it "allows to override 'value' attribute" do
        actual = view.form_for(:book, action) do
          datetime_local_field :released_at, value: "2015-02-19T14:01:28+01:00"
        end.to_s

        expect(actual).to include(%(<input type="datetime-local" name="book[released_at]" id="book-released-at" value="2015-02-19T14:01:28+01:00">))
      end
    end
  end

  describe "#time_field" do
    it "renders" do
      actual = view.form_for(:book, action) do
        time_field :release_hour
      end.to_s

      expect(actual).to include(%(<input type="time" name="book[release_hour]" id="book-release-hour" value="">))
    end

    it "allows to override 'id' attribute" do
      actual = view.form_for(:book, action) do
        time_field :release_hour, id: "release-hour"
      end.to_s

      expect(actual).to include(%(<input type="time" name="book[release_hour]" id="release-hour" value="">))
    end

    it "allows to override 'name' attribute" do
      actual = view.form_for(:book, action) do
        time_field :release_hour, name: "release_hour"
      end.to_s

      expect(actual).to include(%(<input type="time" name="release_hour" id="book-release-hour" value="">))
    end

    it "allows to override 'value' attribute" do
      actual = view.form_for(:book, action) do
        time_field :release_hour, value: "00:00"
      end.to_s

      expect(actual).to include(%(<input type="time" name="book[release_hour]" id="book-release-hour" value="00:00">))
    end

    it "allows to specify HTML attributes" do
      actual = view.form_for(:book, action) do
        time_field :release_hour, class: "form-control"
      end.to_s

      expect(actual).to include(%(<input type="time" name="book[release_hour]" id="book-release-hour" value="" class="form-control">))
    end

    describe "with values" do
      let(:values) { Hash[book: Book.new(release_hour: val)] }
      let(:val)    { "18:30" }

      it "renders with value" do
        actual = view.form_for(:book, action, values: values) do
          time_field :release_hour
        end.to_s

        expect(actual).to include(%(<input type="time" name="book[release_hour]" id="book-release-hour" value="#{val}">))
      end

      it "allows to override 'value' attribute" do
        actual = view.form_for(:book, action, values: values) do
          time_field :release_hour, value: "17:00"
        end.to_s

        expect(actual).to include(%(<input type="time" name="book[release_hour]" id="book-release-hour" value="17:00">))
      end
    end

    describe "with filled params" do
      let(:params) { Hash[book: {release_hour: val}] }
      let(:val)    { "11:30" }

      it "renders with value" do
        actual = view.form_for(:book, action) do
          time_field :release_hour
        end.to_s

        expect(actual).to include(%(<input type="time" name="book[release_hour]" id="book-release-hour" value="#{val}">))
      end

      it "allows to override 'value' attribute" do
        actual = view.form_for(:book, action) do
          time_field :release_hour, value: "8:15"
        end.to_s

        expect(actual).to include(%(<input type="time" name="book[release_hour]" id="book-release-hour" value="8:15">))
      end
    end
  end

  describe "#month_field" do
    it "renders" do
      actual = view.form_for(:book, action) do
        month_field :release_month
      end.to_s

      expect(actual).to include(%(<input type="month" name="book[release_month]" id="book-release-month" value="">))
    end

    it "allows to override 'id' attribute" do
      actual = view.form_for(:book, action) do
        month_field :release_month, id: "release-month"
      end.to_s

      expect(actual).to include(%(<input type="month" name="book[release_month]" id="release-month" value="">))
    end

    it "allows to override 'name' attribute" do
      actual = view.form_for(:book, action) do
        month_field :release_month, name: "release_month"
      end.to_s

      expect(actual).to include(%(<input type="month" name="release_month" id="book-release-month" value="">))
    end

    it "allows to override 'value' attribute" do
      actual = view.form_for(:book, action) do
        month_field :release_month, value: "2017-03"
      end.to_s

      expect(actual).to include(%(<input type="month" name="book[release_month]" id="book-release-month" value="2017-03">))
    end

    it "allows to specify HTML attributes" do
      actual = view.form_for(:book, action) do
        month_field :release_month, class: "form-control"
      end.to_s

      expect(actual).to include(%(<input type="month" name="book[release_month]" id="book-release-month" value="" class="form-control">))
    end

    describe "with values" do
      let(:values) { Hash[book: Book.new(release_month: val)] }
      let(:val)    { "2017-03" }

      it "renders with value" do
        actual = view.form_for(:book, action, values: values) do
          month_field :release_month
        end.to_s

        expect(actual).to include(%(<input type="month" name="book[release_month]" id="book-release-month" value="#{val}">))
      end

      it "allows to override 'value' attribute" do
        actual = view.form_for(:book, action, values: values) do
          month_field :release_month, value: "2017-04"
        end.to_s

        expect(actual).to include(%(<input type="month" name="book[release_month]" id="book-release-month" value="2017-04">))
      end
    end

    describe "with filled params" do
      let(:params) { Hash[book: {release_month: val}] }
      let(:val)    { "2017-10" }

      it "renders with value" do
        actual = view.form_for(:book, action) do
          month_field :release_month
        end.to_s

        expect(actual).to include(%(<input type="month" name="book[release_month]" id="book-release-month" value="#{val}">))
      end

      it "allows to override 'value' attribute" do
        actual = view.form_for(:book, action) do
          month_field :release_month, value: "2017-04"
        end.to_s

        expect(actual).to include(%(<input type="month" name="book[release_month]" id="book-release-month" value="2017-04">))
      end
    end
  end

  describe "#week_field" do
    it "renders" do
      actual = view.form_for(:book, action) do
        week_field :release_week
      end.to_s

      expect(actual).to include(%(<input type="week" name="book[release_week]" id="book-release-week" value="">))
    end

    it "allows to override 'id' attribute" do
      actual = view.form_for(:book, action) do
        week_field :release_week, id: "release-week"
      end.to_s

      expect(actual).to include(%(<input type="week" name="book[release_week]" id="release-week" value="">))
    end

    it "allows to override 'name' attribute" do
      actual = view.form_for(:book, action) do
        week_field :release_week, name: "release_week"
      end.to_s

      expect(actual).to include(%(<input type="week" name="release_week" id="book-release-week" value="">))
    end

    it "allows to override 'value' attribute" do
      actual = view.form_for(:book, action) do
        week_field :release_week, value: "2017-W10"
      end.to_s

      expect(actual).to include(%(<input type="week" name="book[release_week]" id="book-release-week" value="2017-W10">))
    end

    it "allows to specify HTML attributes" do
      actual = view.form_for(:book, action) do
        week_field :release_week, class: "form-control"
      end.to_s

      expect(actual).to include(%(<input type="week" name="book[release_week]" id="book-release-week" value="" class="form-control">))
    end

    describe "with values" do
      let(:values) { Hash[book: Book.new(release_week: val)] }
      let(:val)    { "2017-W10" }

      it "renders with value" do
        actual = view.form_for(:book, action, values: values) do
          week_field :release_week
        end.to_s

        expect(actual).to include(%(<input type="week" name="book[release_week]" id="book-release-week" value="#{val}">))
      end

      it "allows to override 'value' attribute" do
        actual = view.form_for(:book, action, values: values) do
          week_field :release_week, value: "2017-W31"
        end.to_s

        expect(actual).to include(%(<input type="week" name="book[release_week]" id="book-release-week" value="2017-W31">))
      end
    end

    describe "with filled params" do
      let(:params) { Hash[book: {release_week: val}] }
      let(:val)    { "2017-W44" }

      it "renders with value" do
        actual = view.form_for(:book, action) do
          week_field :release_week
        end.to_s

        expect(actual).to include(%(<input type="week" name="book[release_week]" id="book-release-week" value="#{val}">))
      end

      it "allows to override 'value' attribute" do
        actual = view.form_for(:book, action) do
          week_field :release_week, value: "2017-W07"
        end.to_s

        expect(actual).to include(%(<input type="week" name="book[release_week]" id="book-release-week" value="2017-W07">))
      end
    end
  end

  describe "#email_field" do
    it "renders" do
      actual = view.form_for(:book, action) do
        email_field :publisher_email
      end.to_s

      expect(actual).to include(%(<input type="email" name="book[publisher_email]" id="book-publisher-email" value="">))
    end

    it "allows to override 'id' attribute" do
      actual = view.form_for(:book, action) do
        email_field :publisher_email, id: "publisher-email"
      end.to_s

      expect(actual).to include(%(<input type="email" name="book[publisher_email]" id="publisher-email" value="">))
    end

    it "allows to override 'name' attribute" do
      actual = view.form_for(:book, action) do
        email_field :publisher_email, name: "book[email]"
      end.to_s

      expect(actual).to include(%(<input type="email" name="book[email]" id="book-publisher-email" value="">))
    end

    it "allows to override 'value' attribute" do
      actual = view.form_for(:book, action) do
        email_field :publisher_email, value: "publisher@example.org"
      end.to_s

      expect(actual).to include(%(<input type="email" name="book[publisher_email]" id="book-publisher-email" value="publisher@example.org">))
    end

    it "allows to specify 'multiple' attribute" do
      actual = view.form_for(:book, action) do
        email_field :publisher_email, multiple: true
      end.to_s

      expect(actual).to include(%(<input type="email" name="book[publisher_email]" id="book-publisher-email" value="" multiple="multiple">))
    end

    it "allows to specify HTML attributes" do
      actual = view.form_for(:book, action) do
        email_field :publisher_email, class: "form-control"
      end.to_s

      expect(actual).to include(%(<input type="email" name="book[publisher_email]" id="book-publisher-email" value="" class="form-control">))
    end

    describe "with values" do
      let(:values) { Hash[book: Book.new(publisher_email: val)] }
      let(:val)    { "maria@publisher.org" }

      it "renders with value" do
        actual = view.form_for(:book, action, values: values) do
          email_field :publisher_email
        end.to_s

        expect(actual).to include(%(<input type="email" name="book[publisher_email]" id="book-publisher-email" value="maria@publisher.org">))
      end

      it "allows to override 'value' attribute" do
        actual = view.form_for(:book, action, values: values) do
          email_field :publisher_email, value: "publisher@example.org"
        end.to_s

        expect(actual).to include(%(<input type="email" name="book[publisher_email]" id="book-publisher-email" value="publisher@example.org">))
      end
    end

    describe "with filled params" do
      let(:params) { Hash[book: {publisher_email: val}] }
      let(:val)    { "maria@publisher.org" }

      it "renders with value" do
        actual = view.form_for(:book, action) do
          email_field :publisher_email
        end.to_s

        expect(actual).to include(%(<input type="email" name="book[publisher_email]" id="book-publisher-email" value="maria@publisher.org">))
      end

      it "allows to override 'value' attribute" do
        actual = view.form_for(:book, action) do
          email_field :publisher_email, value: "publisher@example.org"
        end.to_s

        expect(actual).to include(%(<input type="email" name="book[publisher_email]" id="book-publisher-email" value="publisher@example.org">))
      end
    end
  end

  describe "#url_field" do
    it "renders" do
      actual = view.form_for(:book, action) do
        url_field :website
      end.to_s

      expect(actual).to include(%(<input type="url" name="book[website]" id="book-website" value="">))
    end

    it "allows to override 'id' attribute" do
      actual = view.form_for(:book, action) do
        url_field :website, id: "website"
      end.to_s

      expect(actual).to include(%(<input type="url" name="book[website]" id="website" value="">))
    end

    it "allows to override 'name' attribute" do
      actual = view.form_for(:book, action) do
        url_field :website, name: "book[url]"
      end.to_s

      expect(actual).to include(%(<input type="url" name="book[url]" id="book-website" value="">))
    end

    it "allows to override 'value' attribute" do
      actual = view.form_for(:book, action) do
        url_field :website, value: "http://example.org"
      end.to_s

      expect(actual).to include(%(<input type="url" name="book[website]" id="book-website" value="http://example.org">))
    end

    it "allows to specify 'multiple' attribute" do
      actual = view.form_for(:book, action) do
        url_field :website, multiple: true
      end.to_s

      expect(actual).to include(%(<input type="url" name="book[website]" id="book-website" value="" multiple="multiple">))
    end

    it "allows to specify HTML attributes" do
      actual = view.form_for(:book, action) do
        url_field :website, class: "form-control"
      end.to_s

      expect(actual).to include(%(<input type="url" name="book[website]" id="book-website" value="" class="form-control">))
    end

    describe "with values" do
      let(:values) { Hash[book: Book.new(website: val)] }
      let(:val)    { "http://publisher.org" }

      it "renders with value" do
        actual = view.form_for(:book, action, values: values) do
          url_field :website
        end.to_s

        expect(actual).to include(%(<input type="url" name="book[website]" id="book-website" value="http://publisher.org">))
      end

      it "allows to override 'value' attribute" do
        actual = view.form_for(:book, action, values: values) do
          url_field :website, value: "https://www.example.org"
        end.to_s

        expect(actual).to include(%(<input type="url" name="book[website]" id="book-website" value="https://www.example.org">))
      end
    end

    describe "with filled params" do
      let(:params) { Hash[book: {website: val}] }
      let(:val)    { "http://publisher.org" }

      it "renders with value" do
        actual = view.form_for(:book, action) do
          url_field :website
        end.to_s

        expect(actual).to include(%(<input type="url" name="book[website]" id="book-website" value="http://publisher.org">))
      end

      it "allows to override 'value' attribute" do
        actual = view.form_for(:book, action) do
          url_field :website, value: "http://example.org"
        end.to_s

        expect(actual).to include(%(<input type="url" name="book[website]" id="book-website" value="http://example.org">))
      end
    end

    describe "with escape url" do
      let(:values) { Hash[book: Book.new(website: val)] }
      let(:val)    { %("onclick=javascript:alert('xss')) }

      it "renders with automatic value" do
        actual = view.form_for(:book, action, values: values) do
          url_field :website
        end.to_s

        expect(actual).to include(%(<input type="url" name="book[website]" id="book-website" value="">))
      end

      it "renders with explicit value" do
        actual = view.form_for(:book, action, values: values) do
          url_field :website, value: val
        end.to_s

        expect(actual).to include(%(<input type="url" name="book[website]" id="book-website" value="">))
      end
    end
  end

  describe "#tel_field" do
    it "renders" do
      actual = view.form_for(:book, action) do
        tel_field :publisher_telephone
      end.to_s

      expect(actual).to include(%(<input type="tel" name="book[publisher_telephone]" id="book-publisher-telephone" value="">))
    end

    it "allows to override 'id' attribute" do
      actual = view.form_for(:book, action) do
        tel_field :publisher_telephone, id: "publisher-telephone"
      end.to_s

      expect(actual).to include(%(<input type="tel" name="book[publisher_telephone]" id="publisher-telephone" value="">))
    end

    it "allows to override 'name' attribute" do
      actual = view.form_for(:book, action) do
        tel_field :publisher_telephone, name: "book[telephone]"
      end.to_s

      expect(actual).to include(%(<input type="tel" name="book[telephone]" id="book-publisher-telephone" value="">))
    end

    it "allows to override 'value' attribute" do
      actual = view.form_for(:book, action) do
        tel_field :publisher_telephone, value: "publisher@example.org"
      end.to_s

      expect(actual).to include(%(<input type="tel" name="book[publisher_telephone]" id="book-publisher-telephone" value="publisher@example.org">))
    end

    it "allows to specify 'multiple' attribute" do
      actual = view.form_for(:book, action) do
        tel_field :publisher_telephone, multiple: true
      end.to_s

      expect(actual).to include(%(<input type="tel" name="book[publisher_telephone]" id="book-publisher-telephone" value="" multiple="multiple">))
    end

    it "allows to specify HTML attributes" do
      actual = view.form_for(:book, action) do
        tel_field :publisher_telephone, class: "form-control"
      end.to_s

      expect(actual).to include(%(<input type="tel" name="book[publisher_telephone]" id="book-publisher-telephone" value="" class="form-control">))
    end

    describe "with values" do
      let(:values) { Hash[book: Book.new(publisher_telephone: val)] }
      let(:val)    { "maria@publisher.org" }

      it "renders with value" do
        actual = view.form_for(:book, action, values: values) do
          tel_field :publisher_telephone
        end.to_s

        expect(actual).to include(%(<input type="tel" name="book[publisher_telephone]" id="book-publisher-telephone" value="maria@publisher.org">))
      end

      it "allows to override 'value' attribute" do
        actual = view.form_for(:book, action, values: values) do
          tel_field :publisher_telephone, value: "publisher@example.org"
        end.to_s

        expect(actual).to include(%(<input type="tel" name="book[publisher_telephone]" id="book-publisher-telephone" value="publisher@example.org">))
      end
    end

    describe "with filled params" do
      let(:params) { Hash[book: {publisher_telephone: val}] }
      let(:val)    { "maria@publisher.org" }

      it "renders with value" do
        actual = view.form_for(:book, action) do
          tel_field :publisher_telephone
        end.to_s

        expect(actual).to include(%(<input type="tel" name="book[publisher_telephone]" id="book-publisher-telephone" value="maria@publisher.org">))
      end

      it "allows to override 'value' attribute" do
        actual = view.form_for(:book, action) do
          tel_field :publisher_telephone, value: "publisher@example.org"
        end.to_s

        expect(actual).to include(%(<input type="tel" name="book[publisher_telephone]" id="book-publisher-telephone" value="publisher@example.org">))
      end
    end
  end

  describe "#file_field" do
    it "renders" do
      actual = view.form_for(:book, action) do
        file_field :image_cover
      end.to_s

      expect(actual).to include(%(<input type="file" name="book[image_cover]" id="book-image-cover">))
    end

    it "sets 'enctype' attribute to the form"
    # it "sets 'enctype' attribute to the form" do
    #   actual = view.form_for(:book, action) do
    #     file_field :image_cover
    #   end.to_s

    #   expect(actual).to include(%(<form action="/books" id="book-form" method="POST" enctype="multipart/form-data">))
    # end

    it "sets 'enctype' attribute to the form when there are nested fields"
    # it "sets 'enctype' attribute to the form when there are nested fields" do
    #   actual = view.form_for(:book, action) do
    #     fields_for :images do
    #       file_field :cover
    #     end
    #   end.to_s

    #   expect(actual).to include(%(<form action="/books" id="book-form" method="POST" enctype="multipart/form-data">))
    # end

    it "allows to override 'id' attribute" do
      actual = view.form_for(:book, action) do
        file_field :image_cover, id: "book-cover"
      end.to_s

      expect(actual).to include(%(<input type="file" name="book[image_cover]" id="book-cover">))
    end

    it "allows to override 'name' attribute" do
      actual = view.form_for(:book, action) do
        file_field :image_cover, name: "book[cover]"
      end.to_s

      expect(actual).to include(%(<input type="file" name="book[cover]" id="book-image-cover">))
    end

    it "allows to specify 'multiple' attribute" do
      actual = view.form_for(:book, action) do
        file_field :image_cover, multiple: true
      end.to_s

      expect(actual).to include(%(<input type="file" name="book[image_cover]" id="book-image-cover" multiple="multiple">))
    end

    it "allows to specify single value for 'accept' attribute" do
      actual = view.form_for(:book, action) do
        file_field :image_cover, accept: "application/pdf"
      end.to_s

      expect(actual).to include(%(<input type="file" name="book[image_cover]" id="book-image-cover" accept="application/pdf">))
    end

    it "allows to specify multiple values for 'accept' attribute" do
      actual = view.form_for(:book, action) do
        file_field :image_cover, accept: "image/png,image/jpg"
      end.to_s

      expect(actual).to include(%(<input type="file" name="book[image_cover]" id="book-image-cover" accept="image/png,image/jpg">))
    end

    it "allows to specify multiple values (array) for 'accept' attribute" do
      actual = view.form_for(:book, action) do
        file_field :image_cover, accept: ["image/png", "image/jpg"]
      end.to_s

      expect(actual).to include(%(<input type="file" name="book[image_cover]" id="book-image-cover" accept="image/png,image/jpg">))
    end

    describe "with values" do
      let(:values) { Hash[book: Book.new(image_cover: val)] }
      let(:val)    { "image" }

      it "ignores value" do
        actual = view.form_for(:book, action, values: values) do
          file_field :image_cover
        end.to_s

        expect(actual).to include(%(<input type="file" name="book[image_cover]" id="book-image-cover">))
      end
    end

    describe "with filled params" do
      let(:params) { Hash[book: {image_cover: val}] }
      let(:val)    { "image" }

      it "ignores value" do
        actual = view.form_for(:book, action) do
          file_field :image_cover
        end.to_s

        expect(actual).to include(%(<input type="file" name="book[image_cover]" id="book-image-cover">))
      end
    end
  end

  describe "#hidden_field" do
    it "renders" do
      actual = view.form_for(:book, action) do
        hidden_field :author_id
      end.to_s

      expect(actual).to include(%(<input type="hidden" name="book[author_id]" id="book-author-id" value="">))
    end

    it "allows to override 'id' attribute" do
      actual = view.form_for(:book, action) do
        hidden_field :author_id, id: "author-id"
      end.to_s

      expect(actual).to include(%(<input type="hidden" name="book[author_id]" id="author-id" value="">))
    end

    it "allows to override 'name' attribute" do
      actual = view.form_for(:book, action) do
        hidden_field :author_id, name: "book[author]"
      end.to_s

      expect(actual).to include(%(<input type="hidden" name="book[author]" id="book-author-id" value="">))
    end

    it "allows to override 'value' attribute" do
      actual = view.form_for(:book, action) do
        hidden_field :author_id, value: "23"
      end.to_s

      expect(actual).to include(%(<input type="hidden" name="book[author_id]" id="book-author-id" value="23">))
    end

    it "allows to specify HTML attributes" do
      actual = view.form_for(:book, action) do
        hidden_field :author_id, class: "form-details"
      end.to_s

      expect(actual).to include(%(<input type="hidden" name="book[author_id]" id="book-author-id" value="" class="form-details">))
    end

    describe "with values" do
      let(:values) { Hash[book: Book.new(author_id: val)] }
      let(:val)    { "1" }

      it "renders with value" do
        actual = view.form_for(:book, action, values: values) do
          hidden_field :author_id
        end.to_s

        expect(actual).to include(%(<input type="hidden" name="book[author_id]" id="book-author-id" value="1">))
      end

      it "allows to override 'value' attribute" do
        actual = view.form_for(:book, action, values: values) do
          hidden_field :author_id, value: "23"
        end.to_s

        expect(actual).to include(%(<input type="hidden" name="book[author_id]" id="book-author-id" value="23">))
      end
    end

    describe "with filled params" do
      let(:params) { Hash[book: {author_id: val}] }
      let(:val)    { "1" }

      it "renders with value" do
        actual = view.form_for(:book, action) do
          hidden_field :author_id
        end.to_s

        expect(actual).to include(%(<input type="hidden" name="book[author_id]" id="book-author-id" value="1">))
      end

      it "allows to override 'value' attribute" do
        actual = view.form_for(:book, action) do
          hidden_field :author_id, value: "23"
        end.to_s

        expect(actual).to include(%(<input type="hidden" name="book[author_id]" id="book-author-id" value="23">))
      end
    end
  end

  describe "#number_field" do
    it "renders the element" do
      actual = view.form_for(:book, action) do
        number_field :percent_read
      end.to_s

      expect(actual).to include(%(<input type="number" name="book[percent_read]" id="book-percent-read" value="">))
    end

    it "allows to override 'id' attribute" do
      actual = view.form_for(:book, action) do
        number_field :percent_read, id: "percent-read"
      end.to_s

      expect(actual).to include(%(<input type="number" name="book[percent_read]" id="percent-read" value="">))
    end

    it "allows to override the 'name' attribute" do
      actual = view.form_for(:book, action) do
        number_field :percent_read, name: "book[read]"
      end.to_s

      expect(actual).to include(%(<input type="number" name="book[read]" id="book-percent-read" value="">))
    end

    it "allows to override the 'value' attribute" do
      actual = view.form_for(:book, action) do
        number_field :percent_read, value: "99"
      end.to_s

      expect(actual).to include(%(<input type="number" name="book[percent_read]" id="book-percent-read" value="99">))
    end

    it "allows to specify HTML attributes" do
      actual = view.form_for(:book, action) do
        number_field :percent_read, class: "form-control"
      end.to_s

      expect(actual).to include(%(<input type="number" name="book[percent_read]" id="book-percent-read" value="" class="form-control">))
    end

    it "allows to specify a 'min' attribute" do
      actual = view.form_for(:book, action) do
        number_field :percent_read, min: 0
      end.to_s

      expect(actual).to include(%(<input type="number" name="book[percent_read]" id="book-percent-read" value="" min="0">))
    end

    it "allows to specify a 'max' attribute" do
      actual = view.form_for(:book, action) do
        number_field :percent_read, max: 100
      end.to_s

      expect(actual).to include(%(<input type="number" name="book[percent_read]" id="book-percent-read" value="" max="100">))
    end

    it "allows to specify a 'step' attribute" do
      actual = view.form_for(:book, action) do
        number_field :percent_read, step: 5
      end.to_s

      expect(actual).to include(%(<input type="number" name="book[percent_read]" id="book-percent-read" value="" step="5">))
    end

    describe "with values" do
      let(:values) { Hash[book: Book.new(percent_read: val)] }
      let(:val)    { 95 }

      it "renders with value" do
        actual = view.form_for(:book, action, values: values) do
          number_field :percent_read
        end.to_s

        expect(actual).to include(%(<input type="number" name="book[percent_read]" id="book-percent-read" value="95">))
      end

      it "allows to override 'value' attribute" do
        actual = view.form_for(:book, action, values: values) do
          number_field :percent_read, value: 50
        end.to_s

        expect(actual).to include(%(<input type="number" name="book[percent_read]" id="book-percent-read" value="50">))
      end
    end

    describe "without values" do
      let(:book)   { Book.new(title: val) }
      let(:val)    { '"DDD" Book' }

      it "renders with value" do
        actual = view.form_for(:book, action) do
          text_field :title
        end.to_s

        expect(actual).to include(%(<input type="text" name="book[title]" id="book-title" value="">))
      end

      it "allows to override 'value' attribute" do
        actual = view.form_for(:book, action) do
          text_field :title, value: book.title
        end.to_s

        expect(actual).to include(%(<input type="text" name="book[title]" id="book-title" value="&quot;DDD&quot; Book">))
      end
    end

    describe "with filled params" do
      let(:params) { Hash[book: {percent_read: val}] }
      let(:val)    { 95 }

      it "renders with value" do
        actual = view.form_for(:book, action) do
          number_field :percent_read
        end.to_s

        expect(actual).to include(%(<input type="number" name="book[percent_read]" id="book-percent-read" value="95">))
      end

      it "allows to override 'value' attribute" do
        actual = view.form_for(:book, action) do
          number_field :percent_read, value: 50
        end.to_s

        expect(actual).to include(%(<input type="number" name="book[percent_read]" id="book-percent-read" value="50">))
      end
    end
  end

  describe "#range_field" do
    it "renders the element" do
      actual = view.form_for(:book, action) do
        range_field :discount_percentage
      end.to_s

      expect(actual).to include(%(<input type="range" name="book[discount_percentage]" id="book-discount-percentage" value="">))
    end

    it "allows to override 'id' attribute" do
      actual = view.form_for(:book, action) do
        range_field :discount_percentage, id: "discount-percentage"
      end.to_s

      expect(actual).to include(%(<input type="range" name="book[discount_percentage]" id="discount-percentage" value="">))
    end

    it "allows to override the 'name' attribute" do
      actual = view.form_for(:book, action) do
        range_field :discount_percentage, name: "book[read]"
      end.to_s

      expect(actual).to include(%(<input type="range" name="book[read]" id="book-discount-percentage" value="">))
    end

    it "allows to override the 'value' attribute" do
      actual = view.form_for(:book, action) do
        range_field :discount_percentage, value: "99"
      end.to_s

      expect(actual).to include(%(<input type="range" name="book[discount_percentage]" id="book-discount-percentage" value="99">))
    end

    it "allows to specify HTML attributes" do
      actual = view.form_for(:book, action) do
        range_field :discount_percentage, class: "form-control"
      end.to_s

      expect(actual).to include(%(<input type="range" name="book[discount_percentage]" id="book-discount-percentage" value="" class="form-control">))
    end

    it "allows to specify a 'min' attribute" do
      actual = view.form_for(:book, action) do
        range_field :discount_percentage, min: 0
      end.to_s

      expect(actual).to include(%(<input type="range" name="book[discount_percentage]" id="book-discount-percentage" value="" min="0">))
    end

    it "allows to specify a 'max' attribute" do
      actual = view.form_for(:book, action) do
        range_field :discount_percentage, max: 100
      end.to_s

      expect(actual).to include(%(<input type="range" name="book[discount_percentage]" id="book-discount-percentage" value="" max="100">))
    end

    it "allows to specify a 'step' attribute" do
      actual = view.form_for(:book, action) do
        range_field :discount_percentage, step: 5
      end.to_s

      expect(actual).to include(%(<input type="range" name="book[discount_percentage]" id="book-discount-percentage" value="" step="5">))
    end

    describe "with values" do
      let(:values) { Hash[book: Book.new(discount_percentage: val)] }
      let(:val)    { 95 }

      it "renders with value" do
        actual = view.form_for(:book, action, values: values) do
          range_field :discount_percentage
        end.to_s

        expect(actual).to include(%(<input type="range" name="book[discount_percentage]" id="book-discount-percentage" value="95">))
      end

      it "allows to override 'value' attribute" do
        actual = view.form_for(:book, action, values: values) do
          range_field :discount_percentage, value: 50
        end.to_s

        expect(actual).to include(%(<input type="range" name="book[discount_percentage]" id="book-discount-percentage" value="50">))
      end
    end

    describe "without values" do
      let(:book)   { Book.new(title: val) }
      let(:val)    { '"DDD" Book' }

      it "renders with value" do
        actual = view.form_for(:book, action) do
          text_field :title
        end.to_s

        expect(actual).to include(%(<input type="text" name="book[title]" id="book-title" value="">))
      end

      it "allows to override 'value' attribute" do
        actual = view.form_for(:book, action) do
          text_field :title, value: book.title
        end.to_s

        expect(actual).to include(%(<input type="text" name="book[title]" id="book-title" value="&quot;DDD&quot; Book">))
      end
    end

    describe "with filled params" do
      let(:params) { Hash[book: {discount_percentage: val}] }
      let(:val)    { 95 }

      it "renders with value" do
        actual = view.form_for(:book, action) do
          range_field :discount_percentage
        end.to_s

        expect(actual).to include(%(<input type="range" name="book[discount_percentage]" id="book-discount-percentage" value="95">))
      end

      it "allows to override 'value' attribute" do
        actual = view.form_for(:book, action) do
          range_field :discount_percentage, value: 50
        end.to_s

        expect(actual).to include(%(<input type="range" name="book[discount_percentage]" id="book-discount-percentage" value="50">))
      end
    end
  end

  describe "#text_area" do
    it "renders the element" do
      actual = view.form_for(:book, action) do
        text_area :description
      end.to_s

      expect(actual).to include(%(<textarea name="book[description]" id="book-description"></textarea>))
    end

    it "allows to override 'id' attribute" do
      actual = view.form_for(:book, action) do
        text_area :description, nil, id: "desc"
      end.to_s

      expect(actual).to include(%(<textarea name="book[description]" id="desc"></textarea>))
    end

    it "allows to override 'name' attribute" do
      actual = view.form_for(:book, action) do
        text_area :description, nil, name: "book[desc]"
      end.to_s

      expect(actual).to include(%(<textarea name="book[desc]" id="book-description"></textarea>))
    end

    it "allows to specify HTML attributes" do
      actual = view.form_for(:book, action) do
        text_area :description, nil, class: "form-control", cols: "5"
      end.to_s

      expect(actual).to include(%(<textarea name="book[description]" id="book-description" class="form-control" cols="5"></textarea>))
    end

    it "allows to omit content" do
      actual = view.form_for(:book, action) do
        text_area :description, class: "form-control", cols: "5"
      end.to_s

      expect(actual).to include(%(<textarea name="book[description]" id="book-description" class="form-control" cols="5"></textarea>))
    end

    it "allows to omit content, by accepting Hash serializable options" do
      options = Hanami::Utils::Hash.new(class: "form-control", cols: 5)

      actual = view.form_for(:book, action) do
        text_area :description, options
      end.to_s

      expect(actual).to include(%(<textarea name="book[description]" id="book-description" class="form-control" cols="5"></textarea>))
    end

    describe "set content explicitly" do
      let(:content) { "A short description of the book" }

      it "allows to set content" do
        actual = view.form_for(:book, action) do
          text_area :description, content
        end.to_s

        expect(actual).to include(%(<textarea name="book[description]" id="book-description">#{content}</textarea>))
      end
    end

    describe "with values" do
      let(:values) { Hash[book: Book.new(description: val)] }
      let(:val) { "A short description of the book" }

      it "renders with value" do
        actual = view.form_for(:book, action, values: values) do
          text_area :description
        end.to_s

        expect(actual).to include(%(<textarea name="book[description]" id="book-description">#{val}</textarea>))
      end

      it "renders with value, when only attributes are specified" do
        actual = view.form_for(:book, action, values: values) do
          text_area :description, class: "form-control"
        end.to_s

        expect(actual).to include(%(<textarea name="book[description]" id="book-description" class="form-control">#{val}</textarea>))
      end

      it "allows to override value" do
        actual = view.form_for(:book, action, values: values) do
          text_area :description, "Just a simple description"
        end.to_s

        expect(actual).to include(%(<textarea name="book[description]" id="book-description">Just a simple description</textarea>))
      end

      it "forces blank value" do
        actual = view.form_for(:book, action, values: values) do
          text_area :description, ""
        end.to_s

        expect(actual).to include(%(<textarea name="book[description]" id="book-description"></textarea>))
      end

      it "forces blank value, when also attributes are specified" do
        actual = view.form_for(:book, action, values: values) do
          text_area :description, "", class: "form-control"
        end.to_s

        expect(actual).to include(%(<textarea name="book[description]" id="book-description" class="form-control"></textarea>))
      end
    end

    describe "with filled params" do
      let(:params) { Hash[book: {description: val}] }
      let(:val) { "A short description of the book" }

      it "renders with value" do
        actual = view.form_for(:book, action) do
          text_area :description
        end.to_s

        expect(actual).to include(%(<textarea name="book[description]" id="book-description">#{val}</textarea>))
      end

      it "renders with value, when only attributes are specified" do
        actual = view.form_for(:book, action) do
          text_area :description, class: "form-control"
        end.to_s

        expect(actual).to include(%(<textarea name="book[description]" id="book-description" class="form-control">#{val}</textarea>))
      end

      it "allows to override value" do
        actual = view.form_for(:book, action) do
          text_area :description, "Just a simple description"
        end.to_s

        expect(actual).to include(%(<textarea name="book[description]" id="book-description">Just a simple description</textarea>))
      end

      it "forces blank value" do
        actual = view.form_for(:book, action) do
          text_area :description, ""
        end.to_s

        expect(actual).to include(%(<textarea name="book[description]" id="book-description"></textarea>))
      end

      it "forces blank value, when also attributes are specified" do
        actual = view.form_for(:book, action) do
          text_area :description, "", class: "form-control"
        end.to_s

        expect(actual).to include(%(<textarea name="book[description]" id="book-description" class="form-control"></textarea>))
      end
    end
  end

  describe "#text_field" do
    it "renders" do
      actual = view.form_for(:book, action) do
        text_field :title
      end.to_s

      expect(actual).to include(%(<input type="text" name="book[title]" id="book-title" value="">))
    end

    it "allows to override 'id' attribute" do
      actual = view.form_for(:book, action) do
        text_field :title, id: "book-short-title"
      end.to_s

      expect(actual).to include(%(<input type="text" name="book[title]" id="book-short-title" value="">))
    end

    it "allows to override 'name' attribute" do
      actual = view.form_for(:book, action) do
        text_field :title, name: "book[short_title]"
      end.to_s

      expect(actual).to include(%(<input type="text" name="book[short_title]" id="book-title" value="">))
    end

    it "allows to override 'value' attribute" do
      actual = view.form_for(:book, action) do
        text_field :title, value: "Refactoring"
      end.to_s

      expect(actual).to include(%(<input type="text" name="book[title]" id="book-title" value="Refactoring">))
    end

    it "allows to specify HTML attributes" do
      actual = view.form_for(:book, action) do
        text_field :title, class: "form-control"
      end.to_s

      expect(actual).to include(%(<input type="text" name="book[title]" id="book-title" value="" class="form-control">))
    end

    describe "with values" do
      let(:values) { Hash[book: Book.new(title: val)] }
      let(:val)    { "PPoEA" }

      it "renders with value" do
        actual = view.form_for(:book, action, values: values) do
          text_field :title
        end.to_s

        expect(actual).to include(%(<input type="text" name="book[title]" id="book-title" value="PPoEA">))
      end

      it "allows to override 'value' attribute" do
        actual = view.form_for(:book, action, values: values) do
          text_field :title, value: "DDD"
        end.to_s

        expect(actual).to include(%(<input type="text" name="book[title]" id="book-title" value="DDD">))
      end
    end

    describe "with filled params" do
      let(:params) { Hash[book: {title: val}] }
      let(:val)    { "PPoEA" }

      it "renders with value" do
        actual = view.form_for(:book, action) do
          text_field :title
        end.to_s

        expect(actual).to include(%(<input type="text" name="book[title]" id="book-title" value="PPoEA">))
      end

      it "allows to override 'value' attribute" do
        actual = view.form_for(:book, action) do
          text_field :title, value: "DDD"
        end.to_s

        expect(actual).to include(%(<input type="text" name="book[title]" id="book-title" value="DDD">))
      end
    end
  end

  describe "#search_field" do
    it "renders" do
      actual = view.form_for(:book, action) do
        search_field :search_title
      end.to_s

      expect(actual).to include(%(<input type="search" name="book[search_title]" id="book-search-title" value="">))
    end

    it "allows to override 'id' attribute" do
      actual = view.form_for(:book, action) do
        search_field :search_title, id: "book-short-title"
      end.to_s

      expect(actual).to include(%(<input type="search" name="book[search_title]" id="book-short-title" value="">))
    end

    it "allows to override 'name' attribute" do
      actual = view.form_for(:book, action) do
        search_field :search_title, name: "book[short_title]"
      end.to_s

      expect(actual).to include(%(<input type="search" name="book[short_title]" id="book-search-title" value="">))
    end

    it "allows to override 'value' attribute" do
      actual = view.form_for(:book, action) do
        search_field :search_title, value: "Refactoring"
      end.to_s

      expect(actual).to include(%(<input type="search" name="book[search_title]" id="book-search-title" value="Refactoring">))
    end

    it "allows to specify HTML attributes" do
      actual = view.form_for(:book, action) do
        search_field :search_title, class: "form-control"
      end.to_s

      expect(actual).to include(%(<input type="search" name="book[search_title]" id="book-search-title" value="" class="form-control">))
    end

    describe "with values" do
      let(:values) { Hash[book: Book.new(search_title: val)] }
      let(:val)    { "PPoEA" }

      it "renders with value" do
        actual = view.form_for(:book, action, values: values) do
          search_field :search_title
        end.to_s

        expect(actual).to include(%(<input type="search" name="book[search_title]" id="book-search-title" value="PPoEA">))
      end

      it "allows to override 'value' attribute" do
        actual = view.form_for(:book, action, values: values) do
          search_field :search_title, value: "DDD"
        end.to_s

        expect(actual).to include(%(<input type="search" name="book[search_title]" id="book-search-title" value="DDD">))
      end
    end

    describe "with filled params" do
      let(:params) { Hash[book: {search_title: val}] }
      let(:val)    { "PPoEA" }

      it "renders with value" do
        actual = view.form_for(:book, action) do
          search_field :search_title
        end.to_s

        expect(actual).to include(%(<input type="search" name="book[search_title]" id="book-search-title" value="PPoEA">))
      end

      it "allows to override 'value' attribute" do
        actual = view.form_for(:book, action) do
          search_field :search_title, value: "DDD"
        end.to_s

        expect(actual).to include(%(<input type="search" name="book[search_title]" id="book-search-title" value="DDD">))
      end
    end
  end

  describe "#password_field" do
    it "renders" do
      actual = view.form_for(:signup, action) do
        password_field :password
      end.to_s

      expect(actual).to include(%(<input type="password" name="signup[password]" id="signup-password" value="">))
    end

    it "allows to override 'id' attribute" do
      actual = view.form_for(:signup, action) do
        password_field :password, id: "signup-pass"
      end.to_s

      expect(actual).to include(%(<input type="password" name="signup[password]" id="signup-pass" value="">))
    end

    it "allows to override 'name' attribute" do
      actual = view.form_for(:signup, action) do
        password_field :password, name: "password"
      end.to_s

      expect(actual).to include(%(<input type="password" name="password" id="signup-password" value="">))
    end

    it "allows to override 'value' attribute" do
      actual = view.form_for(:signup, action) do
        password_field :password, value: "topsecret"
      end.to_s

      expect(actual).to include(%(<input type="password" name="signup[password]" id="signup-password" value="topsecret">))
    end

    it "allows to specify HTML attributes" do
      actual = view.form_for(:signup, action) do
        password_field :password, class: "form-control"
      end.to_s

      expect(actual).to include(%(<input type="password" name="signup[password]" id="signup-password" value="" class="form-control">))
    end

    describe "with values" do
      let(:values) { Hash[signup: Signup.new(password: val)] }
      let(:val)    { "secret" }

      it "ignores value" do
        actual = view.form_for(:signup, action, values: values) do
          password_field :password
        end.to_s

        expect(actual).to include(%(<input type="password" name="signup[password]" id="signup-password" value="">))
      end

      it "allows to override 'value' attribute" do
        actual = view.form_for(:signup, action, values: values) do
          password_field :password, value: "123"
        end.to_s

        expect(actual).to include(%(<input type="password" name="signup[password]" id="signup-password" value="123">))
      end
    end

    describe "with filled params" do
      let(:params) { Hash[signup: {password: val}] }
      let(:val)    { "secret" }

      it "ignores value" do
        actual = view.form_for(:signup, action) do
          password_field :password
        end.to_s

        expect(actual).to include(%(<input type="password" name="signup[password]" id="signup-password" value="">))
      end

      it "allows to override 'value' attribute" do
        actual = view.form_for(:signup, action) do
          password_field :password, value: "123"
        end.to_s

        expect(actual).to include(%(<input type="password" name="signup[password]" id="signup-password" value="123">))
      end
    end
  end

  describe "#radio_button" do
    it "renders" do
      actual = view.form_for(:book, action) do
        radio_button :category, "Fiction"
        radio_button :category, "Non-Fiction"
      end.to_s

      expect(actual).to include(%(<input type="radio" name="book[category]" value="Fiction">\n<input type="radio" name="book[category]" value="Non-Fiction">))
    end

    it "allows to override 'name' attribute" do
      actual = view.form_for(:book, action) do
        radio_button :category, "Fiction",     name: "category_name"
        radio_button :category, "Non-Fiction", name: "category_name"
      end.to_s

      expect(actual).to include(%(<input type="radio" name="category_name" value="Fiction">\n<input type="radio" name="category_name" value="Non-Fiction">))
    end

    it "allows to specify HTML attributes" do
      actual = view.form_for(:book, action) do
        radio_button :category, "Fiction",     class: "form-control"
        radio_button :category, "Non-Fiction", class: "radio-button"
      end.to_s

      expect(actual).to include(%(<input type="radio" name="book[category]" value="Fiction" class="form-control">\n<input type="radio" name="book[category]" value="Non-Fiction" class="radio-button">))
    end

    describe "with values" do
      let(:values) { Hash[book: Book.new(category: val)] }
      let(:val)    { "Non-Fiction" }

      it "renders with value" do
        actual = view.form_for(:book, action, values: values) do
          radio_button :category, "Fiction"
          radio_button :category, "Non-Fiction"
        end.to_s

        expect(actual).to include(%(<input type="radio" name="book[category]" value="Fiction">\n<input type="radio" name="book[category]" value="Non-Fiction" checked="checked">))
      end
    end

    describe "with filled params" do
      describe "string value" do
        let(:params) { Hash[book: {category: val}] }
        let(:val)    { "Non-Fiction" }

        it "renders with value" do
          actual = view.form_for(:book, action) do
            radio_button :category, "Fiction"
            radio_button :category, "Non-Fiction"
          end.to_s

          expect(actual).to include(%(<input type="radio" name="book[category]" value="Fiction">\n<input type="radio" name="book[category]" value="Non-Fiction" checked="checked">))
        end
      end

      describe "decimal value" do
        let(:params) { Hash[book: {price: val}] }
        let(:val)    { "20.0" }

        it "renders with value" do
          actual = view.form_for(:book, action) do
            radio_button :price, 10.0
            radio_button :price, 20.0
          end.to_s

          expect(actual).to include(%(<input type="radio" name="book[price]" value="10.0">\n<input type="radio" name="book[price]" value="20.0" checked="checked">))
        end
      end
    end
  end

  describe "#select" do
    let(:option_values) { Hash["Italy" => "it", "United States" => "us"] }

    it "renders" do
      actual = view.form_for(:book, action) do
        select :store, option_values
      end.to_s

      expect(actual).to include(%(<select name="book[store]" id="book-store">\n<option value="it">Italy</option>\n<option value="us">United States</option>\n</select>))
    end

    it "allows to override 'id' attribute" do
      actual = view.form_for(:book, action) do
        select :store, option_values, id: "store"
      end.to_s

      expect(actual).to include(%(<select name="book[store]" id="store">\n<option value="it">Italy</option>\n<option value="us">United States</option>\n</select>))
    end

    it "allows to override 'name' attribute" do
      actual = view.form_for(:book, action) do
        select :store, option_values, name: "store"
      end.to_s

      expect(actual).to include(%(<select name="store" id="book-store">\n<option value="it">Italy</option>\n<option value="us">United States</option>\n</select>))
    end

    it "allows to specify HTML attributes" do
      actual = view.form_for(:book, action) do
        select :store, option_values, class: "form-control"
      end.to_s

      expect(actual).to include(%(<select name="book[store]" id="book-store" class="form-control">\n<option value="it">Italy</option>\n<option value="us">United States</option>\n</select>))
    end

    it "allows to specify HTML attributes for options" do
      actual = view.form_for(:book, action) do
        select :store, option_values, options: {class: "form-option"}
      end.to_s

      expect(actual).to include(%(<select name="book[store]" id="book-store">\n<option value="it" class="form-option">Italy</option>\n<option value="us" class="form-option">United States</option>\n</select>))
    end

    describe "with option 'multiple'" do
      it "renders" do
        actual = view.form_for(:book, action) do
          select :store, option_values, multiple: true
        end.to_s

        expect(actual).to include(%(<select name="book[store][]" id="book-store" multiple="multiple">\n<option value="it">Italy</option>\n<option value="us">United States</option>\n</select>))
      end

      it "allows to select values" do
        actual = view.form_for(:book, action) do
          select :store, option_values, multiple: true, options: {selected: %w[it us]}
        end.to_s

        expect(actual).to include(%(<select name="book[store][]" id="book-store" multiple="multiple">\n<option value="it" selected="selected">Italy</option>\n<option value="us" selected="selected">United States</option>\n</select>))
      end
    end

    describe "with values an structured Array of values" do
      let(:option_values) { [%w[Italy it], ["United States", "us"]] }

      it "renders" do
        actual = view.form_for(:book, action) do
          select :store, option_values
        end.to_s

        expect(actual).to include(%(<select name="book[store]" id="book-store">\n<option value="it">Italy</option>\n<option value="us">United States</option>\n</select>))
      end

      describe "and filled params" do
        let(:params) { Hash[book: {store: val}] }
        let(:val)    { "it" }

        it "renders with value" do
          actual = view.form_for(:book, action) do
            select :store, option_values
          end.to_s

          expect(actual).to include(%(<select name="book[store]" id="book-store">\n<option value="it" selected="selected">Italy</option>\n<option value="us">United States</option>\n</select>))
        end
      end

      describe "and repeated values" do
        let(:option_values) { [%w[Italy it], ["United States", "us"], %w[Italy it]] }

        it "renders" do
          actual = view.form_for(:book, action) do
            select :store, option_values
          end.to_s

          expect(actual).to include(%(<select name="book[store]" id="book-store">\n<option value="it">Italy</option>\n<option value="us">United States</option>\n<option value="it">Italy</option>\n</select>))
        end
      end
    end

    describe "with values an Array of objects" do
      let(:values) { [Store.new("it", "Italy"), Store.new("us", "United States")] }

      it "renders" do
        actual = view.form_for(:book, action) do
          select :store, option_values
        end.to_s

        expect(actual).to include(%(<select name="book[store]" id="book-store">\n<option value="it">Italy</option>\n<option value="us">United States</option>\n</select>))
      end

      describe "and filled params" do
        let(:params) { Hash[book: {store: val}] }
        let(:val)    { "it" }

        it "renders with value" do
          actual = view.form_for(:book, action) do
            select :store, option_values
          end.to_s

          expect(actual).to include(%(<select name="book[store]" id="book-store">\n<option value="it" selected="selected">Italy</option>\n<option value="us">United States</option>\n</select>))
        end
      end
    end

    describe "with values" do
      let(:values) { Hash[book: Book.new(store: val)] }
      let(:val)    { "it" }

      it "renders with value" do
        actual = view.form_for(:book, action, values: values) do
          select :store, option_values
        end.to_s

        expect(actual).to include(%(<select name="book[store]" id="book-store">\n<option value="it" selected="selected">Italy</option>\n<option value="us">United States</option>\n</select>))
      end
    end

    describe "with filled params" do
      let(:params) { Hash[book: {store: val}] }
      let(:val)    { "it" }

      it "renders with value" do
        actual = view.form_for(:book, action) do
          select :store, option_values
        end.to_s

        expect(actual).to include(%(<select name="book[store]" id="book-store">\n<option value="it" selected="selected">Italy</option>\n<option value="us">United States</option>\n</select>))
      end
    end

    describe "with prompt option" do
      it "allows string" do
        actual = view.form_for(:book, action) do
          select :store, option_values, options: {prompt: "Select a store"}
        end.to_s

        expect(actual).to include(%(<select name="book[store]" id="book-store">\n<option disabled="disabled">Select a store</option>\n<option value="it">Italy</option>\n<option value="us">United States</option>\n</select>))
      end

      it "allows blank string" do
        actual = view.form_for(:book, action) do
          select :store, option_values, options: {prompt: ""}
        end.to_s

        expect(actual).to include(%(<select name="book[store]" id="book-store">\n<option disabled="disabled"></option>\n<option value="it">Italy</option>\n<option value="us">United States</option>\n</select>))
      end

      describe "with values" do
        let(:values) { Hash[book: Book.new(store: val)] }
        let(:val)    { "it" }

        it "renders with value" do
          actual = view.form_for(:book, action, values: values) do
            select :store, option_values, options: {prompt: "Select a store"}
          end.to_s

          expect(actual).to include(%(<select name="book[store]" id="book-store">\n<option disabled="disabled">Select a store</option>\n<option value="it" selected="selected">Italy</option>\n<option value="us">United States</option>\n</select>))
        end
      end

      describe "with filled params" do
        describe "string values" do
          let(:params) { Hash[book: {store: val}] }
          let(:val)    { "it" }

          it "renders with value" do
            actual = view.form_for(:book, action) do
              select :store, option_values, options: {prompt: "Select a store"}
            end.to_s

            expect(actual).to include(%(<select name="book[store]" id="book-store">\n<option disabled="disabled">Select a store</option>\n<option value="it" selected="selected">Italy</option>\n<option value="us">United States</option>\n</select>))
          end
        end

        describe "integer values" do
          let(:values) { Hash["Brave new world" => 1, "Solaris" => 2] }
          let(:params) { Hash[bookshelf: {book: val}] }
          let(:val)    { "1" }

          it "renders" do
            actual = view.form_for(:bookshelf, action) do
              select :book, values
            end.to_s

            expect(actual).to include(%(<select name="bookshelf[book]" id="bookshelf-book">\n<option value="1" selected="selected">Brave new world</option>\n<option value="2">Solaris</option>\n</select>))
          end
        end
      end
    end

    describe "with selected attribute" do
      let(:params) { Hash[book: {store: val}] }
      let(:val)    { "it" }

      it "sets the selected attribute" do
        actual = view.form_for(:book, action) do
          select :store, option_values, options: {selected: val}
        end.to_s

        expect(actual).to include(%(<select name="book[store]" id="book-store">\n<option value="it" selected="selected">Italy</option>\n<option value="us">United States</option>\n</select>))
      end
    end

    describe "with nil as a value" do
      let(:option_values) { Hash["Italy" => "it", "United States" => "us", "N/A" => nil] }

      it "sets nil option as selected by default" do
        actual = view.form_for(:book, action) do
          select :store, option_values
        end.to_s

        expect(actual).to include(%(<select name="book[store]" id="book-store">\n<option value="it">Italy</option>\n<option value="us">United States</option>\n<option value="" selected="selected">N&#x2F;A</option>\n</select>))
      end

      it "set as selected the option with nil value" do
        actual = view.form_for(:book, action) do
          select :store, option_values, options: {selected: nil}
        end.to_s

        expect(actual).to include(%(<select name="book[store]" id="book-store">\n<option value="it">Italy</option>\n<option value="us">United States</option>\n<option value="" selected="selected">N&#x2F;A</option>\n</select>))
      end

      it "set as selected the option with a value" do
        actual = view.form_for(:book, action) do
          select :store, option_values, options: {selected: "it"}
        end.to_s

        expect(actual).to include(%(<select name="book[store]" id="book-store">\n<option value="it" selected="selected">Italy</option>\n<option value="us">United States</option>\n<option value="">N&#x2F;A</option>\n</select>))
      end

      it "allows to force the selection of none" do
        actual = view.form_for(:book, action) do
          select :store, option_values, options: {selected: "none"}
        end.to_s

        expect(actual).to include(%(<select name="book[store]" id="book-store">\n<option value="it">Italy</option>\n<option value="us">United States</option>\n<option value="">N&#x2F;A</option>\n</select>))
      end

      describe "with values" do
        let(:values)        { Hash[book: Book.new(category: val)] }
        let(:option_values) { Hash["N/A" => nil, "Horror" => "horror", "SciFy" => "scify"] }
        let(:val)           { "horror" }

        it "sets correct value as selected" do
          actual = view.form_for(:book, action, values: values) do
            select :category, option_values
          end.to_s

          expect(actual).to include(%(<form action="/books" method="POST" accept-charset="utf-8" id="book-form">\n<select name="book[category]" id="book-category">\n<option value="">N&#x2F;A</option>\n<option value="horror" selected="selected">Horror</option>\n<option value="scify">SciFy</option>\n</select>\n</form>))
        end
      end

      describe "with non String values" do
        let(:values)        { Hash[book: Book.new(category: val)] }
        let(:option_values) { Hash["Horror" => "1", "SciFy" => "2"] }
        let(:val)           { 1 }

        it "sets correct value as selected" do
          actual = view.form_for(:book, action, values: values) do
            select :category, option_values
          end.to_s

          expect(actual).to include(%(<form action="/books" method="POST" accept-charset="utf-8" id="book-form">\n<select name="book[category]" id="book-category">\n<option value="1" selected="selected">Horror</option>\n<option value="2">SciFy</option>\n</select>\n</form>))
        end
      end
    end
  end

  describe "#datalist" do
    let(:values) { ["Italy", "United States"] }

    it "renders" do
      actual = view.form_for(:book, action) do
        datalist :store, values, "books"
      end.to_s

      expect(actual).to include(%(<input type="text" name="book[store]" id="book-store" value="" list="books">\n<datalist id="books">\n<option value="Italy"></option>\n<option value="United States"></option>\n</datalist>))
    end

    it "just allows to override 'id' attribute of the text input" do
      actual = view.form_for(:book, action) do
        datalist :store, values, "books", id: "store"
      end.to_s

      expect(actual).to include(%(<input type="text" name="book[store]" id="store" value="" list="books">\n<datalist id="books">\n<option value="Italy"></option>\n<option value="United States"></option>\n</datalist>))
    end

    it "allows to override 'name' attribute" do
      actual = view.form_for(:book, action) do
        datalist :store, values, "books", name: "store"
      end.to_s

      expect(actual).to include(%(<input type="text" name="store" id="book-store" value="" list="books">\n<datalist id="books">\n<option value="Italy"></option>\n<option value="United States"></option>\n</datalist>))
    end

    it "allows to specify HTML attributes" do
      actual = view.form_for(:book, action) do
        datalist :store, values, "books", class: "form-control"
      end.to_s

      expect(actual).to include(%(<input type="text" name="book[store]" id="book-store" value="" class="form-control" list="books">\n<datalist id="books">\n<option value="Italy"></option>\n<option value="United States"></option>\n</datalist>))
    end

    it "allows to specify HTML attributes for options" do
      actual = view.form_for(:book, action) do
        datalist :store, values, "books", options: {class: "form-option"}
      end.to_s

      expect(actual).to include(%(<input type="text" name="book[store]" id="book-store" value="" list="books">\n<datalist id="books">\n<option value="Italy" class="form-option"></option>\n<option value="United States" class="form-option"></option>\n</datalist>))
    end

    it "allows to specify HTML attributes for datalist" do
      actual = view.form_for(:book, action) do
        datalist :store, values, "books", datalist: {class: "form-option"}
      end.to_s

      expect(actual).to include(%(<input type="text" name="book[store]" id="book-store" value="" list="books">\n<datalist class="form-option" id="books">\n<option value="Italy"></option>\n<option value="United States"></option>\n</datalist>))
    end

    describe "with a Hash of values" do
      let(:values) { Hash["Italy" => "it", "United States" => "us"] }

      it "renders" do
        actual = view.form_for(:book, action) do
          datalist :store, values, "books"
        end.to_s

        expect(actual).to include(%(<input type="text" name="book[store]" id="book-store" value="" list="books">\n<datalist id="books">\n<option value="Italy">it</option>\n<option value="United States">us</option>\n</datalist>))
      end
    end
  end
end
