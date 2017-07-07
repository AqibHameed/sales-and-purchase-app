class AddConfirmedToCustomersTenders < ActiveRecord::Migration[5.1]
  def change
    add_column :customers_tenders, :confirmed, :boolean, :default => false
  end
end

