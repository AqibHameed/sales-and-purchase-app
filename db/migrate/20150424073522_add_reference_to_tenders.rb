class AddReferenceToTenders < ActiveRecord::Migration
  def change
  	add_column :tenders, :reference, :integer unless column_exists?(:tenders, :reference)
  end
end
