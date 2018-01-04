class ChangeColumnsToTransactions < ActiveRecord::Migration[5.1]
  def change
  	rename_column :transactions, :buyer_rejected, :buyer_confirmed
  end
end
