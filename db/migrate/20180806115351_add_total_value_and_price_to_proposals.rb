class AddTotalValueAndPriceToProposals < ActiveRecord::Migration[5.1]
  def change
    add_column :proposals, :total_value, :integer, default: 0
    add_column :proposals, :percent, :integer, default: 0
  end
end
