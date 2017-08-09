class Auction < ApplicationRecord

  has_many :auction_rounds
  belongs_to :tender
end
