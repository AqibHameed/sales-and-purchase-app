class AddTimeToOpenCloseDateTenders < ActiveRecord::Migration
  def up
    change_column :tenders, :open_date, :datetime
    change_column :tenders, :close_date, :datetime
  end

  def down
    change_column :tenders, :open_date, :date
    change_column :tenders, :close_date, :date
  end
end

