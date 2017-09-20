class CreateSupplierNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :supplier_notifications do |t|
      t.integer :supplier_id
      t.references :customer
      t.boolean :notify
      t.timestamps
    end
  end
end
