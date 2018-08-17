class AddLimitsToCompaniesGroups < ActiveRecord::Migration[5.1]
  def change
    add_column :companies_groups, :group_market_limit, :integer
    add_column :companies_groups, :group_overdue_limit, :integer
  end
end
