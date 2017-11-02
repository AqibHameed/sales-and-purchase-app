class AddColumnAuctionIdIntoRoundLoosers < ActiveRecord::Migration[5.1]
  def change
    add_column :round_loosers, :auction_id, :integer
    add_column :round_winners, :auction_id, :integer
  end
end
