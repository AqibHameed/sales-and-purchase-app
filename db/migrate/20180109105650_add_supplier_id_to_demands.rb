class AddSupplierIdToDemands < ActiveRecord::Migration[5.1]
  def change
  	add_column :demands, :supplier_id, :integer
  	add_column :demand_lists, :supplier_id, :integer
  end
end
