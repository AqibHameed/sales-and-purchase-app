class AddAnonymousColumnToTradingParcel < ActiveRecord::Migration[5.1]
  def change
  	add_column :trading_parcels, :shape, :string
    add_column :trading_parcels, :color, :string
    add_column :trading_parcels, :clarity, :string
    add_column :trading_parcels, :cut, :string
    add_column :trading_parcels, :polish, :string
    add_column :trading_parcels, :symmetry, :string
    add_column :trading_parcels, :fluorescence, :string
    add_column :trading_parcels, :lab, :string
    add_column :trading_parcels, :city, :string
    add_column :trading_parcels, :country, :string
    add_column :trading_parcels, :anonymous, :boolean, :default => false
    add_column :companies, :is_anonymous, :boolean, :default => false
    add_column :companies, :add_polished, :boolean, :default => false
  end
end
