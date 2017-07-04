class RenameTypeInTenders < ActiveRecord::Migration
  def up
    rename_column :tenders, :type, :tender_type
  end

  def down
    rename_column :tenders, :tender_type, :type
  end
end

