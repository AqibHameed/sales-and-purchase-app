module AuctionsHelper

  def can_user_place_bid? stone
    @auction.round_loosers.where(stone_id: stone.id, customer_id: current_customer.id).blank? rescue true
  end

  def user_loose_auction_for_stone? stone
    @auction.round_loosers.where(stone_id: stone.id, customer_id: current_customer.id).present?
  end

  def user_win_auction_for_stone? stone
  	@auction.round_winners.where(stone_id: stone.id, customer_id: current_customer.id).present?
  end	
end
