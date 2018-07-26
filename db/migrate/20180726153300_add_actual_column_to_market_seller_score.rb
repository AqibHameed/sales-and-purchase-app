class AddActualColumnToMarketSellerScore < ActiveRecord::Migration[5.1]
  def change
    add_column :market_seller_scores, :actual, :boolean, null: false, default: 0
  end
end
