class AddColumnsToDemand < ActiveRecord::Migration[5.1]
  def change
  	add_column :demands, :deleted, :boolean, dafault: false
  end
end
