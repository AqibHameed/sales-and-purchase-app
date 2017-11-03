class CreateSupplierMines < ActiveRecord::Migration[5.1]
  def change
    create_table :supplier_mines do |t|
      t.string  :name
      t.references :company
      t.timestamps
    end
  end
end
