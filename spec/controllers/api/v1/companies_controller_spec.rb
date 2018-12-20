require 'rails_helper'
RSpec.describe Api::V1::CompaniesController do
  before(:all) do
    company = Company.create(name: Faker::Name.name)
    @customer = Customer.create(first_name: FFaker::Name.first_name, last_name: FFaker::Name.last_name, email: FFaker::Internet.email,
                                password: FFaker::DizzleIpsum.words(4).join('!').first(8), mobile_no: Faker::PhoneNumber.phone_number,
                                role: "Buyer/Seller", confirmed_at: Time.current, company: company, authentication_token: Devise.friendly_token)
    create(:customer_role, customer: @customer)
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
  describe '#live_monitering' do
    context 'when secure center already exists' do
      it 'does fetch secure center data' do
        get 'live_monitoring', params: {id: @buyer.company_id}
        expect(@secure_center).should equal?(seller_id: @customer.company_id,
                                             buyer_id: @buyer.company_id)
        expect(response.status).to eq(200)
      end
    end

    context 'when secure center not already exists' do
      it 'does create secure center and return secure center data' do
        get 'live_monitoring', params: {id: @buyer.company_id}
        expect(@secure_center).should equal?(seller_id: @customer.company_id,
                                             buyer_id: @buyer.company_id)
        expect(response.status).to eq(200)
      end
    end
  end
  describe '#history' do
    context 'when fetch history without any params' do
      it 'does show all history' do
        rough = Transaction.where(seller_id: @customer.company_id, buyer_id: @buyer.company_id, diamond_type: 'Rough')
        polished = Transaction.where(seller_id: @customer.company_id, buyer_id: @buyer.company_id, diamond_type: 'Polished')
        get 'history'
        assigns[:all_rough_transaction].size.should eq(rough.size)
        assigns[:all_rough_transaction].size.should eq(polished.size)
      end
    end
    context 'when fetch history with type rough' do
      it 'does show only Rough history' do
        transactions = Transaction.where(seller_id: @customer.company_id, buyer_id: @buyer.company_id, diamond_type: 'Rough')
        get 'history', params: {type: 'rough'}
        assigns[:transactions].flatten.size.should eq(transactions.size)
        transactions.last.update_attributes(diamond_type: 'Polished')
        get 'history', params: {type: 'rough'}
        new_tran = Transaction.where(seller_id: @customer.company_id, buyer_id: @buyer.company_id, diamond_type: 'Rough')
        assigns[:transactions].flatten.size.should eq(new_tran.size)
      end
    end
    context 'When fetch history with Type rough and activity bought' do
      it 'does show bought transaction where diamond type is Rough' do
        transaction = Transaction.find_by(seller_id: @customer.company_id, buyer_id: @buyer.company_id, diamond_type: 'Rough')
        get 'history', params: {type: 'rough', activity: 'bought'}
        bought_transactions = Transaction.where(buyer_id: @customer.company_id, seller_id: @buyer.company_id, diamond_type: 'Rough').size
        assigns[:transactions].flatten.size.should eq(bought_transactions)
        transaction.update_attributes(seller_id: @buyer.company_id, buyer_id: @customer.company_id, diamond_type: 'Rough')
        get 'history', params: {type: 'rough', activity: 'bought'}
        bought_transactions = Transaction.where(buyer_id: @customer.company_id, seller_id: @buyer.company_id, diamond_type: 'Rough').size
        assigns[:transactions].flatten.size.should eq(bought_transactions)
      end
    end
    context 'When fetch history with Type rough and activity sold' do
      it 'does show bought transaction where diamond type is sold' do
        transaction = Transaction.find_by(seller_id: @customer.company_id, buyer_id: @buyer.company_id, diamond_type: 'Rough')
        get 'history', params: {type: 'rough', activity: 'sold'}
        sold_transactions = Transaction.where(seller_id: @customer.company_id, buyer_id: @buyer.company_id, diamond_type: 'Rough').size
        assigns[:transactions].flatten.size.should eq(sold_transactions)
        transaction.update_attributes(buyer_id: @customer.company_id, seller_id: @buyer.company_id, diamond_type: 'Rough')
        get 'history', params: {type: 'rough', activity: 'sold'}
        sold_transactions = Transaction.where(seller_id: @customer.company_id, buyer_id: @buyer.company_id, diamond_type: 'Rough').size
        assigns[:transactions].flatten.size.should eq(sold_transactions)
      end
    end
    context 'When fetch history with Type rough and activity sold status pending' do
      it 'does show bought transaction where diamond type is sold and status pending' do
        transactions = Transaction.where(seller_id: @customer.company_id, buyer_id: @buyer.company_id, diamond_type: 'Rough')
        get 'history', params: {type: 'rough', activity: 'sold', status: 'pending'}
        pending = transactions.where('due_date > ? AND paid= ?', Date.current, false).size
        assigns[:transactions].flatten.size.should eq(pending)
        transactions.last.update_attributes(due_date: (Date.current-30.days))
        get 'history', params: {type: 'rough', activity: 'sold', status: 'pending'}
        pending = transactions.where('due_date > ? AND paid= ?', Date.current, false).size
        assigns[:transactions].flatten.size.should eq(pending)
      end
    end
    context 'When fetch history with Type rough and activity sold status overdue' do
      it 'does show bought transaction where diamond type is sold and status overdue' do
        transactions = Transaction.where(seller_id: @customer.company_id, buyer_id: @buyer.company_id, diamond_type: 'Rough')
        get 'history', params: {type: 'rough', activity: 'sold', status: 'overdue'}
        overdue = transactions.where("due_date < ? && paid = ? && buyer_confirmed = true", Date.current, false).size
        assigns[:transactions].flatten.size.should eq(overdue)
        transactions.last.update_attributes(due_date: (Date.current-30.days))
        get 'history', params: {type: 'rough', activity: 'sold', status: 'overdue'}
        overdue = transactions.where("due_date < ? && paid = ? && buyer_confirmed = true", Date.current, false).size
        assigns[:transactions].flatten.size.should eq(overdue)
      end
    end
    context 'When fetch history with Type rough and activity sold status completed' do
      it 'does show bought transaction where diamond type is sold and status completed' do
        transactions = Transaction.where(seller_id: @customer.company_id, buyer_id: @buyer.company_id, diamond_type: 'Rough')
        get 'history', params: {type: 'rough', activity: 'sold', status: 'completed'}
        overdue = transactions.where("paid = ?", true).size
        assigns[:transactions].flatten.size.should eq(overdue)
        transactions.last.update_attributes(paid: true)
        get 'history', params: {type: 'rough', activity: 'sold', status: 'completed'}
        overdue = transactions.where("paid = ?", true).size
        assigns[:transactions].flatten.size.should eq(overdue)
      end
    end


    context 'when fetch history with type polished' do
      it 'does show only polished history' do
        transactions = Transaction.where(seller_id: @customer.company_id, buyer_id: @buyer.company_id, diamond_type: 'polished')
        get 'history', params: {type: 'polished'}
        assigns[:transactions].flatten.size.should eq(transactions.size)
        transactions.last.update_attributes(diamond_type: 'rough')
        get 'history', params: {type: 'polished'}
        new_tran = Transaction.where(seller_id: @customer.company_id, buyer_id: @buyer.company_id, diamond_type: 'polished')
        assigns[:transactions].flatten.size.should eq(new_tran.size)
      end
    end
    context 'When fetch history with Type polished and activity bought' do
      it 'does show bought transaction where diamond type is polished' do
        transaction = Transaction.find_by(seller_id: @customer.company_id, buyer_id: @buyer.company_id, diamond_type: 'Polished')
        get 'history', params: {type: 'polished', activity: 'bought'}
        bought_transactions = Transaction.where(buyer_id: @customer.company_id, seller_id: @buyer.company_id, diamond_type: 'Polished').size
        assigns[:transactions].flatten.size.should eq(bought_transactions)
        transaction.update_attributes(seller_id: @buyer.company_id, buyer_id: @customer.company_id, diamond_type: 'Polished')
        get 'history', params: {type: 'polished', activity: 'bought'}
        bought_transactions = Transaction.where(buyer_id: @customer.company_id, seller_id: @buyer.company_id, diamond_type: 'Polished').size
        assigns[:transactions].flatten.size.should eq(bought_transactions)
      end
    end
    context 'When fetch history with Type polished and activity sold' do
      it 'does show bought transaction where diamond type polished and activity sold' do
        transaction = Transaction.find_by(seller_id: @customer.company_id, buyer_id: @buyer.company_id, diamond_type: 'Polished')
        get 'history', params: {type: 'polished', activity: 'sold'}
        sold_transactions = Transaction.where(seller_id: @customer.company_id, buyer_id: @buyer.company_id, diamond_type: 'Polished').size
        assigns[:transactions].flatten.size.should eq(sold_transactions)
        transaction.update_attributes(buyer_id: @customer.company_id, seller_id: @buyer.company_id, diamond_type: 'Polished')
        get 'history', params: {type: 'polished', activity: 'sold'}
        sold_transactions = Transaction.where(seller_id: @customer.company_id, buyer_id: @buyer.company_id, diamond_type: 'Polished').size
        assigns[:transactions].flatten.size.should eq(sold_transactions)
      end
    end
    context 'When fetch history with Type polished and activity sold status pending' do
      it 'does show bought transaction where diamond type polished, activity is sold and status pending' do
        transactions = Transaction.where(seller_id: @customer.company_id, buyer_id: @buyer.company_id, diamond_type: 'Polished')
        get 'history', params: {type: 'polished', activity: 'sold', status: 'pending'}
        pending = transactions.where('due_date > ? AND paid= ?', Date.current, false).size
        assigns[:transactions].flatten.size.should eq(pending)
        transactions.last.update_attributes(due_date: (Date.current-30.days))
        get 'history', params: {type: 'polished', activity: 'sold', status: 'pending'}
        pending = transactions.where('due_date > ? AND paid= ?', Date.current, false).size
        assigns[:transactions].flatten.size.should eq(pending)
      end
    end
    context 'When fetch history with Type polished and activity sold status overdue' do
      it 'does show bought transaction where diamond type polished, activity is sold and status overdue' do
        transactions = Transaction.where(seller_id: @customer.company_id, buyer_id: @buyer.company_id, diamond_type: 'Polished')
        get 'history', params: {type: 'polished', activity: 'sold', status: 'overdue'}
        overdue = transactions.where("due_date < ? && paid = ? && buyer_confirmed = true", Date.current, false).size
        assigns[:transactions].flatten.size.should eq(overdue)
        transactions.last.update_attributes(due_date: (Date.current-30.days))
        get 'history', params: {type: 'polished', activity: 'sold', status: 'overdue'}
        overdue = transactions.where("due_date < ? && paid = ? && buyer_confirmed = true", Date.current, false).size
        assigns[:transactions].flatten.size.should eq(overdue)
      end
    end
    context 'When fetch history with Type polished and activity sold status completed' do
      it 'does show bought transaction where diamond type polished, activity is sold and status completed' do
        transactions = Transaction.where(seller_id: @customer.company_id, buyer_id: @buyer.company_id, diamond_type: 'Polished')
        get 'history', params: {type: 'polished', activity: 'sold', status: 'completed'}
        overdue = transactions.where("paid = ?", true).size
        assigns[:transactions].flatten.size.should eq(overdue)
        transactions.last.update_attributes(paid: true)
        get 'history', params: {type: 'polished', activity: 'sold', status: 'completed'}
        overdue = transactions.where("paid = ?", true).size
        assigns[:transactions].flatten.size.should eq(overdue)
      end
    end
  end
end