class AddColumnScoresToSecureCenter < ActiveRecord::Migration[5.1]
  def change
    add_column :secure_centers, :payment_score, :float
    add_column :secure_centers, :market_payment_score, :float
    add_column :secure_centers, :collection_ratio_days, :float
  end
end
