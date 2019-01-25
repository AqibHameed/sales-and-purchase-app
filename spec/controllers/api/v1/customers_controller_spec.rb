require 'rails_helper'
RSpec.describe Api::V1::CustomersController do
  before(:all) do
    create_roles
    @customer = create_customer
    # @com_id = @customer.company.id
    @buyer = create_buyer
    @broker = create_broker
    @parcel = create(:trading_parcel, customer: @customer, company: @customer.company)
    create(:credit_limit, buyer_id: @buyer.company_id, seller_id:  @customer.company_id )
    create(:transaction, buyer_id: @buyer.company_id,
           seller_id: @customer.company_id,
           trading_parcel_id: @parcel.id,
           due_date: Date.current + 12,
           created_at: 10.days.ago,
           paid: false,
           credit:0
    )
    create(:transaction, buyer_id: @buyer.company_id,
           seller_id: @customer.company_id,
           trading_parcel_id: @parcel.id,
           due_date: Date.current - 12,
           created_at: 10.days.ago,
           paid: false,
           credit:0
    )
    create(:transaction, buyer_id: @buyer.company_id,
           seller_id: @customer.company_id,
           trading_parcel_id: @parcel.id,
           created_at: 10.days.ago,
           paid: true,
           credit:0
    )
    create(:transaction, buyer_id: @buyer.company_id,
           seller_id: @customer.company_id,
           trading_parcel_id: @parcel.id,
           due_date: Date.current + 12,
           created_at: 10.days.ago,
           paid: false,
           credit: 20
    )
    create(:transaction, buyer_id: @buyer.company_id,
           seller_id: @customer.company_id,
           trading_parcel_id: @parcel.id,
           due_date: Date.current - 12,
           created_at: 10.days.ago,
           paid: false,
           credit: 20
    )
    create(:transaction, buyer_id: @buyer.company_id,
           seller_id: @customer.company_id,
           trading_parcel_id: @parcel.id,
           created_at: 10.days.ago,
           paid: true,
           credit:20
    )
  end
  before(:each) do
    request.headers.merge!(authorization: @customer.authentication_token)
    1.upto(5) do
      create(:transaction, buyer_id: @buyer.company_id,
             seller_id: @customer.company_id,
             trading_parcel_id: @parcel.id,
             due_date: Date.current + 30,
             created_at: 10.days.ago,
             paid: true
      )
    end

    1.upto(5) do
      create(:transaction, buyer_id: @buyer.company_id,
             seller_id: @customer.company_id,
             trading_parcel_id: @parcel.id,
             due_date: Date.current + 30,
             created_at: 10.days.ago,
             paid: false
      )
    end
  end
  describe '#access_tiles' do
    context 'when unauhorized user want to access the api' do
      it 'does show Not Authenticated ' do
        request.headers.merge!(authorization: 'unknown_token')
        get :access_tiles, params: {tab: 'history'}
        response.body.should have_content('Not authenticated')
      end
    end

  #
    context 'when authorized Trader want to access the api' do
      it 'does count increase of related tab' do
        get :access_tiles, params: {tab: 'history'}
        expect(JSON.parse(response.body)['messages'].first['History']).to eq(true)
        expect(JSON.parse(response.body)['messages'].first['count']).to eq(@customer.tiles_count.history)
      end
    end

    context 'when authorized Trader want to access the api' do
      it 'does count increase of related tab' do
        get :access_tiles, params: {tab: 'record_sale'}
        expect(JSON.parse(response.body)['messages'].first['Record Sale']).to eq(true)
        expect(JSON.parse(response.body)['messages'].first['count']).to eq(1)
      end
    end
  #
    context 'when authorized broker want to access the api' do
      it 'does count increase of related tab' do
        get :access_tiles, params: {tab: 'sell'}
        expect(JSON.parse(response.body)['messages'].first['Sell']).to eq(true)
        expect(JSON.parse(response.body)['messages'].first['count']).to eq(1)
      end
    end
  #
    context 'when authorized broker want to access the api' do
      it 'does count increase of related tab' do
        request.headers.merge!(authorization: @broker.authentication_token)
        get :access_tiles, params: {tab: 'upcoming_tenders'}
        expect(JSON.parse(response.body)['messages'].first['Upcoming Tenders']).to eq(true)
        expect(JSON.parse(response.body)['messages'].first['count']).to eq(@broker.tiles_count.upcoming_tenders)
      end
    end
  #
    context 'when authorized buyer want to access the api' do
      it 'does count increase of related tab' do
        request.headers.merge!(authorization: @buyer.authentication_token)
        request.content_type = 'application/json'
        get :access_tiles, params: {tab: 'history'}
        expect(JSON.parse(response.body)['messages'].first['History']).to eq(true)
        expect(JSON.parse(response.body)['messages'].first['count']).to eq(@buyer.tiles_count.history)
       end
    end
  end


  describe '#info' do
    context 'when not permit user want to access the info api' do
      it 'does show Not company_not_exist ' do
        get :info
        response.body.should have_content('company id not exist')
      end
    end
    #
    context 'when permited user want to access the info api' do
      it 'does show permissons are not allowed ' do
        get :info, params: {receiver_id: 12}
        response.body.should have_content('permission Access denied')
      end
    end

    # context 'when unauthorized user want to access the info api' do
    #   it 'does show un-authoruized user ' do
    #     # request.headers.merge!(authorization: 'unknown_token_laylo')
    #     get :info, params: {receiver_id: @customer.company.id}
    #    response.body.should have_content('Not authenticated')
    #   end
    # end

    context 'when authorized user want to access the info api' do
      it 'does check total transection of currunt customer' do
        transactions = Transaction.where(seller_id: @customer.company_id, buyer_id: @buyer.company_id)
        get :info , params:{receiver_id: @customer.company.id}
       expect(JSON.parse(response.body)['transactions']['total']).to eq(transactions.size)
      end
    end
    #
    context 'when authorized user want to access the info api' do
      it 'does check pending transection of current customer' do
        transactions = Transaction.where(seller_id: @customer.company_id, buyer_id: @buyer.company_id)
        get :info , params:{receiver_id: @customer.company.id}
        pending = transactions.where('due_date > ? AND paid= ?', Date.current, false).size
        expect(JSON.parse(response.body)['transactions']['pending']).to eq(pending  )
      end
    end

    context 'when authorized user want to access the info api' do
      it 'does check overdue transection of current customer' do
        transactions = Transaction.where(seller_id: @customer.company_id, buyer_id: @buyer.company_id)
        get :info , params:{receiver_id: @customer.company.id}
        overdue = transactions.where('due_date < ? AND paid= ?', Date.current, false).size
        expect(JSON.parse(response.body)['transactions']['overdue']).to eq(overdue)
      end
    end

    context 'when authorized user want to access the info api' do
      it 'does check completed transection of current customer' do
        transactions = Transaction.where(seller_id: @customer.company_id, buyer_id: @buyer.company_id, paid: true)
        get :info , params:{receiver_id: @customer.company.id}
        expect(JSON.parse(response.body)['transactions']['completed']).to eq(transactions.size)
      end
    end

    context 'when authorized user want to access the info api' do
      it 'does check completed transection of current customer' do
        transactions = Transaction.where(seller_id: @customer.company_id, buyer_id: @buyer.company_id, paid: true)
        get :info , params:{receiver_id: @customer.company.id}
        expect(JSON.parse(response.body)['transactions']['completed']).to eq(transactions.size)
      end
    end

    context 'when authorized user want to access the info api' do
      it 'does check credit_given_to of sales of current customer(saller)' do
        credit_limit = CreditLimit.where(seller_id: @customer.company_id)
        get :info , params:{receiver_id: @customer.company.id}
        expect(JSON.parse(response.body)['sales']['credit_given_to']).to eq(credit_limit.size)
      end
    end

    context 'when authorized user want to access the info api' do
      it 'does check credit_given_to of sales of current customer(saller)' do
        credit_given = CreditLimit.where(seller_id: @customer.company_id).sum(:credit_limit)
        get :info , params:{receiver_id: @customer.company.id}
        expect(JSON.parse(response.body)['sales']['total_given_credit'].to_i).to eq(credit_given)
      end
    end

    context 'when authorized user want to access the info api' do
      it 'does check total_used_credit of sales of current customer(saller)' do

        used_credit = Transaction.where(seller_id: @customer.company.id).sum(:remaining_amount)
        get :info , params:{receiver_id: @customer.company.id}
        expect(JSON.parse(response.body)['sales']['total_used_credit'].to_i).to eq(used_credit.to_i)
      end
    end

    context 'when authorized user want to access the info api' do
      it 'does check total_available_credit of sales of current customer(saller)' do

        credit_given = CreditLimit.where(seller_id: @customer.company_id).sum(:credit_limit)
        used_credit = Transaction.where(seller_id: @customer.company.id).sum(:remaining_amount)
        available_credit = credit_given - used_credit
        get :info , params:{receiver_id: @customer.company.id}
        expect(JSON.parse(response.body)['sales']['total_available_credit']).to eq(number_to_currency(available_credit))
      end
    end

    context 'when authorized user want to access the info api' do
      it 'does check credit_recieved_count of purchases of current customer(buyer)' do
        request.headers.merge!(authorization: @buyer.authentication_token)
        credit_limit = CreditLimit.where(buyer_id: @buyer.company_id)
        get :info , params:{receiver_id: @buyer.company.id}
        expect(JSON.parse(response.body)['purchases']['credit_recieved_count']).to eq(credit_limit.size)
      end
    end

    context 'when authorized user want to access the info api' do
      it 'does check total_credit_received of purchases of current customer(buyer)' do
        request.headers.merge!(authorization: @buyer.authentication_token)
        credit_given = CreditLimit.where(buyer_id: @buyer.company_id).sum(:credit_limit)
        get :info , params:{receiver_id: @buyer .company.id}
        expect(JSON.parse(response.body)['purchases']['total_credit_received']).to eq(number_to_currency(credit_given))
      end
    end

    context 'when authorized user want to access the info api' do
      it 'does check total_pending sales of current customer(saller) when condition == 0' do

        total_pending = Transaction.where("seller_id = ? AND due_date >= ? AND paid = ? AND buyer_confirmed = ?", @customer.company_id, Date.current, false, true).sum(:total_amount)
        pending = Transaction.where("seller_id = ? AND due_date >= ? AND paid = ? AND buyer_confirmed = ? AND credit = ?", @customer.company.id, Date.current, false, true, 0).sum(:total_amount)
        pending_percent = ((pending / total_pending.to_f) * 100).to_i rescue 0
        final = "#{number_to_currency(pending)}(#{pending_percent}%)"
        get :info, params: {receiver_id: @customer.company.id}
        expect(JSON.parse(response.body)['sales']['sales'].first['pending_transaction']).to eq(final)

    end
    end


    context 'when authorized user want to access the info api' do
        it 'does check total_overdue  sales of current customer(saller) when condition == 0' do

        total_overdue = Transaction.includes(:trading_parcel).where("seller_id = ? AND due_date < ? AND paid = ? AND buyer_confirmed = ?", @customer.company_id, Date.current, false, true).sum(:total_amount)
        overdue = Transaction.where("seller_id =? AND due_date < ? AND paid = ? AND buyer_confirmed = ? AND credit = ?", @customer.company.id, Date.current, false, true, 0).sum(:total_amount)
        overdue_percent = ((overdue / total_overdue.to_f) * 100).to_i rescue 0
        final = "#{number_to_currency(overdue)}(#{overdue_percent}%)"
        get :info, params: {receiver_id: @customer.company.id}
        expect(JSON.parse(response.body)['sales']['sales'].first['overdue_transaction']).to eq(final)

      end
    end


    context 'when authorized user want to access the info api' do
      it 'does check total_complete sales of current customer(saller) when condition == 0' do

        total_complete = Transaction.includes(:trading_parcel).where("seller_id = ? AND paid = ? AND buyer_confirmed = ?", @customer.company_id, true, true).sum(:total_amount)
        complete = Transaction.where("seller_id = ? AND paid = ? AND buyer_confirmed = ? AND credit = ?", @customer.company.id, true, true, 0).sum(:total_amount)
        complete_percent = ((complete / total_complete.to_f) * 100).to_i rescue 0
        final = "#{number_to_currency(complete)}(#{complete_percent}%)"
        get :info, params: {receiver_id: @customer.company.id}
        expect(JSON.parse(response.body)['sales']['sales'].first['complete_transaction']).to eq(final)

      end
    end

    context 'when authorized user want to access the info api' do
      it 'does check total_amount_given sales of current customer(saller) when condition == 0' do
        credit_given = Transaction.where('seller_id =?', @customer.company.id).count
        count = Transaction.where('credit = ? and seller_id =?', 0, @customer.company.id).count
        count_percent = ((count/credit_given.to_f)*100).to_i rescue 0

        final = "#{count}(#{count_percent}%)"
        get :info, params: {receiver_id: @customer.company.id}
        expect(JSON.parse(response.body)['sales']['sales'].first['percent']).to eq(final)

      end
    end





    context 'when authorized user want to access the info api' do
      it 'does check total_pending sales of current customer(saller) when condition >0' do

        total_pending = Transaction.where("seller_id = ? AND due_date >= ? AND paid = ? AND buyer_confirmed = ?", @customer.company_id, Date.current, false, true).sum(:total_amount)
        pending = Transaction.where("seller_id = ? AND due_date >= ? AND paid = ? AND buyer_confirmed = ? AND credit >= ? and credit <= ?", @customer.company.id, Date.current, false, true, 1, 30).sum(:total_amount)
        pending_percent = (( pending / total_pending.to_f) * 100).to_i rescue 0
        final = "#{number_to_currency(pending)}(#{pending_percent}%)"
        get :info, params: {receiver_id: @customer.company.id}
        expect(JSON.parse(response.body)['sales']['sales'].second['pending_transaction']).to eq(final)

    end
    end


    context 'when authorized user want to access the info api' do
        it 'does check total_overdue  sales of current customer(saller) when condition > 0' do

        total_overdue = Transaction.includes(:trading_parcel).where("seller_id = ? AND due_date < ? AND paid = ? AND buyer_confirmed = ?", @customer.company_id, Date.current, false, true).sum(:total_amount)
        overdue = Transaction.where("seller_id =? AND due_date < ? AND paid = ? AND buyer_confirmed = ? AND credit >= ? and credit <= ?", @customer.company.id, Date.current, false, true, 1, 30).sum(:total_amount)

        overdue_percent = ((overdue / total_overdue.to_f) * 100).to_i rescue 0
        final = "#{number_to_currency(overdue)}(#{overdue_percent}%)"
        get :info, params: {receiver_id: @customer.company.id}
        expect(JSON.parse(response.body)['sales']['sales'].second['overdue_transaction']).to eq(final)

      end
    end
    #

    context 'when authorized user want to access the info api' do
      it 'does check total_complete sales of current customer(saller) when condition > 0' do

        total_complete = Transaction.includes(:trading_parcel).where("seller_id = ? AND paid = ? AND buyer_confirmed = ?", @customer.company_id, true, true).sum(:total_amount)
        complete = Transaction.where("seller_id = ? AND paid = ? AND buyer_confirmed = ? AND credit >= ? and credit <= ?", @customer.company.id, true, true,1,30).sum(:total_amount)
        complete_percent = ((complete / total_complete.to_f) * 100).to_i rescue 0
        final = "#{number_to_currency(complete)}(#{complete_percent}%)"
        get :info, params: {receiver_id: @customer.company.id}
        expect(JSON.parse(response.body)['sales']['sales'].second['complete_transaction']).to eq(final)

      end
    end

    context 'when authorized user want to access the info api' do
      it 'does check total_amount_given sales of current customer(saller) when condition >0' do

        credit_given = Transaction.where('seller_id =?', @customer.company.id).count
        count = Transaction.where('credit >=   ? and credit <= ? and seller_id =?', 1, 30, @customer.company.id).count

        count_percent = ((count/credit_given.to_f)*100).to_i rescue 0
        final = "#{count}(#{count_percent}%)"
        get :info, params: {receiver_id: @customer.company.id}
        expect(JSON.parse(response.body)['sales']['sales'].second['percent']).to eq(final)

      end
    end



  end
end