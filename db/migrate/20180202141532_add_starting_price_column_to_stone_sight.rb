class AddStartingPriceColumnToStoneSight < ActiveRecord::Migration[5.1]
  def change
    add_column :stones, :starting_price, :float
    add_column :sights, :starting_price, :float
  end
end
