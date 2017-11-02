class AddLimitToCompany < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :credit_limit, :integer
    add_column :companies, :market_limit, :integer
  end
end
