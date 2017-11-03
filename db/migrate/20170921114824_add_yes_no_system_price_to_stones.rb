class AddYesNoSystemPriceToStones < ActiveRecord::Migration[5.1]
  def up
    add_column :stones, :yes_no_system_price, :integer
    add_column :stones, :stone_winning_price, :integer
  end
  def down
  	remove_column :stones, :yes_no_system_price, :integer
    remove_column :stones, :stone_winning_price, :integer
  end
end
