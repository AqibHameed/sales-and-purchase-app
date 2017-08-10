class AddColumnIntoAuctionRounds < ActiveRecord::Migration[5.1]
  def change
    add_column :auction_rounds, :completed, :boolean, default: false
    add_column :auction_rounds, :started_at, :datetime
    add_column :auctions, :started, :boolean, default: false
    add_column :auctions, :completed, :boolean, default: false
  end
end
