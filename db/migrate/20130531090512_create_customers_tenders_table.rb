class CreateCustomersTendersTable < ActiveRecord::Migration[5.1]
  def up
    create_table :customers_tenders do |t|
      t.references :tender
      t.references :customer

      t.timestamps
    end
  end

  def down
    drop_table :customers_tenders
  end
end

