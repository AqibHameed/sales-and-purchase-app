class AddColumnsToTenders < ActiveRecord::Migration[5.1]
  def change
  	add_column :tenders, :country, :string
  	add_column :tenders, :city, :string
  end
end
