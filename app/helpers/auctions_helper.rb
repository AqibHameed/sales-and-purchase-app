module AuctionsHelper

  def can_user_place_bid? stone
     @last_round.present? ? @auction.round_loosers.where(stone_id: stone.id, customer_id: current_customer.id).blank? : true
  end
end
