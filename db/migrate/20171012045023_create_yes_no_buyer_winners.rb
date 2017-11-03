class CreateYesNoBuyerWinners < ActiveRecord::Migration[5.1]
  def self.up
    create_table :yes_no_buyer_winners do |t|
      t.references :tender
	  t.references :stone
	  t.references :sight
	  t.references :customer
	  t.references :yes_no_buyer_interest
	  t.datetime :bid_open_time
      t.datetime :bid_close_time
      t.integer :round
	  t.string :winning_price
	  t.timestamps
    end
  end
  def self.down
    drop_table :yes_no_buyer_winners do |t|
      t.references :tender
	  t.references :stone
	  t.references :sight
	  t.references :customer
	  t.references :yes_no_buyer_interest
	  t.datetime :bid_open_time
      t.datetime :bid_close_time
      t.integer :round
	  t.string :winning_price
	  t.timestamps
    end
  end
end
