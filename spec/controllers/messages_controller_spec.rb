require 'rails_helper'

RSpec.describe MessagesController, type: :controller do

  before(:all) do
    create_user
    @parcel = create(:trading_parcel, customer: @customer, company: @customer.company)
  end

  before(:each) do
    create_user_login_user
  end

  describe "When I click on new message and I see the buyer’s offer" do

    it "Should create proposal and new message" do
      buyer = create_buyer
      proposal = buyer_create_proposal(buyer)
      message = create_message(buyer, proposal)
      get :index
      expect(assigns(:messages)).to eq([message])
    end


    it "should return 200 status code" do
      get :index
      expect(response.status).to eq(200)
    end

  end

  describe "I go to Inbox to see all incoming offers" do

    it "should be greater than zero(0)" do
      buyer = create_buyer
      proposal = buyer_create_proposal(buyer)
      message = create_message(buyer, proposal)
      get :index
      assigns(:messages).size.should be > 0
    end

    it "should return 200 status code" do
      get :index
      expect(response.status).to eq(200)
    end

  end


end
