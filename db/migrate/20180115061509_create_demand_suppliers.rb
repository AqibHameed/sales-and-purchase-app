class CreateDemandSuppliers < ActiveRecord::Migration[5.1]
  def change
    create_table :demand_suppliers do |t|
      t.string :name
      t.timestamps
    end
  end
end
