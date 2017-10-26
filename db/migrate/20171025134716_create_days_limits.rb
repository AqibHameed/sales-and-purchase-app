class CreateDaysLimits < ActiveRecord::Migration[5.1]
  def change
    create_table :days_limits do |t|
      t.integer :supplier_id
      t.integer :buyer_id
      t.decimal :days_limit
      t.timestamps
    end
  end
end
