class AddNewFieldsToCustomers < ActiveRecord::Migration[5.1]
  def change
    add_column :customers, :company, :string
    add_column :customers, :company_address, :text
    add_column :customers, :phone_2, :string
    add_column :customers, :mobile_no, :string
  end
end
