class AddColumnsToCustomers < ActiveRecord::Migration[5.1]
  def change
  	add_column :customers, :is_requested, :boolean, default: false
  end
end
