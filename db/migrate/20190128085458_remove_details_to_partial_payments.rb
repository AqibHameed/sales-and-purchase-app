class RemoveDetailsToPartialPayments < ActiveRecord::Migration[5.1]
  def change
    remove_column :partial_payments, :seller_reject, :boolean
    remove_column :partial_payments, :seller_confirmed, :boolean
  end
end
