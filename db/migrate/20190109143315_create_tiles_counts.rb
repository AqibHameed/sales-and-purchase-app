class CreateTilesCounts < ActiveRecord::Migration[5.1]
  def change
    create_table :tiles_counts do |t|
      t.integer :smart_search, default: 0
      t.integer :sell, default: 0
      t.integer :inbox, default: 0
      t.integer :history, default: 0
      t.integer :live_monitor, default: 0
      t.integer :public_channels, default: 0
      t.integer :feedback, default: 0
      t.integer :share_app, default: 0
      t.integer :invite, default: 0
      t.integer :current_tenders, default: 0
      t.integer :upcoming_tenders, default: 0
      t.integer :protection, default: 0
      t.integer :record_sale, default: 0
      t.integer :past_tenders, default: 0
      t.integer :customer_id

      t.timestamps
    end
    add_index :tiles_counts, :customer_id
  end
end
