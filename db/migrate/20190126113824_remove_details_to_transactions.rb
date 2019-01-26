class RemoveDetailsToTransactions < ActiveRecord::Migration[5.1]
  def change
    remove_column :transactions, :seller_reject, :boolean
    remove_column :transactions, :seller_confirmed, :boolean
  end
end
