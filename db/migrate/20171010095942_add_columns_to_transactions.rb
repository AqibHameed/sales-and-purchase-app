class AddColumnsToTransactions < ActiveRecord::Migration[5.1]
  def change
  	add_column :transactions, :buyer_rejected, :boolean, default: false
  	add_column :transactions, :reject_reason, :text
  	add_column :transactions, :reject_date, :datetime
  	add_column :transactions, :transaction_type, :string
  end
end
