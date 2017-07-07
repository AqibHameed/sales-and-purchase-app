class CreateTenders < ActiveRecord::Migration[5.1]
  def change
    create_table :tenders do |t|
      t.string :name
      t.text :description
      t.datetime :open_date
      t.datetime :close_date
      t.boolean :tender_open

      t.timestamps
    end
  end
end

