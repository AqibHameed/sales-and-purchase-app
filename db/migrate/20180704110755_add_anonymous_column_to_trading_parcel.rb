class AddAnonymousColumnToTradingParcel < ActiveRecord::Migration[5.1]
  def change
    add_column :trading_parcels, :anonymous, :boolean, :default => false
  end
end
