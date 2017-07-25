class RenameParentId < ActiveRecord::Migration[5.1]
  def up
    rename_column :companies, :parent_id, :integer
  end

  def down
  	rename_column :companies, :integer, :parent_id
    
  end
end
