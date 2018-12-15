require 'rails_helper'
include LiveMonitor

describe LiveMonitor do

  before(:all) do
    seller_company = Company.create(name: Faker::Name.name)
    sellercompany = Company.create(name: Faker::Name.name)
    sellercompany1 = Company.create(name: Faker::Name.name)
    buyer_company = Company.create(name: Faker::Name.name)
    @customer = Customer.create(first_name: FFaker::Name.first_name, last_name: FFaker::Name.last_name, email: FFaker::Internet.email,
                                password: FFaker::DizzleIpsum.words(4).join('!').first(8), mobile_no: Faker::PhoneNumber.phone_number,
                                role: "Buyer/Seller", confirmed_at: Time.current, company: seller_company, authentication_token: Devise.friendly_token)
    @seller = Customer.create(first_name: FFaker::Name.first_name, last_name: FFaker::Name.last_name, email: FFaker::Internet.email,
                              password: FFaker::DizzleIpsum.words(4).join('!').first(8), mobile_no: Faker::PhoneNumber.phone_number,
                              role: "Buyer/Seller", confirmed_at: Time.current, company: sellercompany, authentication_token: Devise.friendly_token)
    @seller1 = Customer.create(first_name: FFaker::Name.first_name, last_name: FFaker::Name.last_name, email: FFaker::Internet.email,
                              password: FFaker::DizzleIpsum.words(4).join('!').first(8), mobile_no: Faker::PhoneNumber.phone_number,
                              role: "Buyer/Seller", confirmed_at: Time.current, company: sellercompany1, authentication_token: Devise.friendly_token)
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

    create(:transaction, buyer_id: @buyer.company_id,
           seller_id: @seller1.company_id,
           trading_parcel_id: @parcel.id)
  end
  describe '#update_secure_center' do
    context 'when there is no transaction' do
      it 'does show paid date equal to nil' do
        transaction = Transaction.find_by(seller_id: @customer.company_id, buyer_id: @buyer.company_id)
        secure_center = SecureCenter.find_by(seller_id: transaction.seller_id, buyer_id: transaction.buyer_id)
        secure_center.paid_date.should be nil
      end
    end
    context 'when transaction paid' do
      it 'does show the last paid date' do
        transaction = Transaction.find_by(seller_id: @customer.company_id, buyer_id: @buyer.company_id)
        partial_payment = PartialPayment.create(company_id: @buyer.company_id, transaction_id: transaction.id, amount: 2000)
        payment(partial_payment)
        secure_center = SecureCenter.find_by(seller_id: transaction.seller_id, buyer_id: transaction.buyer_id)
        expect(secure_center.paid_date).to eq(Date.current)
      end
    end
    context 'when new seller and buyer connect' do
      it 'does show supplier paid increment' do
        new_company = Company.create(name: Faker::Name.name)
        new_seller = Customer.create(first_name: FFaker::Name.first_name, last_name: FFaker::Name.last_name, email: FFaker::Internet.email,
                                    password: FFaker::DizzleIpsum.words(4).join('!').first(8), mobile_no: Faker::PhoneNumber.phone_number,
                                    role: "Buyer/Seller", confirmed_at: Time.current, company: new_company, authentication_token: Devise.friendly_token)
        parcel = create(:trading_parcel, customer: @customer, company: new_seller.company)
        transaction = create(:transaction, buyer_id: @buyer.company_id,
               seller_id: new_seller.company_id,
               trading_parcel_id: parcel.id)
        secure_center = SecureCenter.find_by(seller_id: transaction.seller_id, buyer_id: transaction.buyer_id)
        expect(secure_center.supplier_paid).to eq(@buyer.company.buyer_transactions.collect(&:seller_id).uniq.count)

      end
    end
    context 'when over due date passed away' do
      it 'does show over due amount' do
        transaction = Transaction.find_by(seller_id: @customer.company_id, buyer_id: @buyer.company_id)
        secure_center = SecureCenter.find_by(seller_id: transaction.seller_id, buyer_id: transaction.buyer_id)
        expect(secure_center.overdue_amount).to eq(0)
        transaction.update_attributes(due_date: (DateTime.current - 30.days))
        secure_center = SecureCenter.find_by(seller_id: transaction.seller_id, buyer_id: transaction.buyer_id)
        expect(secure_center.overdue_amount).to eq(@parcel.total_value)
      end
    end
    context 'when made a unpaid transaction' do
      it 'does show correct outstanding amount' do
        transaction = Transaction.find_by(seller_id: @customer.company_id, buyer_id: @buyer.company_id)
        secure_center = SecureCenter.find_by(seller_id: transaction.seller_id, buyer_id: transaction.buyer_id)
        total_amount = TradingParcel.where(customer: @customer).sum(:total_value)
        expect(secure_center.outstandings).to eq(total_amount)
        partial_payment = PartialPayment.create(company_id: @buyer.company_id, transaction_id: transaction.id, amount: 4000)
        payment(partial_payment)
        secure_center = SecureCenter.find_by(seller_id: transaction.seller_id, buyer_id: transaction.buyer_id)
        outstanding = total_amount - @parcel.total_value
        expect(secure_center.outstandings).to eq(outstanding)
      end
    end
    context 'when with respect to all seller' do
      it 'does show all seller invoices overdue' do
        transaction = Transaction.find_by(seller_id: @customer.company_id, buyer_id: @buyer.company_id)
        secure_center = SecureCenter.find_by(seller_id: transaction.seller_id, buyer_id: transaction.buyer_id)
        expect(secure_center.invoices_overdue).to eq(0)
        buyer_transactions = Transaction.where(seller_id: @customer.company_id, buyer_id: @buyer.company_id)
        overdue = buyer_transactions.update_all(due_date: (DateTime.current - 60.days))
        invoices_overdue = buyer_transactions.where("due_date < ? AND paid = ? AND remaining_amount > 2000", Date.current, false).count
        expect(overdue).to eq(invoices_overdue)
      end
      it 'does show last_bought_on' do
        company_transactions = @buyer.company.buyer_transactions
        new_transaction = create(:transaction, buyer_id: @buyer.company_id,
                                 seller_id: @seller.company_id,
                                 trading_parcel_id: @parcel.id)
        secure_center = SecureCenter.find_by(buyer_id: @buyer.company_id)
        expect(new_transaction.updated_at).to eq(secure_center.updated_at)
      end
      it 'does show buyer_percentage' do
        previous_date = DateTime.current - 90.days
        company_transactions = @buyer.company.buyer_transactions
        total_transactions = company_transactions.update_all(due_date: (DateTime.current - 60.days))
        total_buyer_transactions = @buyer.company.buyer_transactions.select(:id).where("due_date>= ? AND due_date < ?", previous_date, Date.current)
        paid_transactions_amount = PartialPayment.where(transaction_id: total_buyer_transactions.pluck(:id)).sum(:amount).to_f
        expect(0.0).to eq(paid_transactions_amount)
        PartialPayment.create(company_id: @buyer.company_id, transaction_id: total_buyer_transactions.last.id, amount: 4000)
        paid_transactions_amount = PartialPayment.where(transaction_id: total_buyer_transactions.pluck(:id)).sum(:amount).to_f
        expect(4000.0).to eq(paid_transactions_amount)
        total_amount_of_transactions = company_transactions.sum(:total_amount).to_f
        buyer_percentage = (paid_transactions_amount / total_amount_of_transactions) * 100
        expect(20.0).to eq(buyer_percentage)
      end
      it 'does show system percentage' do
        1.upto(5) do
          create(:transaction, buyer_id: @buyer.company_id,
                 seller_id: @seller.company_id,
                 trading_parcel_id: @parcel.id)
        end
        previous_date = DateTime.current - 90.days

        all_company_transactions_90days = Transaction.select(:id).where("due_date>= ?  AND due_date < ?", previous_date, Date.current)
        all_company_transactions_90days.blank?

        all_transactions = Transaction.all
        all_transactions.update_all(due_date: (DateTime.current - 60.days))

        all_company_transactions_90days = Transaction.select(:id).where("due_date>= ?  AND due_date < ?", previous_date, Date.current)
        expect(all_company_transactions_90days.count).to eq(10)
        total_transactions_amount_90_days = all_company_transactions_90days.sum(:remaining_amount).round(2)
        expect(total_transactions_amount_90_days).to eq(10 * 4000)

        paid_all_transaction_amount_last_90_days = PartialPayment.where(transaction_id: all_company_transactions_90days.pluck(:id)).sum(:amount).to_f
        expect(paid_all_transaction_amount_last_90_days).to eq(0.0)

        PartialPayment.create(company_id: @buyer.company_id, transaction_id: all_company_transactions_90days.last.id, amount: 4000)
        paid_all_transaction_amount_last_90_days = PartialPayment.where(transaction_id: all_company_transactions_90days.pluck(:id)).sum(:amount).to_f
        expect(paid_all_transaction_amount_last_90_days).to eq(4000.0)
        binding.pry
        system_percentage = (paid_all_transaction_amount_last_90_days / total_transactions_amount_90_days) * 100
        expect(system_percentage.to_i).to eq(10)
      end
    end
  end
end

def payment(payment)
    transaction = Transaction.find(payment.transaction_id)
    amount = transaction.remaining_amount
    transaction.remaining_amount = amount - payment.amount
    if transaction.remaining_amount == 0
      transaction.paid = true
    end
    transaction.save
end