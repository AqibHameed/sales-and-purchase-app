class CreateDemands < ActiveRecord::Migration[5.1]
  def change
    create_table :demands do |t|
      t.string :description
      t.float :weight
      t.float :price
      t.references :customer
      t.string :diamond_type
      t.timestamps
    end
  end
end
