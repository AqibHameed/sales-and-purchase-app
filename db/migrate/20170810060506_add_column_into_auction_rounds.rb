class AddColumnIntoAuctionRounds < ActiveRecord::Migration[5.1]
  def change
    add_column :auction_rounds, :completed, :boolean, default: false
  end
end
