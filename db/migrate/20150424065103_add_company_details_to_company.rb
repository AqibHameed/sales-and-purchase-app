class AddCompanyDetailsToCompany < ActiveRecord::Migration
  def change
  	add_column :companies, :address, :string unless column_exists?(:companies, :address)
  	add_column :companies, :country, :string unless column_exists?(:companies, :country)
  	add_column :companies, :email, :string unless column_exists?(:companies, :email)
  	add_column :companies, :registration_vat_no, :integer unless column_exists?(:companies, :registration_vat_no)
  	add_column :companies, :registration_no, :string unless column_exists?(:companies, :registration_no)
  	add_column :companies, :fax, :integer unless column_exists?(:companies, :fax)
  	add_column :companies, :telephone, :integer unless column_exists?(:companies, :telephone)
  	add_column :companies, :mobile, :integer unless column_exists?(:companies, :mobile)
  end
end
