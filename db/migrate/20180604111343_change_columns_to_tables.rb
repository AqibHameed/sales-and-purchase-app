class ChangeColumnsToTables < ActiveRecord::Migration[5.1]
  def change
    rename_column :credit_limits, :supplier_id, :seller_id
    rename_column :days_limits, :supplier_id, :seller_id
    rename_column :transactions, :supplier_id, :seller_id
    rename_column :proposals, :supplier_id, :seller_id
    rename_column :supplier_mines, :company_id, :supplier_id
    rename_column :tenders, :company_id, :supplier_id
  end
end
