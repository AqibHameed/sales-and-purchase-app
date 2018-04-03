class AddColumnToCreditLimit < ActiveRecord::Migration[5.1]
  def change
    add_column :sub_company_credit_limits, :credit_limit, :integer
  end
end
