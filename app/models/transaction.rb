class Transaction < ApplicationRecord
  belongs_to :trading_parcel
  belongs_to :buyer, class_name: 'Customer', foreign_key: 'buyer_id'
  belongs_to :supplier, class_name: 'Customer', foreign_key: 'supplier_id'

  after_create :update_credit_limit

  def self.create_new(proposal)
    Transaction.create(buyer_id: proposal.buyer_id, supplier_id: proposal.supplier_id,
                      trading_parcel_id: proposal.trading_parcel_id, price: proposal.price,
                      credit: proposal.credit, due_date: Date.today + (proposal.credit).days,
                      paid: false)
  end

  def update_credit_limit
    price = self.price
    cl = CreditLimit.where(buyer_id: self.buyer_id, supplier_id: self.supplier_id).first
    remaining_limit = cl.credit_limit.to_f - price
    cl.credit_limit = remaining_limit
    cl.save!
  end

  def set_due_date
    self.due_date = created_at + (credit).days
    self.save!
  end
end
