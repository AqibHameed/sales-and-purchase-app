class ChangeReferenceToReferenceIdTenders < ActiveRecord::Migration[5.1]
  def up
  	rename_column :tenders, :reference, :reference_id if column_exists?(:tenders, :reference)
  end

  def down
  	rename_column :tenders, :reference_id, :reference if column_exists?(:tenders, :reference_id)
  end
end
