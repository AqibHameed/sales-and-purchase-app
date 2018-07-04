class RenameColumnToPartialPayment < ActiveRecord::Migration[5.1]
  def change
    rename_column :partial_payments, :customer_id, :company_id
  end
end
