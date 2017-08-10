class CreateRoundLoosers < ActiveRecord::Migration[5.1]
  def change
    create_table :round_loosers do |t|
      t.integer :stone_id
      t.integer :customer_id
      t.integer :bid_id
      t.integer :auction_round_id

      t.timestamps
    end
  end
end
