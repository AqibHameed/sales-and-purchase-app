class CreateStoneDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :stone_details do |t|
      t.integer :stone_id
      t.integer :tender_id
      t.integer :customer_id
      t.text :description
      t.decimal :weight, precision: 16, scale: 2
      t.string :color_mechine
      t.string :color_eye
      t.string :fluorescence
      t.string :tention

      t.timestamps
    end
  end
end
