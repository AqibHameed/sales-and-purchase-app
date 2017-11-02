class AddSystemPriceAndOptionToStone < ActiveRecord::Migration[5.1]
  def change
    add_column :stones, :system_price, :float
    add_column :stones, :lot_permission, :boolean
  end
end
