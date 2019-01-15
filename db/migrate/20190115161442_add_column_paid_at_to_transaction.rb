class AddColumnPaidAtToTransaction < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :paid_at, :DateTime
    Transaction.update_all(paid_at: DateTime.now)
  end
end
