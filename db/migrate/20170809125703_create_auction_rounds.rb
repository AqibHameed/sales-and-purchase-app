class CreateAuctionRounds < ActiveRecord::Migration[5.1]
  def change
    create_table :auction_rounds do |t|
      t.integer :round_no
      t.float :min_bid
      t.float :max_bid
      t.integer :auction_id

      t.timestamps
    end
  end
end
