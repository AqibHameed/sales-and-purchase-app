class AddDiamondTypeToTransaction < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :diamond_type, :string
  end
end
