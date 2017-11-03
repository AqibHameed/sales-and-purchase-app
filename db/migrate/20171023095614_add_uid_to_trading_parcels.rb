class AddUidToTradingParcels < ActiveRecord::Migration[5.1]
  def change
  	add_column :trading_parcels, :uid, :string
  end
end
