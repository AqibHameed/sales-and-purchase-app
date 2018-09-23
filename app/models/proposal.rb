class Proposal < ApplicationRecord
  paginates_per 25
  belongs_to :trading_parcel
  belongs_to :buyer, class_name: 'Company', foreign_key: 'buyer_id'
  belongs_to :seller, class_name: 'Company', foreign_key: 'seller_id'
  has_many :messages
  has_many :negotiations
  after_create :set_buyer_offers


  enum status: [ :negotiated, :accepted, :rejected ]

  def set_buyer_offers
    self.buyer_percent = self.percent
    self.buyer_price = self.price
    self.buyer_total_value = self.total_value
    self.buyer_credit = self.credit
    self.save
  end

  def negotiation_status from
    if from == buyer
      sender = 'buyer'
      receiver = 'seller'      
    elsif from == seller
      sender = 'seller'
      receiver = 'buyer'
    end

    last_negotiation = negotiations.where(from: sender).last
    if last_negotiation
      if negotiations.where(from: receiver).where('created_at > ?', last_negotiation.created_at).present?
        return 'negotiated'
      else
        return 'yes'
      end
    else
      return 'no'
    end        
  end

  # validate  :credit_validation

  # def credit_validation
  #   limit = CreditLimit.where(buyer_id: buyer_id, seller_id: seller_id).first
  #   if limit.nil?
  #     # do nothing
  #   else
  #     credit_limit = limit.credit_limit
  #     transactions = Transaction.where(buyer_id: buyer_id, seller_id: seller_id, paid: false, buyer_confirmed: true)
  #     @amount = []
  #     transactions.each do |t|
  #       @amount << t.remaining_amount
  #     end
  #     used_amt = @amount.sum
  #     get_weight = self.trading_parcel.weight.blank? ? 1 : self.trading_parcel.weight
  #     if self.trading_parcel.diamond_type == 'Rough'
  #       total_price = self.trading_parcel.price.to_f * get_weight.to_f
  #     else
  #       total_price = self.trading_parcel.price.to_f * get_weight.to_f
  #     end
  #     available_limit = credit_limit.to_f - used_amt.to_f
  #     if total_price.to_f > available_limit
  #       errors[:base] << "You have available credit limit of #{available_limit}. So you can't buy more than this limit"
  #     end
  #   end
  #   # limit = CreditLimit.where(buyer_id: buyer_id, seller_id: seller_id).first
  #   # if limit.present?
  #   #   credit_limit = limit.credit_limit
  #   #   if price.to_f > credit_limit
  #   #     errors[:base] << "Your credit limit is #{limit.credit_limit}. You cannot buy more than #{limit.credit_limit} from this supplier."
  #     # end
  #   # end
  # end

  ####### Not in use #######

  # def price_validation
  #   supplier_price = trading_parcel.price
  #   unless supplier_price.nil?
  #     buyer_price = supplier_price*(0.85)
  #     if price.to_f < buyer_price
  #       errors[:base] << "Price should not be less than 15% of supplier price. Please try again"
  #     end
  #   end
  # end

  # def check_sub_company_limit(current_customer)
  #   scc = SubCompanyCreditLimit.where(sub_company_id: self.seller_id).first
  #   if scc.try(:credit_type) == 'Yours'
  #     cl = CreditLimit.where(seller_id: scc.try(:parent_id), buyer_id: current_customer.id).first
  #     if cl.present?
  #       credit_limit = cl.credit_limit
  #       check_transaction(credit_limit, 'sub_company', scc.try(:parent_id))
  #     else
  #       self.errors.add(:credit_limit, "not available for this customer")
  #     end
  #   else
  #     limit = CreditLimit.where(buyer_id: buyer_id, seller_id: seller_id).first
  #     if limit.nil?
  #       self.errors.add(:credit_limit, "haven't given by Supplier to you. Request credits from below")
  #     else
  #       credit_limit = limit.credit_limit
  #       check_transaction(credit_limit, 'supplier', seller_id)
  #     end
  #   end
  # end

  # def check_transaction(credit_limit, type, supplier)
  #   transactions = Transaction.where(buyer_id: buyer_id, seller_id: supplier, paid: false, buyer_confirmed: true)
  #   @amount = []
  #   transactions.each do |t|
  #     @amount << t.remaining_amount
  #   end
  #   used_amt = @amount.sum
  #   get_weight = self.trading_parcel.weight.blank? ? 1 : self.trading_parcel.weight
  #   if self.trading_parcel.diamond_type == 'Rough'
  #     total_price = self.trading_parcel.price.to_f * get_weight.to_f
  #   else
  #     total_price = self.trading_parcel.price.to_f * get_weight.to_f
  #   end
  #   available_limit = credit_limit.to_f - used_amt.to_f
  #   if total_price.to_f > available_limit
  #     if type =='sub_company'
  #       self.errors.add(:credit_limit, "is not enough to buy this")
  #     else
  #       self.errors.add(:credit_limit, "of #{available_limit} limit is available to you. So you can't buy more than this limit")
  #     end
  #   end
  # end
end


