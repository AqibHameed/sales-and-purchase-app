class AddDetailsToPartialPayments < ActiveRecord::Migration[5.1]
  def change
    add_column :partial_payments, :seller_reject, :boolean
    add_column :partial_payments, :seller_confirmed, :boolean
  end
end
