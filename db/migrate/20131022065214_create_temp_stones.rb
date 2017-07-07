class CreateTempStones < ActiveRecord::Migration[5.1]
  def change
    create_table :temp_stones do |t|
      t.integer :tender_id
      t.integer :lot_no
      t.string :description
      t.integer :no_of_stones
      t.float :carat

      t.timestamps
    end
  end
end
