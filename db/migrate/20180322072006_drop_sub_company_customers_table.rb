class DropSubCompanyCustomersTable < ActiveRecord::Migration[5.1]
  def change
    drop_table :sub_company_customers
  end
end
