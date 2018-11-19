class CreditLimit < ApplicationRecord
  include LiveMonitor

  validates_numericality_of :credit_limit
  after_create :secure_center
  after_update :secure_center
  belongs_to :buyer, class_name: 'Company', foreign_key: 'buyer_id'
  belongs_to :seller, class_name: 'Company', foreign_key: 'seller_id'
  validate :verify_market_limit_is_greater_than_credit_limit?

  def verify_market_limit_is_greater_than_credit_limit?
    errors.add(:market_limit, 'Should be greater than credit limit') if market_limit < credit_limit
  end

end
