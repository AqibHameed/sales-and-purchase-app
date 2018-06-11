class ChangeColumnToCustomers < ActiveRecord::Migration[5.1]
  def change
  	rename_column :customers, :company, :company_id
  	change_column :customers, :company_id, :integer
  end
end
