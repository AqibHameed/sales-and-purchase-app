class CreateHistoricalRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :historical_records do |t|
      t.integer :seller_id
      t.integer :buyer_id
      t.integer :total_limit
      t.integer :market_limit
      t.integer :overdue_limit
      t.date :date

      t.timestamps
    end
  end
end
