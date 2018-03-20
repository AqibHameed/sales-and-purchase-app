class CreateSubCompanyCustomers < ActiveRecord::Migration[5.1]
  def change
    create_table :sub_company_customers do |t|
      t.integer :sub_company_credit_limit_id
      t.integer :customer_id
      t.integer :credit_limit
      t.timestamps
    end
  end
end
