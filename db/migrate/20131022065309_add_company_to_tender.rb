class AddCompanyToTender < ActiveRecord::Migration[5.1]
  def change
    add_column :tenders, :company_id, :integer
  end
end
