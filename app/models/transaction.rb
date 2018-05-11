class Transaction < ApplicationRecord
  belongs_to :trading_parcel

  belongs_to :buyer, class_name: 'Customer', foreign_key: 'buyer_id'
  belongs_to :supplier, class_name: 'Customer', foreign_key: 'supplier_id'

  validate :credit_validation, :validate_invoice_date
  after_create :update_credit_limit, :generate_and_add_uid, :generate_and_add_amount
  after_save :calculate_amount

  attr_accessor :weight

  def credit_validation
    limit = CreditLimit.where(buyer_id: buyer_id, supplier_id: supplier_id).first
    if limit.nil?
      errors[:base] << "Please increase credit limit. Available credit is less than the invoice amount. Please <a href = '/suppliers/credit'>click here</a> to assign.".html_safe
    else
      credit_limit = limit.credit_limit
      transactions = Transaction.where(buyer_id: buyer_id, supplier_id: supplier_id, paid: false, buyer_confirmed: true)
      @amount = []
      transactions.each do |t|
        @amount << t.remaining_amount
      end
      used_amt = @amount.sum
      get_weight = weight.blank? ? 1 : weight
      if diamond_type == 'Rough'
        total_price = price.to_f * weight.to_f
      else
        total_price = price.to_f * weight.to_f
      end
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
    trading_parcel = proposal.trading_parcel
    Transaction.create(buyer_id: proposal.buyer_id, supplier_id: proposal.supplier_id,
                      trading_parcel_id: proposal.trading_parcel_id, price: proposal.price,
                      credit: proposal.credit, due_date: Date.today + (trading_parcel.credit_period).days,
                      paid: false, buyer_confirmed: true, created_at: Time.now, diamond_type: trading_parcel.diamond_type)
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
    uid = SecureRandom.hex(12)
    self.transaction_uid = uid
    self.description = trading_parcel.description
    self.save(validate: false)
  end

  def generate_and_add_amount
    amount = price*trading_parcel.weight
    self.remaining_amount = amount
    self.total_amount = amount
    self.save(validate: false)
  end

  def calculate_amount
    amount = price*trading_parcel.weight
    paid_amt = PartialPayment.where(transaction_id: self.id).sum(:amount)
    remaining_amount = amount - paid_amt
    self.update_columns({remaining_amount: remaining_amount, total_amount: amount})
  end

  def self.total_transaction(customer_id)
    total_transaction = Transaction.where('(buyer_id = ? or supplier_id = ?) and buyer_confirmed = ?',customer_id, customer_id, true)
  end

  def self.pending_sent_transaction(customer_id)
    total_pending_sent = Transaction.where("supplier_id = ? AND due_date >= ? AND paid = ? AND buyer_confirmed = ?", customer_id, Date.today, false, true)
  end

  def self.pending_received_transaction(customer_id)
    total_pending_received = Transaction.where("buyer_id = ? AND due_date >= ? AND paid = ? AND buyer_confirmed = ?", customer_id, Date.today, false, true)
  end

  def self.overdue_received_transaction(customer_id)
    total_overdue_received = Transaction.includes(:trading_parcel).where("buyer_id = ? AND due_date < ? AND paid = ? AND buyer_confirmed = ?", customer_id, Date.today, false, true)
  end

  def self.overdue_sent_transaction(customer_id)
    total_overdue_sent = Transaction.includes(:trading_parcel).where("supplier_id = ? AND due_date < ? AND paid = ? AND buyer_confirmed = ?", customer_id, Date.today, false, true)
  end

  def self.complete_received_transaction(customer_id)
    total_complete_received = Transaction.includes(:trading_parcel).where("buyer_id = ? AND paid = ? AND buyer_confirmed = ?", customer_id, true, true)
  end

  def self.complete_sent_transaction(customer_id)
    total_complete_sent = Transaction.includes(:trading_parcel).where("supplier_id = ? AND paid = ? AND buyer_confirmed = ?", customer_id, true, true)
  end

  def self.send_overdue_email
    Transaction.all.each do |t|
      invoice_date = t.created_at
      credit_days = t.buyer.credit_days_by_supplier(t.supplier)
      overdue_date = invoice_date + credit_days.days
      if Date.today == overdue_date
        TenderMailer.send_overdue_transaction_mail(t).deliver rescue logger.info "Error sending email" 
      end
    end
  end

  # def release_credits
  #   cl = CreditLimit.where(buyer_id: self.buyer_id, supplier_id: self.supplier_id).first
  #   if cl
  #     cl.credit_limit = cl.credit_limit + price
  #     cl.save!
  #   end
  # end
end
