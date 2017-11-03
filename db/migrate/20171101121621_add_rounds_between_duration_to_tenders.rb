class AddRoundsBetweenDurationToTenders < ActiveRecord::Migration[5.1]
  def change
    add_column :tenders, :rounds_between_duration, :integer
  end
end
