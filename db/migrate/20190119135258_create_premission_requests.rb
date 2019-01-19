class CreatePremissionRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :premission_requests do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.integer :status, default: 2
      t.boolean :live_monitor
      t.boolean :secure_center
      t.boolean :buyer_score
      t.boolean :seller_score
      t.boolean :customer_info

      t.timestamps
    end
  end
end
