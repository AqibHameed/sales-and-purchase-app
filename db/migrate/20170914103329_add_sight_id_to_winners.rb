class AddSightIdToWinners < ActiveRecord::Migration[5.1]
  def change
    add_column :winners, :sight_id, :integer
  end
end
