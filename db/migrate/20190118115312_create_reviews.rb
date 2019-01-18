class CreateReviews < ActiveRecord::Migration[5.1]
  def change
    create_table :reviews do |t|
      t.boolean :know
      t.boolean :trade
      t.boolean :recommend
      t.boolean :experience
      t.integer :customer_id
      t.integer :company_id

      t.timestamps
    end
  end
end
