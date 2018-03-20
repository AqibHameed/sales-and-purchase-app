class AddColumnCreditTypeToSubCompanyCreditLimit < ActiveRecord::Migration[5.1]
  def change
  	add_column :sub_company_credit_limits, :credit_type, :string
    remove_column :sub_company_credit_limits, :credit_limit
    rename_column :sub_company_credit_limits, :customer_id, :sub_company_id
  end
end
