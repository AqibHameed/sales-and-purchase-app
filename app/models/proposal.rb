class Proposal < ApplicationRecord
  paginates_per 25
  belongs_to :trading_parcel
  belongs_to :buyer, class_name: 'Customer', foreign_key: 'buyer_id'
  belongs_to :supplier, class_name: 'Customer', foreign_key: 'supplier_id'

  enum status: [ :negotiated, :accepted, :rejected ]

  validate :price_validation, :credit_validation

  def price_validation
    supplier_price = trading_parcel.price
    unless supplier_price.nil?
      buyer_price = supplier_price*(0.85)
      if price.to_f < buyer_price
        errors[:base] << "Price should be less than 15% of supplier price. Please try again"
      end
    end
  end

  def credit_validation
    limit = CreditLimit.where(buyer_id: buyer_id, supplier_id: supplier_id).first
    if limit.nil?
      errors[:base] << "You haven't given any limit to selected customer. Please <a href = '/suppliers/credit'>click here</a> to assign.".html_safe
    else
      credit_limit = limit.credit_limit
      transactions = Transaction.where(buyer_id: buyer_id, supplier_id: supplier_id, paid: false, buyer_confirmed: true)
      @amount = []
      transactions.each do |t|
        @amount << t.remaining_amount
      end
      used_amt = @amount.sum
      get_weight = self.trading_parcel.weight.blank? ? 1 : self.trading_parcel.weight
      if self.trading_parcel.diamond_type == 'Rough'
        total_price = price.to_f * get_weight.to_f
      else
        total_price = price.to_f * get_weight.to_f
      end
      available_limit = credit_limit.to_f - used_amt.to_f
      if total_price.to_f > available_limit
        errors[:base] << "You have available credit limit of #{available_limit}. So you can't buy more than this limit"
      end
    end
    # limit = CreditLimit.where(buyer_id: buyer_id, supplier_id: supplier_id).first
    # if limit.present?
    #   credit_limit = limit.credit_limit
    #   if price.to_f > credit_limit
    #     errors[:base] << "Your credit limit is #{limit.credit_limit}. You cannot buy more than #{limit.credit_limit} from this supplier."
      # end
    # end
  end
end


