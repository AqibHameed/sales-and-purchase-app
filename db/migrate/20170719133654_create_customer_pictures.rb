class CreateCustomerPictures < ActiveRecord::Migration[5.1]
  def change
    create_table :customer_pictures do |t|
      t.attachment :picture
      t.references :customer
      t.references :tender
      t.timestamps
    end
  end
end
