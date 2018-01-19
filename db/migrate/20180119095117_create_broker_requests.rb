class CreateBrokerRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :broker_requests do |t|
      t.integer :broker_id
      t.integer :seller_id
      t.boolean :accepted
      t.timestamps
    end
  end
end
