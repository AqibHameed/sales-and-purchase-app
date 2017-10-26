class DaysLimit < ApplicationRecord
  validates_numericality_of :days_limit

  belongs_to :buyer, class_name: 'Customer', foreign_key: 'buyer_id'
  belongs_to :supplier, class_name: 'Customer', foreign_key: 'supplier_id'
end
