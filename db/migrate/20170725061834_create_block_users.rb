class CreateBlockUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :block_users do |t|
      t.integer :customer_id
      t.string :block_user_ids
      t.timestamps
    end
  end
end
