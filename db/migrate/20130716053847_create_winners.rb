class CreateWinners < ActiveRecord::Migration
  def change
    create_table :winners do |t|
      t.references :tender
      t.references :customer
      t.references :bid
      t.references :stone

      t.timestamps
    end
  end
end

