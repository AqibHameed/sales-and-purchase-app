class Transaction < ApplicationRecord
  belongs_to :trading_parcel
  belongs_to :buyer, class_name: 'Customer', foreign_key: 'buyer_id'
  belongs_to :supplier, class_name: 'Customer', foreign_key: 'supplier_id'
  
  validate :credit_validation, :validate_invoice_date
  after_create :update_credit_limit


  def credit_validation
    limit = CreditLimit.where(buyer_id: buyer_id, supplier_id: supplier_id).first
    if limit.present?
      credit_limit = limit.credit_limit
      if price.to_f > credit_limit
        errors[:base] << "Customer has credit limit of #{limit.credit_limit}. Please <a href = '/suppliers/credit'>click here</a> to increase it.".html_safe
      end
    end
  end

  def validate_invoice_date
    errors[:base] << "Invoice date can't be nil." if created_at.nil? || created_at.blank?
  end

  def self.create_new(proposal)
    Transaction.create(buyer_id: proposal.buyer_id, supplier_id: proposal.supplier_id,
                      trading_parcel_id: proposal.trading_parcel_id, price: proposal.price,
                      credit: proposal.credit, due_date: Date.today + (proposal.credit).days,
                      paid: false)
  end

  def update_credit_limit
    cl = CreditLimit.where(buyer_id: self.buyer_id, supplier_id: self.supplier_id).first
    if cl.nil?
      cl = CreditLimit.create(buyer_id: self.buyer_id, supplier_id: self.supplier_id, credit_limit: 0.0)
    end
  end

  def set_due_date
    self.due_date = created_at + (credit).days
    self.save!
  end

  def release_credits
    cl = CreditLimit.where(buyer_id: self.buyer_id, supplier_id: self.supplier_id).first
    if cl
      cl.credit_limit = cl.credit_limit + price
      cl.save!
    end
  end
end
