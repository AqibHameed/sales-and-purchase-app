class Auction < ApplicationRecord

  has_many :auction_rounds
  has_many :round_loosers
  has_many :round_winners
  belongs_to :tender

  def current_auction_round
    round = auction_rounds.where(completed: false).try(:last)
    round = auction_rounds.create() if round.blank?
    round
  end

  def current_round_no
    try(:current_auction_round).try(:round_no).to_i
  end

  def is_in_process?
    started && !completed
  end

  def is_ready_to_start?
    !started && (time <= Time.current)
  end

  def last_round
    auction_rounds.where(completed: true).sort_by(&:round_no).try(:last)
  end

  def make_it_completed
    update(completed: true)
  end

  def make_it_started
    update(started: true)
  end

  def second_last_round last_round
    auction_rounds.where(round_no: last_round.round_no.to_i-1).try(:first)
  end

  def highest_bids_for_stone stone_id
    @bids = Bid.joins(auction_round: :auction).where('auctions.id': id, 'stone_id': stone_id)
  end

  def highest_bid_for_stone stone_id
    @bids.group_by(&:total).try(:sort).try(:reverse).to_h.try(:first).try(:second).sort_by(&:created_at).try(:first) if highest_bids_for_stone(stone_id).present?
  end
end
