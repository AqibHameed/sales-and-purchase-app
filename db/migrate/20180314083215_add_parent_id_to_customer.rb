class AddParentIdToCustomer < ActiveRecord::Migration[5.1]
  def change
  	add_column :customers, :parent_id, :integer
  end
end
