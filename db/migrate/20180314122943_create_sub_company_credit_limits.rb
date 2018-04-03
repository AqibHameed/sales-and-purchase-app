class CreateSubCompanyCreditLimits < ActiveRecord::Migration[5.1]
  def change
    create_table :sub_company_credit_limits do |t|
      t.integer :customer_id
      t.integer :credit_limit
      t.integer :parent_id
      t.timestamps
    end
  end
end
