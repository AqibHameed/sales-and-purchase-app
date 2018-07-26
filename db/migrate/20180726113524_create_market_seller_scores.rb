class CreateMarketSellerScores < ActiveRecord::Migration[5.1]
  def change
    create_table :market_seller_scores do |t|
      t.float :late_payment, null: false, default: '0.00'
      t.float :current_risk, null: false, default: '0.00'
      t.float :network_diversity, null: false, default: '0.00'
      t.float :seller_network, null: false, default: '0.00'
      t.float :due_date, null: false, default: '0.00'
      t.float :credit_used, null: false, default: '0.00'
      t.timestamps
    end
  end
end
