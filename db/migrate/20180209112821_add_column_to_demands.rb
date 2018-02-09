class AddColumnToDemands < ActiveRecord::Migration[5.1]
  def change
  	add_column :demands, :block, :boolean
  end
end
