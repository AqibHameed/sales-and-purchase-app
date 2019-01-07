require 'rails_helper'
RSpec.describe Api::V1::LimitsController do
  before(:all) do
    @company = Company.create(name: Faker::Name.name)
    @customer = Customer.create(first_name: FFaker::Name.first_name, last_name: FFaker::Name.last_name, email: FFaker::Internet.email,
                                password: FFaker::DizzleIpsum.words(4).join('!').first(8), mobile_no: Faker::PhoneNumber.phone_number,
                                role: "Buyer/Seller", confirmed_at: Time.current, company: @company, authentication_token: Devise.friendly_token)
    create(:customer_role, customer: @customer)
    create(:credit_limit, buyer_id: @company.id, seller_id: @customer.company.id)
    create(:days_limit, buyer_id: @company.id, seller_id: @customer.company.id)
  end

  before(:each) do
    request.headers.merge!(authorization: @customer.authentication_token)
  end

  describe '#add_limits' do
    context 'when unauthorized user to update the credit limit' do
      it 'does show error un authorized user' do
        request.headers.merge!(authorization: 'wetasdetoken')
        post :add_limits
        response.body.should have_content('Not authenticated')
      end
    end

    context 'when authorized user to update the credit limit and buyer id is not exist' do
      it 'does show the message Buyer doesnt exist' do
        post :add_limits, params: {buyer_id: 'al'}
        response.body.should have_content("Buyer doesn't exist")
      end
    end

    context 'when authorized user to update the credit limit and buyer id is  exist' do
      it 'does show the message Limits updated' do
        post :add_limits, params: {buyer_id: @company.id, limit: '3000'}
        response.body.should have_content("Limits updated")
      end
    end
  end

  describe '#add_overdue_limit' do
    context 'when unauthorized user to update the days limit' do
      it 'does show error un authorized user' do
        request.headers.merge!(authorization: 'wetasdetoken')
        post :add_overdue_limit
        response.body.should have_content('Not authenticated')
      end
    end

    context 'when authorized user to update the days limit and buyer id is not exist' do
      it 'does show the message Buyer doesnt exist' do
        post :add_overdue_limit, params: {buyer_id: 'al'}
        response.body.should have_content("Buyer doesn't exist")
      end
    end

    context 'when authorized user to update the days limit and buyer id is  exist' do
      it 'does show the message Days Limit updated' do
        post :add_overdue_limit, params: {buyer_id: @company.id, limit: '20'}
        response.body.should have_content("Days Limit updated")
      end
    end
  end

  describe '#credit_limit_list' do
    context 'when unauthorized user to get the credit limit list' do
      it 'does show error un authorized user' do
        request.headers.merge!(authorization: 'wetasdetoken')
        get :credit_limit_list
        response.body.should have_content('You have to login first')
      end
    end

    context 'when authorized user to get the credit limit list if company id not exist' do
      it 'does show the message Company not found' do
        get :credit_limit_list, params: {company_id: 'al'}
        response.body.should have_content('Company not found')
      end
    end

    context 'when authorized user to get the credit limit list if company id exist' do
      it 'does the values according to the formula' do
        get :credit_limit_list, params: {company_id: @company.id}
        company = Company.find_by(id: @company.id)
        current_company = @customer.company
        credit = CreditLimit.find_by(buyer_id: company.id, seller_id: current_company.id)
        credit_limit = credit.present? ? credit.credit_limit : 0.0
        get_used_credit_limit = Transaction.where(buyer_id: company.id, seller_id: current_company.id, paid: false, buyer_confirmed: true).sum(:remaining_amount).to_f

        available_credit_limit = credit_limit.to_f - get_used_credit_limit.to_f
        if available_credit_limit < 0
          available_credit_limit = 0.0
        end

        days_limit = DaysLimit.find_by(buyer_id: company.id, seller_id: current_company.id)
        limit_days = days_limit.present? ? "#{days_limit.days_limit.to_i}"+ " "+ "days" : "30 days"
        supplier_paid = @company.supplier_paid

        expect(credit_limit).to eq(JSON.parse(response.body)['limits']['total_limit'])
        expect(get_used_credit_limit).to eq(JSON.parse(response.body)['limits']['used_limit'])
        expect(limit_days).to eq(JSON.parse(response.body)['limits']['overdue_limit'])
        expect(supplier_paid).to eq(JSON.parse(response.body)['limits']['supplier_connected'])
      end
    end

    context 'when authorized user to get the credit limit list if company id is not exist' do
      it 'does the values according to the formula' do
        get :credit_limit_list
        company = Company.find_by(id: @company.id)
        current_company = @customer.company
        credit = CreditLimit.find_by(buyer_id: company.id, seller_id: current_company.id)
        credit_limit = credit.present? ? credit.credit_limit : 0.0
        get_used_credit_limit = Transaction.where(buyer_id: company.id, seller_id: current_company.id, paid: false, buyer_confirmed: true).sum(:remaining_amount).to_f

        available_credit_limit = credit_limit.to_f - get_used_credit_limit.to_f
        if available_credit_limit < 0
          available_credit_limit = 0.0
        end

        days_limit = DaysLimit.find_by(buyer_id: company.id, seller_id: current_company.id)
        limit_days = days_limit.present? ? "#{days_limit.days_limit.to_i}"+ " "+ "days" : "30 days"
        supplier_paid = @company.supplier_paid
        expect(credit_limit).to eq(JSON.parse(response.body)['limits'].first['total_limit'])
        expect(get_used_credit_limit).to eq(JSON.parse(response.body)['limits'].first['used_limit'])
        expect(limit_days).to eq(JSON.parse(response.body)['limits'].first['overdue_limit'])
        expect(supplier_paid).to eq(JSON.parse(response.body)['limits'].first['supplier_connected'])
      end
    end
  end
end