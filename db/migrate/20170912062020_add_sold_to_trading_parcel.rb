class AddSoldToTradingParcel < ActiveRecord::Migration[5.1]
  def change
  	add_column :trading_parcels, :sold, :boolean, default: false
  end
end
