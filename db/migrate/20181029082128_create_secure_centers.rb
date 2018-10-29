class CreateSecureCenters < ActiveRecord::Migration[5.1]
  def change
    create_table :secure_centers do |t|
      t.integer :seller_id
      t.integer :buyer_id
      t.integer :invoices_overdue
      t.date :paid_date
      t.integer :late_days
      t.integer :buyer_days_limit
      t.decimal :market_limit
      t.integer :supplier_connected
      t.decimal :outstandings
      t.decimal :overdue_amount
      t.decimal :given_credit_limit
      t.decimal :given_market_limit
      t.decimal :given_overdue_limit
      t.date :last_bought_on

      t.timestamps
    end
  end
end
