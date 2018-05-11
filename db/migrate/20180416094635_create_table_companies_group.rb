class CreateTableCompaniesGroup < ActiveRecord::Migration[5.1]
  def change
    create_table :companies_groups do |t|
      t.string  :group_name
      t.integer :seller_id
      t.integer :customer_id
      t.timestamps
    end
  end
end
