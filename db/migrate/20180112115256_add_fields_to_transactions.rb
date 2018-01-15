class AddFieldsToTransactions < ActiveRecord::Migration[5.1]
  def change
  	add_column :transactions, :invoice_no, :string
  	add_column :transactions, :ready_for_buyer, :boolean
  end
end
