class AddBrokerIdsToParcels < ActiveRecord::Migration[5.1]
  def change
    add_column :trading_parcels, :broker_ids, :text
  end
end
