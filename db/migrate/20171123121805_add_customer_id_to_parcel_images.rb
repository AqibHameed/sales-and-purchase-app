class AddCustomerIdToParcelImages < ActiveRecord::Migration[5.1]
  def change
  	add_column :parcel_images, :customer_id, :integer
  end
end
