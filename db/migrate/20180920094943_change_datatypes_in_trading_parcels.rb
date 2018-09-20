class ChangeDatatypesInTradingParcels < ActiveRecord::Migration[5.1]
  def change
    change_column :trading_parcels, :price, :decimal,  precision: 12, scale: 2
    change_column :trading_parcels, :total_value, :decimal,  precision: 12, scale: 2
    change_column :trading_parcels, :cost, :decimal,  precision: 12, scale: 2
  end
end
