class CreateCreditRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :credit_requests do |t|
      t.integer :customer_id
      t.integer :buyer_id
      t.integer :parent_id
      t.integer :limit
      t.boolean :approve

      t.timestamps
    end
  end
end
