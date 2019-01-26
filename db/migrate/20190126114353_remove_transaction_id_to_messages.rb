class RemoveTransactionIdToMessages < ActiveRecord::Migration[5.1]
  def change
    remove_column :messages, :transaction_id, :integer
  end
end
