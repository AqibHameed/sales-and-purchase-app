class Proposal < ApplicationRecord
  paginates_per 25
  belongs_to :trading_parcel
  belongs_to :buyer, class_name: 'Customer', foreign_key: 'buyer_id'
  belongs_to :supplier, class_name: 'Customer', foreign_key: 'supplier_id'

  enum status: [ :negotiated, :accepted, :rejected ]

  validate :price_validation

  def price_validation
    supplier_price = trading_parcel.price
    unless supplier_price.nil?
      buyer_price = supplier_price*(0.85)
      if price.to_f < buyer_price
        errors[:base] << "Price should be less than 15% of supplier price. Please try again"
      end
    end
  end
end


