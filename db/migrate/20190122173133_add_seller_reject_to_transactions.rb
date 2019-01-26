class AddSellerRejectToTransactions < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :seller_reject, :boolean, default: false
  end
end
