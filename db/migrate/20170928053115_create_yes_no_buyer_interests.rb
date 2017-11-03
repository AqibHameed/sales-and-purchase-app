class CreateYesNoBuyerInterests < ActiveRecord::Migration[5.1]
  def up
    create_table :yes_no_buyer_interests do |t|
    	t.references :tender
    	t.references :stone
    	t.references :sight
    	t.references :customer
        t.datetime :bid_open_time
        t.datetime :bid_close_time
        t.integer :round
        t.string :reserved_price
    	t.boolean :interest, :default => false
    	t.timestamps
    end
  end
  def down
    drop_table :yes_no_buyer_interests do |t|
        t.references :tender
        t.references :stone
        t.references :sight
        t.references :customer
        t.datetime :bid_open_time
        t.datetime :bid_close_time
        t.integer :round
        t.string :reserved_price
        t.boolean :interest, :default => false
        t.timestamps
    end
  end
end

  