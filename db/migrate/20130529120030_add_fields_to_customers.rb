class AddFieldsToCustomers < ActiveRecord::Migration[5.1]
  def change
    add_column :customers, :first_name, :string
    add_column :customers, :last_name, :string
    add_column :customers, :city, :string
    add_column :customers, :address, :string
    add_column :customers, :postal_code, :string
    add_column :customers, :phone, :string
    add_column :customers, :status, :boolean
  end
end

