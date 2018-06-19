class ChangeColumnNameBlockUserTable < ActiveRecord::Migration[5.1]
  def change
    rename_column :block_users, :customer_id, :company_id
    rename_column :block_users, :block_user_ids, :block_company_ids
  end
end
