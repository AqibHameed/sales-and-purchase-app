class AddBuyerRejectToTransactions < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :buyer_reject, :boolean, default: false
  end
end
