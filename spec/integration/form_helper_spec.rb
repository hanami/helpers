RSpec.describe 'Form helper' do
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
      expect(@actual).to include(%(<form action="/sessions" method="POST" accept-charset="utf-8" id="session-form" class="form-horizontal">\n<input type="hidden" name="_csrf_token" value="#{@session[:_csrf_token]}">\n<div class="form-group">\n<label for="session-email">Email</label>\n<input type="email" name="session[email]" id="session-email" value="" class="form-control" placeholder="Email address">\n</div>\n<div class="form-group">\n<label for="session-password">Password</label>\n<input type="password" name="session[password]" id="session-password" value="" class="form-control">\n</div>\n<input type="hidden" name="session[remember][me]" value="0">\n<input type="checkbox" name="session[remember][me]" id="session-remember-me" value="1">\n<button type="submit" class="btn btn-default">Sign in</button>\n</form>))
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
        expect(@actual).to include(%(<form action="/deliveries" method="POST" accept-charset="utf-8" id="delivery-form" class="form-horizontal">\n<input type="hidden" name="_csrf_token" value="#{@session[:_csrf_token]}">\n<div class="form-group">\n<label for="delivery-customer">Customer</label>\n<input type="text" name="" id="delivery-customer" value="" class="form-control" placeholder="Customer">\n<input type="hidden" name="delivery[customer_id]" id="delivery-customer-id" value="">\n</div>\n<fieldset>\n<legend>Address</legend>\n<div class="form-group">\n<label for="delivery-address-street">Street</label>\n<input type="text" name="delivery[address][street]" id="delivery-address-street" value="" class="form-control" placeholder="Street">\n</div>\n</fieldset>\n<button type="submit" class="btn btn-default">Create</button>\n</form>))
      end
    end

    describe 'after a failed form submission' do
      before do
        @params  = DeliveryParams.new(delivery: { address: { street: '5th Ave' } })
        @session = Session.new(_csrf_token: 'm15')

        @actual = FullStack::Views::Deliveries::New.render(format: :html, params: @params, session: @session)
      end

      it 'renders the form with previous values' do
        expect(@actual).to include(%(<form action="/deliveries" method="POST" accept-charset="utf-8" id="delivery-form" class="form-horizontal">\n<input type="hidden" name="_csrf_token" value="#{@session[:_csrf_token]}">\n<div class="form-group">\n<label for="delivery-customer">Customer</label>\n<input type="text" name="" id="delivery-customer" value="" class="form-control" placeholder="Customer">\n<input type="hidden" name="delivery[customer_id]" id="delivery-customer-id" value="">\n</div>\n<fieldset>\n<legend>Address</legend>\n<div class="form-group">\n<label for="delivery-address-street">Street</label>\n<input type="text" name="delivery[address][street]" id="delivery-address-street" value="5th Ave" class="form-control" placeholder="Street">\n</div>\n</fieldset>\n<button type="submit" class="btn btn-default">Create</button>\n</form>))
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
        expect(@actual).to include(%(<form action="/deliveries/#{@delivery.id}" method="POST" accept-charset="utf-8" id="delivery-form" class="form-horizontal">\n<input type="hidden" name="_method" value="PATCH">\n<input type="hidden" name="_csrf_token" value="#{@session[:_csrf_token]}">\n<div class="form-group">\n<label for="delivery-customer">Customer</label>\n<input type="text" name="" id="delivery-customer" value="" class="form-control" placeholder="Customer">\n<input type="hidden" name="delivery[customer_id]" id="delivery-customer-id" value="#{@delivery.customer_id}">\n</div>\n<fieldset>\n<legend>Address</legend>\n<div class="form-group">\n<label for="delivery-address-street">Street</label>\n<input type="text" name="delivery[address][street]" id="delivery-address-street" value="#{@address.street}" class="form-control" placeholder="Street">\n</div>\n</fieldset>\n<button type="submit" class="btn btn-default">Update</button>\n</form>))
      end
    end

    describe 'after a failed submission' do
      before do
        @address  = Address.new(street: '5th Ave')
        @delivery = Delivery.new(id: 1, customer_id: 23, address: @address)
        @params   = DeliveryParams.new(delivery: { address: { street: 'Mulholland Drive' } })
        @session  = Session.new(_csrf_token: 's14')

        @actual = FullStack::Views::Deliveries::Edit.render(format: :html, delivery: @delivery, params: @params, session: @session)
      end

      it 'renders the form' do
        expect(@actual).to include(%(<form action="/deliveries/#{@delivery.id}" method="POST" accept-charset="utf-8" id="delivery-form" class="form-horizontal">\n<input type="hidden" name="_method" value="PATCH">\n<input type="hidden" name="_csrf_token" value="#{@session[:_csrf_token]}">\n<div class="form-group">\n<label for="delivery-customer">Customer</label>\n<input type="text" name="" id="delivery-customer" value="" class="form-control" placeholder="Customer">\n<input type="hidden" name="delivery[customer_id]" id="delivery-customer-id" value="#{@delivery.customer_id}">\n</div>\n<fieldset>\n<legend>Address</legend>\n<div class="form-group">\n<label for="delivery-address-street">Street</label>\n<input type="text" name="delivery[address][street]" id="delivery-address-street" value="#{@params[:delivery][:address][:street]}" class="form-control" placeholder="Street">\n</div>\n</fieldset>\n<button type="submit" class="btn btn-default">Update</button>\n</form>))
      end
    end

    describe 'after a failed submission with blank values' do
      before do
        @address  = Address.new(street: '5th Ave')
        @delivery = Delivery.new(id: 1, customer_id: 23, address: @address)
        @params   = DeliveryParams.new(delivery: { address: { street: '' } })
        @session  = Session.new(_csrf_token: 's14')

        @actual = FullStack::Views::Deliveries::Edit.render(format: :html, delivery: @delivery, params: @params, session: @session)
      end

      it 'renders the form' do
        expect(@actual).to include(%(<form action="/deliveries/#{@delivery.id}" method="POST" accept-charset="utf-8" id="delivery-form" class="form-horizontal">\n<input type="hidden" name="_method" value="PATCH">\n<input type="hidden" name="_csrf_token" value="#{@session[:_csrf_token]}">\n<div class="form-group">\n<label for="delivery-customer">Customer</label>\n<input type="text" name="" id="delivery-customer" value="" class="form-control" placeholder="Customer">\n<input type="hidden" name="delivery[customer_id]" id="delivery-customer-id" value="#{@delivery.customer_id}">\n</div>\n<fieldset>\n<legend>Address</legend>\n<div class="form-group">\n<label for="delivery-address-street">Street</label>\n<input type="text" name="delivery[address][street]" id="delivery-address-street" value="" class="form-control" placeholder="Street">\n</div>\n</fieldset>\n<button type="submit" class="btn btn-default">Update</button>\n</form>))
      end
    end
  end

  describe 'form with nested structures' do
    describe 'first page load' do
      before do
        @address1 = Address.new(street: '5th Ave', city: 'New York')
        @address2 = Address.new(street: '4th Ave', city: 'Seattle')
        @bill     = Bill.new(id: 1, addresses: [@address1, @address2])
        @params   = BillParams.new({})
        @session  = Session.new(_csrf_token: 's14')

        @actual   = FullStack::Views::Bills::Edit.render(format: :html, bill: @bill, params: @params, session: @session)
      end

      it 'renders the form' do
        expected = %(
        <form action="/bills/#{@bill.id}" method="POST" accept-charset="utf-8" id="bill-form" class="form-horizontal">
        <input type="hidden" name="_method" value="PATCH">
        <input type="hidden" name="_csrf_token" value="#{@session[:_csrf_token]}">
        <fieldset>
        <legend>Addresses</legend>
        <div class="form-group">
        <label for="bill-addresses-0-street">Street</label>
        <input type="text" name="bill[addresses][0][street]" id="bill-addresses-0-street" value="#{@address1.street}" class="form-control" placeholder="Street" data-funky="id-0">
        </div>
        <div class="form-group">
        <label for="bill-addresses-0-city">City</label>
        <input type="text" name="bill[addresses][0][city]" id="bill-addresses-0-city" value="#{@address1.city}" class="form-control" placeholder="City" data-funky="id-0">
        </div>
        <div class="form-group">
        <label for="bill-addresses-1-street">Street</label>
        <input type="text" name="bill[addresses][1][street]" id="bill-addresses-1-street" value="#{@address2.street}" class="form-control" placeholder="Street" data-funky="id-1">
        </div>
        <div class="form-group">
        <label for="bill-addresses-1-city">City</label>
        <input type="text" name="bill[addresses][1][city]" id="bill-addresses-1-city" value="#{@address2.city}" class="form-control" placeholder="City" data-funky="id-1">
        </div>
        <label for="bill-ensure-names">Ensure names</label>
        </fieldset>
        <button type="submit" class="btn btn-default">Update</button>
        </form>
        ).strip.split("\n").map(&:strip).join("\n")

        expect(@actual).to include(expected)
      end
    end

    describe 'after a failed submission' do
      before do
        @address1 = Address.new(street: '5th Ave', city: 'New York')
        @address2 = Address.new(street: '4th Ave', city: 'Seattle')
        @bill     = Bill.new(id: 1, addresses: [@address1, @address2])
        @params   = BillParams.new(bill: { addresses: [{ street: 'Mulholland Drive' }, { street: 'Quaint Edge' }] })
        @session  = Session.new(_csrf_token: 's14')

        @actual   = FullStack::Views::Bills::Edit.render(format: :html, bill: @bill, params: @params, session: @session)
      end

      it 'renders the form' do
        expected = %(
        <form action="/bills/#{@bill.id}" method="POST" accept-charset="utf-8" id="bill-form" class="form-horizontal">
        <input type="hidden" name="_method" value="PATCH">
        <input type="hidden" name="_csrf_token" value="#{@session[:_csrf_token]}">
        <fieldset>
        <legend>Addresses</legend>
        <div class="form-group">
        <label for="bill-addresses-0-street">Street</label>
        <input type="text" name="bill[addresses][0][street]" id="bill-addresses-0-street" value="#{@params[:bill][:addresses][0][:street]}" class="form-control" placeholder="Street" data-funky="id-0">
        </div>
        <div class="form-group">
        <label for="bill-addresses-0-city">City</label>
        <input type="text" name="bill[addresses][0][city]" id="bill-addresses-0-city" value="#{@address1.city}" class="form-control" placeholder="City" data-funky="id-0">
        </div>
        <div class="form-group">
        <label for="bill-addresses-1-street">Street</label>
        <input type="text" name="bill[addresses][1][street]" id="bill-addresses-1-street" value="#{@params[:bill][:addresses][1][:street]}" class="form-control" placeholder="Street" data-funky="id-1">
        </div>
        <div class="form-group">
        <label for="bill-addresses-1-city">City</label>
        <input type="text" name="bill[addresses][1][city]" id="bill-addresses-1-city" value="#{@address2.city}" class="form-control" placeholder="City" data-funky="id-1">
        </div>
        <label for="bill-ensure-names">Ensure names</label>
        </fieldset>
        <button type="submit" class="btn btn-default">Update</button>
        </form>
        ).strip.split("\n").map(&:strip).join("\n")

        expect(@actual).to include(expected)
      end
    end
  end
end
