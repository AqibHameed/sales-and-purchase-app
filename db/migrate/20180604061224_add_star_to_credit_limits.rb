class AddStarToCreditLimits < ActiveRecord::Migration[5.1]
  def change
    add_column :credit_limits, :star, :boolean, :default => false
  end
end
