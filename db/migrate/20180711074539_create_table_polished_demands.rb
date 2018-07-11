class CreateTablePolishedDemands < ActiveRecord::Migration[5.1]
  def change
    create_table :polished_demands do |t|
      t.integer :demand_supplier_id
      t.integer :company_id
      t.string  :description
      t.integer :weight
      t.integer :price
      t.boolean :block, default: false
      t.boolean :deleted, default: false
      t.string :shape
      t.string :color
      t.string :clarity
      t.string :cut
      t.string :polish
      t.string :symmetry
      t.string :fluorescence
      t.string :lab
      t.string :city
      t.string :country
      t.timestamps
    end
  end
end
