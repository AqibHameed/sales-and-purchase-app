class CreditLimit < ApplicationRecord
  validates_numericality_of :credit_limit

  belongs_to :buyer, class_name: 'Company', foreign_key: 'buyer_id'
  belongs_to :seller, class_name: 'Company', foreign_key: 'seller_id'
end
