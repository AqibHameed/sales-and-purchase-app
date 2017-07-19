class CreateCustomerRatings < ActiveRecord::Migration[5.1]
  def change
    create_table :customer_ratings do |t|
      t.integer :star
      t.references :customer
      t.references :tender
      t.timestamps
    end
  end
end
