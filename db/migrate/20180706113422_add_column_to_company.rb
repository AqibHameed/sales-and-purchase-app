class AddColumnToCompany < ActiveRecord::Migration[5.1]
  def change
  	add_column :companies, :is_broker, :boolean, default: false
  end
end
