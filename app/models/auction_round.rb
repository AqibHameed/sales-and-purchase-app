class AuctionRound < ApplicationRecord

  has_many :bids
  has_many :round_loosers
  has_many :round_winners
  belongs_to :auction

  before_validation :add_round_no
  validate :uniq_round_no_for_auction, :check_last_round_completion, :auction_not_completed

  default_scope { where.not(id: nil) }

  def add_round_looser bid
    self.round_loosers.create(stone_id: bid.stone_id, customer_id: bid.customer_id, bid_id: bid.id, auction_id: self.auction.id).save
  end

  def add_round_no
    self.round_no = self.auction.auction_rounds.sort_by(&:round_no).try(:last).try(:round_no).to_i+1 if self.round_no.blank?
  end

  def add_round_winner bid
    self.round_winners.create(stone_id: bid.stone_id, customer_id: bid.customer_id, bid_id: bid.id, auction_id: self.auction.id).save
  end

  def auction_not_completed
    errors.add(:auction_round, "Auction completed!") if self.auction.completed
  end

  def check_last_round_completion
    status = auction.auction_rounds.where(round_no: self.round_no-1).try(:last).try(:completed)
    return true if status.nil?
    errors.add(:auction_round, "Last auction not completed yet!") unless status
  end

  def current_customer_bid_on_stone customer, stone_id
    self.bids.where(customer_id: customer.id, stone_id: stone_id).first_or_initialize
  end

  def highest_bid_for_stone stone_id
    self.bids.where(stone_id: stone_id).sort_by(&:total).try(:last).try(:total)
  end

  def uniq_round_no_for_auction
    self.auction.auction_rounds.where(round_no: self.round_no).blank?
  end
end
