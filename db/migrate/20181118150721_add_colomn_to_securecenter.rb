class AddColomnToSecurecenter < ActiveRecord::Migration[5.1]
  def change
    rename_column :secure_centers, :supplier_connected, :supplier_paid
    add_column :secure_centers, :supplier_unpaid, :integer, default: 0
  end
end
