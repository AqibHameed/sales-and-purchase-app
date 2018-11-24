class DaysLimit < ApplicationRecord
  include LiveMonitor
  validates_numericality_of :days_limit
  after_save :secure_center
  belongs_to :buyer, class_name: 'Company', foreign_key: 'buyer_id'
  belongs_to :seller, class_name: 'Company', foreign_key: 'seller_id'
end
