class AddColumnToStonesSights < ActiveRecord::Migration[5.1]
  def change
  	add_column :stones, :status, :integer, default: 0
  	add_column :sights, :status, :integer, default: 0 
  end
end
