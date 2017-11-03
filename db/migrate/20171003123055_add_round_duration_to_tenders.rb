class AddRoundDurationToTenders < ActiveRecord::Migration[5.1]
  def change
    add_column :tenders, :round_duration, :integer
  end
end
