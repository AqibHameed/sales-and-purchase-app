class AuctionRound < ApplicationRecord

  has_many :bids
  has_many :round_loosers
  has_many :round_winners
  belongs_to :auction

  validates :round_no, uniqueness: { scope: :auction_id }
  
  # validate :check_last_round_completion

  before_create :add_round_no
  
  def add_round_looser bid
    self.round_loosers.create(stone_id: bid.stone_id, customer_id: bid.customer_id, bid_id: bid.id, auction_id: self.auction.id).save
  end

  def add_round_winner bid
    self.round_winners.create(stone_id: bid.stone_id, customer_id: bid.customer_id, bid_id: bid.id, auction_id: self.auction.id).save
  end

  def add_round_no
    self.round_no = self.auction.auction_rounds.count+1
  end

  # def check_last_round_completion
  #   round = auction.auction_rounds.sort_by(&:created_at).try(:last)
  #   return true if round == self
  #   errors.add(:auction_round, "Last auction not completed yet!") if round.try(:persisted?) && !round.try(:completed)
  # end

  def current_customer_bid_on_stone customer, stone_id
    self.bids.where(customer_id: customer.id, stone_id: stone_id).first_or_initialize
  end

  def highest_bid_for_stone stone_id
    self.bids.where(stone_id: stone_id).sort_by(&:total).try(:last).try(:total)
  end
end
