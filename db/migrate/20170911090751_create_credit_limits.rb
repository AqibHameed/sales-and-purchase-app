class CreateCreditLimits < ActiveRecord::Migration[5.1]
  def change
    create_table :credit_limits do |t|
      t.integer :supplier_id
      t.integer :buyer_id
      t.decimal :credit_limit
      t.decimal :market_limit
      t.timestamps
    end
  end
end
