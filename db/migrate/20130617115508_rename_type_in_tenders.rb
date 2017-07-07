class RenameTypeInTenders < ActiveRecord::Migration[5.1]
  def up
    rename_column :tenders, :type, :tender_type
  end

  def down
    rename_column :tenders, :tender_type, :type
  end
end

