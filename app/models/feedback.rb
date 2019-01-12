class Feedback < ApplicationRecord
  belongs_to :customer
  belongs_to :trading_parcel, optional: true
  belongs_to :credit_limit, optional: true
  belongs_to :proposal, optional: true
  belongs_to :demand, optional: true
  belongs_to :partial_payment, optional: true

  validates :star, :presence => true
end
