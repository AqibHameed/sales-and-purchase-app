class Transaction < ApplicationRecord
  include LiveMonitor
  
  belongs_to :trading_parcel

  belongs_to :buyer, class_name: 'Company', foreign_key: 'buyer_id'
  belongs_to :seller, class_name: 'Company', foreign_key: 'seller_id'

  has_many :partial_payment, class_name: 'PartialPayment', foreign_key: 'transaction_id'

  validate :validate_invoice_date
  after_create :generate_and_add_uid, :generate_and_add_amount
  after_save :calculate_amount
  after_create :secure_center
  after_update :secure_center

  attr_accessor :weight

  def credit_validation
    limit = CreditLimit.where(buyer_id: buyer_id, seller_id: seller_id).first
    if limit.nil?
      errors[:base] << "Please increase credit limit. Available credit is less than the invoice amount. Please <a href = '/suppliers/credit'>click here</a> to assign.".html_safe
    else
      credit_limit = limit.credit_limit
      transactions = Transaction.where(buyer_id: buyer_id, seller_id: seller_id, paid: false, buyer_confirmed: true)
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

  def paid_date
    if self.paid == true
      self.partial_payment.order('created_at ASC').last.created_at if self.partial_payment.present?
    end
  end

  def self.create_new(proposal)
    trading_parcel = proposal.trading_parcel
    Transaction.create(buyer_id: proposal.buyer_id, seller_id: proposal.seller_id,
                      trading_parcel_id: proposal.trading_parcel_id, price: proposal.price,
                      credit: proposal.credit, due_date: Date.current + (trading_parcel.credit_period).days,
                      paid: false, buyer_confirmed: true, created_at: Time.current, diamond_type: trading_parcel.diamond_type)
  end

  # def update_credit_limit
  #   cl = CreditLimit.where(buyer_id: self.buyer_id, seller_id: self.seller_id).first
  #   if cl.nil?
  #     cl = CreditLimit.create(buyer_id: self.buyer_id, seller_id: self.seller_id, credit_limit: 0.0)
  #   end
  # end

  def set_due_date
    self.due_date = created_at + (credit).days
    self.save(validate: false)
  end

  def generate_and_add_uid
    if transaction_type == 'manual'
      if buyer.customers.blank?
        is_buyer_confirmed = true
      else
        is_buyer_confirmed = false
      end
    else
      is_buyer_confirmed = true
    end
    uid = SecureRandom.hex(12)
    self.update_columns({description: trading_parcel.description, transaction_uid: uid, buyer_confirmed: is_buyer_confirmed})
  end

  def generate_and_add_amount
    amount = trading_parcel.try(:total_value) rescue price*trading_parcel.weight
    remaining_amount = amount
    total_amount = amount
    self.save(validate: false)
  end

  def calculate_amount
    amount = (price.nil? || trading_parcel.try(:weight).nil?) ? trading_parcel.try(:total_value) : price*trading_parcel.weight
    paid_amt = PartialPayment.where(transaction_id: self.id).sum(:amount)
    remaining_amount = amount - paid_amt
    self.update_columns({remaining_amount: remaining_amount, total_amount: amount})
  end

  def self.total_transaction(company_id)
    total_transaction = Transaction.where('(buyer_id = ? or seller_id = ?) and buyer_confirmed = ?',company_id, company_id, true)
  end

  def self.pending_sent_transaction(company_id)
    total_pending_sent = Transaction.where("seller_id = ? AND due_date >= ? AND paid = ? AND buyer_confirmed = ?", company_id, Date.current, false, true)
  end

  def self.pending_received_transaction(company_id)
    total_pending_received = Transaction.where("buyer_id = ? AND due_date >= ? AND paid = ? AND buyer_confirmed = ?", company_id, Date.current, false, true)
  end

  def self.overdue_received_transaction(company_id)
    total_overdue_received = Transaction.includes(:trading_parcel).where("buyer_id = ? AND due_date < ? AND paid = ? AND buyer_confirmed = ?", company_id, Date.current, false, true)
  end

  def self.overdue_sent_transaction(company_id)
    total_overdue_sent = Transaction.includes(:trading_parcel).where("seller_id = ? AND due_date < ? AND paid = ? AND buyer_confirmed = ?", company_id, Date.current, false, true)
  end

  def self.complete_received_transaction(company_id)
    total_complete_received = Transaction.includes(:trading_parcel).where("buyer_id = ? AND paid = ? AND buyer_confirmed = ?", company_id, true, true)
  end

  def self.complete_sent_transaction(company_id)
    total_complete_sent = Transaction.includes(:trading_parcel).where("seller_id = ? AND paid = ? AND buyer_confirmed = ?", company_id, true, true)
  end

  def self.send_overdue_email
    Transaction.all.each do |t|
      invoice_date = t.created_at
      credit_days = t.buyer.credit_days_by_supplier(t.supplier)
      overdue_date = invoice_date + credit_days.days
      if Date.current == overdue_date
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

  def create_parcel_for_buyer
    new_parcel = trading_parcel.dup
    new_parcel.company_id = self.buyer_id
    new_parcel.sold = false
    new_parcel.sale_all = false
    new_parcel.save
  end
end
