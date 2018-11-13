require 'rails_helper'

RSpec.describe ProposalsController, type: :controller do

  before(:all) do
    create_user
    @parcel = create(:trading_parcel, customer: @customer, company: @customer.company)
  end

  before(:each) do
    create_user_login_user
  end


  describe "When seller accept the proposal" do

    it "should process transaction if buyer is less than the limit" do

      buyer = create_buyer
      proposal = buyer_create_proposal(buyer)
      message = create_message(buyer, proposal)
      put :accept, params: {id: proposal.id}
      message = Message.find_by(sender_id: @customer.company.id, receiver_id: buyer.company.id, proposal_id: proposal.id)

      expect(message).to be_present
      expect(message).to be_valid
      expect(message.subject).to eq("Your proposal is accepted.")

      credit_limit = CreditLimit.find_by(seller_id: @customer.company.id, buyer_id: buyer.company.id)

      expect(message).to be_present
      expect(message).to be_valid

      transaction = Transaction.find_by(buyer_id: buyer.company.id, seller_id: @customer.company.id, trading_parcel_id: @parcel.id)

      expect(message).to be_present
      expect(message).to be_valid

    end

    it "should give error message if buyer is higher than the limit, click yes to continue" do
      buyer = create_buyer
      proposal = buyer_create_proposal(buyer)
      message = create_message(buyer, proposal)
      put :accept, params: {id: proposal.id}
      message = Message.find_by(sender_id: @customer.company.id, receiver_id: buyer.company.id, proposal_id: proposal.id)

      expect(message).to be_present
      expect(message).to be_valid
      expect(message.subject).to eq("Your proposal is accepted.")

      credit_limit = CreditLimit.find_by(seller_id: @customer.company.id, buyer_id: buyer.company.id)

      expect(message).to be_present
      expect(message).to be_valid

      transaction = Transaction.find_by(buyer_id: buyer.company.id, seller_id: @customer.company.id, trading_parcel_id: @parcel.id)

      expect(message).to be_present
      expect(message).to be_valid
    end

    it "should be cancel if click on No" do
      buyer = create_buyer
      proposal = buyer_create_proposal(buyer)
      message = create_message(buyer, proposal)
      put :accept, params: {id: proposal.id, check: true, format: :js}

      message = Message.find_by(sender_id: @customer.company.id, receiver_id: buyer.company.id, proposal_id: proposal.id)

      expect(message).to be_nil

      credit_limit = CreditLimit.find_by(seller_id: @customer.company.id, buyer_id: buyer.company.id)
      expect(message).to be_nil

      transaction = Transaction.find_by(buyer_id: buyer.company.id, seller_id: @customer.company.id, trading_parcel_id: @parcel.id)
      expect(message).to be_nil

    end

    it "should return 200 status code" do
      buyer = create_buyer
      proposal = buyer_create_proposal(buyer)
      message = create_message(buyer, proposal)
      put :accept, params: {id: proposal.id, check: true, format: :js}
      expect(response.status).to eq(200)
    end

  end

  describe "proposals/show.html.erb" do
    render_views

    context "check buttons exist" do

      it "should have three buttons, Accept, Reject, Negotiation" do

        buyer = create_buyer
        proposal = buyer_create_proposal(buyer)
        message = create_message(buyer, proposal)

        put :show, params: {id: proposal.id}

        response.body.should have_link('Accept')
        response.body.should have_link('Reject')
        response.body.should have_link('Negotiate')
      end

    end

  end

  describe "#reject" do

    context "reject the proposal" do

      it "should reject the proposal" do
        buyer = create_buyer
        proposal = buyer_create_proposal(buyer)
        message = create_message(buyer, proposal)
        put :reject, params: {id: proposal.id}
        message = Message.find_by(sender_id: @customer.company.id, receiver_id: buyer.company.id, proposal_id: proposal.id)

        expect(message).to be_present
        expect(message).to be_valid
        expect(message.subject).to eq("Your proposal is rejected.")

      end

    end

  end

  describe "#update" do

    context "negotiation on proposal" do

      it "should negotiate the proposal" do
        buyer = create_buyer
        proposal = buyer_create_proposal(buyer)
        message = create_message(buyer, proposal)

        put :update, params: {id: proposal.id, proposal: {price: 3500.0, percent: 10.0}, flag: true, format: :js}

        updated_proposal = Proposal.find(proposal.id)

        expect(updated_proposal.price).to eq(3500.0)
        expect(updated_proposal.percent).to eq(10.0)

        expect(updated_proposal).to redirect_to(trading_customers_path)
      end

    end

  end

end
