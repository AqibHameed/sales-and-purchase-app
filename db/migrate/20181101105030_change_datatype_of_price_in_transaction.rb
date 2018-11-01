class ChangeDatatypeOfPriceInTransaction < ActiveRecord::Migration[5.1]
  def change
  	change_column :transactions, :price, :decimal,  precision: 12, scale: 2
  end
end
