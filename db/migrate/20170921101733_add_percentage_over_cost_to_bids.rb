class AddPercentageOverCostToBids < ActiveRecord::Migration[5.1]
  def change
    add_column :bids, :percentage_over_cost, :integer
  end
end
