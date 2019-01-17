require 'rails_helper'
RSpec.describe Api::V1::ProposalsController do
  before(:all) do
    create_roles
    @customer = create_customer
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

  describe '#negotiate' do
    context 'when seller negotiate proposal without authenticated token' do
      it 'does not authenticated' do
        create(:proposal,
               buyer_id: @buyer.company.id,
               seller_id: @customer.company.id,
               trading_parcel_id: @parcel.id,
               price: '4000',
               credit: '1500')
        proposal = Proposal.last
        post :negotiate, params: {
                price: 200.0,
                credit: 60,
                comment: '',
                total_value: 11000.0,
                percent: 0.0,
                confirm: true,
                id: proposal.id
        }
        response.body.should have_content('Not authenticated')
      end
    end

    context 'when seller negotiate proposal' do
      it 'does proposal negotiated successfully' do
        request.headers.merge!(authorization: @customer.authentication_token)
        request.content_type = 'application/json'
        create(:proposal,
               buyer_id: @buyer.company.id,
               seller_id: @customer.company.id,
               trading_parcel_id: @parcel.id,
               price: '4000',
               credit: '1500')
        proposal = Proposal.last
        post :negotiate, params: {
            price: 200.0,
            credit: 60,
            comment: '',
            total_value: 11000.0,
            percent: 0.0,
            confirm: true,
            id: proposal.id
        }
        expect(response.success?).to be true
        response.body.should have_content('Proposal is negotiated successfully.')
        expect(response.status).to eq(200)
      end
    end

    context 'when seller negotiate proposal if already exit' do
      it 'does proposal will be updated' do
        request.headers.merge!(authorization: @customer.authentication_token)
        request.content_type = 'application/json'
        create(:proposal,
               buyer_id: @buyer.company.id,
               seller_id: @customer.company.id,
               trading_parcel_id: @parcel.id,
               price: '4000',
               credit: '1500')
        proposal = Proposal.last
        create(:negotiation, proposal_id: proposal.id, from: 'seller')
        post :negotiate, params: {
            price: 200.0,
            credit: 60,
            comment: '',
            total_value: 11000.0,
            percent: 0.0,
            confirm: true,
            id: proposal.id
        }
        response.body.should have_content('Proposal is updated successfully.')
        expect(response.status).to eq(200)
        expect(response.success?).to be true
      end
    end

    context 'when seller negotiate proposal if already exit' do
      it 'does proposal negotiated updated' do
        request.headers.merge!(authorization: @customer.authentication_token)
        request.content_type = 'application/json'
        create(:proposal,
               buyer_id: @buyer.company.id,
               seller_id: @customer.company.id,
               trading_parcel_id: @parcel.id,
               price: '4000',
               credit: '1500')
        proposal = Proposal.last
        create(:negotiation, proposal_id: proposal.id, from: 'seller')
        negotiation = Negotiation.last
        post :negotiate, params: {
            price: 200.0,
            credit: 60,
            comment: '',
            total_value: 11000.0,
            percent: 0.0,
            confirm: true,
            negotiation_id: negotiation.id,
            id: proposal.id
        }
        response.body.should have_content('Negotiation is updated successfully.')
        expect(response.status).to eq(200)
        expect(response.success?).to be true
      end
    end

    context 'when seller negotiate proposal first time' do
      it 'does check credit limits' do
        request.headers.merge!(authorization: @customer.authentication_token)
        request.content_type = 'application/json'
        create(:proposal,
               buyer_id: @buyer.company.id,
               seller_id: @customer.company.id,
               trading_parcel_id: @parcel.id,
               price: '4000',
               credit: '1500')
        proposal = Proposal.last
        create(:credit_limit, seller_id: @customer.company_id, buyer_id: @buyer.company_id)
        post :negotiate, params: {
            price: 200.0,
            credit: 60,
            comment: '',
            total_value: 11000.0,
            percent: 0.0,
            id: proposal.id
        }
        response.body.should have_content('Proposal is negotiated successfully.')
        response.status.should be 200
        response.success?.should be true
      end
    end
    context 'when seller negotiate already accepted proposal' do
      it 'does show error message ' do
        request.headers.merge!(authorization: @customer.authentication_token)
        request.content_type = 'application/json'
        create(:proposal,
               buyer_id: @buyer.company.id,
               seller_id: @customer.company.id,
               trading_parcel_id: @parcel.id,
               price: '4000',
               credit: '1500',
               status: 'accepted')
        proposal = Proposal.last
        create(:negotiation, proposal_id: proposal.id, from: 'seller')
        negotiation = Negotiation.last
        post :negotiate, params: {
            price: 200.0,
            credit: 60,
            comment: '',
            total_value: 11000.0,
            percent: 0.0,
            negotiation_id: negotiation.id,
            id: proposal.id
        }
        response.body.should have_content('It is proceeded, So Now you can not update it.')
      end
    end

  end
end