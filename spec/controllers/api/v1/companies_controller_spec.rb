require 'rails_helper'
RSpec.describe Api::V1::CompaniesController do
  before(:all) do
    create_roles
    @customer = create_customer
    @trader = create_customer
    @buyer = create_buyer
    @parcel = create(:trading_parcel, customer: @customer, company: @customer.company)
  end

  before(:each) do
    request.headers.merge!(authorization: @customer.authentication_token)
    1.upto(5) do
      @parcel = create(:trading_parcel, customer: @customer, company: @customer.company)
      create(:transaction, buyer_id: @buyer.company_id,
             seller_id: @customer.company_id,
             trading_parcel_id: @parcel.id,
             diamond_type: 'polished')
    end
    1.upto(5) do
      @parcel = create(:trading_parcel, customer: @customer, company: @customer.company)
      create(:transaction, buyer_id: @buyer.company_id,
             seller_id: @customer.company_id,
             trading_parcel_id: @parcel.id,
             diamond_type: 'Rough')
    end

  end

  # describe '#live_monitering' do
  #   context 'when secure center already exists' do
  #     it 'does fetch secure center data' do
  #       get 'live_monitoring', params: {id: @buyer.company_id}
  #       expect(@secure_center).should equal?(seller_id: @customer.company_id,
  #                                            buyer_id: @buyer.company_id)
  #       expect(response.status).to eq(200)
  #     end
  #   end
  #
  #   context 'when secure center not already exists' do
  #     it 'does create secure center and return secure center data' do
  #       get 'live_monitoring', params: {id: @buyer.company_id}
  #       expect(@secure_center).should equal?(seller_id: @customer.company_id,
  #                                            buyer_id: @buyer.company_id)
  #       expect(response.status).to eq(200)
  #     end
  #   end
  # end
  #
  # describe '#history' do
  #   context 'when fetch history without any params' do
  #     it 'does show all history' do
  #       rough = Transaction.where(seller_id: @customer.company_id, buyer_id: @buyer.company_id, diamond_type: 'Rough')
  #       polished = Transaction.where(seller_id: @customer.company_id, buyer_id: @buyer.company_id, diamond_type: 'Polished')
  #       get 'history'
  #       assigns[:all_rough_transaction].size.should eq(rough.size)
  #       assigns[:all_rough_transaction].size.should eq(polished.size)
  #     end
  #   end
  #
  #   context 'when fetch history with type rough' do
  #     it 'does show only Rough history' do
  #       transactions = Transaction.where(seller_id: @customer.company_id, buyer_id: @buyer.company_id, diamond_type: 'Rough')
  #       get 'history', params: {type: 'rough'}
  #       assigns[:transactions].flatten.size.should eq(transactions.size)
  #       transactions.last.update_attributes(diamond_type: 'Polished')
  #       get 'history', params: {type: 'rough'}
  #       new_tran = Transaction.where(seller_id: @customer.company_id, buyer_id: @buyer.company_id, diamond_type: 'Rough')
  #       assigns[:transactions].flatten.size.should eq(new_tran.size)
  #     end
  #   end
  #
  #   context 'When fetch history with Type rough and activity bought' do
  #     it 'does show bought transaction where diamond type is Rough' do
  #       transaction = Transaction.find_by(seller_id: @customer.company_id, buyer_id: @buyer.company_id, diamond_type: 'Rough')
  #       get 'history', params: {type: 'rough', activity: 'bought'}
  #       bought_transactions = Transaction.where(buyer_id: @customer.company_id, seller_id: @buyer.company_id, diamond_type: 'Rough').size
  #       assigns[:transactions].flatten.size.should eq(bought_transactions)
  #       transaction.update_attributes(seller_id: @buyer.company_id, buyer_id: @customer.company_id, diamond_type: 'Rough')
  #       get 'history', params: {type: 'rough', activity: 'bought'}
  #       bought_transactions = Transaction.where(buyer_id: @customer.company_id, seller_id: @buyer.company_id, diamond_type: 'Rough').size
  #       assigns[:transactions].flatten.size.should eq(bought_transactions)
  #     end
  #   end
  #
  #   context 'When fetch history with Type rough and activity sold' do
  #     it 'does show bought transaction where diamond type is sold' do
  #       transaction = Transaction.find_by(seller_id: @customer.company_id, buyer_id: @buyer.company_id, diamond_type: 'Rough')
  #       get 'history', params: {type: 'rough', activity: 'sold'}
  #       sold_transactions = Transaction.where(seller_id: @customer.company_id, buyer_id: @buyer.company_id, diamond_type: 'Rough').size
  #       assigns[:transactions].flatten.size.should eq(sold_transactions)
  #       transaction.update_attributes(buyer_id: @customer.company_id, seller_id: @buyer.company_id, diamond_type: 'Rough')
  #       get 'history', params: {type: 'rough', activity: 'sold'}
  #       sold_transactions = Transaction.where(seller_id: @customer.company_id, buyer_id: @buyer.company_id, diamond_type: 'Rough').size
  #       assigns[:transactions].flatten.size.should eq(sold_transactions)
  #     end
  #   end
  #
  #   context 'When fetch history with Type rough and activity sold status pending' do
  #     it 'does show bought transaction where diamond type is sold and status pending' do
  #       transactions = Transaction.where(seller_id: @customer.company_id, buyer_id: @buyer.company_id, diamond_type: 'Rough')
  #       get 'history', params: {type: 'rough', activity: 'sold', status: 'pending'}
  #       pending = transactions.where('due_date > ? AND paid= ?', Date.current, false).size
  #       assigns[:transactions].flatten.size.should eq(pending)
  #       transactions.last.update_attributes(due_date: (Date.current - 30.days))
  #       get 'history', params: {type: 'rough', activity: 'sold', status: 'pending'}
  #       pending = transactions.where('due_date > ? AND paid= ?', Date.current, false).size
  #       assigns[:transactions].flatten.size.should eq(pending)
  #     end
  #   end
  #
  #   context 'When fetch history with Type rough and activity sold status overdue' do
  #     it 'does show bought transaction where diamond type is sold and status overdue' do
  #       transactions = Transaction.where(seller_id: @customer.company_id, buyer_id: @buyer.company_id, diamond_type: 'Rough')
  #       get 'history', params: {type: 'rough', activity: 'sold', status: 'overdue'}
  #       overdue = transactions.where("due_date < ? && paid = ? && buyer_confirmed = true", Date.current, false).size
  #       assigns[:transactions].flatten.size.should eq(overdue)
  #       transactions.last.update_attributes(due_date: (Date.current - 30.days))
  #       get 'history', params: {type: 'rough', activity: 'sold', status: 'overdue'}
  #       overdue = transactions.where("due_date < ? && paid = ? && buyer_confirmed = true", Date.current, false).size
  #       assigns[:transactions].flatten.size.should eq(overdue)
  #     end
  #   end
  #
  #   context 'When fetch history with Type rough and activity sold status completed' do
  #     it 'does show bought transaction where diamond type is sold and status completed' do
  #       transactions = Transaction.where(seller_id: @customer.company_id, buyer_id: @buyer.company_id, diamond_type: 'Rough')
  #       get 'history', params: {type: 'rough', activity: 'sold', status: 'completed'}
  #       overdue = transactions.where("paid = ?", true).size
  #       assigns[:transactions].flatten.size.should eq(overdue)
  #       transactions.last.update_attributes(paid: true)
  #       get 'history', params: {type: 'rough', activity: 'sold', status: 'completed'}
  #       overdue = transactions.where("paid = ?", true).size
  #       assigns[:transactions].flatten.size.should eq(overdue)
  #     end
  #   end
  #
  #   context 'when fetch history with type polished' do
  #     it 'does show only polished history' do
  #       transactions = Transaction.where(seller_id: @customer.company_id, buyer_id: @buyer.company_id, diamond_type: 'polished')
  #       get 'history', params: {type: 'polished'}
  #       assigns[:transactions].flatten.size.should eq(transactions.size)
  #       transactions.last.update_attributes(diamond_type: 'rough')
  #       get 'history', params: {type: 'polished'}
  #       new_tran = Transaction.where(seller_id: @customer.company_id, buyer_id: @buyer.company_id, diamond_type: 'polished')
  #       assigns[:transactions].flatten.size.should eq(new_tran.size)
  #     end
  #   end
  #
  #   context 'When fetch history with Type polished and activity bought' do
  #     it 'does show bought transaction where diamond type is polished' do
  #       transaction = Transaction.find_by(seller_id: @customer.company_id, buyer_id: @buyer.company_id, diamond_type: 'Polished')
  #       get 'history', params: {type: 'polished', activity: 'bought'}
  #       bought_transactions = Transaction.where(buyer_id: @customer.company_id, seller_id: @buyer.company_id, diamond_type: 'Polished').size
  #       assigns[:transactions].flatten.size.should eq(bought_transactions)
  #       transaction.update_attributes(seller_id: @buyer.company_id, buyer_id: @customer.company_id, diamond_type: 'Polished')
  #       get 'history', params: {type: 'polished', activity: 'bought'}
  #       bought_transactions = Transaction.where(buyer_id: @customer.company_id, seller_id: @buyer.company_id, diamond_type: 'Polished').size
  #       assigns[:transactions].flatten.size.should eq(bought_transactions)
  #     end
  #   end
  #
  #   context 'When fetch history with Type polished and activity sold' do
  #     it 'does show bought transaction where diamond type polished and activity sold' do
  #       transaction = Transaction.find_by(seller_id: @customer.company_id, buyer_id: @buyer.company_id, diamond_type: 'Polished')
  #       get 'history', params: {type: 'polished', activity: 'sold'}
  #       sold_transactions = Transaction.where(seller_id: @customer.company_id, buyer_id: @buyer.company_id, diamond_type: 'Polished').size
  #       assigns[:transactions].flatten.size.should eq(sold_transactions)
  #       transaction.update_attributes(buyer_id: @customer.company_id, seller_id: @buyer.company_id, diamond_type: 'Polished')
  #       get 'history', params: {type: 'polished', activity: 'sold'}
  #       sold_transactions = Transaction.where(seller_id: @customer.company_id, buyer_id: @buyer.company_id, diamond_type: 'Polished').size
  #       assigns[:transactions].flatten.size.should eq(sold_transactions)
  #     end
  #   end
  #
  #   context 'When fetch history with Type polished and activity sold status pending' do
  #     it 'does show bought transaction where diamond type polished, activity is sold and status pending' do
  #       transactions = Transaction.where(seller_id: @customer.company_id, buyer_id: @buyer.company_id, diamond_type: 'Polished')
  #       get 'history', params: {type: 'polished', activity: 'sold', status: 'pending'}
  #       pending = transactions.where('due_date > ? AND paid= ?', Date.current, false).size
  #       assigns[:transactions].flatten.size.should eq(pending)
  #       transactions.last.update_attributes(due_date: (Date.current - 30.days))
  #       get 'history', params: {type: 'polished', activity: 'sold', status: 'pending'}
  #       pending = transactions.where('due_date > ? AND paid= ?', Date.current, false).size
  #       assigns[:transactions].flatten.size.should eq(pending)
  #     end
  #   end
  #
  #   context 'When fetch history with Type polished and activity sold status overdue' do
  #     it 'does show bought transaction where diamond type polished, activity is sold and status overdue' do
  #       transactions = Transaction.where(seller_id: @customer.company_id, buyer_id: @buyer.company_id, diamond_type: 'Polished')
  #       get 'history', params: {type: 'polished', activity: 'sold', status: 'overdue'}
  #       overdue = transactions.where("due_date < ? && paid = ? && buyer_confirmed = true", Date.current, false).size
  #       assigns[:transactions].flatten.size.should eq(overdue)
  #       transactions.last.update_attributes(due_date: (Date.current - 30.days))
  #       get 'history', params: {type: 'polished', activity: 'sold', status: 'overdue'}
  #       overdue = transactions.where("due_date < ? && paid = ? && buyer_confirmed = true", Date.current, false).size
  #       assigns[:transactions].flatten.size.should eq(overdue)
  #     end
  #   end
  #
  #   context 'When fetch history with Type polished and activity sold status completed' do
  #     it 'does show bought transaction where diamond type polished, activity is sold and status completed' do
  #       transactions = Transaction.where(seller_id: @customer.company_id, buyer_id: @buyer.company_id, diamond_type: 'Polished')
  #       get 'history', params: {type: 'polished', activity: 'sold', status: 'completed'}
  #       overdue = transactions.where("paid = ?", true).size
  #       assigns[:transactions].flatten.size.should eq(overdue)
  #       transactions.last.update_attributes(paid: true)
  #       get 'history', params: {type: 'polished', activity: 'sold', status: 'completed'}
  #       overdue = transactions.where("paid = ?", true).size
  #       assigns[:transactions].flatten.size.should eq(overdue)
  #     end
  #   end
  # end
  #
  # describe '#invite' do
  #   context 'when unknown user invite the other company' do
  #     it 'does show message not authenticated user' do
  #       request.headers.merge!(authorization: 'asdasdasdasdasdsd')
  #       post :invite, params: {company: @buyer.company.name, county: @buyer.company.county}
  #       response.body.should have_content('Not authenticated')
  #     end
  #   end
  #
  #   context 'when authenticated user invite the other company' do
  #     it 'does show message Company is invited successfully' do
  #       post :invite, params: {company: Faker::Name.name, county: Faker::Address.country}
  #       response.body.should have_content('Company is invited successfully')
  #     end
  #   end
  # end
  #
  # describe '#send_feedback' do
  #   context 'when unknown user send feedback' do
  #     it 'does show message not authenticated user' do
  #       request.headers.merge!(authorization: 'asdasdasdasdasdsd')
  #       post :send_feedback, params: {star: Faker::Number.number(1), comment: Faker::Lorem.sentence}
  #       response.body.should have_content('Not authenticated')
  #     end
  #   end
  #
  #   context 'when authenticated user send feedback' do
  #     it 'does show message Feedback is submitted successfully' do
  #       post :send_feedback, params: {star: Faker::Number.number(1), comment: Faker::Lorem.sentence}
  #       response.body.should have_content('Feedback is submitted successfully')
  #     end
  #   end
  # end

  describe "#send_security_data_request" do
    # context "when unauthenticated Trader want try to send request to buyer" do
    #   it 'does show user is not authenticated' do
    #     request.headers.merge!(authorization: 'unknown user')
    #     post :send_security_data_request, params: {receiver_id: @buyer.company_id}
    #     response.body.should have_content('Not authenticated')
    #   end
    # end

    context "when authenticated trader want try to send request to buyer" do
      it 'does show request sent successfully' do
        post :send_security_data_request, params: {receiver_id: @buyer.company_id}
        response.body.should have_content('Request send successfully.')
      end
    end
    #
    # context "when authenticated trader want try to send request to trader" do
    #   it 'does show request sent successfully' do
    #     post :send_security_data_request, params: {receiver_id: @trader.company_id}
    #     response.body.should have_content('Request send successfully.')
    #   end
    # end
  end
end