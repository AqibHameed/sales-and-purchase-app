class AddTenderIdToSights < ActiveRecord::Migration[5.1]
  def change
    add_column :sights, :tender_id, :integer
  end
end
