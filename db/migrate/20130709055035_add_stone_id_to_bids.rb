class AddStoneIdToBids < ActiveRecord::Migration
  def change
    add_column :bids, :stone_id, :integer
  end
end
