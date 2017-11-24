class AddPlaceBidToYesNoBuyerInterests < ActiveRecord::Migration[5.1]
  def change
  	add_column :yes_no_buyer_interests, :place_bid, :integer, default: 1
  end
end
