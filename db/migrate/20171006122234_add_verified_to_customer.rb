class AddVerifiedToCustomer < ActiveRecord::Migration[5.1]
  def change
  	add_column :customers, :verified, :boolean, default: false
  end
end