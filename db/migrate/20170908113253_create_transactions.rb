class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.integer :buyer_id
      t.integer :supplier_id
      t.integer :trading_parcel_id
      t.datetime :due_date
      t.decimal :price
      t.integer :credit
      t.boolean :paid
      t.timestamps
    end
  end
end
