class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.integer :tender_id
      t.integer :customer_id
      t.string :key
      t.text :note

      t.timestamps
    end
  end
end
