class ChangeFaxTypeCompany < ActiveRecord::Migration
  def up
  		change_column :companies, :fax, :string if column_exists?(:companies, :fax, :integer)
  	  change_column :companies, :telephone, :string if column_exists?(:companies, :telephone, :integer)
  end

  def down
  end
end
