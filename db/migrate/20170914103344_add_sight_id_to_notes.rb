class AddSightIdToNotes < ActiveRecord::Migration[5.1]
  def change
    add_column :notes, :sight_id, :integer
  end
end
