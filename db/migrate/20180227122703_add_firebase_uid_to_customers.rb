class AddFirebaseUidToCustomers < ActiveRecord::Migration[5.1]
  def change
    add_column :customers, :firebase_uid, :string
  end
end
