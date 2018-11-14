class DaysLimit < ApplicationRecord
  include LiveMonitor
  validates_numericality_of :days_limit
  # after_create :secure_center
  # after_update :secure_center
  belongs_to :buyer, class_name: 'Company', foreign_key: 'buyer_id'
  belongs_to :seller, class_name: 'Company', foreign_key: 'seller_id'
end
