class CreateBidCalculations < ActiveRecord::Migration[5.1]
  def change
    create_table :bid_calculations do |t|
      t.integer :stone_id
      t.integer :customer_id
      t.boolean :responce
      t.integer :round
      t.float :system_price
      t.timestamps
    end
  end
end
