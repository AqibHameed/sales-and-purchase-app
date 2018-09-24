class AddCancelToTransactions < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :cancel, :boolean, default: false
  end
end
