# frozen_string_literal: true

RSpec.describe "Form helper" do
  describe "form with huge ERB block" do
    subject do
      FullStack::Views::Sessions::New.new.call(format: :html, params: params, session: session).to_s
    end

    let(:params)  { Hanami::Action::BaseParams.new({}) }
    let(:session) { Session.new(_csrf_token: "l23") }

    it "renders the form" do
      expected = <<~HTML
        <form action="/sessions" method="POST" accept-charset="utf-8" id="session-form" class="form-horizontal">
        <input type="hidden" name="_csrf_token" value="#{session[:_csrf_token]}">
        <div class="form-group">
        <label for="session-email">Email</label>
        <input type="email" name="session[email]" id="session-email" value="" class="form-control" placeholder="Email address">
        </div>
        <div class="form-group">
        <label for="session-password">Password</label>
        <input type="password" name="session[password]" id="session-password" value="" class="form-control">
        </div>
        <input type="hidden" name="session[remember][me]" value="0">
        <input type="checkbox" name="session[remember][me]" id="session-remember-me" value="1">
        <button type="submit" class="btn btn-default">Sign in</button>
        </form>
      HTML

      expect(subject).to match(expected)
    end
  end

  describe "form with Form object" do
    subject do
      FullStack::Views::Settings::Edit.new.call(format: :html, params: params, session: session).to_s
    end

    let(:params) { Hanami::Action::BaseParams.new({}) }
    let(:session) { Session.new(_csrf_token: "ln16") }

    it "renders the form" do
      expected = <<~HTML
        <form action="/settings" method="POST" accept-charset="utf-8" id="settings-form">
        <input type="hidden" name="_csrf_token" value="#{session[:_csrf_token]}">
        <div>
        <label for="settings-email">Email</label>
        <input type="email" name="settings[email]" id="settings-email" value="">
        </div>
        <button type="submit">Update settings</button>
        </form>
      HTML

      expect(subject).to match(expected)
    end
  end

  describe "form to create a new resource" do
    describe "first page load" do
      subject do
        FullStack::Views::Deliveries::New.new.call(format: :html, params: params, session: session).to_s
      end

      let(:params) { DeliveryParams.new({}) }
      let(:session) { Session.new(_csrf_token: "m15") }

      it "renders the form" do
        expected = <<~HTML
          <form action="/deliveries" method="POST" accept-charset="utf-8" id="delivery-form" class="form-horizontal">
          <input type="hidden" name="_csrf_token" value="#{session[:_csrf_token]}">
          <div class="form-group">
          <label for="delivery-customer">Customer</label>
          <input type="text" name="" id="delivery-customer" value="" class="form-control" placeholder="Customer">
          <input type="hidden" name="delivery[customer_id]" id="delivery-customer-id" value="">
          </div>
          <fieldset>
          <legend>Address</legend>
          <div class="form-group">
          <label for="delivery-address-street">Street</label>
          <input type="text" name="delivery[address][street]" id="delivery-address-street" value="" class="form-control" placeholder="Street">
          </div>
          </fieldset>
          <button type="submit" class="btn btn-default">Create</button>
          </form>

        HTML

        expect(subject).to match(expected)
      end
    end

    describe "after a failed form submission" do
      subject do
        FullStack::Views::Deliveries::New.new.call(format: :html, params: params, session: session).to_s
      end

      let(:params) { DeliveryParams.new(delivery: {address: {street: "5th Ave"}}) }
      let(:session) { Session.new(_csrf_token: "m15") }

      it "renders the form with previous values" do
        expected = <<~HTML
          <form action="/deliveries" method="POST" accept-charset="utf-8" id="delivery-form" class="form-horizontal">
          <input type="hidden" name="_csrf_token" value="#{session[:_csrf_token]}">
          <div class="form-group">
          <label for="delivery-customer">Customer</label>
          <input type="text" name="" id="delivery-customer" value="" class="form-control" placeholder="Customer">
          <input type="hidden" name="delivery[customer_id]" id="delivery-customer-id" value="">
          </div>
          <fieldset>
          <legend>Address</legend>
          <div class="form-group">
          <label for="delivery-address-street">Street</label>
          <input type="text" name="delivery[address][street]" id="delivery-address-street" value="5th Ave" class="form-control" placeholder="Street">
          </div>
          </fieldset>
          <button type="submit" class="btn btn-default">Create</button>
          </form>

        HTML

        expect(subject).to match(expected)
      end
    end
  end

  describe "form to update a resource" do
    describe "first page load" do
      subject do
        FullStack::Views::Deliveries::Edit.new.call(format: :html, delivery: delivery, params: params, session: session).to_s
      end

      let(:address) { Address.new(street: "5th Ave") }
      let(:delivery) { Delivery.new(id: 1, customer_id: 23, address: address) }
      let(:params) { DeliveryParams.new({}) }
      let(:session) { Session.new(_csrf_token: "s14") }

      it "renders the form" do
        expected = <<~HTML
          <form action="/deliveries/#{delivery.id}" method="POST" accept-charset="utf-8" id="delivery-form" class="form-horizontal">
          <input type="hidden" name="_method" value="PATCH">
          <input type="hidden" name="_csrf_token" value="#{session[:_csrf_token]}">
          <div class="form-group">
          <label for="delivery-customer">Customer</label>
          <input type="text" name="" id="delivery-customer" value="" class="form-control" placeholder="Customer">
          <input type="hidden" name="delivery[customer_id]" id="delivery-customer-id" value="#{delivery.customer_id}">
          </div>
          <fieldset>
          <legend>Address</legend>
          <div class="form-group">
          <label for="delivery-address-street">Street</label>
          <input type="text" name="delivery[address][street]" id="delivery-address-street" value="#{address.street}" class="form-control" placeholder="Street">
          </div>
          </fieldset>
          <button type="submit" class="btn btn-default">Update</button>
          </form>

        HTML

        expect(subject).to match(expected)
      end
    end

    describe "after a failed submission" do
      subject do
        FullStack::Views::Deliveries::Edit.new.call(format: :html, delivery: delivery, params: params, session: session).to_s
      end

      let(:address) { Address.new(street: "5th Ave") }
      let(:delivery) { Delivery.new(id: 1, customer_id: 23, address: address) }
      let(:params) { DeliveryParams.new(delivery: {address: {street: "Mulholland Drive"}}) }
      let(:session) { Session.new(_csrf_token: "s14") }

      it "renders the form" do
        expected = <<~HTML
          <form action="/deliveries/#{delivery.id}" method="POST" accept-charset="utf-8" id="delivery-form" class="form-horizontal">
          <input type="hidden" name="_method" value="PATCH">
          <input type="hidden" name="_csrf_token" value="#{session[:_csrf_token]}">
          <div class="form-group">
          <label for="delivery-customer">Customer</label>
          <input type="text" name="" id="delivery-customer" value="" class="form-control" placeholder="Customer">
          <input type="hidden" name="delivery[customer_id]" id="delivery-customer-id" value="#{delivery.customer_id}">
          </div>
          <fieldset>
          <legend>Address</legend>
          <div class="form-group">
          <label for="delivery-address-street">Street</label>
          <input type="text" name="delivery[address][street]" id="delivery-address-street" value="#{params[:delivery][:address][:street]}" class="form-control" placeholder="Street">
          </div>
          </fieldset>
          <button type="submit" class="btn btn-default">Update</button>
          </form>

        HTML

        expect(subject).to match(expected)
      end
    end

    describe "after a failed submission with blank values" do
      subject do
        FullStack::Views::Deliveries::Edit.new.call(format: :html, delivery: delivery, params: params, session: session).to_s
      end

      let(:address) { Address.new(street: "5th Ave") }
      let(:delivery) { Delivery.new(id: 1, customer_id: 23, address: address) }
      let(:params) { DeliveryParams.new(delivery: {address: {street: ""}}) }
      let(:session) { Session.new(_csrf_token: "s14") }

      it "renders the form" do
        expected = <<~HTML
          <form action="/deliveries/#{delivery.id}" method="POST" accept-charset="utf-8" id="delivery-form" class="form-horizontal">
          <input type="hidden" name="_method" value="PATCH">
          <input type="hidden" name="_csrf_token" value="#{session[:_csrf_token]}">
          <div class="form-group">
          <label for="delivery-customer">Customer</label>
          <input type="text" name="" id="delivery-customer" value="" class="form-control" placeholder="Customer">
          <input type="hidden" name="delivery[customer_id]" id="delivery-customer-id" value="#{delivery.customer_id}">
          </div>
          <fieldset>
          <legend>Address</legend>
          <div class="form-group">
          <label for="delivery-address-street">Street</label>
          <input type="text" name="delivery[address][street]" id="delivery-address-street" value="" class="form-control" placeholder="Street">
          </div>
          </fieldset>
          <button type="submit" class="btn btn-default">Update</button>
          </form>

        HTML

        expect(subject).to match(expected)
      end
    end
  end

  describe "form with nested structures" do
    describe "first page load" do
      subject do
        FullStack::Views::Bills::Edit.new.call(format: :html, bill: bill, params: params, session: session).to_s
      end

      let(:address1) { Address.new(street: "5th Ave") }
      let(:address2) { Address.new(street: "4th Ave") }
      let(:bill) { Bill.new(id: 1, addresses: [address1, address2]) }
      let(:params) { BillParams.new({}) }
      let(:session) { Session.new(_csrf_token: "s14") }

      it "renders the form" do
        expected = <<~HTML
          <form action="/bills/#{bill.id}" method="POST" accept-charset="utf-8" id="bill-form" class="form-horizontal">
          <input type="hidden" name="_method" value="PATCH">
          <input type="hidden" name="_csrf_token" value="#{session[:_csrf_token]}">
          <fieldset>
          <legend>Addresses</legend>
          <div class="form-group">
          <label for="bill-addresses-0-street">Street</label>
          <input type="text" name="bill[addresses][][street]" id="bill-addresses-0-street" value="#{address1.street}" class="form-control" placeholder="Street" data-funky="index-0">
          </div>
          <div class="form-group">
          <label for="bill-addresses-1-street">Street</label>
          <input type="text" name="bill[addresses][][street]" id="bill-addresses-1-street" value="#{address2.street}" class="form-control" placeholder="Street" data-funky="index-1">
          </div>
          <label for="bill-ensure-names">Ensure names</label>
          </fieldset>
          <button type="submit" class="btn btn-default">Update</button>
          </form>
        HTML

        expect(subject).to match(expected)
      end
    end

    describe "after a failed submission" do
      subject do
        FullStack::Views::Bills::Edit.new.call(format: :html, bill: bill, params: params, session: session).to_s
      end

      let(:address1) { Address.new(street: "5th Ave") }
      let(:address2) { Address.new(street: "4th Ave") }
      let(:bill) { Bill.new(id: 1, addresses: [address1, address2]) }
      let(:params) { BillParams.new(bill: {addresses: [{street: "Mulholland Drive"}, {street: "Quaint Edge"}]}) }
      let(:session) { Session.new(_csrf_token: "s14") }

      it "renders the form" do
        expected = <<~HTML
          <form action="/bills/#{bill.id}" method="POST" accept-charset="utf-8" id="bill-form" class="form-horizontal">
          <input type="hidden" name="_method" value="PATCH">
          <input type="hidden" name="_csrf_token" value="#{session[:_csrf_token]}">
          <fieldset>
          <legend>Addresses</legend>
          <div class="form-group">
          <label for="bill-addresses-0-street">Street</label>
          <input type="text" name="bill[addresses][][street]" id="bill-addresses-0-street" value="#{params[:bill][:addresses][0][:street]}" class="form-control" placeholder="Street" data-funky="index-0">
          </div>
          <div class="form-group">
          <label for="bill-addresses-1-street">Street</label>
          <input type="text" name="bill[addresses][][street]" id="bill-addresses-1-street" value="#{params[:bill][:addresses][1][:street]}" class="form-control" placeholder="Street" data-funky="index-1">
          </div>
          <label for="bill-ensure-names">Ensure names</label>
          </fieldset>
          <button type="submit" class="btn btn-default">Update</button>
          </form>
        HTML

        expect(subject).to match(expected)
      end
    end

    describe "accessing resource data" do
      subject do
        FullStack::Views::Bills::Edit2.new.call(format: :html, bill: bill, params: params, session: session).to_s
      end

      let(:address1) { Address.new(id: 23, street: "5th Ave") }
      let(:address2) { Address.new(id: 42, street: "4th Ave") }
      let(:bill) { Bill.new(id: 1, addresses: [address1, address2]) }
      let(:params) { BillParams.new({}) }
      let(:session) { Session.new(_csrf_token: "s14") }

      it "renders the form" do
        expected = <<~HTML
          <form action="/bills/#{bill.id}" method="POST" accept-charset="utf-8" id="bill-form" class="form-horizontal">
          <input type="hidden" name="_method" value="PATCH">
          <input type="hidden" name="_csrf_token" value="#{session[:_csrf_token]}">
          <fieldset>
          <legend>Addresses</legend>
          <div class="form-group">
          Address id: 23
          <label for="bill-addresses-0-street">Street</label>
          <input type="text" name="bill[addresses][][street]" id="bill-addresses-0-street" value="#{address1.street}" class="form-control" placeholder="Street" data-funky="index-0">
          </div>
          <div class="form-group">
          Address id: 42
          <label for="bill-addresses-1-street">Street</label>
          <input type="text" name="bill[addresses][][street]" id="bill-addresses-1-street" value="#{address2.street}" class="form-control" placeholder="Street" data-funky="index-1">
          </div>
          <label for="bill-ensure-names">Ensure names</label>
          </fieldset>
          <button type="submit" class="btn btn-default">Update</button>
          </form>
        HTML

        expect(subject).to match(expected)
      end
    end
  end
end
