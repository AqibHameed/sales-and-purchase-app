class ChangeStoneWinningPriceToFloatInStones < ActiveRecord::Migration[5.1]
  def change
  	change_column :stones, :stone_winning_price, :float
  end
end
