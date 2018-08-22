class AddColumnsToProposals < ActiveRecord::Migration[5.1]
  def change
    add_column :proposals, :seller_price, :integer
    add_column :proposals, :seller_credit, :integer
    add_column :proposals, :seller_total_value, :integer
    add_column :proposals, :seller_percent, :integer
  end
end
