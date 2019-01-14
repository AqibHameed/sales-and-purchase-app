class AddTransactionIdToMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :transaction_id, :integer
  end
end
