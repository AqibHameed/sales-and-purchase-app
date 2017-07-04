class CreateTenderWinners < ActiveRecord::Migration
  def change
    create_table :tender_winners do |t|
      t.integer :tender_id
      t.integer :lot_no
      t.string :selling_price

      t.timestamps
    end
  end
end
