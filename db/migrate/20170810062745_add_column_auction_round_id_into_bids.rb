class AddColumnAuctionRoundIdIntoBids < ActiveRecord::Migration[5.1]
  def change
    add_column :bids, :auction_round_id, :integer
  end
end
