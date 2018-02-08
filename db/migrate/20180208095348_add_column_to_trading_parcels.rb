class AddColumnToTradingParcels < ActiveRecord::Migration[5.1]
  def change
    add_column :trading_parcels, :sale_all, :boolean, default: false
    add_column :trading_parcels, :sale_none, :boolean, default: true
    add_column :trading_parcels, :sale_broker, :boolean, default: false
    add_column :trading_parcels, :sale_credit, :boolean, default: false
    add_column :trading_parcels, :sale_demanded, :boolean, default: false
    # remove_column :trading_parcels, :for_sale
  end
end
