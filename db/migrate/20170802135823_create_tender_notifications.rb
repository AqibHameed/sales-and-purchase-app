class CreateTenderNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :tender_notifications do |t|
      t.integer :customer_id
      t.integer :tender_id
      t.boolean :notify
      t.timestamps
    end
  end
end
