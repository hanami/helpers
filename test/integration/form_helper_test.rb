require 'test_helper'

describe 'Form helper' do
  describe 'first page load' do
    before do
      @params = DeliveryParams.new({})
      @actual = FullStack::Views::Deliveries::New.render(format: :html, params: @params)
    end

    it 'renders the form' do
      @actual.must_include %(<form action="/deliveries" id="delivery-form" method="POST" class="form-horizontal">\n<div class="form-group">\n<label for="delivery-customer">Customer</label>\n<input type="text" name="" id="delivery-customer" value="" class="form-control" placeholder="Customer">\n<input type="hidden" name="delivery[customer_id]" id="delivery-customer-id" value="">\n</div>\n<fieldset>\n<legend>Address</legend>\n<div class="form-group">\n<label for="delivery-address-street">Street</label>\n<input type="text" name="delivery[address][street]" id="delivery-address-street" value="" class="form-control" placeholder="Street">\n</div>\n</fieldset>\n<button type="submit" class="btn btn-default">Create</button>\n</form>)
    end
  end

  describe 'after a failed form submission' do
    before do
      @params = DeliveryParams.new({ delivery: { address: { street: '5th Ave' }}})
      @params.valid? # trigger validations

      @actual = FullStack::Views::Deliveries::New.render(format: :html, params: @params)
    end

    it 'renders the form with previous values' do
      @actual.must_include %(<form action="/deliveries" id="delivery-form" method="POST" class="form-horizontal">\n<div class="form-group">\n<label for="delivery-customer">Customer</label>\n<input type="text" name="" id="delivery-customer" value="" class="form-control" placeholder="Customer">\n<input type="hidden" name="delivery[customer_id]" id="delivery-customer-id" value="">\n</div>\n<fieldset>\n<legend>Address</legend>\n<div class="form-group">\n<label for="delivery-address-street">Street</label>\n<input type="text" name="delivery[address][street]" id="delivery-address-street" value="5th Ave" class="form-control" placeholder="Street">\n</div>\n</fieldset>\n<button type="submit" class="btn btn-default">Create</button>\n</form>)
    end
  end
end
