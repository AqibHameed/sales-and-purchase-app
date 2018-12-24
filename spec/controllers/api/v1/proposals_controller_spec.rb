require 'rails_helper'
RSpec.describe Api::V1::ProposalsController do
  before(:all) do
    company = Company.create(name: Faker::Name.name)
    @customer = Customer.create(first_name: FFaker::Name.first_name, last_name: FFaker::Name.last_name, email: FFaker::Internet.email,
                                password: FFaker::DizzleIpsum.words(4).join('!').first(8), mobile_no: Faker::PhoneNumber.phone_number,
                                role: "Buyer/Seller", confirmed_at: Time.current, company: company, authentication_token: Devise.friendly_token)
    create(:customer_role, customer: @customer)
    @buyer = create_buyer
    @parcel = create(:trading_parcel, customer: @customer, company: @customer.company)
    @parcel = create(:trading_parcel, customer: @buyer, company: @customer.company)
  end

  before(:each) do

  end

  describe '#create' do
    context 'when user submite proposal without authorization' do
      it 'does show error un authorized user' do
        post :create, params: {
            trading_parcel_id: @parcel.id,
            credit: 155,
            price: 4500,
            total_value: 4000
        }
        response.body.should have_content('Not authenticated')
      end
    end

    context 'when user submite proposal with authorized user' do
      it 'does show error un authorized user' do
        request.headers.merge!(authorization: @customer.authentication_token)
        post :create, params: {
            trading_parcel_id: '',
            credit: 155,
            price: 4500,
            total_value: 4000
        }
        response.body.should have_content('Parcel does not exists for this id')
      end

      it 'does submite proposal succesfully' do
        request.headers.merge!(authorization: @customer.authentication_token)
        post :create, params: {
            trading_parcel_id: @parcel.id,
            credit: 155,
            price: 4500,
            total_value: 4000
        }
        response.body.should have_content('Proposal Submitted Successfully')
      end
    end

    context 'when update proposal with proposal id'do
      it 'does update exiting proposal' do
        create(:proposal, buyer_id: @buyer.company.id, seller_id: @customer.company.id, trading_parcel_id: @parcel.id, price: "4000", credit: "1500")
        proposal = Proposal.last
        request.headers.merge!(authorization: @customer.authentication_token)
        post :create, params: {
            id: proposal.id,
            credit: 155,
            price: 4500,
            total_value: 4000
        }
        response.body.should have_content('Proposal Updated Successfully')
      end
    end
  end

  describe '#show' do
    context 'when seller want to see any proposal' do
      it 'does show the proposal' do
        request.headers.merge!(authorization: @customer.authentication_token)
        create(:proposal, buyer_id: @buyer.company.id, seller_id: @customer.company.id, trading_parcel_id: @parcel.id, price: "4000", credit: "1500")
        proposal = Proposal.last
        put :show, params: {id: proposal.id}
        response.success?.should be true
        assigns(:data)[:status].should eq('new_proposal')
      end
    end

    context 'when buyer want to see any proposal' do
      it 'does show the proposal' do
        request.headers.merge!(authorization: @buyer.authentication_token)
        create(:proposal, buyer_id: @buyer.company.id, seller_id: @customer.company.id, trading_parcel_id: @parcel.id, price: "4000", credit: "1500")
        proposal = Proposal.last
        put :show, params: {id: proposal.id}
        response.success?.should be true
      end
    end

    context 'when want to see negotiated proposal' do
      it 'does show negotiated proposals' do
        request.headers.merge!(authorization: @buyer.authentication_token)
        create(:proposal, buyer_id: @buyer.company.id, seller_id: @customer.company.id, trading_parcel_id: @parcel.id, price: "4000", credit: "1500")
        proposal = Proposal.last
        put :show, params: {id: proposal.id}
        create(:negotiation, proposal_id: proposal.id, from: 'seller')
        proposal.update_attributes(status: 'negotiated')
        request.headers.merge!(authorization: @customer.authentication_token)
        put :show, params: {id: proposal.id}
        assigns(:data)[:status].should eq('negotiated')
        response.success?.should be true
      end
    end
  end

  describe '#accept_and_decline'do
    context 'when user not authenticated and want to accept the proposal' do
      it 'does show user not authenticated' do
        create(:proposal, buyer_id: @buyer.company.id, seller_id: @customer.company.id, trading_parcel_id: @parcel.id, price: "4000", credit: "1500")
        proposal = Proposal.last
        get :accept_and_decline, params: {id: proposal.id, perform: 'reject'}
        response.body.should have_content('Not authenticated')
      end
    end

    context 'when seller accept the proposal' do
      it 'does accept proposal successfully' do
        request.headers.merge!(authorization: @customer.authentication_token)
        create(:proposal, buyer_id: @buyer.company.id, seller_id: @customer.company.id, trading_parcel_id: @parcel.id, price: "4000", credit: "1500")
        proposal = Proposal.last
        get :accept_and_decline, params: {id: proposal.id,
                                          perform: 'accept',
                                          confirm: true}
        response.body.should have_content('Proposal is accepted.')
      end
    end

    context 'when seller reject the proposal' do
      it 'does reject proposal successfully' do
        request.headers.merge!(authorization: @customer.authentication_token)
        create(:proposal, buyer_id: @buyer.company.id, seller_id: @customer.company.id, trading_parcel_id: @parcel.id, price: "4000", credit: "1500")
        proposal = Proposal.last
        get :accept_and_decline, params: {id: proposal.id,
                                          perform: 'reject',
                                          confirm: true}
        response.body.should have_content('Proposal is rejected.')
      end
    end

    context 'when seller reject the proposal without confirmation' do
      it 'does show Secure center data' do
        request.headers.merge!(authorization: @customer.authentication_token)
        create(:proposal, buyer_id: @buyer.company.id, seller_id: @customer.company.id, trading_parcel_id: @parcel.id, price: "4000", credit: "1500")
        proposal = Proposal.last
        get :accept_and_decline, params: {id: proposal.id, perform: 'accept'}
        assigns(:secure_center).should_not be nil
        assigns(:secure_center).seller_id.should eq(@customer.company_id)
        assigns(:secure_center).buyer_id.should eq(@buyer.company_id)
      end
    end

    context 'when buyer accept the proposal' do
      it 'does accept the proposal successfully' do
        request.headers.merge!(authorization: @buyer.authentication_token)
        create(:proposal,
               buyer_id: @buyer.company.id,
               seller_id: @customer.company.id,
               trading_parcel_id: @parcel.id,
               price: '4000',
               credit: '1500')

        proposal = Proposal.last
        create(:negotiation, proposal_id: proposal.id, from: 'seller')
        proposal.update_attributes(status: 'negotiated')
        get :accept_and_decline, params: {id: proposal.id,
                                          perform: 'accept',
                                          confirm: true}
        response.body.should have_content('Proposal is accepted.')
      end
    end

    context 'when buyer reject the proposal' do
      it 'does reject the proposal successfully' do
        request.headers.merge!(authorization: @buyer.authentication_token)
        create(:proposal,
               buyer_id: @buyer.company.id,
               seller_id: @customer.company.id,
               trading_parcel_id: @parcel.id,
               price: '4000',
               credit: '1500')

        proposal = Proposal.last
        create(:negotiation, proposal_id: proposal.id, from: 'seller')
        proposal.update_attributes(status: 'negotiated')
        get :accept_and_decline, params: {id: proposal.id,
                                          perform: 'reject',
                                          confirm: true}
        response.body.should have_content('Proposal is rejected.')
      end
    end

    context 'when buyer reject the proposal' do
      it 'does reject the proposal successfully' do
        request.headers.merge!(authorization: @buyer.authentication_token)
        create(:proposal,
               buyer_id: @buyer.company.id,
               seller_id: @customer.company.id,
               trading_parcel_id: @parcel.id,
               price: '4000',
               credit: '1500')

        proposal = Proposal.last
        create(:negotiation, proposal_id: proposal.id, from: 'seller')
        proposal.update_attributes(status: 'negotiated')
        get :accept_and_decline, params: {id: proposal.id,
                                          perform: 'reject',
                                          confirm: true}
        response.body.should have_content('Proposal is rejected.')
      end
    end

    context 'when buyer reject the proposal' do
      it 'does reject the proposal successfully' do
        request.headers.merge!(authorization: @buyer.authentication_token)
        create(:proposal,
               buyer_id: @buyer.company.id,
               seller_id: @customer.company.id,
               trading_parcel_id: @parcel.id,
               price: '4000',
               credit: '1500')

        proposal = Proposal.last
        create(:negotiation, proposal_id: proposal.id, from: 'seller')
        proposal.update_attributes(status: 'negotiated')
        get :accept_and_decline, params: {id: proposal.id,
                                          perform: 'reject',
                                          confirm: true}
        response.body.should have_content('Proposal is rejected.')
      end
    end

    context 'when seller accept the proposal with in credit limits' do
      it 'does accept the proposal successfully' do
        request.headers.merge!(authorization: @customer.authentication_token)
        create(:proposal,
               buyer_id: @buyer.company.id,
               seller_id: @customer.company.id,
               trading_parcel_id: @parcel.id,
               price: '4000',
               credit: '1500')
        create(:credit_limit, seller_id: @customer.company_id, buyer_id: @buyer.company_id)
        proposal = Proposal.last
        get :accept_and_decline, params: {id: proposal.id,
                                          perform: 'accept'}
        response.body.should have_content('Proposal is accepted.')
      end
    end
  end
end