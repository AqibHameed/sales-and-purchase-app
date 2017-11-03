class AddSightReservedFieldToTenders < ActiveRecord::Migration[5.1]
  def change
    add_column :tenders, :sight_reserved_field, :string
  end
end
