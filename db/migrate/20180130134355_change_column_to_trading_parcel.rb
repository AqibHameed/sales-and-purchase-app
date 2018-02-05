class ChangeColumnToTradingParcel < ActiveRecord::Migration[5.1]
  def change
  	remove_column :trading_parcels, :for_sale
  	add_column :trading_parcels, :for_sale, :integer, default: 1
  end
end
