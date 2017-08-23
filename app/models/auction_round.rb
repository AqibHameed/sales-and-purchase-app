class AuctionRound < ApplicationRecord

  has_many :bids
  has_many :round_loosers
  has_many :round_winners
  belongs_to :auction

  after_create :add_round_no

  def add_round_looser bid
    self.round_loosers.create(stone_id: bid.stone_id, customer_id: bid.customer_id, bid_id: bid.id, auction_id: self.auction.id).save
  end

  def add_round_winner bid
    self.round_winners.create(stone_id: bid.stone_id, customer_id: bid.customer_id, bid_id: bid.id, auction_id: self.auction.id).save
  end

  def add_round_no
    self.update(round_no: self.auction.auction_rounds.count)    
  end

  def current_customer_bid_on_stone customer, stone_id
    self.bids.where(customer_id: customer.id, stone_id: stone_id).first_or_initialize
  end
end
