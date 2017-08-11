module AuctionsHelper

  def can_user_place_bid? stone
    return @last_round.round_loosers.where(stone_id: stone.id, customer_id: current_customer.id).blank? if @last_round.present?
    return true
  end
end
