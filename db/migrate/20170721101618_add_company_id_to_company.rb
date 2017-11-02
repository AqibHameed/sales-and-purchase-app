class AddCompanyIdToCompany < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :parent_id, :integer
  end
end
