class AddCompanyIdToDocument < ActiveRecord::Migration[5.1]
  def change
  	add_column :trading_documents, :company_id, :integer
  end
end
