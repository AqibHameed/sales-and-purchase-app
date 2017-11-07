class AddBidColumnsToTenders < ActiveRecord::Migration[5.1]
  def up
    add_column :tenders, :bid_open, :datetime
    add_column :tenders, :bid_close, :datetime
  end
  def down
    remove_column :tenders, :bid_open, :datetime
    remove_column :tenders, :bid_close, :datetime
  end
end
