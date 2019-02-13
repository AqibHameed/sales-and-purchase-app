class CreateWishLists < ActiveRecord::Migration[5.1]
  def change
    create_table :wish_lists do |t|
      t.boolean :wish_status, default: false
      t.integer :stone_id
      t.integer :customer_id

      t.timestamps
    end
  end
end
