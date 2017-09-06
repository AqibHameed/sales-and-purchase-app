class AddFieldsToTradingParcels < ActiveRecord::Migration[5.1]
  def change
  	add_column :trading_parcels, :source, :string
  	add_column :trading_parcels, :box, :string
  end
end
