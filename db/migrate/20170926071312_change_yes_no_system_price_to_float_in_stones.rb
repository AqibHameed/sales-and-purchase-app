class ChangeYesNoSystemPriceToFloatInStones < ActiveRecord::Migration[5.1]
  def change
  	change_column :stones, :yes_no_system_price, :float
  end
end
