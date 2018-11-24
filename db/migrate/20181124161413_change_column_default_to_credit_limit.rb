class ChangeColumnDefaultToCreditLimit < ActiveRecord::Migration[5.1]
  def change
    change_column_default :credit_limits, :credit_limit, 0
    change_column_default :credit_limits, :market_limit, 0
  end
end
