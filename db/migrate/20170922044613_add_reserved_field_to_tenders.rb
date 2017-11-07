class AddReservedFieldToTenders < ActiveRecord::Migration[5.1]
  def up
    add_column :tenders, :reserved_field, :string
  end
  def down
    remove_column :tenders, :reserved_field, :string
  end
end
