class AddPaymentConfirmToPartialPayments < ActiveRecord::Migration[5.1]
  def change
    add_column :partial_payments, :payment_status, :integer, default: 2
  end
end
