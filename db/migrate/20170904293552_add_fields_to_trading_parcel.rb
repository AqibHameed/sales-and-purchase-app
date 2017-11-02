class AddFieldsToTradingParcel < ActiveRecord::Migration[5.1]
  def change
    add_column :trading_parcels, :cost, :integer
    add_column :trading_parcels, :box_value, :string
    add_column :trading_parcels, :sight, :string
  end
end
