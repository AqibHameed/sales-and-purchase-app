class AddStoneIdToBids < ActiveRecord::Migration[5.1]
  def change
    add_column :bids, :stone_id, :integer
  end
end
