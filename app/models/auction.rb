class Auction < ApplicationRecord

  has_many :auction_rounds
  has_many :round_loosers
  has_many :round_winners
  belongs_to :tender

  def current_auction_round
    self.auction_rounds.where(completed: false).first_or_initialize
  end

  def make_it_completed
    self.update(completed: true)
  end

  def make_it_started
    self.update(started: true)
  end
end
