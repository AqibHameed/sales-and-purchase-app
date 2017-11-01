class CreatePartialPayments < ActiveRecord::Migration[5.1]
  def change
    create_table :partial_payments do |t|
    	t.references :customer
    	t.references :transaction
    	t.integer :amount
    	t.timestamps
    end
  end
end
