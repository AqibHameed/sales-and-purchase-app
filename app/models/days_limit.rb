class DaysLimit < ApplicationRecord
  include LiveMonitor
  validates_numericality_of :days_limit
  has_paper_trail
  belongs_to :buyer, class_name: 'Company', foreign_key: 'buyer_id'
  belongs_to :seller, class_name: 'Company', foreign_key: 'seller_id'

  rails_admin do
    configure :versions do
      label "Versions"
    end
  end
end
