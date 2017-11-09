class ChangeColumnToTransaction < ActiveRecord::Migration[5.1]
  def change
  	add_column :transactions, :total_amount, :decimal
  	rename_column :transactions, :amount, :remaining_amount
  end
end
