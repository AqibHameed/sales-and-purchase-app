class AddNameToAdmins < ActiveRecord::Migration
  def change
  	add_column :admins, :name, :string unless column_exists?(:admins, :name)
  end
end
