class CreateCustomerRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :customer_roles do |t|
    	t.integer :customer_id
    	t.integer :role_id
      t.timestamps
    end
  end
end
