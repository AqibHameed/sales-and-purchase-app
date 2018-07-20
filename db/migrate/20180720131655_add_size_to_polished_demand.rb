class AddSizeToPolishedDemand < ActiveRecord::Migration[5.1]
  def change
  	add_column :polished_demands, :size, :integer
  	add_column :trading_parcels, :size, :integer
  end
end
