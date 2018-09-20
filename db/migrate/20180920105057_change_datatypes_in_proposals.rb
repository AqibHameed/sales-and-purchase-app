class ChangeDatatypesInProposals < ActiveRecord::Migration[5.1]
  def change
  	change_column :proposals, :price, :decimal,  precision: 12, scale: 2
    change_column :proposals, :total_value, :decimal,  precision: 12, scale: 2
    change_column :proposals, :percent, :decimal,  precision: 12, scale: 2
  end
end
