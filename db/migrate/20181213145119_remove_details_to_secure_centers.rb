class RemoveDetailsToSecureCenters < ActiveRecord::Migration[5.1]
  def change
    remove_column :secure_centers, :late_days, :integer
    remove_column :secure_centers, :buyer_days_limit, :integer
    remove_column :secure_centers, :market_limit, :decimal
    remove_column :secure_centers, :given_credit_limit, :decimal
    remove_column :secure_centers, :given_market_limit, :decimal
    remove_column :secure_centers, :given_overdue_limit, :decimal
    remove_column :secure_centers, :supplier_unpaid, :integer
    remove_column :secure_centers, :percentage, :decimal
    remove_column :secure_centers, :activity_bought, :decimal
  end
end
