class CreateRoundWinners < ActiveRecord::Migration[5.1]
  def change
    create_table :round_winners do |t|
      t.integer :customer_id
      t.integer :auction_round_id
      t.integer :bid_id
      t.integer :stone_id
      t.timestamps
    end
  end
end
