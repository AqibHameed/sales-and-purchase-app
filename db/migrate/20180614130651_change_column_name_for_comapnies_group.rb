class ChangeColumnNameForComapniesGroup < ActiveRecord::Migration[5.1]
  def change
    rename_column :companies_groups, :customer_id, :company_id
  end
end
