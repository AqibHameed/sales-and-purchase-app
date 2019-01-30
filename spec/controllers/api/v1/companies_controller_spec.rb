require 'rails_helper'
RSpec.describe Api::V1::CompaniesController do
  before(:all) do
    create_roles
    @customer = create_customer
    @trader = create_customer
    @buyer = create_buyer
    @permissions = {sender_id: @customer.company_id,
                    receiver_id: @buyer.company_id,
                    secure_center: true,
                    seller_score: true}
    @parcel = create(:trading_parcel, customer: @customer, company: @customer.company)
    create(:days_limit, days_limit:20 ,seller_id:@customer.company.id,  buyer_id:@buyer.company.id )

  end

  before(:each) do
    @permission_request = create_permission_request(@permissions)
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
        get 'live_monitoring', params: {receiver_id: @buyer.company_id}
        expect(@secure_center).should equal?(seller_id: @customer.company_id,
                                             buyer_id: @buyer.company_id)
        expect(response.status).to eq(200)
      end
    end

    context 'when secure center not already exists' do
      it 'does create secure center and return secure center data' do
        get 'live_monitoring', params: {receiver_id: @buyer.company_id}
        expect(@secure_center).should equal?(seller_id: @customer.company_id,
                                             buyer_id: @buyer.company_id)
        expect(response.status).to eq(200)
      end
    end

    context 'when user want to access data without permission' do
      it 'does show security center data few fields' do
        get 'live_monitoring', params: {receiver_id: @buyer.company_id}
        expect(assigns(:secure_center).seller_id).to eq(@customer.company_id)
        expect(assigns(:secure_center).buyer_id).to eq(@buyer.company_id)
        assigns(:secure_center).collection_ratio_days
        assigns(:secure_center).system_percentage
        assigns(:secure_center).buyer_percentage
      end
    end

    context 'when user want to access data with permission' do
      it 'does show security center data all fields' do
        get 'live_monitoring', params: {receiver_id: @buyer.company_id}
        expect(assigns(:secure_center).seller_id).to eq(@customer.company_id)
        expect(assigns(:secure_center).buyer_id).to eq(@buyer.company_id)
        assigns(:secure_center).collection_ratio_days
        assigns(:secure_center).system_percentage
        assigns(:secure_center).buyer_percentage
        assigns(:secure_center).supplier_paid
        assigns(:secure_center).overdue_amount
        assigns(:secure_center).invoices_overdue
        assigns(:secure_center).outstandings
        assigns(:secure_center).last_bought_on
        assigns(:credit_limit)
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
        transactions.last.update_attributes(due_date: (Date.current - 30.days))
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
        transactions.last.update_attributes(due_date: (Date.current - 30.days))
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
        transactions.last.update_attributes(due_date: (Date.current - 30.days))
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
        transactions.last.update_attributes(due_date: (Date.current - 30.days))
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

  describe '#invite' do
    context 'when unknown user invite the other company' do
      it 'does show message not authenticated user' do
        request.headers.merge!(authorization: 'asdasdasdasdasdsd')
        post :invite, params: {company: @buyer.company.name, county: @buyer.company.county}
        response.body.should have_content('Not authenticated')
      end
    end

    context 'when authenticated user invite the other company' do
      it 'does show message Company is invited successfully' do
        post :invite, params: {company: Faker::Name.name, county: Faker::Address.country}
        response.body.should have_content('Company is invited successfully')
      end
    end
  end

  describe '#send_feedback' do
    context 'when unknown user send feedback' do
      it 'does show message not authenticated user' do
        request.headers.merge!(authorization: 'asdasdasdasdasdsd')
        post :send_feedback, params: {star: Faker::Number.number(1), comment: Faker::Lorem.sentence}
        response.body.should have_content('Not authenticated')
      end
    end

    context 'when authenticated user send feedback' do
      it 'does show message Feedback is submitted successfully' do
        post :send_feedback, params: {star: Faker::Number.number(1), comment: Faker::Lorem.sentence}
        response.body.should have_content('Feedback is submitted successfully')
      end
    end
  end

  describe "#send_security_data_request" do
    context "when unauthenticated Trader want try to send request to buyer" do
      it 'does show user is not authenticated' do
        request.headers.merge!(authorization: 'unknown user')
        post :send_security_data_request, params: {receiver_id: @buyer.company_id}
        response.body.should have_content('Not authenticated')
      end
    end

    context "when authenticated trader want try to send request to buyer" do
      it 'does show request sent successfully' do
        post :send_security_data_request, params: {receiver_id: @buyer.company_id}
        response.body.should have_content('Request send successfully.')
      end
    end

    context "when authenticated trader want try to send request to trader" do
      it 'does show request sent successfully' do
        post :send_security_data_request, params: {receiver_id: @trader.company_id}
        response.body.should have_content('Request send successfully.')
      end
    end
  end

  describe "#accept_secuirty_data_request" do
    context "when unauthenticated user try to accept request" do
      it 'does show not authenticated user ' do
        request.headers.merge!(authorization: 'unknowtoken')
        post :accept_secuirty_data_request, params:{request_id: @permission_request.id}
        response.body.should have_content('Not authenticated')
      end
    end

    context "when authenticated but unknown user user try to accept request" do
      it 'does show not authenticated user ' do
        post :accept_secuirty_data_request, params:{request_id: @permission_request.id}
        response.body.should have_content("you don't have permission perform this action")
      end
    end

    context "when authenticated but unknown user user try to accept request" do
      it 'does show not authenticated user ' do
        request.headers.merge!(authorization: @buyer.authentication_token)
        post :accept_secuirty_data_request, params:{request_id: @permission_request.id}
        response.body.should have_content("Request accepted successfully.")
      end
    end
  end

  describe "#reject_secuirty_data_request" do
    context "when unauthenticated user try to reject request" do
      it 'does show not authenticated' do
        request.headers.merge!(authorization: 'unknowtoken')
        post :reject_secuirty_data_request, params: {request_id: @permission_request.id}
        response.body.should have_content('Not authenticated')
      end
    end

    context "when authenticated but unknown user try to reject request" do
      it 'does show not authenticated' do
        post :reject_secuirty_data_request, params: {request_id: @permission_request.id}
        response.body.should have_content("you don't have permission perform this action")
      end
    end

    context "when authenticated but unknown user try to reject request" do
      it 'does show not authenticated' do
        request.headers.merge!(authorization: @buyer.authentication_token)
        post :reject_secuirty_data_request, params: {request_id: @permission_request.id}
        response.body.should have_content("Request rejected successfully.")
      end
    end
  end

  describe '#companies_review' do
    context 'when unauthorized user review a company' do
      it 'does show error un authorized user' do
        request.headers.merge!(authorization: 'unknown token')
        post :companies_review
        response.body.should have_content('Not authenticated')
      end
    end

    context 'when authorized user to review the company' do
      it 'does match the parameters' do
        post :companies_review, params: {company_id: @buyer.company.id, know: true, trade: false, recommend:true, experience:false}
        expect(JSON.parse(response.body)['review']['know']).to eq(true)
        expect(JSON.parse(response.body)['review']['trade']).to eq(false)
        expect(JSON.parse(response.body)['review']['recommend']).to eq(true)
        expect(JSON.parse(response.body)['review']['experience']).to eq(false)
      end

      it 'does match the status code 200' do
        post :companies_review, params: {company_id: @buyer.company.id, know: true, trade: false, recommend:true, experience:false}
        expect(JSON.parse(response.body)['response_code']).to eq(200)
      end
    end

    context 'when authorized user to review the company' do
      it 'does match the parameters' do
        create(:review, company_id: @buyer.company.id, customer_id: @customer.id)
        post :companies_review, params: {company_id: @buyer.company.id, know: true, trade: false, recommend:true, experience:false}
        expect(JSON.parse(response.body)['review']['know']).to eq(true)
        expect(JSON.parse(response.body)['review']['trade']).to eq(false)
        expect(JSON.parse(response.body)['review']['recommend']).to eq(true)
        expect(JSON.parse(response.body)['review']['experience']).to eq(false)
      end

      it 'does match the status code 201' do
        create(:review, company_id: @buyer.company.id, customer_id: @customer.id)
        post :companies_review, params: {company_id: @buyer.company.id, know: true, trade: false, recommend:true, experience:false}
        expect(JSON.parse(response.body)['response_code']).to eq(201)
      end
    end

  end

  describe '#show_review' do
    context "when unauthenticated user try to access show_review" do
      it 'does show not authenticated' do
        request.headers.merge!(authorization: 'unknowtoken')
        get :show_review
        response.body.should have_content('Not authenticated')
      end
    end

    context "when authenticated user try to access show_review if record not found" do
      it 'does show Record not Found' do
        get :show_review, params: {company_id: 'ul'}
        response.body.should have_content('Record not Found')
      end
    end

    context "when authenticated user try to access show_review" do
      it 'does match the status code 200' do
        create(:review, company_id: @buyer.company.id, customer_id: @customer.id)
        get :show_review, params: {company_id: @buyer.company.id}
        expect(JSON.parse(response.body)['response_code']).to eq(200)
      end
    end
  end


  describe '#count_companies_review' do 
    context 'when unauthenticated user want to show customer info' do
      it 'does show Not authenticated' do
        request.headers.merge!(authorization: 'Unknown token')
        get :count_companies_review
        response.body.should have_content('Not authenticated')
      end
    end

    context 'when Authenticated user want to show own info' do
      it 'does show info of company' do
        create_review(@buyer.id, @customer.company_id)
        get :count_companies_review
        rank = Rank.find_by(company_id: @customer.company_id)
        expect(JSON.parse(response.body)['success']).to be true
        expect(JSON.parse(response.body)['companies_rated_count']['rank']).to eq(rank.rank)
      end
    end

    context 'when Authenticated user want to show own info' do
      it 'does show info of company' do
        create_review(@buyer.id, @customer.company_id)
        create_review(@buyer.id, @customer.company_id)
        create_review(@customer.id, @buyer.company_id)
        request.headers.merge!(authorization: @customer.authentication_token)
        get :count_companies_review
        rank = Rank.find_by(company_id: @customer.company_id)
        expect(JSON.parse(response.body)['success']).to be true
        expect(JSON.parse(response.body)['companies_rated_count']['rank']).to eq(rank.rank)
      end
    end
  end



  describe '#seller_companies' do

    context 'when unknown user wants to access api' do
      it 'does show message not authenticated user' do
        request.headers.merge!(authorization: 'not_authorized_token ')
        get :seller_companies
        response.body.should have_content('Not authenticated')
      end
    end


    context 'when unknown user wants to access api' do
      it 'does show check id of the selected company against current customer' do
        companies = Company.select(" companies.id,count(companies.id) as transaction_count,companies.name,sum(t.remaining_amount) as remaining_amount").joins("inner join transactions t on (companies.id = t.buyer_id and t.seller_id = #{@customer.company.id} and t.buyer_confirmed = true and t.paid = 0 and t.due_date != #{Date.current} )").group(:id).order(:id)
        get :seller_companies, params: {receiver_id: @buyer.company_id}
        expect(JSON.parse(response.body)['companies'].first['id']).to eq(companies.first.id)
      end
    end


    context 'when unknown user wants to access api' do
      it 'does show check name of the selected company against current customer' do
        companies = Company.select(" companies.id,count(companies.id) as transaction_count,companies.name,sum(t.remaining_amount) as remaining_amount").joins("inner join transactions t on (companies.id = t.buyer_id and t.seller_id = #{@customer.company.id} and t.buyer_confirmed = true and t.paid = 0 and t.due_date != #{Date.current} )").group(:id).order(:id)
        get :seller_companies, params: {receiver_id: @buyer.company_id}
        expect(JSON.parse(response.body)['companies'].first['name']).to eq(companies.first.name)
      end
    end

    context 'when unknown user wants to access api' do
      it 'does show check transaction_count  of the selected company against current customer' do
        companies = Company.select(" companies.id,count(companies.id) as transaction_count,companies.name,sum(t.remaining_amount) as remaining_amount").joins("inner join transactions t on (companies.id = t.buyer_id and t.seller_id = #{@customer.company.id} and t.buyer_confirmed = true and t.paid = 0 and t.due_date != #{Date.current} )").group(:id).order(:id)
        get :seller_companies, params: {receiver_id: @buyer.company_id}
        expect(JSON.parse(response.body)['companies'].first['transaction_count']).to eq(companies.first.transaction_count )
      end
    end
    context 'when unknown user wants to access api' do
      it 'does show check remaining_amount  of the selected company against current customer' do
        companies = Company.select(" companies.id,count(companies.id) as transaction_count,companies.name,sum(t.remaining_amount) as remaining_amount").joins("inner join transactions t on (companies.id = t.buyer_id and t.seller_id = #{@customer.company.id} and t.buyer_confirmed = true and t.paid = 0 and t.due_date != #{Date.current} )").group(:id).order(:id)
        get :seller_companies, params: {receiver_id: @buyer.company_id}
        expect(JSON.parse(response.body)['companies'].first['remaining_amount'].to_f).to eq(companies.first.remaining_amount.to_f)
      end
    end

    context 'when unknown user wants to access api' do
      it 'does show check amount_due  of the selected company against current customer' do
        companies = Company.select(" companies.id,count(companies.id) as transaction_count,companies.name,sum(t.remaining_amount) as remaining_amount").joins("inner join transactions t on (companies.id = t.buyer_id and t.seller_id = #{@customer.company.id} and t.buyer_confirmed = true and t.paid = 0 and t.due_date != #{Date.current} )").group(:id).order(:id)
        company_transactions = companies.first.buyer_transactions
        company_transactions_with_current_seller = company_transactions.where(seller_id: @customer.company.id)
        amount_due = company_transactions_with_current_seller.present? ? company_transactions_with_current_seller.where("paid = ? AND buyer_confirmed = ?", false, true).sum(:remaining_amount).round(2) : 0.0
        get :seller_companies, params: {receiver_id: @buyer.company_id}
        expect(JSON.parse(response.body)['companies'].first['amount_due'].to_f).to eq(amount_due.to_f)
      end
    end


    context 'when unknown user wants to access api' do
      it 'does show check  overdue_status gets false  of the selected company against current customer' do
       create(:transaction, buyer_id:@customer.company_id,
               seller_id:  @buyer.company_id,
               trading_parcel_id: @parcel.id,
               due_date: Date.current + 30,
               created_at: 10.days.ago,
               paid: false,
               credit: 20
        )
        companies = Company.select(" companies.id,count(companies.id) as transaction_count,companies.name,sum(t.remaining_amount) as remaining_amount").joins("inner join transactions t on (companies.id = t.buyer_id and t.seller_id = #{@customer.company.id} and t.buyer_confirmed = true and t.paid = 0 and t.due_date != #{Date.current} )").group(:id).order(:id)
        transaction = Transaction.where("seller_id = ? AND buyer_id = ? AND paid = ?", @customer.company.id, companies.first.id, false)
        overdue_days = (Date.current - transaction.first.due_date.to_date).to_i
        get :seller_companies, params: {receiver_id: @buyer.company_id}
        expect(JSON.parse(response.body)['companies'].first['overdue_status']).to eq(false)
      end
    end


    context 'when unknown user wants to access api' do
      it 'does show check  overdue_status gets true  of the selected company against current customer' do
        create(:transaction, buyer_id:  @buyer.company_id,
               seller_id:@customer.company_id,
               trading_parcel_id: @parcel.id,
               due_date: Date.current - 30,
               created_at: 10.days.ago,
               paid: false,
               credit: 20
        )
        companies = Company.select(" companies.id,count(companies.id) as transaction_count,companies.name,sum(t.remaining_amount) as remaining_amount").joins("inner join transactions t on (companies.id = t.buyer_id and t.seller_id = #{@customer.company.id} and t.buyer_confirmed = true and t.paid = 0 and t.due_date != #{Date.current} )").group(:id).order(:id)
        transaction = Transaction.where("seller_id = ? AND buyer_id = ? AND paid = ?", @customer.company.id, companies.first.id, false)
        overdue_days = (Date.current - transaction.first.due_date.to_date).to_i
        get :seller_companies, params: {receiver_id: @buyer.company_id}
        expect(JSON.parse(response.body)['companies'].first['overdue_status']).to eq(true)
      end
    end

  end
end