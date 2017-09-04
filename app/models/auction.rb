class Auction < ApplicationRecord

  has_many :auction_rounds
  has_many :round_loosers
  has_many :round_winners
  belongs_to :tender

  def current_auction_round
    round = self.auction_rounds.where(completed: false).try(:last)
    round = auction_rounds.create() if round.blank?
    round
  end

  def is_in_process?
    started && !completed
  end

  def is_ready_to_start?
    !started && (time <= Time.now)
  end

  def last_round
    auction_rounds.where(completed: true).sort_by(&:created_at).last
  end

  # def is_last_round_completed?
  #   auction_rounds.sort_by(&:round_no).try(:last).try(:completed)
  # end

  def make_it_completed
    self.update(completed: true)
  end

  def make_it_started
    self.update(started: true)
  end

end
