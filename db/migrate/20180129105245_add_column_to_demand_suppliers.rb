class AddColumnToDemandSuppliers < ActiveRecord::Migration[5.1]
  def change
  	add_column :demand_suppliers, :diamond_type, :string
  end
end
