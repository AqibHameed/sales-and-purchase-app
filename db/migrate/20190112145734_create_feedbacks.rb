class CreateFeedbacks < ActiveRecord::Migration[5.1]
  def change
    create_table :feedbacks do |t|
      t.integer :star
      t.text :comment
      t.integer :demand_id
      t.integer :trading_parcel_id
      t.integer :partial_payment_id
      t.integer :proposal_id
      t.integer :credit_limit_id
      t.integer :customer_id

      t.timestamps
    end
  end
end
