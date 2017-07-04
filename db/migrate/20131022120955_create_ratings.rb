class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :tender_id
      t.integer :customer_id
      t.string :key
      t.integer :score

      t.timestamps
    end
  end
end
