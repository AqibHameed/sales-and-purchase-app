class CreateCustomerComments < ActiveRecord::Migration[5.1]
  def change
    create_table :customer_comments do |t|
      t.text :description
      t.references :customer
      t.references :tender
      t.timestamps
    end
  end
end
