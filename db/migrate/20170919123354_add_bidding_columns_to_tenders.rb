class AddBiddingColumnsToTenders < ActiveRecord::Migration[5.1]
  def change
  	add_column :tenders, :bidding_start, :datetime
  	add_column :tenders, :bidding_end, :datetime
  	add_column :tenders, :timezone, :string
  end
end
