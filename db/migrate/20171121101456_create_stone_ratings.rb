class CreateStoneRatings < ActiveRecord::Migration[5.1]
  def change
    create_table :stone_ratings do |t|
      t.integer :stone_id
      t.integer :customer_id
      t.string :comments
      t.string :valuation
      t.integer :parcel_rating
      t.timestamps
    end
  end
end
