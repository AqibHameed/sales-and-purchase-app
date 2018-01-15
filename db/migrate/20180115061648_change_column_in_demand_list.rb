class ChangeColumnInDemandList < ActiveRecord::Migration[5.1]
  def change
  	rename_column :demand_lists, :supplier_id, :demand_supplier_id
  	rename_column :demands, :supplier_id, :demand_supplier_id
  end
end
