class AddRoundOpenTimeToTenders < ActiveRecord::Migration[5.1]
  def change
  	add_column :tenders, :round_open_time, :datetime
  	add_column :tenders, :round, :integer, default: 1
  	add_column :tenders, :updated_after_round, :boolean
  end
end
