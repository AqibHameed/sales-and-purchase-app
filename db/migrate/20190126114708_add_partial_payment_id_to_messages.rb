class AddPartialPaymentIdToMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :partial_payment_id, :integer
  end
end
