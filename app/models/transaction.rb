class Transaction < ApplicationRecord
  belongs_to :trading_parcel

  belongs_to :buyer, class_name: 'Customer', foreign_key: 'buyer_id'
  belongs_to :supplier, class_name: 'Customer', foreign_key: 'supplier_id'

  validate :credit_validation, :validate_invoice_date
  after_create :update_credit_limit, :generate_and_add_uid, :generate_and_add_amount

  attr_accessor :weight

  def credit_validation
    limit = CreditLimit.where(buyer_id: buyer_id, supplier_id: supplier_id).first
    if limit.nil?
      errors[:base] << "You haven't given any limit to selected customer. Please <a href = '/suppliers/credit'>click here</a> to assign.".html_safe
    else
      credit_limit = limit.credit_limit
      transactions = Transaction.where(buyer_id: buyer_id, supplier_id: supplier_id, paid: false)
      @amount = []
      transactions.each do |t|
        weight = (t.trading_parcel.weight.blank? || t.trading_parcel.weight.nil?) ? 1 : t.trading_parcel.weight
        price = t.price
        @amount << (weight.to_f * price.to_f)
      end
      used_amt = @amount.sum
      get_weight = weight.blank? ? 1 : weight
      total_price = price.to_f * weight.to_f
      available_limit = credit_limit.to_f - used_amt.to_f
      if total_price.to_f > available_limit
        errors[:base] << "Customer has available credit limit of #{available_limit}. Please <a href = '/suppliers/credit'>click here</a> to increase it.".html_safe
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
                      paid: false, created_at: Time.now)
  end

  def update_credit_limit
    cl = CreditLimit.where(buyer_id: self.buyer_id, supplier_id: self.supplier_id).first
    if cl.nil?
      cl = CreditLimit.create(buyer_id: self.buyer_id, supplier_id: self.supplier_id, credit_limit: 0.0)
    end
  end

  def set_due_date
    self.due_date = created_at + (credit).days
    self.save(validate: false)
  end

  def generate_and_add_uid
    uid = SecureRandom.hex(6)
    self.transaction_uid = uid
    self.save(validate: false)
  end

  def generate_and_add_amount
    amount = trading_parcel.price*trading_parcel.weight
    self.amount = amount
    self.save(validate: false)
  end

  # def release_credits
  #   cl = CreditLimit.where(buyer_id: self.buyer_id, supplier_id: self.supplier_id).first
  #   if cl
  #     cl.credit_limit = cl.credit_limit + price
  #     cl.save!
  #   end
  # end
end
