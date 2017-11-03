class AddReservedPriceToStones < ActiveRecord::Migration[5.1]
  def up
    add_column :stones, :reserved_price, :integer
  end
  def down
    remove_column :stones, :reserved_price, :integer
  end
end
