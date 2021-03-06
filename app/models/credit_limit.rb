class CreditLimit < ApplicationRecord
  include LiveMonitor

  validates_numericality_of :credit_limit, greater_than_or_equal_to: 0
  #validates_numericality_of :market_limit, greater_than_or_equal_to: 0
  validates_presence_of :credit_limit
  belongs_to :buyer, class_name: 'Company', foreign_key: 'buyer_id'
  has_paper_trail
  belongs_to :seller, class_name: 'Company', foreign_key: 'seller_id'
  #validate :verify_market_limit_is_greater_than_or_equal_to_credit_limit?

  def verify_market_limit_is_greater_than_or_equal_to_credit_limit?
    errors.add(:market_limit, 'Should be greater than credit limit') if credit_limit.to_f > market_limit.to_f
  end

  rails_admin do
    configure :versions do
      label "Versions"
    end
  end

end
