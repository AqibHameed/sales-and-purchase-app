class ChangeOutstandingScaleInMySecureCenter < ActiveRecord::Migration[5.1]
  def change
    change_column :secure_centers, :market_limit, :decimal, precision: 10, scale: 2
    change_column :secure_centers, :overdue_amount, :decimal, precision: 10, scale: 2
    change_column :secure_centers, :outstandings, :decimal, precision: 10, scale: 2
    change_column :secure_centers, :given_credit_limit, :decimal, precision: 10, scale: 2
    change_column :secure_centers, :given_market_limit, :decimal, precision: 10, scale: 2
    change_column :secure_centers, :given_overdue_limit, :decimal, precision: 10, scale: 2
    change_column :secure_centers, :percentage, :decimal, precision: 10, scale: 2
    change_column :secure_centers, :activity_bought, :decimal, precision: 10, scale: 2
    change_column :secure_centers, :buyer_percentage, :decimal, precision: 10, scale: 2
    change_column :secure_centers, :system_percentage, :decimal, precision: 10, scale: 2
  end
end