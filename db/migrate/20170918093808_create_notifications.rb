class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.string :title
      t.text :description
      t.references :tender
      t.references :customer
      t.timestamps
    end
  end
end