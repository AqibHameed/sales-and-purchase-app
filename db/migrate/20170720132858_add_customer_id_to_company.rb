class AddCustomerIdToCompany < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :customer_id, :integer
  end
end
