class AddFieldsToBids < ActiveRecord::Migration
  def change
    rename_column :bids, :amount, :total
    add_column :bids, :price_per_carat, :float
  end
end

