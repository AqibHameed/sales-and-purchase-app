class AddDiamondTypeToTradingParcel < ActiveRecord::Migration[5.1]
  def change
    add_column :trading_parcels, :diamond_type, :string
  end
end
