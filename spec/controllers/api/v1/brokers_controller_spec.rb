require 'rails_helper'
RSpec.describe Api::V1::BrokersController do
  before(:all) do
    1.upto(5) do
      @customer = create_customer
    end
    1.upto(3) do
      @broker = create_broker
    end
    @buyer = create_buyer
    @parcel = create_parcel(@customer)
  end

  before(:each) do
    request.headers.merge!(authorization: @customer.authentication_token)
  end

  describe '#company_record_on_the_basis_of_roles' do
    context 'when unknown user want to see brokers or seller list' do
      it 'does show message not authenticated user' do
        request.headers.merge!(authorization: 'asdasdasdasdasdsd')
        get :company_record_on_the_basis_of_roles
      end
    end
  end

end
