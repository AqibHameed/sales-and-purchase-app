class AddTotalValueToTradingParcels < ActiveRecord::Migration[5.1]
  def change
    add_column :trading_parcels, :total_value, :integer
  end
end
