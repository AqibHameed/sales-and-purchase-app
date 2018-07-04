class DaysLimit < ApplicationRecord
  validates_numericality_of :days_limit

  belongs_to :buyer, class_name: 'Company', foreign_key: 'buyer_id'
  belongs_to :seller, class_name: 'Company', foreign_key: 'seller_id'
end
