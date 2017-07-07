class ChangeDateTypeOfOpenDateCloseDateInTenders < ActiveRecord::Migration[5.1]
  def up
    change_column :tenders, :open_date, :date
    change_column :tenders, :close_date, :date
  end

  def down
    change_column :tenders, :open_date, :datetime
    change_column :tenders, :close_date, :datetime
  end
end

