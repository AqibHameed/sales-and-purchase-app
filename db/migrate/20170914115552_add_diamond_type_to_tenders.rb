class AddDiamondTypeToTenders < ActiveRecord::Migration[5.1]
  def change
    add_column :tenders, :diamond_type, :string
  end
end
