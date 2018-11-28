class AddPercentageToSecureCenters < ActiveRecord::Migration[5.1]
  def change
    add_column :secure_centers, :percentage, :decimal, default: 0
  end
end
