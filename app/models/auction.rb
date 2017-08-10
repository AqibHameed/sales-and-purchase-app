class Auction < ApplicationRecord

  has_many :auction_rounds
  belongs_to :tender

  def current_auction_round
    self.auction_rounds.where(completed: false).last
  end
end
