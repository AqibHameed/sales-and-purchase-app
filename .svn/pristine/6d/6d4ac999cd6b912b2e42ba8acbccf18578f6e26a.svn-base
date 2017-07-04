class CreateStones < ActiveRecord::Migration
  def change
    create_table :stones do |t|
      t.string :stone_type
      t.integer :no_of_stones
      t.float :size
      t.float :weight
      t.float :carat
      t.float :purity
      t.string :color
      t.boolean :polished
      t.references :tender

      t.timestamps
    end
  end
end

