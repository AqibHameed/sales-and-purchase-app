class AddDetailsToSecureCenters < ActiveRecord::Migration[5.1]
  def change
    add_column :secure_centers, :buyer_percentage, :decimal, default: 0
    add_column :secure_centers, :system_percentage, :decimal, default: 0
  end
end
