class CreateParcelImages < ActiveRecord::Migration[5.1]
  def change
    create_table :parcel_images do |t|
      t.integer :parcel_id 
      t.attachment :image
      t.timestamps
    end
  end
end
