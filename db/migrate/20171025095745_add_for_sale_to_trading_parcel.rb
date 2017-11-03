class AddForSaleToTradingParcel < ActiveRecord::Migration[5.1]
  def change
    add_column :trading_parcels, :for_sale, :boolean, default: false
  end
end
