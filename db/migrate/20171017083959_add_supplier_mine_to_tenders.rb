class AddSupplierMineToTenders < ActiveRecord::Migration[5.1]
  def change
    add_column :tenders, :supplier_mine_id, :integer
  end
end
