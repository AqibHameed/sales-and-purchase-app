class AuctionRound < ApplicationRecord

  has_many :bids

  after_create :add_round_no

  def add_round_no
    self.update(round_no: self.auction.auction_rounds.count)    
  end

  def current_customer_bid_on_stone customer, stone_id
    self.bids.where(customer_id: customer.id, stone_id: stone_id).first_or_initialize
  end
end
