class AddActivityBoughtToSecureCenters < ActiveRecord::Migration[5.1]
  def change
    add_column :secure_centers, :activity_bought, :decimal
  end
end
