class ChangeColumnToCompaniesGroup < ActiveRecord::Migration[5.1]
  def change
  	change_column :companies_groups, :customer_id, :text
  end
end
