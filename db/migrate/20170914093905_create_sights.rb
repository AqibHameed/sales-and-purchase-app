class CreateSights < ActiveRecord::Migration[5.1]
  def change
    create_table :sights do |t|
      t.string :stone_type
      t.string :source
      t.string :box
      t.integer :carats
      t.integer :cost
      t.integer :box_value_from
      t.integer :box_value_to
      t.string :sight
      t.integer :price
      t.integer :credit

      t.timestamps
    end
  end
end
