class AddColumnIntoBids < ActiveRecord::Migration[5.1]
  def change
    add_column :bids, :bid_amount, :float
  end
end
