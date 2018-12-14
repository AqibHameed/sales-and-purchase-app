require 'rails_helper'
include LiveMonitor

describe LiveMonitor do

  before(:all) do
    seller_company = Company.create(name: Faker::Name.name)
    sellercompany = Company.create(name: Faker::Name.name)
    buyer_company = Company.create(name: Faker::Name.name)
    @customer = Customer.create(first_name: FFaker::Name.first_name, last_name: FFaker::Name.last_name, email: FFaker::Internet.email,
                                password: FFaker::DizzleIpsum.words(4).join('!').first(8), mobile_no: Faker::PhoneNumber.phone_number,
                                role: "Buyer/Seller", confirmed_at: Time.current, company: seller_company, authentication_token: Devise.friendly_token)
    @seller = Customer.create(first_name: FFaker::Name.first_name, last_name: FFaker::Name.last_name, email: FFaker::Internet.email,
                                password: FFaker::DizzleIpsum.words(4).join('!').first(8), mobile_no: Faker::PhoneNumber.phone_number,
                                role: "Buyer/Seller", confirmed_at: Time.current, company: sellercompany, authentication_token: Devise.friendly_token)
    @buyer = Customer.create(first_name: FFaker::Name.first_name, last_name: FFaker::Name.last_name, email: FFaker::Internet.email,
                                password: FFaker::DizzleIpsum.words(4).join('!').first(8), mobile_no: Faker::PhoneNumber.phone_number,
                                role: "Buyer/Seller", confirmed_at: Time.current, company: buyer_company, authentication_token: Devise.friendly_token)
    create(:customer_role, customer: @customer)
  end
  before(:each) do
    1.upto(3) do
      @parcel = create(:trading_parcel, customer: @customer, company: @customer.company)
      create(:transaction, buyer_id: @buyer.company_id,
             seller_id: @customer.company_id,
             trading_parcel_id: @parcel.id)
    end
    create(:transaction, buyer_id: @buyer.company_id,
           seller_id: @seller.company_id,
           trading_parcel_id: @parcel.id)
  end
  describe '#update_secure_center' do
    context 'when call secure center' do
      it 'does show paid date equal to nil' do
        @transaction = Transaction.last
        transactions = @transaction.secure_center
        transactions.last.paid_date.should be nil
      end
    end
    context 'when transaction paid' do
      it 'does show the last paid date' do
        @transaction = Transaction.last
        PartialPayment.create(company_id: @buyer.company_id, transaction_id: @transaction.id, amount: 50)
        transactions = @transaction.secure_center
        expect(Date.current).to eq(transactions.last.paid_date)
      end
      it 'does show supplier paid increased' do
        @transaction = Transaction.last
        PartialPayment.create(company_id: @buyer.company_id, transaction_id: @transaction.id, amount: 50)
        secure_center = @transaction.secure_center
        supplier_paid = @buyer.company.supplier_paid
        expect(supplier_paid).to eq(secure_center.last.supplier_paid)
      end
    end
    context 'when over due date passed away' do
      it 'does show over due amount' do
        @transactions = Transaction.where(buyer_id: @buyer.company_id, seller_id: @customer.company_id)
        company_transactions_with_current_seller = @transactions.where(seller_id: @customer.id)
        overdue_amount = company_transactions_with_current_seller.where("due_date < ? AND paid = ? AND buyer_confirmed = ?", Date.current, false, true).sum(:remaining_amount).round(2)
        expect(0).to eq(overdue_amount)
        company_transactions_with_current_seller.last.update_attributes(due_date: 30.days.ago)
        overdue_amount = company_transactions_with_current_seller.where("due_date < ? AND paid = ? AND buyer_confirmed = ?", Date.current, false, true).sum(:remaining_amount).round(2)
        expect(@parcel.total_value).to eq(overdue_amount)
      end
    end
    context 'when made a unpaid transaction' do
      it 'does show correct outstanding amount' do
        @transactions = Transaction.where(buyer_id: @buyer.company_id, seller_id: @customer.company_id)
        outstandings = @transactions.where("paid = ? AND buyer_confirmed = ?", false, true).sum(:remaining_amount)
        total_amount = TradingParcel.where(customer: @customer).sum(:total_value)
        expect(total_amount).to  eq(outstandings)
      end
    end
    context 'when with respect to all seller'do
      it 'does show all seller invoices overdue' do
        company_transactions = @buyer.company.buyer_transactions
        invoices_overdue = company_transactions.where("due_date < ? AND paid = ? AND remaining_amount > 2000", Date.current, false).count
        expect(0).to eq(invoices_overdue)
        check_invoice = company_transactions.where(seller_id: @seller.company_id).last
        check_invoice.update_attributes(due_date: 30.days.ago)
        invoices_overdue = company_transactions.where("due_date < ? AND paid = ? AND remaining_amount > 2000", Date.current, false).count
        expect(1).to eq(invoices_overdue)
      end
      it 'does show last last_bought_on' do
        company_transactions = @buyer.company.buyer_transactions
        new_transaction = create(:transaction, buyer_id: @buyer.company_id,
                                 seller_id: @seller.company_id,
                                 trading_parcel_id: @parcel.id)
        last_bought_on = company_transactions.order('created_at ASC').last
        expect(new_transaction.updated_at).to eq(last_bought_on.updated_at)
      end
      it 'does show buyer_percentage' do

      end
    end
  end
end