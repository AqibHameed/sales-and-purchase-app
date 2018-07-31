class AddActualColumnToMarketBuyerScore < ActiveRecord::Migration[5.1]
  def change
    add_column :market_buyer_scores, :actual, :boolean, null: false, default: 0
  end
end
