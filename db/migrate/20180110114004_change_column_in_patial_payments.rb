class ChangeColumnInPatialPayments < ActiveRecord::Migration[5.1]
  def change
  	change_column :partial_payments, :amount, :decimal, :precision => 16, :scale => 2
  end
end
