class AddAuthenticationTokenToCustomers < ActiveRecord::Migration[5.1]
  def change
  	add_column :customers, :authentication_token, :string
  end
end
