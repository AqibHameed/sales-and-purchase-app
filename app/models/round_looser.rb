class RoundLooser < ApplicationRecord
  belongs_to :auction_round
  belongs_to :bid
  belongs_to :customer
  belongs_to :stone
end
