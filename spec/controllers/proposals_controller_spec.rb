require 'rails_helper'

RSpec.describe ProposalsController, type: :controller do

  before(:all) do
    company = Company.create(name: Faker::Name.name)
    @customer = Customer.create(first_name: FFaker::Name.first_name, last_name: FFaker::Name.last_name, email: FFaker::Internet.email,
                                password: FFaker::DizzleIpsum.words(4).join('!').first(8), mobile_no: Faker::PhoneNumber.phone_number,
                                role: "Buyer/Seller", confirmed_at: Time.current, company: company)
    create(:customer_role, customer: @customer)
    @parcel = create(:trading_parcel, customer: @customer, company: @customer.company)
  end

  before(:each) do
    create_user_login_user
  end


  describe "#accept" do

    render_views

    context "When seller accept the proposal" do


      it "does process transaction if seller set limit is less than the buyer amount" do

        buyer = create_buyer
        proposal = buyer_create_proposal(buyer)
        message = create_message(buyer, proposal)
        put :accept, params: {id: proposal.id}
        message = Message.find_by(sender_id: @customer.company.id, receiver_id: buyer.company.id, proposal_id: proposal.id)

        expect(message).to be_present
        expect(message).to be_valid
        expect(message.subject).to eq("Your proposal is accepted.")

        credit_limit = CreditLimit.find_by(seller_id: @customer.company.id, buyer_id: buyer.company.id)

        expect(credit_limit).to be_present
        expect(credit_limit).to be_valid

        transaction = Transaction.find_by(buyer_id: buyer.company.id, seller_id: @customer.company.id, trading_parcel_id: @parcel.id)

        expect(transaction).to be_present
        expect(transaction).to be_valid

      end

      it "does give error message if seller set limit is higher than the buyer amount, click yes to continue" do
        buyer = create_buyer
        proposal = buyer_create_proposal(buyer)
        message = create_message(buyer, proposal)
        put :accept, params: {id: proposal.id}
        message = Message.find_by(sender_id: @customer.company.id, receiver_id: buyer.company.id, proposal_id: proposal.id)

        expect(message).to be_present
        expect(message).to be_valid
        expect(message.subject).to eq("Your proposal is accepted.")

        credit_limit = CreditLimit.find_by(seller_id: @customer.company.id, buyer_id: buyer.company.id)

        expect(credit_limit).to be_present
        expect(credit_limit).to be_valid

        transaction = Transaction.find_by(buyer_id: buyer.company.id, seller_id: @customer.company.id, trading_parcel_id: @parcel.id)

        expect(transaction).to be_present
        expect(transaction).to be_valid
      end


      it "does cancel if click on No" do

        buyer = create_buyer
        proposal = buyer_create_proposal(buyer)
        message = create_message(buyer, proposal)

        put :accept, params: {id: proposal.id, check: true, format: :js}


        message = Message.find_by(sender_id: @customer.company.id, receiver_id: buyer.company.id, proposal_id: proposal.id)

        expect(message).to be_nil

        credit_limit = CreditLimit.find_by(seller_id: @customer.company.id, buyer_id: buyer.company.id)
        expect(credit_limit).to be_nil

        transaction = Transaction.find_by(buyer_id: buyer.company.id, seller_id: @customer.company.id, trading_parcel_id: @parcel.id)
        expect(transaction).to be_nil

      end

      it "does less than the market limit" do
        buyer = create_buyer
        proposal = buyer_create_proposal(buyer)
        message = create_message(buyer, proposal)

        companies_groups = create(:companies_group, company_id: [buyer.company.id], seller_id:@customer.company.id)

        put :accept, params: {id: proposal.id, check: true, format: :js}

        companies_groups.group_market_limit.should be < proposal.total_value
      end

      it "does less than the over_due limit " do

        buyer = create_buyer
        proposal = buyer_create_proposal(buyer)
        message = create_message(buyer, proposal)
        companies_groups = create(:companies_group, company_id: [buyer.company.id], seller_id: @customer.company.id)

        days_limit = companies_groups.group_overdue_limit
        date = Date.current - days_limit.days
        all_members = companies_groups.company_id

        put :accept, params: {id: proposal.id, check: true, format: :js}


        over_due = Transaction.where("buyer_id IN (?) AND due_date < ? AND paid = ?", all_members, date, false).present?

        expect(over_due).to eq(false)

        companies_groups.group_market_limit.should be < proposal.total_value
      end

      it "does match the warning messages" do
        buyer = create_buyer
        proposal = buyer_create_proposal(buyer)
        message = create_message(buyer, proposal)

        put :accept, params: {id: proposal.id, check: true, format: :js}
        existing_limit = 0;
        existing_market_limit = 0;
        new_limit = proposal.price*proposal.trading_parcel.weight.to_f;

        response.body.should have_content("Your existing credit limit for this buyer was: #{number_to_currency(existing_limit)}. This transaction would increase it to #{number_to_currency(new_limit)}.")
        response.body.should have_content("Your existing market limit for this buyer was: #{ number_to_currency(existing_market_limit) }. This transaction would increase it to #{number_to_currency(new_limit) }")

      end

      it "does return 200 status code" do
        buyer = create_buyer
        proposal = buyer_create_proposal(buyer)
        message = create_message(buyer, proposal)
        put :accept, params: {id: proposal.id, check: true, format: :js}
        expect(response.status).to eq(200)
      end

    end

  end

  describe "#show" do
    render_views

    context "when it check buttons exist" do

      it "does have three buttons, Accept, Reject, Negotiation" do

        buyer = create_buyer
        proposal = buyer_create_proposal(buyer)
        message = create_message(buyer, proposal)

        put :show, params: {id: proposal.id}

        response.body.should have_link('Accept')
        response.body.should have_link('Reject')
        response.body.should have_link('Negotiate')
      end

      it "does return 200 status code" do
        buyer = create_buyer
        proposal = buyer_create_proposal(buyer)
        message = create_message(buyer, proposal)
        put :show, params: {id: proposal.id}
        expect(response.status).to eq(200)
      end

    end

  end

  describe "#reject" do

    context "when reject the proposal" do

      it "does rejected" do
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

    context "when negotiation on proposal" do

      it "does negotiated" do
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
