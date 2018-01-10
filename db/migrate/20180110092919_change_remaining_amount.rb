class ChangeRemainingAmount < ActiveRecord::Migration[5.1]
  def change
  	change_column :transactions, :remaining_amount, :decimal, :precision => 16, :scale => 2
  	change_column :transactions, :total_amount, :decimal, :precision => 16, :scale => 2
  end
end
