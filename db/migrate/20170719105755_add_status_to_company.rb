class AddStatusToCompany < ActiveRecord::Migration[5.1]
  def change
  	add_column :companies, :status, :string unless column_exists?(:companies, :status)
  end
end
