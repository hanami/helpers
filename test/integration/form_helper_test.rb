require 'test_helper'

describe 'Form helper' do
  before do
    Hanami::View.load!
  end

  describe 'form with huge ERB block' do
    before do
      @params  = Hanami::Action::BaseParams.new({})
      @session = Session.new(_csrf_token: 'l23')
      @actual  = FullStack::Views::Sessions::New.render(format: :html, params: @params, session: @session)
    end

    it 'renders the form' do
      @actual.must_include %(<form action="/sessions" method="POST" accept-charset="utf-8" id="session-form" class="form-horizontal">\n<input type="hidden" name="_csrf_token" value="#{@session[:_csrf_token]}">\n<div class="form-group">\n<label for="session-email">Email</label>\n<input type="email" name="session[email]" id="session-email" value="" class="form-control" placeholder="Email address">\n</div>\n<div class="form-group">\n<label for="session-password">Password</label>\n<input type="password" name="session[password]" id="session-password" value="" class="form-control">\n</div>\n<input type="hidden" name="session[remember][me]" value="0">\n<input type="checkbox" name="session[remember][me]" id="session-remember-me" value="1">\n<button type="submit" class="btn btn-default">Sign in</button>\n</form>)
    end
  end

  describe 'form to create a new resource' do
    describe 'first page load' do
      before do
        @params  = DeliveryParams.new({})
        @session = Session.new(_csrf_token: 'm15')
        @actual  = FullStack::Views::Deliveries::New.render(format: :html, params: @params, session: @session)
      end

      it 'renders the form' do
        @actual.must_include %(<form action="/deliveries" method="POST" accept-charset="utf-8" id="delivery-form" class="form-horizontal">\n<input type="hidden" name="_csrf_token" value="#{@session[:_csrf_token]}">\n<div class="form-group">\n<label for="delivery-customer">Customer</label>\n<input type="text" name="" id="delivery-customer" value="" class="form-control" placeholder="Customer">\n<input type="hidden" name="delivery[customer_id]" id="delivery-customer-id" value="">\n</div>\n<fieldset>\n<legend>Address</legend>\n<div class="form-group">\n<label for="delivery-address-street">Street</label>\n<input type="text" name="delivery[address][street]" id="delivery-address-street" value="" class="form-control" placeholder="Street">\n</div>\n</fieldset>\n<button type="submit" class="btn btn-default">Create</button>\n</form>)
      end
    end

    describe 'after a failed form submission' do
      before do
        @params  = DeliveryParams.new(delivery: { address: { street: '5th Ave' } })
        @session = Session.new(_csrf_token: 'm15')
        @params.valid? # trigger validations

        @actual = FullStack::Views::Deliveries::New.render(format: :html, params: @params, session: @session)
      end

      it 'renders the form with previous values' do
        @actual.must_include %(<form action="/deliveries" method="POST" accept-charset="utf-8" id="delivery-form" class="form-horizontal">\n<input type="hidden" name="_csrf_token" value="#{@session[:_csrf_token]}">\n<div class="form-group">\n<label for="delivery-customer">Customer</label>\n<input type="text" name="" id="delivery-customer" value="" class="form-control" placeholder="Customer">\n<input type="hidden" name="delivery[customer_id]" id="delivery-customer-id" value="">\n</div>\n<fieldset>\n<legend>Address</legend>\n<div class="form-group">\n<label for="delivery-address-street">Street</label>\n<input type="text" name="delivery[address][street]" id="delivery-address-street" value="5th Ave" class="form-control" placeholder="Street">\n</div>\n</fieldset>\n<button type="submit" class="btn btn-default">Create</button>\n</form>)
      end
    end
  end

  describe 'form to update a resource' do
    describe 'first page load' do
      before do
        @address  = Address.new(street: '5th Ave')
        @delivery = Delivery.new(id: 1, customer_id: 23, address: @address)
        @params   = DeliveryParams.new({})
        @session  = Session.new(_csrf_token: 's14')
        @actual   = FullStack::Views::Deliveries::Edit.render(format: :html, delivery: @delivery, params: @params, session: @session)
      end

      it 'renders the form' do
        @actual.must_include %(<form action="/deliveries/#{@delivery.id}" method="POST" accept-charset="utf-8" id="delivery-form" class="form-horizontal">\n<input type="hidden" name="_method" value="PATCH">\n<input type="hidden" name="_csrf_token" value="#{@session[:_csrf_token]}">\n<div class="form-group">\n<label for="delivery-customer">Customer</label>\n<input type="text" name="" id="delivery-customer" value="" class="form-control" placeholder="Customer">\n<input type="hidden" name="delivery[customer_id]" id="delivery-customer-id" value="#{@delivery.customer_id}">\n</div>\n<fieldset>\n<legend>Address</legend>\n<div class="form-group">\n<label for="delivery-address-street">Street</label>\n<input type="text" name="delivery[address][street]" id="delivery-address-street" value="#{@address.street}" class="form-control" placeholder="Street">\n</div>\n</fieldset>\n<button type="submit" class="btn btn-default">Update</button>\n</form>)
      end
    end

    describe 'after a failed submission' do
      before do
        @address  = Address.new(street: '5th Ave')
        @delivery = Delivery.new(id: 1, customer_id: 23, address: @address)
        @params   = DeliveryParams.new(delivery: { address: { street: 'Mulholland Drive' } })
        @session  = Session.new(_csrf_token: 's14')
        @params.valid? # trigger validations

        @actual = FullStack::Views::Deliveries::Edit.render(format: :html, delivery: @delivery, params: @params, session: @session)
      end

      it 'renders the form' do
        @actual.must_include %(<form action="/deliveries/#{@delivery.id}" method="POST" accept-charset="utf-8" id="delivery-form" class="form-horizontal">\n<input type="hidden" name="_method" value="PATCH">\n<input type="hidden" name="_csrf_token" value="#{@session[:_csrf_token]}">\n<div class="form-group">\n<label for="delivery-customer">Customer</label>\n<input type="text" name="" id="delivery-customer" value="" class="form-control" placeholder="Customer">\n<input type="hidden" name="delivery[customer_id]" id="delivery-customer-id" value="#{@delivery.customer_id}">\n</div>\n<fieldset>\n<legend>Address</legend>\n<div class="form-group">\n<label for="delivery-address-street">Street</label>\n<input type="text" name="delivery[address][street]" id="delivery-address-street" value="#{@params[:delivery][:address][:street]}" class="form-control" placeholder="Street">\n</div>\n</fieldset>\n<button type="submit" class="btn btn-default">Update</button>\n</form>)
      end
    end

    describe 'after a failed submission with blank values' do
      before do
        @address  = Address.new(street: '5th Ave')
        @delivery = Delivery.new(id: 1, customer_id: 23, address: @address)
        @params   = DeliveryParams.new(delivery: { address: { street: nil } })
        @session  = Session.new(_csrf_token: 's14')
        @params.valid? # trigger validations

        @actual = FullStack::Views::Deliveries::Edit.render(format: :html, delivery: @delivery, params: @params, session: @session)
      end

      it 'renders the form' do
        @actual.must_include %(<form action="/deliveries/#{@delivery.id}" method="POST" accept-charset="utf-8" id="delivery-form" class="form-horizontal">\n<input type="hidden" name="_method" value="PATCH">\n<input type="hidden" name="_csrf_token" value="#{@session[:_csrf_token]}">\n<div class="form-group">\n<label for="delivery-customer">Customer</label>\n<input type="text" name="" id="delivery-customer" value="" class="form-control" placeholder="Customer">\n<input type="hidden" name="delivery[customer_id]" id="delivery-customer-id" value="#{@delivery.customer_id}">\n</div>\n<fieldset>\n<legend>Address</legend>\n<div class="form-group">\n<label for="delivery-address-street">Street</label>\n<input type="text" name="delivery[address][street]" id="delivery-address-street" value="#{@address.street}" class="form-control" placeholder="Street">\n</div>\n</fieldset>\n<button type="submit" class="btn btn-default">Update</button>\n</form>)
      end
    end
  end
end
