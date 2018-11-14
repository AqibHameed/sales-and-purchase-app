require 'rails_helper'

RSpec.describe MessagesController, type: :controller do

  before(:all) do
    create_user
    @parcel = create(:trading_parcel, customer: @customer, company: @customer.company)
  end

  before(:each) do
    create_user_login_user
  end

  describe "#index" do

    context "when click on inbox, shows all incoming offers/proposal " do

        it "does equal to new proposal" do
          buyer = create_buyer
          proposal = buyer_create_proposal(buyer)
          message = create_message(buyer, proposal)
          get :index
          expect(assigns(:messages)).to eq([message])
        end

        it "does greater than zero(0)" do
            buyer = create_buyer
            proposal = buyer_create_proposal(buyer)
            message = create_message(buyer, proposal)
            get :index
            assigns(:messages).size.should be > 0
        end

        it "does return 200 status code" do
            buyer = create_buyer
            proposal = buyer_create_proposal(buyer)
            message = create_message(buyer, proposal)
            get :index
            expect(response.status).to eq(200)
        end

    end

  end

end
