class CreateCustomerNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :customer_notifications do |t|
      t.references :customer
      t.references :notification
      t.timestamps
    end
  end
end
