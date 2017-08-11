class Auction < ApplicationRecord

  has_many :auction_rounds
  belongs_to :tender

  def current_auction_round
    self.auction_rounds.where(completed: false).first_or_initialize
  end

  def make_it_completed
    self.update(complete: true)
  end

  def make_it_started
    self.update(started: true)
  end
end
