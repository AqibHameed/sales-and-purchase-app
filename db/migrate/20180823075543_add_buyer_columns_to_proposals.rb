class AddBuyerColumnsToProposals < ActiveRecord::Migration[5.1]
  def change
    add_column :proposals, :buyer_price, :integer
    add_column :proposals, :buyer_credit, :integer
    add_column :proposals, :buyer_total_value, :integer
    add_column :proposals, :buyer_percent, :integer
  end
end
