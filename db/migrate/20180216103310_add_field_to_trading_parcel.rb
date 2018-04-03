class AddFieldToTradingParcel < ActiveRecord::Migration[5.1]
  def change
  	add_column :trading_parcels, :percent, :decimal, :precision => 16, :scale => 2
  end
end
