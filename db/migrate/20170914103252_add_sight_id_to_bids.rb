class AddSightIdToBids < ActiveRecord::Migration[5.1]
  def change
    add_column :bids, :sight_id, :integer
  end
end
