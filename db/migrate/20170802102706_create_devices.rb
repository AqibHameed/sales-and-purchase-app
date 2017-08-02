class CreateDevices < ActiveRecord::Migration[5.1]
  def change
    create_table :devices do |t|
      t.integer :customer_id
      t.string :token
      t.string :type
      t.timestamps
    end
  end
end
