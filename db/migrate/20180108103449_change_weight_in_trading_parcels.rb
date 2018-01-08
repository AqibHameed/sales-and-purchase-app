class ChangeWeightInTradingParcels < ActiveRecord::Migration[5.1]
  def change
  	change_column :trading_parcels, :weight, :decimal, :precision => 16, :scale => 2
  end
end
