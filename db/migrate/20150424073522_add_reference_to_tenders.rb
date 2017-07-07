class AddReferenceToTenders < ActiveRecord::Migration[5.1]
  def change
  	add_column :tenders, :reference, :integer unless column_exists?(:tenders, :reference)
  end
end
