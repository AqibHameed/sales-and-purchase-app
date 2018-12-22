class AddDeletedAtToTradingParcel < ActiveRecord::Migration[5.1]
  def change
    add_column :trading_parcels, :deleted_at, :datetime
    add_index :trading_parcels, :deleted_at
    add_column :customers, :deleted_at, :datetime
    add_index :customers, :deleted_at
    add_column :companies, :deleted_at, :datetime
    add_index :companies, :deleted_at
    add_column :proposals, :deleted_at, :datetime
    add_index :proposals, :deleted_at
    add_column :parcel_size_infos, :deleted_at, :datetime
    add_index :parcel_size_infos, :deleted_at
    add_column :transactions, :deleted_at, :datetime
    add_index :transactions, :deleted_at
    add_column :trading_documents, :deleted_at, :datetime
    add_index :trading_documents, :deleted_at
  end
end
