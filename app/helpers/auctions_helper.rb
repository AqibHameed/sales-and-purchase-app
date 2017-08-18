module AuctionsHelper

  def auction_for_stone_completed? stone
    winner_for_stone(stone).present?
  end

  def can_user_place_bid? stone
    looser_for_stone(stone).blank? rescue true
  end

  def is_disable? stone
    looser_for_stone(stone).present? || winner_for_stone(stone).present?
  end

  def last_bid_amount stone
    (looser_for_stone(stone).try(:bid).try(:total) || winner_for_stone(stone).try(:bid).try(:total)) if is_disable?(stone)
  end

  def looser_for_stone stone
    @auction.round_loosers.where(stone_id: stone.id, customer_id: current_customer.id).try(:last)
  end

  def user_loose_auction_for_stone? stone
    looser_for_stone(stone).present?
  end

  def user_win_auction_for_stone? stone
  	winner_for_stone(stone).present?
  end	

  def winner_for_stone stone
    @auction.round_winners.where(stone_id: stone.id, customer_id: current_customer.id).try(:last)
  end
end
