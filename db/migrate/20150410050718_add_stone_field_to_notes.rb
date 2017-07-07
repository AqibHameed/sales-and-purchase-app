class AddStoneFieldToNotes < ActiveRecord::Migration[5.1]
  def change
  	add_column :notes, :stone_id, :integer unless column_exists?(:notes, :stone_id)
  	add_column :notes, :deec_no, :string unless column_exists?(:notes, :deec_no)
  end
end
